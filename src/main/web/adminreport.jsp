<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="Model.Report" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    // 数据库连接相关信息
    String jdbcUrl = "jdbc:mysql://localhost:3306/web";
    String dbUser = "root";
    String dbPassword = "123456";

    List<Report> reportList = new ArrayList<>();
    Connection connection = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

// 处理删除评论请求

    String deleteCommentId = request.getParameter("deleteCommentId");
    if (deleteCommentId != null) {
        try {
            // 加载MySQL驱动
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                throw new RuntimeException(e);
            }
            connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
            String deleteQuery = "DELETE FROM comments WHERE id = ?";
            ps = connection.prepareStatement(deleteQuery);
            ps.setInt(1, Integer.parseInt(deleteCommentId));
            ps.executeUpdate();
            out.println("<p style='color: green;'>评论删除成功！</p>");
        } catch (SQLException e) {
            out.println("<p style='color: red;'>删除评论时出现错误: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    try {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
        // 创建数据库连接
        connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
        // 查询举报信息
        String query = "SELECT report_id, news_id, comment_id, reported_by, report_reason, report_time FROM reports ORDER BY report_time DESC";
        ps = connection.prepareStatement(query);
        rs = ps.executeQuery();
        // 遍历结果集并填充举报列表
        while (rs.next()) {
            int reportId = rs.getInt("report_id");
            int newsId = rs.getInt("news_id");
            int commentId = rs.getInt("comment_id");
            String reportedBy = rs.getString("reported_by");
            String reportReason = rs.getString("report_reason");
            Timestamp reportTime = rs.getTimestamp("report_time");
            reportList.add(new Report(reportId, newsId, commentId, reportedBy, reportReason, reportTime));
        }
    } catch (SQLException e) {
        out.println("<p>加载举报信息时出现错误: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        // 关闭数据库连接
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>管理员举报管理</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-image: url('background.jpg');
            background-size: cover;
            color: #333;
            background-position: center;
            background-attachment: fixed;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 12px;
            text-align: left;
        }

        th {
            background-color: #4CAF50;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #ddd;
        }

        p {
            color: red;
            text-align: center;
        }
    </style>
</head>
<body>
<h1>用户举报列表</h1>

<table>
    <thead>
    <tr>
        <th>举报ID</th>
        <th>新闻ID</th>
        <th>评论ID</th>
        <th>举报用户</th>
        <th>举报原因</th>
        <th>举报时间</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <%
        if (reportList.isEmpty()) {
            out.println("<tr><td colspan='7'>暂无举报记录。</td></tr>");
        } else {
            for (Report report : reportList) {
                out.println("<tr>");
                out.println("<td>" + report.getReportId() + "</td>");
                out.println("<td>" + report.getNewsId() + "</td>");
                out.println("<td>" + report.getCommentId() + "</td>");
                out.println("<td>" + report.getReportedBy() + "</td>");
                out.println("<td>" + report.getReportReason() + "</td>");
                out.println("<td>" + report.getReportTime() + "</td>");
                out.println("<td><a href='adminreport.jsp?deleteCommentId=" + report.getCommentId() + "' onclick=\"return confirm('确认删除评论吗?');\">删除评论</a></td>");
                out.println("</tr>");
            }
        }
    %>
    </tbody>
</table>
</body>
</html>
