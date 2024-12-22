<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>删除新闻</title>
</head>
<body>

<%--<%--%>
<%--    if (session.getAttribute("user") == null || !session.getAttribute("isAdmin").equals(true)) {--%>
<%--%>--%>
<%--<p>您没有权限删除新闻。 <a href="login.jsp">登录</a></p>--%>
<%--} else {--%>
<%
        String newsId = request.getParameter("id");

        if (newsId == null) {
            out.println("<p>未指定新闻ID。</p>");
            return;
        }

        // Database connection
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "root", "123456");
            String deleteCommentsSql = "DELETE FROM comments WHERE news_id = ?";
            pstmt = conn.prepareStatement(deleteCommentsSql);
            pstmt.setString(1, newsId);
            pstmt.executeUpdate();

            String deleteNewsSql = "DELETE FROM news WHERE id = ?";
            pstmt = conn.prepareStatement(deleteNewsSql);
            pstmt.setString(1, newsId);
            int rowsDeleted = pstmt.executeUpdate();

            if (rowsDeleted > 0) {
                out.println("<p>新闻删除成功！</p>");
            } else {
                out.println("<p>新闻删除失败！</p>");
            }
        } catch (SQLException e) {
            out.println("<p>数据库错误: " + e.getMessage() + "</p>");
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
%>
<a href="adminnew.jsp">返回</a>
</body>
</html>