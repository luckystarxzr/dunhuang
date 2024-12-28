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
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 50,      // 50 MB
        maxRequestSize = 1024 * 1024 * 100   // 100 MB
)
public class AddNewsServlet extends HttpServlet {
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
            response.getWriter().println("<script>alert('所有字段均为必填！');window.location.href='adminnew.jsp';</script>");
            return;
        }

        // 保存文件并获取文件名
        String fileName = saveUploadedFile(request, filePart);
        if (fileName == null) {
            response.getWriter().println("<script>alert('文件上传失败！');window.location.href='adminnew.jsp';</script>");
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
            pstmt.setString(4, fileName); // 仅存储文件名

            int rowsInserted = pstmt.executeUpdate();
            if (rowsInserted > 0) {
                response.getWriter().println("<script>alert('新闻添加成功！');window.location.href='adminnew.jsp';</script>");
            } else {
                response.getWriter().println("<script>alert('新闻添加失败！');window.location.href='adminnew.jsp';</script>");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.getWriter().println("<script>alert('数据库错误：" + e.getMessage() + "');window.location.href='adminnew.jsp';</script>");
        }
    }

    private String saveUploadedFile(HttpServletRequest request, Part filePart) throws IOException {
        String uploadPath = getServletContext().getRealPath("") + File.separator;
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

        // 返回文件名（不包含路径）
        return fileName;
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
