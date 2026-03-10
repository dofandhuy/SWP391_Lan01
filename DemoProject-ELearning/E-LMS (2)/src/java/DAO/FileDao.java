/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import Context.DBContext;

import Entity.Material;

import java.sql.Connection;

import java.sql.PreparedStatement;

import java.sql.ResultSet;

import java.util.ArrayList;

import java.util.List;



public class FileDao {



    // Lưu Material mới vào DB

    public void saveMaterial(Material material) {

        String sql = "INSERT INTO Materials (ClassID, Title, FilePath, UploadedBy, UploadedAt) " +

                     "VALUES (?, ?, ?, ?, GETDATE())";

        try ( Connection conn = new DBContext().getConnection();

             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, material.getClassId());

            ps.setString(2, material.getTitle());

            ps.setString(3, material.getFilePath());

            ps.setString(4, material.getUploadedBy());

            ps.executeUpdate();

        } catch (Exception e) {

            e.printStackTrace();

        }

    }



    // Lấy ClassID từ ClassName

    public int getClassIdByName(String className) {

        String sql = "SELECT ClassID FROM Classes WHERE ClassName = ?";

        try ( Connection conn = new DBContext().getConnection();

             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, className);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    return rs.getInt("ClassID");

                }

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return -1; // Nếu không tìm thấy

    }

    

    

    public List<Material> getMaterialsByClassId(int classId) {

        List<Material> list = new ArrayList<>();

        String sql = "SELECT * FROM Materials WHERE ClassID = ?";

        try ( Connection conn = new DBContext().getConnection();

             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, classId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Material m = new Material();

                  

                    m.setClassId(rs.getInt("ClassID"));

                    m.setTitle(rs.getString("Title"));

                    m.setFilePath(rs.getString("FilePath"));

                    m.setUploadedBy(rs.getString("UploadedBy"));

                

                    list.add(m);

                }

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return list;

    }

    

public String getClassNameById(int classId) {

    String sql = "SELECT ClassName FROM Classes WHERE ClassID = ?";

    try ( Connection conn = new DBContext().getConnection();

         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, classId);

        try (ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                return rs.getString("ClassName");

            }

        }
} catch (Exception e) {

        e.printStackTrace();

    }

    return null; 

}

    

    

    public boolean checkClassExistsByName(String className) {

        String sql = "SELECT COUNT(*) FROM Classes WHERE ClassName = ?";

        try ( Connection conn = new DBContext().getConnection();

             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, className);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    return rs.getInt(1) > 0;

                }

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return false; 

    }



}
