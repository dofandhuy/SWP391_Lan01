package Servlet;

import Dao.CourseDAO;
import Dao.LessonDAO;
import Dao.ModuleDAO;
import Entity.Module;
import Entity.Lesson;
import Entity.LessonDocument;
import Entity.LessonVideo;
import Entity.Question;
import Entity.QuizDetailsDTO;
import Entity.User;
import Service.CategoryService;
import Service.LessonDocumentService;
import Service.LessonService;
import Service.LessonVideoService;
import Service.ModuleService;
import Service.QuestionService;
import Service.QuizService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ModuleDetailServlet extends HttpServlet {

    private ModuleService moduleService = new ModuleService();
    private LessonService lessonService = new LessonService();
    private CategoryService categoryService = new CategoryService();
    private QuestionService questionService = new QuestionService();
    private LessonDocumentService docService = new LessonDocumentService();
    private LessonVideoService vidService = new LessonVideoService();
    private QuizService quizService = new QuizService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("🔹 [DEBUG] ModuleDetailServlet.doGet() được gọi!");

        try {
            // lấy session
            HttpSession session = request.getSession();

            User currentUser = (User) session.getAttribute("user");

            if (currentUser == null) {

                response.sendRedirect("Signin.jsp");

                return;

            }

            int studentId = currentUser.getUserID();

            // 🟢 1. Lấy tham số từ URL
            String courseParam = request.getParameter("courseID");
            String moduleParam = request.getParameter("moduleID");

            // 🟢 2. Xử lý tham số & mặc định
            int courseID = (courseParam != null) ? Integer.parseInt(courseParam) : 1;
            List<Module> modulesList = moduleService.getModulesByCourseId(courseID);

            int moduleID;
            if (moduleParam != null) {
                moduleID = Integer.parseInt(moduleParam);
            } else if (!modulesList.isEmpty()) {
                moduleID = modulesList.get(0).getId();
            } else {
                moduleID = 0;
            }

            // 🟢 3. Lấy module + lesson
            Module module = moduleService.getModuleById(moduleID);
            List<Lesson> lessonsList = lessonService.getLessonsByModuleId(moduleID);

            // 🟢 4. Lấy CategoryID theo course
            int categoryID = (int) categoryService.getCategoryIdByCourse(courseID).getCategoryId();

            //lấy docs, vid theo lesson hiển thị lên jsp
            Map<Integer, List<Question>> lessonQuestionsMap = new HashMap<>();
            Map<Integer, List<LessonDocument>> lessonDocsMap = new HashMap<>();
            Map<Integer, List<LessonVideo>> lessonVidMap = new HashMap<>();
            for (Lesson lesson : lessonsList) {
                List<Question> qList = questionService.getRandomQuestionsByCategory(categoryID, 3);
                List<LessonDocument> docs = docService.getDocumentsByLesson1(lesson.getLessonID());
                List<LessonVideo> vid = vidService.getVideosByLessonId(lesson.getLessonID());

                lessonDocsMap.put(lesson.getLessonID(), docs);
                lessonVidMap.put(lesson.getLessonID(), vid);
                lessonQuestionsMap.put(lesson.getLessonID(), qList);

            }

            //quiz-preview
            int quizId = quizService.getQuizByModuleId(moduleID).getQuizID();

            // --- BƯỚC 2: GỌI SERVICE ---
            // Bạn đang fix cứng quizId=2 để test. OK!
            QuizDetailsDTO quizData = quizService.getQuizDetailsForStudent(quizId, studentId);

            // --- BƯỚC 3: GỬI DỮ LIỆU SANG VIEW (JSP) ---
            // Đặt tên là "data" để khớp với ${data.quizTitle} trong JSP
            request.setAttribute("data", quizData);

            // 🟢 6. Gửi dữ liệu sang JSP
            request.setAttribute("lessonVidMap", lessonVidMap);
            request.setAttribute("lessonDocsMap", lessonDocsMap);
            request.setAttribute("lessonQuestionsMap", lessonQuestionsMap);
            request.setAttribute("module", module);
            request.setAttribute("modulesList", modulesList);
            request.setAttribute("lessonsList", lessonsList);

            request.getRequestDispatcher("module_detail.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("❌ [ERROR] Lỗi trong ModuleDetailServlet: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }

    }

    @Override
    public String getServletInfo() {
        return "Hiển thị chi tiết module và danh sách bài học + các module trong course";
    }
}
