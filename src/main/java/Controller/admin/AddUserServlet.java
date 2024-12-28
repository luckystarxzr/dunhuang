package Controller.admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;
@WebServlet("/addUser")
public class AddUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // 设置响应的内容类型为 JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 检查是否提供了所有必填字段
        if (username == null || password == null || role == null || username.isEmpty() || password.isEmpty() || role.isEmpty()) {
            response.getWriter().write("{\"error\": \"输入无效，请填写所有字段\"}");
            return;
        }

        try {
            // 加载 JDBC 驱动
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            // 捕获 JDBC 驱动加载失败
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"无法加载数据库驱动\"}");
            return;
        }

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "root", "123456")) {
            // 检查用户名是否已存在
            String checkSql = "SELECT COUNT(*) FROM users WHERE username = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, username);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        response.getWriter().write("{\"error\": \"用户名已存在\"}");
                    } else {
                        // 插入新用户
                        String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
                        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                            pstmt.setString(1, username);
                            pstmt.setString(2, password);
                            pstmt.setString(3, role);
                            pstmt.executeUpdate();
                            response.getWriter().write("{\"success\": true}");
                        } catch (SQLException e) {
                            // 捕获执行插入 SQL 失败
                            e.printStackTrace();
                            response.getWriter().write("{\"error\": \"数据库插入失败，稍后再试\"}");
                        }
                    }
                }
            }
        } catch (SQLException e) {
            // 捕获数据库连接或 SQL 执行错误
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"数据库错误，请稍后再试。\"}");
        }
    }
}
