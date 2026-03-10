/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

/**
 *
 * @author ASUS
 */
import Entity.TokenForgetPassword;
import Entity.User;
import Context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 *
 * @author HP
 */
public class TokenForgetDAO extends DBContext{
    
     public String getFormatDate(LocalDateTime myDateObj) {
        DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");  
        String formattedDate = myDateObj.format(myFormatObj);  
        return formattedDate;
     }
    
    public boolean insertTokenForget(TokenForgetPassword tokenForget) {
    String sql = "INSERT INTO [dbo].[tokenForgetPassword]\n"
            + "([token]\n"
            + ",[expiryTime]\n"
            + ",[isUsed]\n"
            + ",[userId])\n"
            + "VALUES(?, ?, ?, ?)";

    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, tokenForget.getToken());
        ps.setTimestamp(2, Timestamp.valueOf(getFormatDate(tokenForget.getExpiryTime())));
        ps.setBoolean(3, tokenForget.isIsUsed());
        ps.setInt(4, tokenForget.getUserId());

        return ps.executeUpdate() > 0;

    } catch (SQLException e) {
        System.out.println("SQL Error: " + e.getMessage());
    } catch (Exception e) {
        System.out.println("Connection Error: " + e.getMessage());
    }
    return false;
}

    
    
  public TokenForgetPassword getTokenPassword(String token) {
    String sql = "SELECT * FROM [tokenForgetPassword] WHERE token = ?";
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement st = conn.prepareStatement(sql)) {

        st.setString(1, token);
        ResultSet rs = st.executeQuery();

        if (rs.next()) {
            return new TokenForgetPassword(
                rs.getInt("TokenID"),                          // đúng cột
                rs.getInt("UserID"),                           // đúng cột
                rs.getBoolean("IsUsed"),                       // đúng cột
                rs.getString("Token"),                         // đúng cột
                rs.getTimestamp("ExpiryTime").toLocalDateTime()// đúng cột
            );
        }

    } catch (SQLException e) {
        System.out.println("SQL Error in getTokenPassword: " + e.getMessage());
    } catch (Exception e) {
        System.out.println("Connection Error in getTokenPassword: " + e.getMessage());
    }
    return null;
}

public void updateStatus(TokenForgetPassword token) {
    String sql = "UPDATE [dbo].[tokenForgetPassword]\n"
               + "   SET [isUsed] = ?\n"
               + " WHERE token = ?";
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement st = conn.prepareStatement(sql)) {

        st.setBoolean(1, token.isIsUsed());
        st.setString(2, token.getToken());
        st.executeUpdate();

    } catch (SQLException e) {
        System.out.println("SQL Error in updateStatus: " + e.getMessage());
    } catch (Exception e) {
        System.out.println("Connection Error in updateStatus: " + e.getMessage());
    }
}

}
