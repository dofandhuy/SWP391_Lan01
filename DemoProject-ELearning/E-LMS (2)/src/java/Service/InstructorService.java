package Service;

import Entity.ClassEntity;
import Entity.InstructorClass;
import DAO.InstructorDAO;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class InstructorService {
    private InstructorDAO instructorDAO = new InstructorDAO();

    public List<InstructorClass> getInstructorClasses(int instructorId, String keyword, String sort) {
        List<InstructorClass> classes = instructorDAO.getClassesByInstructor(instructorId);

        // Search (không dùng lambda)
        if (keyword != null && !keyword.isEmpty()) {
            List<InstructorClass> filtered = new ArrayList<>();
            for (InstructorClass c : classes) {
                if ((c.getClassName() != null && c.getClassName().toLowerCase().contains(keyword.toLowerCase()))
                        || (c.getClassCode() != null && c.getClassCode().toLowerCase().contains(keyword.toLowerCase()))) {
                    filtered.add(c);
                }
            }
            classes = filtered;
        }

        // Sort (không dùng lambda)
        if ("name".equals(sort)) {
            Collections.sort(classes, new Comparator<InstructorClass>() {
                @Override
                public int compare(InstructorClass a, InstructorClass b) {
                    return a.getClassName().compareToIgnoreCase(b.getClassName());
                }
            });
        } else if ("student".equals(sort)) {
            Collections.sort(classes, new Comparator<InstructorClass>() {
                @Override
                public int compare(InstructorClass a, InstructorClass b) {
                    return b.getStudentCount() - a.getStudentCount();
                }
            });
        }

        return classes;
    }

    public void createClass(String code, String name, int instructorId) {
        instructorDAO.createClass(code, name, instructorId);
    }

    public ClassEntity getClassById(int classId) {
        return instructorDAO.getClassById(classId);
    }

    public boolean updateClass(int classId, String className, String description, int instructorId) {
        List<InstructorClass> list = instructorDAO.getClassesByInstructor(instructorId);
        boolean owned = false;
        for (InstructorClass c : list) {
            if (c.getClassId() == classId) {
                owned = true;
                break;
            }
        }
        if (owned) {
            return instructorDAO.updateClass(classId, className, description);
        }
        return false;
    }

    public void deleteClass(int classId) {
        instructorDAO.deleteClass(classId);
    }
}
