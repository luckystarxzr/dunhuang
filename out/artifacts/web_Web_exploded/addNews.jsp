<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>测试 AddNewsServlet</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<header>
    <h1>测试 AddNewsServlet</h1>
</header>

<main>
    <form action="AddNewsServlet" method="post" enctype="multipart/form-data">
        <label for="title">标题:</label><br>
        <input type="text" id="title" name="title" placeholder="请输入标题" required><br><br>

        <label for="author">作者:</label><br>
        <input type="text" id="author" name="author" placeholder="请输入作者" required><br><br>

        <label for="content">内容:</label><br>
        <textarea id="content" name="content" rows="5" cols="40" placeholder="请输入内容" required></textarea><br><br>

        <label for="fileName">上传文件:</label><br>
        <input type="file" id="fileName" name="fileName" required><br><br>

        <button type="submit">提交新闻</button>
    </form>

    <hr>

    <!-- 显示测试结果 -->
    <%
        String successMessage = (String) request.getAttribute("successMessage");
        String errorMessage = (String) request.getAttribute("errorMessage");

        if (successMessage != null) {
    %>
    <p style="color: green;">成功: <%= successMessage %></p>
    <%
    } else if (errorMessage != null) {
    %>
    <p style="color: red;">错误: <%= errorMessage %></p>
    <% } %>
</main>

<footer>
    <p>&copy; 2024 测试页面</p>
</footer>
</body>
</html>
