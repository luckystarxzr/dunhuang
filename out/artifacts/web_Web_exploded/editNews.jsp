<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<html>
<head>
    <title>修改新闻</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); }
        h2 { text-align: center; color: #333; }
        label { display: block; margin-bottom: 5px; font-weight: bold; color: #555; }
        input[type="text"], textarea { width: 100%; padding: 10px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; }
        input[type="submit"] { background-color: #5cb85c; color: white; padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; width: 100%; }
        input[type="submit"]:hover { background-color: #4cae4c; }
        .error { color: red; font-weight: bold; text-align: center; }
    </style>
</head>
<body>
<div class="container">
    <%
        String url = "jdbc:mysql://localhost:3306/web";
        String user = "root";
        String password = "123456";

        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        int newsId = -1;
        String newsTitle = "";
        String newsAuthor = "";
        String newsContent = "";

        // 处理表单提交
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            try {
                request.setCharacterEncoding("UTF-8");
                newsId = Integer.parseInt(request.getParameter("id"));
                newsTitle = request.getParameter("title");
                newsAuthor = request.getParameter("author");
                newsContent = request.getParameter("content");

                // 更新数据库
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(url, user, password);

                String updateSql = "UPDATE news SET title = ?, author = ?, content = ? WHERE id = ?";
                ps = connection.prepareStatement(updateSql);
                ps.setString(1, newsTitle);
                ps.setString(2, newsAuthor);
                ps.setString(3, newsContent);
                ps.setInt(4, newsId);

                int rowsUpdated = ps.executeUpdate();
                if (rowsUpdated > 0) {
    %>
    <p class='success'>新闻更新成功！两秒后跳转回...</p>
    <meta http-equiv="refresh" content="2;url=adminnew.jsp">
    <%
    } else {
    %>
    <p class='error'>新闻更新失败！</p>
    <%
        }
    } catch (Exception e) {
    %>
    <p class='error'>系统错误：<%= e.getMessage() %></p>
    <%
            } finally {
                try { if (ps != null) ps.close(); } catch (SQLException ignored) {}
                try { if (connection != null) connection.close(); } catch (SQLException ignored) {}
            }
        }

    // 加载新闻数据
        try {
            String newsIdParam = request.getParameter("id");
            try {
                newsId = Integer.parseInt(newsIdParam);
            } catch (NumberFormatException e) {
                out.println("<p class='error'>无效的新闻 ID。</p>");
            }

            if (newsId != -1) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(url, user, password);

                String editSql = "SELECT * FROM news WHERE id = ?";
                ps = connection.prepareStatement(editSql);
                ps.setInt(1, newsId);
                rs = ps.executeQuery();

                if (rs.next()) {
                    newsTitle = rs.getString("title");
                    newsAuthor = rs.getString("author");
                    newsContent = rs.getString("content");
                } else {
                    out.println("<p class='error'>未找到对应的新闻记录。</p>");
                }
            }
        } catch (Exception e) {
            out.println("<p class='error'>系统错误：" + e.getMessage() + "</p>");
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (ps != null) ps.close(); } catch (SQLException ignored) {}
            try { if (connection != null) connection.close(); } catch (SQLException ignored) {}
        }
    %>
    <h2>修改新闻</h2>
    <form action="" method="post">
        <input type="hidden" name="id" value="<%= newsId %>">
        <label for="title">标题:</label>
        <input type="text" id="title" name="title" value="<%= newsTitle %>" required>

        <label for="author">作者:</label>
        <input type="text" id="author" name="author" value="<%= newsAuthor %>" required>

        <label for="content">内容:</label>
        <textarea id="content" name="content" rows="4" required><%= newsContent %></textarea>

        <input type="submit" value="提交">
    </form>
</div>
<a href="adminnew.jsp">返回</a>
</body>
</html>
