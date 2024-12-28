package Controller.news;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DeleteNewsServlet")
public class DeleteNewsServlet extends HttpServlet {
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

        String newsIdStr = request.getParameter("newsId");

        if (newsIdStr == null) {
            response.getWriter().write("{\"success\":false, \"message\":\"新闻ID不能为空\"}");
            return;
        }

        try (Connection connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword)) {
            // 设置事务，保证所有相关删除操作一致
            connection.setAutoCommit(false);

            // 删除新闻记录
            try (PreparedStatement deleteNewsPS = connection.prepareStatement("DELETE FROM news WHERE id = ?")) {
                deleteNewsPS.setInt(1, Integer.parseInt(newsIdStr));
                int newsRows = deleteNewsPS.executeUpdate();

                if (newsRows > 0) {
                    // 提交事务
                    connection.commit();
                    response.getWriter().write("{\"success\":true, \"message\":\"新闻删除成功\"}");
                    System.out.println("删除成功: 新闻ID=" + newsIdStr + ", 新闻记录=" + newsRows);
                } else {
                    // 如果没有找到对应新闻，回滚事务
                    connection.rollback();
                    response.getWriter().write("{\"success\":false, \"message\":\"未找到新闻，删除失败\"}");
                    System.out.println("未找到对应新闻，新闻ID=" + newsIdStr);
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
