package Entity;

import java.sql.Date;
import java.sql.Timestamp;

public class User {
    private int userID;
    private String username;
    private String passwordHash;
    private String email;
    private String fullName;
    private String avatar;
    private String phone;
    private String sex;
    private String address;
    private Date dob;
    private Role role;       // thay vì int roleID
    private boolean status;
    private Timestamp createdAt;

    public User() {}

    public User(int userID, String username, String passwordHash, String email,
                String fullName, String avatar, String phone, String sex,
                String address, Date dob, Role role, boolean status, Timestamp createdAt) {
        this.userID = userID;
        this.username = username;
        this.passwordHash = passwordHash;
        this.email = email;
        this.fullName = fullName;
        this.avatar = avatar;
        this.phone = phone;
        this.sex = sex;
        this.address = address;
        this.dob = dob;
        this.role = role;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getter & Setter...
    // (giữ nguyên như trước nhưng thay roleID bằng Role)

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
