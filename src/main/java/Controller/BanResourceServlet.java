package Controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/banResource")
public class BanResourceServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/web";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "123456";

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 设置请求编码
        request.setCharacterEncoding("UTF-8");
        // 设置响应内容类型和编码
        response.setContentType("text/html; charset=UTF-8");

        int fileId = Integer.parseInt(request.getParameter("fileId"));
        String selectSql = "SELECT is_banned FROM files WHERE id = ?";
        String updateSql;

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
             PreparedStatement selectStmt = conn.prepareStatement(selectSql)) {

            selectStmt.setInt(1, fileId);
            ResultSet rs = selectStmt.executeQuery();

            if (rs.next()) {
                boolean isBanned = rs.getBoolean("is_banned");
                // 根据当前状态决定更新操作
                if (isBanned) {
                    updateSql = "UPDATE files SET is_banned = FALSE WHERE id = ?";
                } else {
                    updateSql = "UPDATE files SET is_banned = TRUE WHERE id = ?";
                }

                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    updateStmt.setInt(1, fileId);
                    updateStmt.executeUpdate();
                    String message = isBanned ? "文件已成功解封。" : "文件已成功封存。";
                    response.getWriter().write(message);
                }
            } else {
                response.getWriter().write("错误：未找到对应的文件。");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("数据库错误：" + e.getMessage());
        }
    }
}
