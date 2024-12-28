package Controller.admin;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/userManagementServlet")
public class UserManagementServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String username = request.getParameter("username");
        String newUser = request.getParameter("newUser");
        String newRole = request.getParameter("newRole");
        String newPassword = request.getParameter("newPassword");

        String message = null;
        try {
            String url = "jdbc:mysql://localhost:3306/web?useSSL=false&serverTimezone=UTC";
            String dbUser = "root";
            String dbPass = "123456";
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, dbUser, dbPass)) {
                if ("ban".equals(action)) {
                    String sql = "UPDATE users SET status = 'banned' WHERE username = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        stmt.setString(1, username);
                        int result = stmt.executeUpdate();
                        message = result > 0 ? "用户已封禁" : "用户封禁失败";
                    }
                } else if ("activate".equals(action)) {
                    String sql = "UPDATE users SET status = 'active' WHERE username = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        stmt.setString(1, username);
                        int result = stmt.executeUpdate();
                        message = result > 0 ? "用户已激活" : "用户激活失败";
                    }
                } else if (newUser != null) {
                    String sql = "INSERT INTO users (username, role, password, status) VALUES (?, ?, ?, 'active')";
                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        stmt.setString(1, newUser);
                        stmt.setString(2, newRole);
                        stmt.setString(3, newPassword);
                        int result = stmt.executeUpdate();
                        message = result > 0 ? "用户已添加" : "添加失败";
                    }
                }
                if (username != null && newPassword != null) {
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                            String sql = "UPDATE users SET password=? WHERE username=?";
                            PreparedStatement pstmt = conn.prepareStatement(sql);
                            pstmt.setString(1, newPassword);
                            pstmt.setString(2, username);
                            pstmt.executeUpdate();
                            message = "密码已更新!";
                    } catch (Exception e) {
                        e.printStackTrace();
                        message = "更新密码失败！";
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "操作失败";
        }

        response.setContentType("text/plain");
        response.getWriter().write(message); // 返回处理结果
    }
}

