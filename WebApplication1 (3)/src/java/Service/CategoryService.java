package Service;

import Dao.CategoryDAO;
import Entity.Category;
import java.util.List;

public class CategoryService {
    private static final CategoryDAO dao = new CategoryDAO();

    public static List<Category> getAllCategories() {
        return dao.getAllCategories();
    }

    public static Category getCategoryById(int id) {
        return dao.getCategoryById(id);
    }
}
