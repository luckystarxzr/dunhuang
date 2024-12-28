package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/web";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "123456";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null) {
            out.println("<script>alert('用户名或密码不能为空。');window.location.href='login.jsp';</script>");
            return;
        }

        // 对密码进行哈希加密
        String hashedPassword = hashPassword(password);

        if (hashedPassword == null) {
            out.println("<script>alert('密码加密失败。');window.location.href='login.jsp';</script>");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            out.println("<script>alert('MySQL JDBC 驱动未找到。');window.location.href='login.jsp';</script>");
            return;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sql = "SELECT role, status FROM users WHERE username=? AND password=?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, username);
                pstmt.setString(2, hashedPassword); // 使用哈希后的密码进行验证

                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        String status = rs.getString("status");
                        String role = rs.getString("role");

                        if ("banned".equals(status)) {
                            out.println("<script>alert('您的账户已被禁止登录。');window.location.href='login.jsp';</script>");
                        } else {
                            HttpSession session = request.getSession();
                            session.setAttribute("username", username);
                            session.setAttribute("role", role);

                            if ("admin".equals(role)) {
                                out.println("<script>alert('登录成功！欢迎管理员！');window.location.href='adminboard.jsp';</script>");
                            } else {
                                out.println("<script>alert('登录成功！欢迎用户！');window.location.href='userboard.jsp';</script>");
                            }
                        }
                    } else {
                        out.println("<script>alert('用户名或密码错误。');window.location.href='login.jsp';</script>");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('数据库连接失败：" + e.getMessage() + "');window.location.href='login.jsp';</script>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
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
