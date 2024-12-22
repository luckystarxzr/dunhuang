package Controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.sql.*;

@WebServlet("/download")
public class DownloadServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/web";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "123456";
    private static final String UPLOAD_DIR = "C:\\Users\\lucky\\Desktop\\web\\src\\main\\web\\files";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 设置请求编码
        request.setCharacterEncoding("UTF-8");
        // 设置响应内容类型和编码
        response.setContentType("text/html; charset=UTF-8");
        int fileId = Integer.parseInt(request.getParameter("fileId"));
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        String sql = "SELECT * FROM files WHERE id=?";

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, fileId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                String owner = rs.getString("owner");
                String fileType = rs.getString("file_type");
                boolean isBanned = rs.getBoolean("is_banned");

                // 检查文件是否被封存
                if (isBanned) {
                    response.getWriter().write("该文件已被封存，无法下载。");
                    return;
                }

                // 检查当前用户是否有权限下载
                HttpSession session = request.getSession();
                String currentUser = (String) session.getAttribute("username");
                boolean hasAccess = "public".equals(fileType) || owner.equals(currentUser);

                if (hasAccess) {
                    String filePath = UPLOAD_DIR + rs.getString("file_name");
                    File file = new File(filePath);
                    if (file.exists()) {
                        // 更新下载次数
                        updateDownloadCount(fileId);

                        response.setContentType("application/octet-stream");
                        response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");
                        Files.copy(file.toPath(), response.getOutputStream());
                        response.getOutputStream().flush();
                    } else {
                        response.getWriter().write("文件不存在。");
                    }
                } else {
                    response.getWriter().write("您没有权限下载该文件。");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("数据库错误：" + e.getMessage());
        }
    }

    private void updateDownloadCount(int fileId) throws SQLException {
        String updateSql = "UPDATE files SET download_count = download_count + 1 WHERE id=?";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
             PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
            pstmt.setInt(1, fileId);
            pstmt.executeUpdate();
        }
    }
}
