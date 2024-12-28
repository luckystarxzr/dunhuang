package Controller.news;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/LoadNewsServlet")
public class LoadNewsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
        String jdbcUrl = "jdbc:mysql://localhost:3306/web";
        String dbUser = "root";
        String dbPassword = "123456";

        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("[");

        try (Connection connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
             PreparedStatement ps = connection.prepareStatement(
                     "SELECT id, title, author, content, file_path, created_at FROM news ORDER BY created_at DESC");
             ResultSet rs = ps.executeQuery()) {
            boolean first = true;
            while (rs.next()) {
                if (!first) {
                    jsonBuilder.append(",");
                }
                jsonBuilder.append("{")
                        .append("\"id\":").append(rs.getInt("id")).append(",")
                        .append("\"title\":\"").append(rs.getString("title")).append("\",")
                        .append("\"author\":\"").append(rs.getString("author")).append("\",")
                        .append("\"content\":\"").append(rs.getString("content")).append("\",")
                        .append("\"filePath\":\"").append(rs.getString("file_path")).append("\",")
                        .append("\"createdAt\":\"").append(rs.getTimestamp("created_at")).append("\"")
                        .append("}");
                first = false;
            }
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"加载数据时出错: " + e.getMessage() + "\"}");
            return;
        }

        jsonBuilder.append("]");
        response.getWriter().write(jsonBuilder.toString());
    }
}


