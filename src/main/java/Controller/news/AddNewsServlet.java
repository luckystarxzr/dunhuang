package Controller.news;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/AddNewsServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 10, // 10 MB
        maxFileSize = 1024 * 1024 * 500,      // 500 MB
        maxRequestSize = 1024 * 1024 * 1000   // 1 GB
)
public class AddNewsServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "news_uploads";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/web";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "123456";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String content = request.getParameter("content");
        Part filePart = request.getPart("fileName");

        // 验证输入是否为空
        if (title == null || author == null || content == null || filePart == null) {
            response.getWriter().println("<script>alert('所有字段均为必填！');window.location.href='addNews.jsp';</script>");
            return;
        }

        // 保存文件并获取文件路径
        String filePath = saveUploadedFile(request, filePart);
        if (filePath == null) {
            response.getWriter().println("<script>alert('文件上传失败！');window.location.href='addNews.jsp';</script>");
            return;
        }

        // 插入新闻信息到数据库
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(
                     "INSERT INTO news (title, author, content, file_path) VALUES (?, ?, ?, ?)");) {
            Class.forName("com.mysql.cj.jdbc.Driver");

            pstmt.setString(1, title);
            pstmt.setString(2, author);
            pstmt.setString(3, content);
            pstmt.setString(4, filePath);

            int rowsInserted = pstmt.executeUpdate();
            if (rowsInserted > 0) {
                response.getWriter().println("<script>alert('新闻添加成功！');window.location.href='adminboard.jsp';</script>");
            } else {
                response.getWriter().println("<script>alert('新闻添加失败！');window.location.href='adminboard.jsp';</script>");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('数据库错误：" + e.getMessage() + "');window.location.href='adminboard.jsp';</script>");
        }
    }

    private String saveUploadedFile(HttpServletRequest request, Part filePart) throws IOException {
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);

        // 如果上传目录不存在，则创建
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        String fileName = extractFileName(filePart);
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }

        // 安全处理文件名（去除非法字符）
        fileName = fileName.replaceAll("[^a-zA-Z0-9\\.\\-_]", "");

        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);
        return UPLOAD_DIR + "/" + fileName; // 返回相对路径
    }

    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String content : contentDisposition.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}
