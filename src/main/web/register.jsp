<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>注册页面</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
<form method="post" action="RegisterServlet">
    <h2>用户注册</h2>
    <label>用户名:</label>
    <input type="text" name="username" placeholder="用户名" required>
    <label>密码:</label>
    <input type="password" name="password" placeholder="密码" required>
    <input type="submit" value="注册">
    <a href="login.jsp">直接登录</a>
</form>
</body>
</html>
