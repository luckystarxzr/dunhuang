package Controller.report;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/LoadReportsServlet")
public class LoadReportsServlet extends HttpServlet {
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
                     "SELECT report_id, news_id, comment_id, reported_by, report_reason, report_time FROM reports ORDER BY report_time DESC");
             ResultSet rs = ps.executeQuery()) {
            boolean first = true;
            while (rs.next()) {
                if (!first) {
                    jsonBuilder.append(",");
                }
                jsonBuilder.append("{")
                        .append("\"reportId\":").append(rs.getInt("report_id")).append(",")
                        .append("\"newsId\":").append(rs.getInt("news_id")).append(",")
                        .append("\"commentId\":").append(rs.getInt("comment_id")).append(",")
                        .append("\"reportedBy\":\"").append(rs.getString("reported_by")).append("\",")
                        .append("\"reportReason\":\"").append(rs.getString("report_reason")).append("\",")
                        .append("\"reportTime\":\"").append(rs.getTimestamp("report_time")).append("\"")
                        .append("}");
                first = false;
            }
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"加载举报数据时出错: " + e.getMessage() + "\"}");
            return;
        }

        jsonBuilder.append("]");
        response.getWriter().write(jsonBuilder.toString());
    }
}


