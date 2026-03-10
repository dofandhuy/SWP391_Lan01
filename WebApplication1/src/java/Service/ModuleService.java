
package Service;

import Dao.ModuleDAO;
import Entity.Module;
import java.util.List;

public class ModuleService {
    private ModuleDAO moduleDAO = new ModuleDAO();

    public List<Module> getModulesByCourseId(int courseId) {
        return moduleDAO.getModulesByCourseId(courseId);
    }

    public boolean addModule(Module module) {
        return moduleDAO.addModule(module);
    }

    public void deleteModulesByCourseId(int courseId) {
        moduleDAO.deleteModulesByCourseId(courseId);
    }

    public boolean deleteModule(int moduleId) {
        return moduleDAO.deleteModule(moduleId);
    }
    public Module getModuleById(int moduleId) {
    return moduleDAO.getModuleById(moduleId);
}
    public boolean updateModule(Module module) {
    return moduleDAO.updateModule(module);
}

    public int getCourseId(int moduleId) {
        return moduleDAO.getCourseId(moduleId);
    }

}