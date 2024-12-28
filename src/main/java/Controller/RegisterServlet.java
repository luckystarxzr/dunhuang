package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/web?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "123456";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
        // 验证输入是否为空
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            out.println("<script>alert('用户名或密码不能为空。');window.location.href='register.jsp';</script>");
            return;
        }

        // 对密码进行哈希加密
        String hashedPassword = hashPassword(password);
        if (hashedPassword == null) {
            out.println("<script>alert('密码加密失败。');window.location.href='register.jsp';</script>");
            return;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 检查用户名是否已存在
            String checkUserSql = "SELECT COUNT(*) FROM users WHERE username = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkUserSql)) {
                checkStmt.setString(1, username);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        out.println("<script>alert('注册失败：用户名已存在。');window.location.href='register.jsp';</script>");
                        return;
                    }
                }
            }

            // 插入新用户
            String sql = "INSERT INTO users (username, password, role, status) VALUES (?, ?, 'user', 'active')";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, username);
                pstmt.setString(2, hashedPassword);

                int rowsInserted = pstmt.executeUpdate();
                if (rowsInserted > 0) {
                    out.println("<script>alert('注册成功！');window.location.href='login.jsp';</script>");
                } else {
                    out.println("<script>alert('注册失败，请稍后重试。');window.location.href='register.jsp';</script>");
                }
            }

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            out.println("<script>alert('MySQL JDBC 驱动未找到。');window.location.href='register.jsp';</script>");
        } catch (SQLException e) {
            e.printStackTrace();
            if (e.getMessage().contains("Duplicate entry")) {
                out.println("<script>alert('注册失败：用户名已存在。');window.location.href='register.jsp';</script>");
            } else {
                out.println("<script>alert('数据库连接失败：" + e.getMessage() + "');window.location.href='register.jsp';</script>");
            }
        }
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }
}
