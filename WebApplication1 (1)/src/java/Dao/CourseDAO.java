package Dao;

import Context.DBContext;
import Entity.Course;
import java.sql.*;
import java.util.*;

public class CourseDAO {

    private Connection conn;

    public CourseDAO() {
        try {
            conn = new DBContext().getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 🔹 Lấy danh sách khóa học theo giảng viên + phân trang
    public List<Course> getCoursesByInstructor(int instructorId, int page, int pageSize, String search) {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT * FROM Courses WHERE InstructorID = ? AND Title LIKE ? "
                + "ORDER BY CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, instructorId);
            ps.setString(2, "%" + search + "%");
            ps.setInt(3, (page - 1) * pageSize);
            ps.setInt(4, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Course(
                        rs.getInt("CourseID"),
                        rs.getInt("InstructorID"),
                        rs.getString("Title"),
                        rs.getString("Description"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getString("Thumbnail")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🔹 Đếm tổng số khóa học để phân trang
    public int countCoursesByInstructor(int instructorId, String search) {
        String sql = "SELECT COUNT(*) FROM Courses WHERE InstructorID = ? AND Title LIKE ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, instructorId);
            ps.setString(2, "%" + search + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 🔹 Tạo khóa học mới
    public boolean addCourse(Course course) {
        String sql = "INSERT INTO Courses (InstructorID, Title, Description, CreatedAt) VALUES (?, ?, ?, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, course.getInstructorId());
            ps.setString(2, course.getTitle());
            ps.setString(3, course.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 🔹 Xóa tất cả module thuộc course
    public void deleteModulesByCourseId(int courseId) {
        String sql = "DELETE FROM Modules WHERE course_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean deleteCourseWithModules(int courseId) {
        String getModuleIdsSQL = "SELECT ModuleID FROM Modules WHERE CourseID = ?";
        String deleteLessonsSQL = "DELETE FROM Lessons WHERE ModuleID = ?";
        String deleteModulesSQL = "DELETE FROM Modules WHERE CourseID = ?";
        String deleteCourseSQL = "DELETE FROM Courses WHERE CourseID = ?";

        try (Connection conn = new DBContext().getConnection()) {
            conn.setAutoCommit(false);

            try (
                    PreparedStatement psGetModules = conn.prepareStatement(getModuleIdsSQL); PreparedStatement psDeleteLessons = conn.prepareStatement(deleteLessonsSQL); PreparedStatement psDeleteModules = conn.prepareStatement(deleteModulesSQL); PreparedStatement psDeleteCourse = conn.prepareStatement(deleteCourseSQL)) {
                // 1️⃣ Lấy tất cả ModuleID của khóa học
                psGetModules.setInt(1, courseId);
                ResultSet rs = psGetModules.executeQuery();

                // 2️⃣ Xoá tất cả bài học trong mỗi module
                while (rs.next()) {
                    int moduleId = rs.getInt("ModuleID");
                    psDeleteLessons.setInt(1, moduleId);
                    psDeleteLessons.executeUpdate();
                }

                // 3️⃣ Xoá các module thuộc khóa học
                psDeleteModules.setInt(1, courseId);
                psDeleteModules.executeUpdate();

                // 4️⃣ Xoá khóa học
                psDeleteCourse.setInt(1, courseId);
                int affected = psDeleteCourse.executeUpdate();

                // 5️⃣ Commit transaction
                conn.commit();
                return affected > 0;
            } catch (SQLException e) {
                conn.rollback(); // Nếu lỗi, rollback toàn bộ
                e.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCourse(Course course) {
        String sql = "UPDATE Courses SET Title = ?, Description = ? WHERE CourseID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, course.getTitle());
            ps.setString(2, course.getDescription());
            ps.setInt(3, course.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Course getCourseById(int courseId) {
        String sql = "SELECT * FROM Courses WHERE CourseID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Course(
                        rs.getInt("CourseID"),
                        rs.getInt("InstructorID"),
                        rs.getString("Title"),
                        rs.getString("Description"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getString("Thumbnail") // 🆕 thêm dòng này
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    //lấy khoá học bằng CourseID
    public Course getCourseById1(int courseId) {
        Course c = null;
        String sql = """
SELECT 
                       c.CourseID, 
                       c.Title, 
                       c.Description, 
                       u.FullName AS InstructorName,
                       c.Price,
                       c.Status, 
                       c.CreatedAt, 
                       c.Thumbnail,
                       cat.CategoryName,
                       COUNT(e.EnrollmentID) AS EnrolledCount
                   FROM Courses c
                   JOIN Users u ON c.InstructorID = u.UserID
                   LEFT JOIN Enrollments e ON e.CourseID = c.CourseID
                   LEFT JOIN Category cat ON c.CategoryID = cat.CategoryID
                   WHERE c.CourseID = ?
                   GROUP BY 
                       c.CourseID, c.Title, c.Description, u.FullName, 
                       c.Status, c.CreatedAt, c.Price, c.Thumbnail, cat.CategoryName
    """;

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                c = new Course();
                c.setCourseID(rs.getInt("CourseID"));
                c.setTitle(rs.getString("Title"));
                c.setDescription(rs.getString("Description"));
                c.setInstructorName(rs.getString("InstructorName"));
                c.setPrice(rs.getBigDecimal("Price")); // ✅ thêm dòng này
                c.setStatus(rs.getString("Status"));
                c.setCreatedAt(rs.getTimestamp("CreatedAt"));
                c.setEnrolledCount(rs.getInt("EnrolledCount"));
                c.setCategoryName(rs.getString("CategoryName"));
                c.setThumbnail(rs.getString("Thumbnail"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return c;
    }

    // Lấy các khoá học student đang học (status = Enrolled) + progress và last enroll date
    public List<Course> getContinueLearning(int studentId) {
        List<Course> list = new ArrayList<>();
        String sql = """
            SELECT * FROM (
                SELECT c.CourseID, c.Title, c.Description, u.FullName AS InstructorName,
                       ISNULL(100.0 * SUM(CASE WHEN sp.IsCompleted = 1 THEN 1 ELSE 0 END) 
                             / NULLIF(COUNT(sp.LessonID),0), 0) AS Progress,
                       MAX(e.EnrollDate) AS LastEnrollDate
                FROM Enrollments e
                JOIN Courses c ON e.CourseID = c.CourseID
                JOIN Users u ON c.InstructorID = u.UserID
                LEFT JOIN StudentProgress sp ON e.EnrollmentID = sp.EnrollmentID
                WHERE e.StudentID = ? AND e.Status = 'Enrolled'
                GROUP BY c.CourseID, c.Title, c.Description, u.FullName
            ) sub
            ORDER BY sub.LastEnrollDate DESC;
        """;

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course c = new Course();
                c.setCourseID(rs.getInt("CourseID"));
                c.setTitle(rs.getString("Title"));
                c.setDescription(rs.getString("Description"));
                c.setInstructorName(rs.getString("InstructorName"));
                c.setImage("https://via.placeholder.com/150");
                c.setProgress(Math.round(rs.getDouble("Progress") * 100.0) / 100.0); // 2 decimals
                list.add(c);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return list;
    }

    // Top 4 popular courses by enrollment count
    public List<Course> getPopularCourses(int topN) {
        List<Course> list = new ArrayList<>();
        String sql = """
            SELECT TOP (?) c.CourseID, c.Title, c.Description, COUNT(e.EnrollmentID) AS EnrollCount
            FROM Courses c
            LEFT JOIN Enrollments e ON c.CourseID = e.CourseID
            GROUP BY c.CourseID, c.Title, c.Description
            ORDER BY COUNT(e.EnrollmentID) DESC;
        """;
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, topN);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course c = new Course();
                c.setCourseID(rs.getInt("CourseID"));
                c.setTitle(rs.getString("Title"));
                c.setDescription(rs.getString("Description"));
                c.setImage("https://via.placeholder.com/150");
                list.add(c);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return list;
    }

    // Các khoá học đã hoàn thành (student)
    public List<Course> getCompletedCourses(int studentId) {
        List<Course> list = new ArrayList<>();
        String sql = """
            SELECT c.CourseID, c.Title, c.Description, u.FullName AS InstructorName
            FROM Enrollments e
            JOIN Courses c ON e.CourseID = c.CourseID
            JOIN Users u ON c.InstructorID = u.UserID
            WHERE e.StudentID = ? AND e.Status = 'Completed'
            ORDER BY e.EnrollDate DESC;
        """;
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course c = new Course();
                c.setCourseID(rs.getInt("CourseID"));
                c.setTitle(rs.getString("Title"));
                c.setDescription(rs.getString("Description"));
                c.setInstructorName(rs.getString("InstructorName"));
                c.setImage("https://via.placeholder.com/150");
                list.add(c);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return list;
    }

    // 2. Recently viewed (lấy 6 mới nhất) - giả sử có bảng RecentlyViewed
    public List<Course> getRecentlyViewed(int userId, int limit) throws SQLException {
        List<Course> list = new ArrayList<>();
        String sql
                = "SELECT TOP (?) c.CourseID, c.Title, c.Description "
                + "FROM dbo.RecentlyViewed rv "
                + "JOIN dbo.Courses c ON c.CourseID = rv.CourseID "
                + "WHERE rv.UserID = ? "
                + "ORDER BY rv.ViewedAt DESC";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course c = new Course();
                c.setCourseID(rs.getInt("CourseID"));
                c.setTitle(rs.getString("Title"));
                c.setDescription(rs.getString("Description"));
                list.add(c);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        }

        return list;
    }

    // 4. Thêm recently viewed (gọi khi user mở course)
    public void addRecentlyViewed(int userId, int courseId) throws SQLException {
        String sql
                = "INSERT INTO dbo.RecentlyViewed(UserID, CourseID, ViewedAt) VALUES(?, ?, SYSUTCDATETIME())";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, courseId);
            ps.executeUpdate();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    public List<Course> getRecommendCourse(int studentId) {
        String sql = """
        SELECT TOP 4 *
        FROM Courses
        WHERE CourseID NOT IN (
            SELECT CourseID FROM Enrollments WHERE StudentID = ?
        )
        ORDER BY NEWID(); -- random 4 khóa
    """;
        List<Course> recommendedCourses = new ArrayList<>();
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId); // id sinh viên đang đăng nhập
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Course c = new Course();
                c.setCourseID(rs.getInt("CourseID"));
                c.setTitle(rs.getString("Title"));
                c.setDescription(rs.getString("Description"));
                c.setImage(rs.getString("Image")); // nếu có cột Image
                recommendedCourses.add(c);
            }
            rs.close();
            ps.close();

        } catch (Exception e) {
            System.out.println(e);
        }
        return recommendedCourses;

    }

    public List<Course> getEnrolledCourses(int studentID) {
        List<Course> list = new ArrayList<>();
        String sql = """
        SELECT c.CourseID, c.Title, c.Description, e.Status,
               MAX(e.EnrollDate) AS EnrollDate,
               CAST(SUM(CASE WHEN sp.IsCompleted = 1 THEN 1 ELSE 0 END) AS FLOAT) /
               NULLIF(COUNT(sp.LessonID),0) * 100 AS Progress
        FROM Enrollments e
        JOIN Courses c ON e.CourseID = c.CourseID
        LEFT JOIN Modules m ON c.CourseID = m.CourseID
        LEFT JOIN Lessons l ON m.ModuleID = l.ModuleID
        LEFT JOIN StudentProgress sp 
               ON sp.LessonID = l.LessonID 
               AND sp.EnrollmentID = e.EnrollmentID
        WHERE e.StudentID = ?
        GROUP BY c.CourseID, c.Title, c.Description, e.Status
        ORDER BY MAX(e.EnrollDate) DESC
    """;

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, studentID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Course c = new Course();
                c.setCourseID(rs.getInt("CourseID"));
                c.setTitle(rs.getString("Title"));
                c.setDescription(rs.getString("Description"));
                c.setStatus(rs.getString("Status"));
                c.setProgress(rs.getDouble("Progress"));
                // nếu muốn hiển thị ngày ghi danh
                // c.setEnrollDate(rs.getDate("EnrollDate"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Course> getCoursesByStudent(int studentID, String status) {
        List<Course> list = new ArrayList<>();
        String sql = """
            SELECT c.CourseID, c.Title, c.Description, e.Status, 
                   CONVERT(VARCHAR, e.Deadline, 106) AS Deadline,
                   CAST(SUM(CASE WHEN sp.IsCompleted = 1 THEN 1 ELSE 0 END) AS FLOAT)
                   / NULLIF(COUNT(sp.LessonID), 0) * 100 AS Progress
            FROM Enrollments e
            JOIN Courses c ON e.CourseID = c.CourseID
            LEFT JOIN StudentProgress sp ON e.EnrollmentID = sp.EnrollmentID
            WHERE e.StudentID = ? AND e.Status = ?
            GROUP BY c.CourseID, c.Title, c.Description, e.Status, e.Deadline
        """;

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentID);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Course c = new Course();
                c.setCourseID(rs.getInt("CourseID"));
                c.setTitle(rs.getString("Title"));
                c.setDescription(rs.getString("Description"));
                c.setStatus(rs.getString("Status"));
                c.setProgress(rs.getDouble("Progress"));
                c.setDeadline(rs.getString("Deadline"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Course> searchCourses(String keyword) {
        List<Course> list = new ArrayList<>();
        String sql = """
            SELECT CourseID, Title, Description 
            FROM Courses
            WHERE (Title LIKE ? OR Description LIKE ?)
            AND Status = 'Active'
        """;

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Course c = new Course();
                c.setCourseID(rs.getInt("CourseID"));
                c.setTitle(rs.getString("Title"));
                c.setDescription(rs.getString("Description"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Course> getAllCourses() {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT CourseID, Title, Description FROM Courses WHERE Status = 'Active'";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Course c = new Course();
                c.setCourseID(rs.getInt("CourseID"));
                c.setTitle(rs.getString("Title"));
                c.setDescription(rs.getString("Description"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🟢 Lấy danh sách khóa học trong giỏ của sinh viên
    public List<Course> getCoursesInCart(int studentId) {
        List<Course> list = new ArrayList<>();

        String sql = """
        SELECT 
            c.CourseID,
            c.Title,
            c.Description,
            c.Price,
            c.Thumbnail,
            c.InstructorID,
            u.FullName AS InstructorName,
            c.Status,
            cc.CreatedAt AS AddedAt
        FROM dbo.CourseCart cc
        JOIN dbo.Courses c ON cc.CourseID = c.CourseID
        JOIN dbo.Users u ON c.InstructorID = u.UserID
        WHERE cc.StudentID = ? 
          AND cc.Status = 'InCart'
        ORDER BY cc.CreatedAt DESC;
    """;

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Course course = new Course();
                course.setCourseID(rs.getInt("CourseID"));
                course.setTitle(rs.getString("Title"));
                course.setDescription(rs.getString("Description"));
                course.setThumbnail(rs.getString("Thumbnail"));
                course.setInstructorId(rs.getInt("InstructorID"));
                course.setInstructorName(rs.getString("InstructorName"));
                course.setStatus(rs.getString("Status"));
                course.setPrice(rs.getBigDecimal("Price")); // ✅ Lấy giá tiền ở đây!
                list.add(course);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

// 🟢 Thêm khóa học vào giỏ
    public boolean addCourseToCart(int studentId, int courseId) {
        String sql = """
            INSERT INTO CourseCart (StudentID, CourseID, Status)
            VALUES (?, ?, 'InCart')
        """;
        ;
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            int rows = ps.executeUpdate(); // ✅ chỉ chạy 1 lần
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // 🟢 Xóa 1 khóa học khỏi giỏ
    // 🟢 Xóa một khóa học khỏi giỏ hàng
    public boolean removeCourseFromCart(int studentId, int courseId) {
        String sql = """
        DELETE FROM dbo.CourseCart
        WHERE StudentID = ? AND CourseID = ? AND Status = 'InCart'
    """;
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

// 🟢 Xóa toàn bộ giỏ hàng của sinh viên
    public boolean clearCart(int studentId) {
        String sql = """
        DELETE FROM dbo.CourseCart
        WHERE StudentID = ? AND Status = 'InCart'
    """;
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

// 🟢 Kiểm tra xem khóa học đã có trong giỏ chưa
    public boolean isCourseInCart(int studentId, int courseId) {
        String sql = """
        SELECT 1 
        FROM dbo.CourseCart
        WHERE StudentID = ? AND CourseID = ? AND Status = 'InCart'
    """;
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            return rs.next(); // nếu có bản ghi thì true
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
