<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>

<%
    String DB_URL = "jdbc:mysql://localhost:3306/web";
    String DB_USER = "root";
    String DB_PASSWORD = "123456";
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String message = "";

    if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
    } else {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
                String sql = "INSERT INTO users (username, password, role, status) VALUES (?, ?, ?, 'active')";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.setString(2, password);
                pstmt.setString(3, "user"); // 角色为用户
                pstmt.executeUpdate();
                message = "注册成功！";
            }
        } catch (SQLException e) {
            message = "注册失败: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>注册页面</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<form method="post" action="">
    <h2>用户注册</h2>
    <label>用户名:</label>
    <input type="text" name="username" placeholder="用户名">
    <label>密码:</label>
    <input type="password" name="password" placeholder="密码">
    <input type="submit" value="注册">
    <a href="login.jsp">直接登录</a>
</form>
<p><%= message %></p>
</body>
</html>