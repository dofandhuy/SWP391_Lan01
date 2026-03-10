package Service;

import Dao.PaymentDAO;
import Dao.EnrollmentDAO;
import Entity.PaymentRequest;
import java.util.ArrayList;
import java.util.List;

public class PaymentService {

    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();

    /**
     * Học sinh gửi yêu cầu thanh toán tới phụ huynh.
     *
     * @param studentID ID học sinh
     * @param courseID ID khóa học
     * @return thông báo kết quả
     */
    public String requestPayment(int studentID, int courseID) {
        // ✅ 1. Tìm phụ huynh liên kết
        int parentID = paymentDAO.getParentIdByStudent(studentID);
        if (parentID == -1) {
            return "❌ Không tìm thấy phụ huynh liên kết với tài khoản học sinh.";
        }

        // ✅ 2. Kiểm tra xem đã có yêu cầu chờ chưa
        if (paymentDAO.hasPendingRequest(studentID, courseID)) {
            return "🕒 Yêu cầu thanh toán cho khóa học này đang chờ duyệt.";
        }

        // ✅ 3. Tạo yêu cầu mới
        boolean created = paymentDAO.createPaymentRequest(studentID, parentID, courseID);
        if (!created) {
            return "⚠️ Không thể tạo yêu cầu thanh toán. Vui lòng thử lại.";
        }

        return "✅ Yêu cầu thanh toán đã được gửi cho phụ huynh.";
    }

    /**
     * Phụ huynh phê duyệt thanh toán => cập nhật trạng thái và ghi danh học
     * sinh.
     *
     * @param requestID ID của yêu cầu thanh toán
     * @return true nếu thành công
     */
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

    /**
     * Phụ huynh từ chối thanh toán.
     */
    public boolean rejectPayment(int requestID) {
        return paymentDAO.updateStatus(requestID, "Rejected");
    }
    public List<PaymentRequest>  getPendingRequestsByParentID(int parentID){
         return paymentDAO.getPendingRequestsByParent(parentID);
    }
}
