<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%@ page import="Model.Comment" %>

<%
    String jdbcUrl = "jdbc:mysql://localhost:3306/web"; // 数据库连接字符串
    String dbUser = "root"; // 数据库用户名
    String dbPassword = "123456"; // 数据库密码

    // 获取当前会话
    HttpSession session2 = request.getSession();
    String reportedBy = (String) session2.getAttribute("username"); // 获取当前登录用户的用户名

    // 验证用户是否已登录
    if (reportedBy == null) {
        // 用户未登录，重定向到登录页面
        response.sendRedirect("login.jsp");
        return;
    }

    String commentId = request.getParameter("commentId"); // 获取评论 ID
    String newsId = request.getParameter("newsId"); // 获取新闻 ID
    String reason = request.getParameter("reason"); // 获取举报原因
    Connection connection = null;
    PreparedStatement ps = null;

    try {
        connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
        String sql = "INSERT INTO reports (comment_id, news_id, reported_by, report_reason, report_time) VALUES (?, ?, ?, ?, NOW())";
        ps = connection.prepareStatement(sql);
        ps.setString(1, commentId);
        ps.setString(2, newsId);
        ps.setString(3, reportedBy); // 使用当前用户的用户名
        ps.setString(4, reason); // 存储举报原因
        ps.executeUpdate();
        out.println("<p>举报成功！</p>");
    } catch (SQLException e) {
        out.println("<p>举报失败: " + e.getMessage() + "</p>");
    } finally {
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<a href="newsDetail.jsp?id=<%= newsId %>">返回新闻</a>