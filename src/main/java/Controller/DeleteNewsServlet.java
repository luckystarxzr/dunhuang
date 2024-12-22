package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/DeleteNewsServlet")
public class DeleteNewsServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String newsId = request.getParameter("id");

        if (newsId == null || newsId.isEmpty()) {
            response.getWriter().println("<p>未指定新闻ID。</p>");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "root", "123456");

            // 删除评论
            String deleteCommentsSql = "DELETE FROM comments WHERE news_id = ?";
            pstmt = conn.prepareStatement(deleteCommentsSql);
            pstmt.setString(1, newsId);
            pstmt.executeUpdate();

            // 删除新闻
            String deleteNewsSql = "DELETE FROM news WHERE id = ?";
            pstmt = conn.prepareStatement(deleteNewsSql);
            pstmt.setString(1, newsId);
            int rowsDeleted = pstmt.executeUpdate();

            if (rowsDeleted > 0) {
                response.getWriter().println("<p>新闻删除成功！</p>");
            } else {
                response.getWriter().println("<p>新闻删除失败！</p>");
            }
        } catch (SQLException e) {
            response.getWriter().println("<p>数据库错误: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            response.getWriter().println("<p>数据库驱动加载错误: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        // 返回到管理页面
        response.sendRedirect("adminnew.jsp");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // POST 请求处理逻辑
        doPost(request, response);
    }
}
