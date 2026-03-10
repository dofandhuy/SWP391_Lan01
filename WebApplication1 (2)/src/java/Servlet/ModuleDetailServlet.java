package Servlet;

import Dao.LessonDAO;
import Dao.ModuleDAO;
import Entity.Module;
import Entity.Lesson;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

public class ModuleDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy tham số từ URL
            String courseParam = request.getParameter("courseID");
            String moduleParam = request.getParameter("moduleID");

            // Nếu người dùng chưa chọn module → mặc định module đầu tiên trong course
            int courseID = (courseParam != null) ? Integer.parseInt(courseParam) : 1;

            ModuleDAO moduleDAO = new ModuleDAO();
            LessonDAO lessonDAO = new LessonDAO();

            List<Module> modulesList = moduleDAO.getModulesByCourseId(courseID);
            int moduleID;

            if (moduleParam != null) {
                moduleID = Integer.parseInt(moduleParam);
            } else if (!modulesList.isEmpty()) {
                moduleID = modulesList.get(0).getId();
            } else {
                moduleID = 0;
            }

            // Lấy thông tin module và lesson
            Module module = moduleDAO.getModuleById(moduleID);
            List lessonsList = lessonDAO.getLessonsByModuleId(moduleID);

            // Gửi dữ liệu qua JSP
            request.setAttribute("module", module);
            request.setAttribute("modulesList", modulesList);
            request.setAttribute("lessonsList", lessonsList);

            request.getRequestDispatcher("module_detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }

    @Override
    public String getServletInfo() {
        return "Hiển thị chi tiết module và danh sách bài học + các module trong course";
    }
}
