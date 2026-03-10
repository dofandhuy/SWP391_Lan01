package Service;

import DAO.FileDao;
import Entity.Material;
import java.util.List;

public class FileService {
    private FileDao fileDao = new FileDao();



   

    public boolean classExists(String className) {

        return fileDao.checkClassExistsByName(className);

    }



  

    public int getClassIdByName(String className) {

        return fileDao.getClassIdByName(className);

    }



   

 public List<Material> getMaterialsByClassId(int classId) {

        return fileDao.getMaterialsByClassId(classId);

    }

   

    public void saveMaterial(Material material) {

    

        fileDao.saveMaterial(material);

    }

}