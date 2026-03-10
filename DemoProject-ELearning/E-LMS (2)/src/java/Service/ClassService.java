package Service;


import Entity.ClassEntity;
import DAO.ClassDAO;
import Entity.ClassInfo;
import java.util.Date;

import java.util.List;
import java.util.Random;

public class ClassService {
    private ClassDAO classDAO = new ClassDAO();
    
    
    private String generateClassCode() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder code = new StringBuilder();
        Random rnd = new Random();
        for (int i = 0; i < 6; i++) {
            code.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return code.toString();
    }
    
     public void createClass(String name, String desc, int instructorId) {
         String code = generateClassCode();
        ClassEntity cls = new ClassEntity(name, desc, code, instructorId, new Date());
        classDAO.createClass(cls);
    }

    public List<ClassInfo> getStudentClasses(int userId, String keyword, String sortBy) {
        List<ClassInfo> classes = classDAO.getEnrolledClasses(userId);

        // filter (search)
        if (keyword != null && !keyword.isEmpty()) {
            classes = classes.stream()
                    .filter(c -> c.getClassName().toLowerCase().contains(keyword.toLowerCase()))
                    .toList();
        }

        // sort
        if ("name".equals(sortBy)) {
            classes = classes.stream().sorted((a,b) -> a.getClassName().compareToIgnoreCase(b.getClassName())).toList();
        } else if ("student".equals(sortBy)) {
            classes = classes.stream().sorted((a,b) -> b.getStudentCount() - a.getStudentCount()).toList();
        }

        return classes;
    }
}
