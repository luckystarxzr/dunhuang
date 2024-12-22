<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>添加新闻</title>
</head>
<body>

<%--<%--%>
<%--    // 检查用户权限--%>
<%--    if (session.getAttribute("user") == null || !session.getAttribute("isAdmin").equals(true)) {--%>
<%--%>--%>
<%--<p>您没有权限添加新闻。 <a href="login.jsp">登录</a></p>--%>
<%--} else {--%>

<form action="file-upload" method="post" enctype="multipart/form-data">
    标题: <input type="text" name="title" required><br>
    作者: <input type="text" name="author" value="<%=session.getAttribute("username")%>" readonly><br>
    内容: <textarea name="content" rows="10" cols="50" required></textarea><br>
    图片/视频: <label for="fileName">选择文件:</label>
    <input type="file" id="fileName" name="fileName" required>
    <input type="submit" value="添加新闻">
</form>
<% String successMessage = (String) request.getAttribute("successMessage"); %>
<% String errorMessage = (String) request.getAttribute("errorMessage"); %>

<% if (successMessage != null) { %>
<p style="color: green;"><%= successMessage %></p>
<% } %>

<% if (errorMessage != null) { %>
<p style="color: red;"><%= errorMessage %></p>
<% } %>

<%
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String content = request.getParameter("content");
        Part filePart = (Part) request.getPart("fileName");
        String file_Path = filePart.getSubmittedFileName();
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "root", "123456");

            String sql = "INSERT INTO news (title, author, content, file_Path) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, title);
            pstmt.setString(2, author);
            pstmt.setString(3, content);
            pstmt.setString(4, file_Path);

            int rowsInserted = pstmt.executeUpdate();
            if (rowsInserted > 0) {
                out.println("<p>新闻添加成功！</p>");
            } else {
                out.println("<p>新闻添加失败！</p>");
            }
        } catch (SQLException e) {
            out.println("<p>数据库错误: " + e.getMessage() + "</p>");
        } catch (Exception e) {
            out.println("<p>错误: " + e.getMessage() + "</p>");
        } finally {
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
%>
</body>
</html>
