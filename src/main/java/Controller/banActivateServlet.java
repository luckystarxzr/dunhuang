package Controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/banActivateServlet")
public class banActivateServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String action = request.getParameter("action");
        String message = "";
        boolean success = false;

        try {
            // 数据库操作
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "root", "123456")) {
                String sql = "UPDATE users SET status=? WHERE username=?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                if ("ban".equals(action)) {
                    pstmt.setString(1, "banned");
                    message = "用户 " + username + " 已被封禁";
                } else if ("activate".equals(action)) {
                    pstmt.setString(1, "active");
                    message = "用户 " + username + " 已激活";
                }
                pstmt.setString(2, username);
                int rowsUpdated = pstmt.executeUpdate();
                success = (rowsUpdated > 0);
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "操作失败，请稍后重试";
        }

        // 返回 JSON 响应
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.println("{\"success\": " + success + ", \"message\": \"" + message + "\"}");
    }
}
