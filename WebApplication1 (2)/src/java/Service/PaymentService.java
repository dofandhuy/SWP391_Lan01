package Service;

import Dao.PaymentDAO;
import Dao.EnrollmentDAO;
import Entity.PaymentRequest;
import java.util.ArrayList;
import java.util.List;

public class PaymentService {

    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();


   

    public String requestPayment(int studentID, int courseID) {
        int parentID = paymentDAO.getParentIdByStudent(studentID);
        if (parentID == -1) {
            return "❌ Không tìm thấy phụ huynh liên kết với tài khoản học sinh.";
        }
        if (paymentDAO.hasPendingRequest(studentID, courseID)) {
            return "🕒 Yêu cầu thanh toán cho khóa học này đang chờ duyệt.";
        }

        boolean created = paymentDAO.createPaymentRequest(studentID, parentID, courseID);
        if (!created) {
            return "⚠️ Không thể tạo yêu cầu thanh toán. Vui lòng thử lại.";
        }
        return "✅ Yêu cầu thanh toán đã được gửi cho phụ huynh.";
    }

    public boolean approvePayment(int requestID) {
        PaymentRequest req = paymentDAO.getPaymentRequestById(requestID);
        if (req == null) {
            System.out.println("Không tìm thấy yêu cầu thanh toán ID: " + requestID);
            return false;
        }

        // ✅ Cập nhật trạng thái yêu cầu -> Completed
        boolean updated = paymentDAO.updateStatus(requestID, "Completed");
        if (!updated) {
            return false;
        }

        // ✅ Ghi danh học sinh vào khóa học
        return enrollmentDAO.createEnrollment(req.getStudentID(), req.getCourseID());
    }


    public boolean rejectPayment(int requestID) {
        return paymentDAO.updateStatus(requestID, "Rejected");
    }
    public List<PaymentRequest> getPendingRequestsByParentID(int parentID){
         return paymentDAO.getPendingRequestsByParent(parentID);
    }
}
