package Controller;

import Model.Report;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;
import java.io.*;
import java.util.ArrayList;
import java.util.List;
@WebServlet("/AdminReportServlet")
public class AdminReportServlet extends HttpServlet {

    // 处理 GET 请求，返回所有举报记录
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        List<Report> reports = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "root", "123456");
            String sql = "SELECT report_id, news_id, comment_id, reported_by, report_reason, report_time FROM reports";
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Report report = new Report(
                        rs.getInt("report_id"),
                        rs.getInt("news_id"),
                        rs.getInt("comment_id"),
                        rs.getString("reported_by"),
                        rs.getString("report_reason"),
                        rs.getTimestamp("report_time")
                );
                reports.add(report);
            }

            StringBuilder jsonResponse = new StringBuilder();
            jsonResponse.append("{\"success\": true, \"reports\": [");

            for (int i = 0; i < reports.size(); i++) {
                Report report = reports.get(i);
                jsonResponse.append("{")
                        .append("\"reportId\": ").append(report.getReportId()).append(", ")
                        .append("\"newsId\": ").append(report.getNewsId()).append(", ")
                        .append("\"commentId\": ").append(report.getCommentId()).append(", ")
                        .append("\"reportedBy\": \"").append(report.getReportedBy()).append("\", ")
                        .append("\"reportReason\": \"").append(report.getReportReason()).append("\", ")
                        .append("\"reportTime\": \"").append(report.getReportTime().toString()).append("\"")
                        .append("}");
                if (i < reports.size() - 1) {
                    jsonResponse.append(", ");
                }
            }

            jsonResponse.append("]}");
            out.print(jsonResponse);

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            String errorResponse = "{\"success\": false, \"message\": \"数据库查询失败\"}";
            out.print(errorResponse);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 处理 POST 请求，删除举报记录和对应评论
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        String commentIdStr = request.getParameter("deleteCommentId");
        boolean success = false;

        if (commentIdStr != null && !commentIdStr.isEmpty()) {
            int commentId = Integer.parseInt(commentIdStr);
            Connection conn = null;
            PreparedStatement stmtDeleteReport = null;
            PreparedStatement stmtDeleteComment = null;

            try {
                // 启用事务
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "root", "123456");
                conn.setAutoCommit(false); // 禁用自动提交，启用事务

                // 删除举报记录
                String deleteReportSql = "DELETE FROM reports WHERE comment_id = ?";
                stmtDeleteReport = conn.prepareStatement(deleteReportSql);
                stmtDeleteReport.setInt(1, commentId);
                int rowsAffectedReport = stmtDeleteReport.executeUpdate();

                // 删除评论
                String deleteCommentSql = "DELETE FROM comments WHERE comment_id = ?";
                stmtDeleteComment = conn.prepareStatement(deleteCommentSql);
                stmtDeleteComment.setInt(1, commentId);
                int rowsAffectedComment = stmtDeleteComment.executeUpdate();

                // 如果两条删除操作都成功，提交事务
                if (rowsAffectedReport > 0 && rowsAffectedComment > 0) {
                    conn.commit(); // 提交事务
                    success = true;
                } else {
                    conn.rollback(); // 如果任何一条删除失败，则回滚事务
                }

            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                try {
                    if (conn != null) conn.rollback(); // 回滚事务
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            } finally {
                try {
                    if (stmtDeleteReport != null) stmtDeleteReport.close();
                    if (stmtDeleteComment != null) stmtDeleteComment.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        // 返回操作结果
        String jsonResponse = "{\"success\": " + success + "}";
        out.print(jsonResponse);
    }
}
