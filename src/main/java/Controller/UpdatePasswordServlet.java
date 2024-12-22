package Controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/updatePassword")
public class UpdatePasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws  IOException {
        String username = request.getParameter("username");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        if (username != null && currentPassword != null && newPassword != null) {
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web?useSSL=false&serverTimezone=UTC", "root", "123456")) {
                // 验证当前密码是否正确
                String checkSql = "SELECT password FROM users WHERE username = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setString(1, username);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next() && rs.getString("password").equals(currentPassword)) {
                    // 更新密码
                    String updateSql = "UPDATE users SET password = ? WHERE username = ?";
                    PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                    updateStmt.setString(1, newPassword);
                    updateStmt.setString(2, username);
                    updateStmt.executeUpdate();
                    response.getWriter().write("{\"success\": true, \"message\": \"密码更新成功。\"}");
                } else {
                    response.getWriter().write("{\"error\": true, \"message\": \"当前密码不正确。\"}");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().write("{\"error\": true, \"message\": \"数据库错误，请稍后再试。\"}");
            }
        } else {
            response.getWriter().write("{\"error\": true, \"message\": \"输入无效，请填写所有字段。\"}");
        }
    }
}
