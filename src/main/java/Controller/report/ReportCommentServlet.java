package Controller.report;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/ReportCommentServlet")
public class ReportCommentServlet extends HttpServlet {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/web";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "123456";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // 获取当前会话
        HttpSession session = request.getSession();
        String reportedBy = (String) session.getAttribute("username");

        // 验证用户是否已登录
        if (reportedBy == null) {
            // 用户未登录，重定向到登录页面
            response.sendRedirect("login.jsp");
            return;
        }

        // 获取请求参数
        String commentId = request.getParameter("commentId");
        String newsId = request.getParameter("newsId");
        String reason = request.getParameter("reason");

        if (commentId == null || newsId == null || reason == null || reason.trim().isEmpty()) {
            out.println("<p>举报失败：所有字段均为必填。</p>");
            out.println("<a href='newsDetail.jsp?id=" + newsId + "'>返回新闻</a>");
            return;
        }

        Connection connection = null;
        PreparedStatement ps = null;

        try {
            // 建立数据库连接
            connection = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);

            // 插入举报信息
            String sql = "INSERT INTO reports (comment_id, news_id, reported_by, report_reason, report_time) " +
                    "VALUES (?, ?, ?, ?, NOW())";
            ps = connection.prepareStatement(sql);
            ps.setString(1, commentId);
            ps.setString(2, newsId);
            ps.setString(3, reportedBy);
            ps.setString(4, reason);

            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                out.println("<p>举报成功！</p>");
            } else {
                out.println("<p>举报失败，请稍后重试。</p>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p>举报失败: " + e.getMessage() + "</p>");
        } finally {
            try {
                if (ps != null) ps.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        out.println("<a href='newsDetail.jsp?id=" + newsId + "'>返回新闻</a>");
    }
}
