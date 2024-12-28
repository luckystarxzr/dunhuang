package Controller.report;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
@WebServlet("/DeleteCommentServlet")
public class DeleteCommentServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }

        String jdbcUrl = "jdbc:mysql://localhost:3306/web";
        String dbUser = "root";
        String dbPassword = "123456";

        String commentIdStr = request.getParameter("commentId");

        if (commentIdStr == null) {
            response.getWriter().write("{\"success\":false, \"message\":\"评论ID不能为空\"}");
            return;
        }

        try (Connection connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword)) {
            // 设置事务，保证两个删除操作一致
            connection.setAutoCommit(false);

            // 删除评论记录
            try (PreparedStatement deleteCommentPS = connection.prepareStatement("DELETE FROM comments WHERE id = ?")) {
                deleteCommentPS.setInt(1, Integer.parseInt(commentIdStr));
                int commentRows = deleteCommentPS.executeUpdate();

                // 删除举报记录
                try (PreparedStatement deleteReportPS = connection.prepareStatement("DELETE FROM reports WHERE comment_id = ?")) {
                    deleteReportPS.setInt(1, Integer.parseInt(commentIdStr));
                    int reportRows = deleteReportPS.executeUpdate();

                    if (commentRows > 0) {
                        // 提交事务
                        connection.commit();
                        response.getWriter().write("{\"success\":true, \"message\":\"评论及举报记录删除成功\"}");
                        System.out.println("删除成功: 评论ID=" + commentIdStr + ", 评论记录=" + commentRows + ", 举报记录=" + reportRows);
                    } else {
                        // 如果没有找到对应评论，回滚事务
                        connection.rollback();
                        response.getWriter().write("{\"success\":false, \"message\":\"未找到评论，删除失败\"}");
                        System.out.println("未找到对应评论，评论ID=" + commentIdStr);
                    }
                }
            } catch (SQLException e) {
                connection.rollback();
                response.getWriter().write("{\"success\":false, \"message\":\"删除操作时出错: " + e.getMessage() + "\"}");
                System.err.println("删除失败，错误: " + e.getMessage());
            }
        } catch (SQLException e) {
            response.getWriter().write("{\"success\":false, \"message\":\"数据库连接失败: " + e.getMessage() + "\"}");
        }
    }
}

