<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String[][] userList = new String[100][4];
    int userCount = 0;
    String url = "jdbc:mysql://localhost:3306/web?useSSL=false&serverTimezone=UTC";
    String dbUser = "root";
    String dbPass = "123456";
    String successMessage = null; // 用于存储成功信息
    String errorMessage = null; // 用于存储错误信息

    // 处理表单提交
    String action = request.getParameter("action");
    String username = request.getParameter("username");
    String newUser = request.getParameter("newUser");
    String newRole = request.getParameter("newRole");
    String newPassword = request.getParameter("newPassword");

    // 用户激活或封禁
    if (action != null && username != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, dbUser, dbPass)) {
                if ("ban".equals(action)) {
                    String sql = "UPDATE users SET status='banned' WHERE username=?";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, username);
                    pstmt.executeUpdate();
                    successMessage = "用户 " + username + " 已被封禁";
                } else if ("activate".equals(action)) {
                    String sql = "UPDATE users SET status='active' WHERE username=?";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, username);
                    pstmt.executeUpdate();
                    successMessage = "用户 " + username + " 已激活";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "无法连接到数据库";
        }
    }

    // 添加新用户
    if (newUser != null && newRole != null && newPassword != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, dbUser, dbPass)) {
                String sql = "INSERT INTO users (username, role, password, status) VALUES (?, ?, ?, 'active')";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, newUser);
                pstmt.setString(2, newRole);
                pstmt.setString(3, newPassword);
                pstmt.executeUpdate();
                successMessage = "用户 " + newUser + " 已成功添加!";
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "添加用户失败！请检查信息是否正确。";
        }
    }

    // 更新用户密码
    if (username != null && newPassword != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, dbUser, dbPass)) {
                String sql = "UPDATE users SET password=? WHERE username=?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, newPassword);
                pstmt.setString(2, username);
                pstmt.executeUpdate();
                successMessage = "用户 " + username + " 的密码已更新!";
            }
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "更新密码失败！";
        }
    }

    // 获取用户列表
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection(url, dbUser, dbPass)) {
            String sql = "SELECT username, role, status FROM users";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next() && userCount < 100) {
                userList[userCount][0] = rs.getString("username");
                userList[userCount][1] = rs.getString("role");
                userList[userCount][2] = rs.getString("status");
                userCount++;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        errorMessage = "无法获取用户列表";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>用户管理系统</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 20px;
            min-height: 100vh;
            background-image: url('background.jpg');
            background-size: cover;
            color: #333;
            background-position: center;
            background-attachment: fixed;
        }
        .container {
            background-color: #ffffff;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            width: 800px;
            padding: 20px;
        }
        h1, h2, h3 {
            text-align: center;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #e1e1e1;
        }
        form {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 20px;
        }
        input[type="text"], input[type="password"], select {
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ccc;
            width: calc(20%);
            box-sizing: border-box;
        }
        input[type="submit"], .button-link {
            padding: 10px 20px;
            border-radius: 5px;
            border: none;
            background-color: #3498db;
            color: white;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-top: 10px;
        }
        input[type="submit"]:hover, .button-link:hover {
            background-color: #2980b9;
        }
        .button-link {
            display: inline-block;
            text-align: center;
            background-color: #27ae60;
            text-decoration: none;
        }
        .button-link:hover {
            background-color: #219653;
        }
        .message {
            text-align: center;
            font-size: 16px;
        }
        .message.success {
            color: green;
        }
        .message.error {
            color: red;
        }
    </style>
    <script>
        window.onload = function () {
            <% if (successMessage != null) { %>
            alert("<%= successMessage %>");
            <% } %>
            <% if (errorMessage != null) { %>
            alert("<%= errorMessage %>");
            <% } %>
        };
        $(document).ready(function () {
            $("#update-password-form").on("submit", function (event) {
                event.preventDefault();

                const formData = {
                    username: $("#username").val(),
                    currentPassword: $("#currentPassword").val(),
                    newPassword: $("#newPassword").val()
                };

                $.ajax({
                    type: "POST",
                    url: "updatePassword",
                    data: formData,
                    dataType: "json",
                    success: function (response) {
                        if (response.success) {
                            $(".message")
                                .removeClass("error")
                                .addClass("success")
                                .text(response.message)
                                .show();
                        } else if (response.error) {
                            $(".message")
                                .removeClass("success")
                                .addClass("error")
                                .text(response.message)
                                .show();
                        }
                    },
                    error: function () {
                        $(".message")
                            .removeClass("success")
                            .addClass("error")
                            .text("服务器错误，请稍后再试。")
                            .show();
                    }
                });
            });
        });
    </script>
</head>
<body>
<div class="container">
    <h2>欢迎, <%= session.getAttribute("username") %></h2>
    <h1>用户管理</h1>
    <h3>封禁/解封</h3>
    <!-- 处理用户激活/封禁 -->
    <form action="" method="post">
        <label>用户名:</label>
        <input type="text" name="username" required>
        <select name="action">
            <option value="ban">封禁</option>
            <option value="activate">激活</option>
        </select>
        <input type="submit" value="执行">
    </form>
    <h3>用户添加</h3>
    <!-- 添加新用户 -->
    <form action="" method="post">
        <label>新用户名:</label>
        <input type="text" name="newUser" required>
        <label>角色:</label>
        <select name="newRole">
            <option value="user">普通用户</option>
            <option value="admin">管理员</option>
        </select>
        <label>密码:</label>
        <input type="password" name="newPassword" required>
        <input type="submit" value="添加用户">
    </form>
        <h3>更新密码</h3>
        <form id="update-password-form">
            <label for="username">用户名</label>
            <input type="text" id="username" name="username" required>
            <label for="currentPassword">当前密码</label>
            <input type="password" id="currentPassword" name="currentPassword" required>
            <label for="newPassword">新密码</label>
            <input type="password" id="newPassword" name="newPassword" required>
            <input type="submit" value="更新密码">
        </form>
        <div class="message"></div>
    <jsp:include page="userList.jsp" />
    <a href="login.jsp" class="button-link">退出</a>
    <a href="index.jsp" class="button-link">进入首页</a>
    <a href="adminnew.jsp" class="button-link">进入新闻管理</a>
    <a href="adminreport.jsp" class="button-link">进入举报管理</a>
</div>
</body>
</html>