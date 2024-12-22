<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String newPassword = request.getParameter("newPassword");
    String username = (String) session.getAttribute("username");
    String message = "";

    if (username != null && newPassword != null) {
        try {
            // 假设有一个简单的数据库连接
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "root", "123456");
            String sql = "UPDATE users SET password = ? WHERE username = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newPassword);
            pstmt.setString(2, username);
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                message = "密码更新成功!";
            } else {
                message = "密码更新失败!";
            }

            pstmt.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
            message = "出现错误: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户主页</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-image: url('background.jpg');
            background-size: cover;
            color: #333;
            background-position: center;
            background-attachment: fixed;
        }

        .container {
            width: 400px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.2);
            padding: 20px;
            text-align: center;
        }

        h2 {
            color: #333;
            margin-bottom: 20px;
        }

        form {
            margin-top: 20px;
        }

        input[type="password"] {
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
            width: 100%;
            box-sizing: border-box;
            margin-bottom: 10px;
        }

        input[type="submit"] {
            padding: 10px 20px;
            border-radius: 5px;
            border: none;
            background-color: #3498db;
            color: white;
            cursor: pointer;
            margin-top: 10px;
            width: 100%;
        }

        input[type="submit"]:hover {
            background-color: #2980b9;
        }

        .link {
            display: block;
            margin-top: 15px;
            color: #3498db;
            text-decoration: none;
        }

        .link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>欢迎, ${sessionScope.username}</h2>
    <p>这是您的主页。</p>

    <%
        String userInfo = null;
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web", "root", "123456");
            String sql = "SELECT * FROM users WHERE username = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                userInfo = "用户名: " + rs.getString("username") + "<br>"
                        + "角色: " + rs.getString("role") + "<br>"
                        + "状态: " + rs.getString("status") + "<br>";
            }
            rs.close();
            pstmt.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    %>

    <p>${userInfo}</p>

    <!-- 修改密码表单 -->
    <form action="" method="post">
        <h3>修改密码</h3>
        <label for="newPassword">新密码:</label>
        <input type="password" id="newPassword" name="newPassword" required>
        <input type="submit" value="更新密码">
    </form>

    <a href="login.jsp" class="link">退出</a>
    <a href="index.jsp" class="link">进入首页</a>

    <script>
        // 弹窗显示消息
        <% if (!message.isEmpty()) { %>
        alert("<%= message %>");
        <% } %>
    </script>

</div>

</body>
</html>