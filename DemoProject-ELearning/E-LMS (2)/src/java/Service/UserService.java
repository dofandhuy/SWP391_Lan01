/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Service;

import DAO.UserDAO;
import Entity.Role;
import Entity.User;

import java.security.MessageDigest;
import java.util.List;

public class UserService {

    private final UserDAO dao = new UserDAO();



    // ========================= SIGN IN =========================
    public User signIn(String email, String password) throws Exception {
        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            throw new Exception("Vui lòng nhập đầy đủ email và mật khẩu!");
        }

        // hash password trước khi gọi UserDAO
        String passwordHash = hashPassword(password);
        User user = dao.signIn(email, passwordHash);
        if (user == null) {
            throw new Exception("Email hoặc mật khẩu không đúng!");
        }

        return user;
    }

    // ========================= SIGN UP =========================
    public void signUp(String username, String email, String password, String confirmPassword,
            String roleIdStr, String phone, String dob, String sex, String address) throws Exception {

        if (username == null || username.isEmpty()
                || email == null || email.isEmpty()
                || password == null || password.isEmpty()
                || confirmPassword == null || confirmPassword.isEmpty()
                || roleIdStr == null || roleIdStr.isEmpty()) {
            throw new Exception("Vui lòng điền đầy đủ thông tin!");
        }

        if (!password.equals(confirmPassword)) {
            throw new Exception("Mật khẩu không trùng khớp!");
        }

        if (dao.existsByEmail(email)) {
            throw new Exception("Email đã tồn tại!");
        }

        String passwordHash = hashPassword(password);
        int roleID = Integer.parseInt(roleIdStr);

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPasswordHash(passwordHash);
        user.setFullName(username);  // ban đầu fullname = username
        user.setAvatar("");          // mặc định rỗng
        user.setPhone(phone);
        user.setSex(sex);
        user.setAddress(address);

        // convert String dob -> java.sql.Date
        if (dob != null && !dob.isEmpty()) {
            try {
                user.setDob(java.sql.Date.valueOf(dob)); // dob format: yyyy-MM-dd
            } catch (IllegalArgumentException e) {
                throw new Exception("Ngày sinh không hợp lệ! Định dạng phải là yyyy-MM-dd.");
            }
        }

        user.setRole(new Role(roleID));
        user.setStatus(true);

        boolean success = dao.Insert(user);
        if (!success) {
            throw new Exception("Đăng ký thất bại. Hãy thử lại.");
        }
    }

    // ========================= GET ALL ROLES =========================
    public List<Role> getAllRoles() {
        return dao.getAllRoles();
    }

    // ========================= HASH PASSWORD =========================
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5"); // demo
            byte[] hashBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateUserProfile(User user) {

        UserDAO dao = new UserDAO();

        // validate, business logic, v.v
        dao.updateUser(user);

    }
}
