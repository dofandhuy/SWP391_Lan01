/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dao;

import Context.DBContext;
import static Context.DBContext.getConnection;
import Entity.PaymentRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;
import java.sql.ResultSet;

/**
 *
 * @author Admin
 */
public class PaymentDAO {

    public boolean createPaymentRequest(int studentID, int parentID, int courseID) {
        String sql = "INSERT INTO PaymentRequest (StudentID, ParentID, CourseID, Status) VALUES (?, ?, ?, 'Pending')";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentID);
            ps.setInt(2, parentID);
            ps.setInt(3, courseID);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<PaymentRequest> getRequestsByParentID(int parentID) {
        List<PaymentRequest> list = new ArrayList<>();

        String sql = """
        SELECT 
            pr.RequestID, 
            stu.FullName AS StudentName, 
            c.Title AS CourseTitle,
            c.Price AS CoursePrice,
            ins.FullName AS InstructorName,
            pr.Status, 
            pr.RequestedAt
        FROM PaymentRequest pr
        JOIN Users stu ON pr.StudentID = stu.UserID
        JOIN Courses c ON pr.CourseID = c.CourseID
        JOIN Users ins ON c.InstructorID = ins.UserID
        WHERE pr.ParentID = ? AND pr.status='PENDING'
        ORDER BY pr.RequestedAt DESC
    """;

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, parentID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                PaymentRequest p = new PaymentRequest();
                p.setRequestID(rs.getInt("RequestID"));
                p.setStudentName(rs.getString("StudentName"));
                p.setCourseName(rs.getString("CourseTitle"));
                p.setStatus(rs.getString("Status"));
                p.setCoursePrice(rs.getBigDecimal("CoursePrice"));
                p.setInstructorName(rs.getString("InstructorName"));
                p.setRequestedAt(rs.getTimestamp("RequestedAt"));
                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void approvePayment(int requestID) {
        String sql = "UPDATE PaymentRequest SET Status='Completed', ApprovedAt=SYSUTCDATETIME() WHERE RequestID=?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestID);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean hasPendingRequest(int studentID, int courseID) {
        String sql = "SELECT COUNT(*) FROM PaymentRequest WHERE StudentID = ? AND CourseID = ? AND Status = 'Pending'";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentID);
            ps.setInt(2, courseID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getParentIdByStudent(int studentID) {
        String sql = "SELECT ParentID FROM ParentStudentLink WHERE StudentID = ? AND Status = 'Active'";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("ParentID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public PaymentRequest getPaymentRequestById(int requestID) {
        String sql = """
        SELECT 
            pr.RequestID, 
            pr.StudentID, 
            pr.ParentID, 
            pr.CourseID, 
            pr.Status, 
            pr.RequestedAt, 
            pr.ApprovedAt,
            s.FullName AS StudentName,
            p.FullName AS ParentName,
            c.Title AS CourseTitle,
            c.Price AS CoursePrice,
            i.FullName AS InstructorName
        FROM PaymentRequest pr
        JOIN Users s ON pr.StudentID = s.UserID
        JOIN Users p ON pr.ParentID = p.UserID
        JOIN Courses c ON pr.CourseID = c.CourseID
        JOIN Users i ON c.InstructorID = i.UserID
        WHERE pr.RequestID = ?
    """;

        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, requestID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                PaymentRequest p = new PaymentRequest();
                p.setRequestID(rs.getInt("RequestID"));
                p.setStudentID(rs.getInt("StudentID"));
                p.setParentID(rs.getInt("ParentID"));
                p.setCourseID(rs.getInt("CourseID"));
                p.setStatus(rs.getString("Status"));
                p.setRequestedAt(rs.getTimestamp("RequestedAt"));
                p.setApprovedAt(rs.getTimestamp("ApprovedAt"));

                // Thông tin mở rộng
                p.setStudentName(rs.getString("StudentName"));
                p.setParentName(rs.getString("ParentName"));
                p.setCourseName(rs.getString("CourseTitle"));
                p.setCoursePrice(rs.getBigDecimal("CoursePrice"));
                p.setInstructorName(rs.getString("InstructorName"));

                return p;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateStatus(int requestID, String newStatus) {
        String sql = "UPDATE PaymentRequest SET Status = ?, ApprovedAt = SYSUTCDATETIME() WHERE RequestID = ?";
        try (Connection con = new DBContext().getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, requestID);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateRequestStatus(int requestId, String newStatus) {
        String sql = "UPDATE PaymentRequest SET Status = ?, ApprovedAt = GETDATE() WHERE RequestID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, requestId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public String getPaymentStatus(int studentId, int courseId) {
        String sql = "SELECT Status FROM PaymentRequest WHERE StudentID=? AND CourseID=?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("Status");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<PaymentRequest> getPendingRequestsByParent(int parentId) {
        List<PaymentRequest> list = new ArrayList<>();
        String sql = """
            SELECT 
                pr.RequestID, 
                pr.RequestedAt, 
                pr.Status,
                c.Title AS CourseName,
                c.Price AS CoursePrice,
                s.FullName AS StudentName
            FROM PaymentRequest pr
            JOIN Courses c ON pr.CourseID = c.CourseID
            JOIN Users s ON pr.StudentID = s.UserID
            WHERE pr.ParentID = ? AND pr.Status = 'Pending'
            ORDER BY pr.RequestedAt DESC
        """;

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                PaymentRequest req = new PaymentRequest();
                req.setRequestID(rs.getInt("RequestID"));
                req.setStatus(rs.getString("Status"));
                req.setCourseName(rs.getString("CourseName"));
                req.setStudentName(rs.getString("StudentName"));
                req.setCoursePrice(rs.getBigDecimal("CoursePrice"));
                req.setRequestedAt(rs.getTimestamp("RequestedAt"));
                list.add(req);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🔹 Cập nhật trạng thái yêu cầu (khi phụ huynh thanh toán)
    public boolean updatePaymentStatus(int requestId, String newStatus) {
        String sql = "UPDATE PaymentRequest SET Status = ?, ApprovedAt = SYSUTCDATETIME() WHERE RequestID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, requestId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<PaymentRequest> getRequestsByParent(int parentId, Integer studentId, String status) {
        List<PaymentRequest> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT pr.RequestID, pr.RequestedAt, pr.Status,
                   s.FullName AS StudentName,
                   c.Title AS CourseTitle,
                   c.Price AS Price,
                   i.FullName AS InstructorName
            FROM PaymentRequest pr
            JOIN Users s ON pr.StudentID = s.UserID
            JOIN Courses c ON pr.CourseID = c.CourseID
            JOIN Users i ON c.InstructorID = i.UserID
            WHERE pr.ParentID = ?
        """);

        if (studentId != null) {
            sql.append(" AND pr.StudentID = ?");
        }
        if (status != null && !"all".equalsIgnoreCase(status)) {
            sql.append(" AND pr.Status = ?");
        }

        sql.append(" ORDER BY pr.RequestedAt DESC");

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            ps.setInt(index++, parentId);
            if (studentId != null) {
                ps.setInt(index++, studentId);
            }
            if (status != null && !"all".equalsIgnoreCase(status)) {
                ps.setString(index++, status);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PaymentRequest r = new PaymentRequest();
                r.setRequestID(rs.getInt("RequestID"));
                r.setStudentName(rs.getString("StudentName"));
                r.setCourseName(rs.getString("CourseTitle"));
                r.setStatus(rs.getString("Status"));
                r.setCoursePrice(rs.getBigDecimal("CoursePrice"));
                r.setRequestedAt(rs.getTimestamp("RequestedAt"));
                r.setParentName(rs.getString("InstructorName"));
                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public int getTotalRequestCount() {
    String sql = "SELECT COUNT(*) FROM PaymentRequest";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) return rs.getInt(1);
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}
    public List<PaymentRequest> getRequestsByPage(int page, int pageSize) {
    List<PaymentRequest> list = new ArrayList<>();
    String sql = """
        SELECT * FROM (
            SELECT ROW_NUMBER() OVER (ORDER BY RequestedAt DESC) AS RowNum,
                   pr.RequestID, s.FullName AS StudentName, c.Title AS CourseName,
                   u.FullName AS InstructorName, c.Price AS CoursePrice,
                   pr.RequestedAt, pr.Status,c.CourseID
            FROM PaymentRequest pr
            JOIN Users s ON pr.StudentID = s.UserID
            JOIN Courses c ON pr.CourseID = c.CourseID
            JOIN Users u ON c.InstructorID = u.UserID
        ) AS Paged
        WHERE RowNum BETWEEN ? AND ?
    """;

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        int start = (page - 1) * pageSize + 1;
        int end = page * pageSize;

        ps.setInt(1, start);
        ps.setInt(2, end);

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            PaymentRequest req = new PaymentRequest();
            req.setRequestID(rs.getInt("RequestID"));
            req.setStudentName(rs.getString("StudentName"));
            req.setCourseID(rs.getInt("CourseID"));
            req.setCourseName(rs.getString("CourseName"));
            req.setInstructorName(rs.getString("InstructorName"));
            req.setCoursePrice(rs.getBigDecimal("CoursePrice"));
            req.setRequestedAt(rs.getTimestamp("RequestedAt"));
            req.setStatus(rs.getString("Status"));
            list.add(req);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
}
