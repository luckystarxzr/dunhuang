package Controller.news;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/UpdateNewsServlet")
public class UpdateNewsServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/web";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "123456";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        String newsId = request.getParameter("newsId");
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String author = request.getParameter("author");

        try (PrintWriter out = response.getWriter()) {
            if (newsId == null || newsId.isEmpty() || title == null || content == null || author == null) {
                out.write("{\"success\":false, \"message\":\"参数缺失\"}");
                return;
            }

            try {
                // 数据库连接
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

                // 更新语句
                String sql = "UPDATE news SET title = ?, content = ?, author = ? WHERE id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, title);
                stmt.setString(2, content);
                stmt.setString(3, author);
                stmt.setInt(4, Integer.parseInt(newsId));

                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    out.write("{\"success\":true, \"message\":\"新闻更新成功\"}");
                } else {
                    out.write("{\"success\":false, \"message\":\"未找到指定新闻\"}");
                }

                stmt.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
                out.write("{\"success\":false, \"message\":\"更新新闻失败，请稍后重试\"}");
            }
        }
    }
}

