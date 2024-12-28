<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
<form action="LoginServlet" method="post">
    <h2>用户登录</h2>
    <label>用户名:</label>
    <input type="text" name="username" placeholder="用户名" required>
    <label>密码:</label>
    <input type="password" name="password" placeholder="密码" required>
    <input type="submit" value="登录">
    <p><%= request.getAttribute("message") != null ? request.getAttribute("message") : "" %></p>
    <a href="register.jsp">注册新用户</a>
</form>
</body>
</html>
