package Servlet;

import Entity.Material;

import jakarta.servlet.ServletException;

import jakarta.servlet.http.*;

import java.io.File;

import java.io.IOException;

import java.nio.file.Paths;

import java.util.List;

import Service.FileService;

import jakarta.servlet.annotation.MultipartConfig;

@MultipartConfig

public class UploadFile extends HttpServlet {

    private final FileService fileService = new FileService();

    @Override

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String className = request.getParameter("className");

        String title = request.getParameter("title");

        String uploadedBy = request.getParameter("uploadedBy");

        if (className == null || className.trim().isEmpty()) {

            request.setAttribute("error", "Class name is required.");

            request.getRequestDispatcher("uploadMaterial.jsp").forward(request, response);

            return;

        }

        if (!fileService.classExists(className)) {

            request.setAttribute("error", "Class with name '" + className + "' does not exist.");

            request.getRequestDispatcher("uploadMaterial.jsp").forward(request, response);

            return;

        }

        int classId = fileService.getClassIdByName(className);

        Part filePart = request.getPart("file");

        if (filePart == null || filePart.getSize() == 0) {

            request.setAttribute("error", "Please choose a file to upload.");

            request.getRequestDispatcher("uploadMaterial.jsp").forward(request, response);

            return;

        }

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        String uploadDirAbsolute = getServletContext().getRealPath("") + File.separator + "uploads";

        File uploadDir = new File(uploadDirAbsolute);

        if (!uploadDir.exists() && !uploadDir.mkdirs()) {

            request.setAttribute("error", "Cannot create upload directory on server.");

            request.getRequestDispatcher("uploadMaterial.jsp").forward(request, response);

            return;

        }

        String absoluteFilePath = uploadDirAbsolute + File.separator + fileName;

        try {

            filePart.write(absoluteFilePath);

        } catch (IOException e) {

            e.printStackTrace();

            request.setAttribute("error", "Failed to save file on server: " + e.getMessage());

            request.getRequestDispatcher("uploadMaterial.jsp").forward(request, response);

            return;

        }

        Material material = new Material();

        material.setClassId(classId);

        material.setTitle(title);

        material.setFilePath("uploads/" + fileName); // đường dẫn relative

        material.setUploadedBy(uploadedBy);

        try {
            fileService.saveMaterial(material);

        } catch (Exception e) {

            e.printStackTrace();

            File saved = new File(absoluteFilePath);

            if (saved.exists()) {
                saved.delete(); // rollback file nếu DB fail
            }
            request.setAttribute("error", "Failed to save file info to database.");

            request.getRequestDispatcher("uploadMaterial.jsp").forward(request, response);

            return;

        }

        List<Material> allMaterials = fileService.getMaterialsByClassId(classId);

        request.setAttribute("materials", allMaterials);

        request.setAttribute("className", className);

        request.getRequestDispatcher("receiveMaterial.jsp").forward(request, response);

    }

}
