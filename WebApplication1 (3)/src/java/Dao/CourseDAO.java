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
            Course c = new Course(
                rs.getInt("CourseID"),
                rs.getInt("InstructorID"),
                rs.getInt("CategoryID"),
                rs.getString("Title"),
                rs.getString("Description"),
                rs.getTimestamp("CreatedAt"),
                rs.getString("Thumbnail")
            );
            // 🧩 Thêm dòng này:
            c.setStatus(rs.getString("Status"));
            list.add(c);
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
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 🔹 Tạo khóa học mới (có CategoryID)
    public boolean addCourse(Course course) {
        String sql = "INSERT INTO Courses (InstructorID, CategoryID, Title, Description,Thumbnail, CreatedAt) VALUES (?, ?, ?, ?,?, GETDATE())";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, course.getInstructorId());
            ps.setInt(2, course.getCategoryId()); // 🆕
            ps.setString(3, course.getTitle());
            ps.setString(4, course.getDescription());
            ps.setString(5, course.getThumbnail());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // 🔹 Xoá module thuộc course
    public void deleteModulesByCourseId(int courseId) {
        String sql = "DELETE FROM Modules WHERE CourseID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean deleteCourseWithModules(int courseId) {
    String getModuleIdsSQL = "SELECT ModuleID FROM Modules WHERE CourseID = ?";
    String getLessonIdsSQL = "SELECT LessonID FROM Lessons WHERE ModuleID = ?";
    
    String deleteLessonVideosSQL = "DELETE FROM LessonVideos WHERE LessonID = ?";
    String deleteLessonDocumentsSQL = "DELETE FROM LessonDocuments WHERE LessonID = ?";
    String deleteStudentProgressSQL = "DELETE FROM StudentProgress WHERE LessonID = ?";
    String deleteLessonsSQL = "DELETE FROM Lessons WHERE ModuleID = ?";
    
    String deleteModulesSQL = "DELETE FROM Modules WHERE CourseID = ?";
    String deleteEnrollmentsSQL = "DELETE FROM Enrollments WHERE CourseID = ?";
    String deleteCourseCartSQL = "DELETE FROM CourseCart WHERE CourseID = ?";
    String deletePaymentRequestSQL = "DELETE FROM PaymentRequest WHERE CourseID = ?";
    
    String deleteCourseSQL = "DELETE FROM Courses WHERE CourseID = ?";

    try (Connection conn = new DBContext().getConnection()) {
        conn.setAutoCommit(false);

        try (
            PreparedStatement psGetModules = conn.prepareStatement(getModuleIdsSQL);
            PreparedStatement psGetLessons = conn.prepareStatement(getLessonIdsSQL);
            PreparedStatement psDeleteLessonVideos = conn.prepareStatement(deleteLessonVideosSQL);
            PreparedStatement psDeleteLessonDocs = conn.prepareStatement(deleteLessonDocumentsSQL);
            PreparedStatement psDeleteStudentProgress = conn.prepareStatement(deleteStudentProgressSQL);
            PreparedStatement psDeleteLessons = conn.prepareStatement(deleteLessonsSQL);
            PreparedStatement psDeleteModules = conn.prepareStatement(deleteModulesSQL);
            PreparedStatement psDeleteEnrollments = conn.prepareStatement(deleteEnrollmentsSQL);
            PreparedStatement psDeleteCourseCart = conn.prepareStatement(deleteCourseCartSQL);
            PreparedStatement psDeletePayment = conn.prepareStatement(deletePaymentRequestSQL);
            PreparedStatement psDeleteCourse = conn.prepareStatement(deleteCourseSQL)
        ) {
            // 1️⃣ Lấy danh sách module của khóa học
            psGetModules.setInt(1, courseId);
            ResultSet rsModules = psGetModules.executeQuery();

            while (rsModules.next()) {
                int moduleId = rsModules.getInt("ModuleID");

                // 2️⃣ Lấy danh sách lesson trong từng module
                psGetLessons.setInt(1, moduleId);
                ResultSet rsLessons = psGetLessons.executeQuery();

                while (rsLessons.next()) {
                    int lessonId = rsLessons.getInt("LessonID");

                    // 3️⃣ Xoá video, document, progress liên quan đến lesson
                    psDeleteLessonVideos.setInt(1, lessonId);
                    psDeleteLessonVideos.executeUpdate();

                    psDeleteLessonDocs.setInt(1, lessonId);
                    psDeleteLessonDocs.executeUpdate();

                    psDeleteStudentProgress.setInt(1, lessonId);
                    psDeleteStudentProgress.executeUpdate();
                }

                // 4️⃣ Xoá lesson thuộc module
                psDeleteLessons.setInt(1, moduleId);
                psDeleteLessons.executeUpdate();
            }

            // 5️⃣ Xoá module thuộc course
            psDeleteModules.setInt(1, courseId);
            psDeleteModules.executeUpdate();

            // 6️⃣ Xoá enrollments, course cart, payment request liên quan
            psDeleteEnrollments.setInt(1, courseId);
            psDeleteEnrollments.executeUpdate();

            psDeleteCourseCart.setInt(1, courseId);
            psDeleteCourseCart.executeUpdate();

            psDeletePayment.setInt(1, courseId);
            psDeletePayment.executeUpdate();

            // 7️⃣ Cuối cùng xoá course
            psDeleteCourse.setInt(1, courseId);
            int affected = psDeleteCourse.executeUpdate();

            conn.commit();
            return affected > 0;

        } catch (SQLException e) {
            conn.rollback();
            e.printStackTrace();
            return false;
        }
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}


    // 🔹 Cập nhật khóa học (có CategoryID và Thumbnail)
public boolean updateCourse(Course course) {
    String sql = "UPDATE Courses "
               + "SET Title = ?, Description = ?, CategoryID = ?, Thumbnail = ? "
               + "WHERE CourseID = ?";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, course.getTitle());
        ps.setString(2, course.getDescription());
        ps.setInt(3, course.getCategoryId());
        ps.setString(4, course.getThumbnail());
        ps.setInt(5, course.getId()); // ✅ đúng getter
        int rows = ps.executeUpdate();
        System.out.println("Updated rows = " + rows); // debug
        return rows > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}


    // 🔹 Lấy chi tiết 1 khóa học (thêm CategoryID)
    public Course getCourseById(int courseId) {
        String sql = "SELECT * FROM Courses WHERE CourseID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Course(
                    rs.getInt("CourseID"),
                    rs.getInt("InstructorID"),
                    rs.getInt("CategoryID"), // 🆕
                    rs.getString("Title"),
                    rs.getString("Description"),
                    rs.getTimestamp("CreatedAt"),
                    rs.getString("Thumbnail")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }


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
                c.setId(rs.getInt("CourseID"));
                c.setTitle(rs.getString("Title"));
                c.setDescription(rs.getString("Description"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public boolean updateCourseStatus(int courseId, String newStatus) {
    String sql = "UPDATE Courses SET Status = ? WHERE CourseID = ?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, newStatus);
        ps.setInt(2, courseId);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

    
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

}
