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
            loadUserList(); // 动态加载用户列表
        };

        // 动态加载用户列表
        function loadUserList() {
            fetch('UserListServlet') // 获取用户列表的后端Servlet
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const userListTable = document.getElementById('userListTable');
                        userListTable.innerHTML = ''; // 清空现有的表格内容

                        // 动态填充用户列表
                        data.users.forEach(user => {
                            const row = document.createElement('tr');
                            row.innerHTML = `
                            <td>${user.username}</td>
                            <td>${user.role}</td>
                            <td>${user.status}</td>
                        `;
                            userListTable.appendChild(row);
                        });
                    } else {
                        alert(data.message);
                    }
                })
                .catch(error => {
                    alert("请求失败: " + error.message);
                });
        }

        // 用户封禁/激活操作
        function handleUserAction(action, username) {
            let formData = new FormData();
            formData.append('action', action);
            formData.append('username', username);

            fetch('banActionServlet', {
                method: 'POST',
                body: formData
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        loadUserList(); // 刷新用户列表
                    } else {
                        alert(data.message);
                    }
                })
                .catch(error => {
                    alert("请求失败: " + error.message);
                });
        }

        // 添加用户操作
        function handleAddUser() {
            let formData = new FormData(document.getElementById('add-user-form'));

            fetch('AddUserServlet', {
                method: 'POST',
                body: formData
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        loadUserList(); // 刷新用户列表
                    } else {
                        alert(data.message);
                    }
                })
                .catch(error => {
                    alert("请求失败: " + error.message);
                });
        }

        // 更新密码操作
        function handleUpdatePassword() {
            let formData = new FormData(document.getElementById('update-password-form'));

            fetch('UpdatePasswordServlet', {
                method: 'POST',
                body: formData
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                    } else {
                        alert(data.message);
                    }
                })
                .catch(error => {
                    alert("请求失败: " + error.message);
                });
        }
    </script>
</head>
<body>
<div class="container">
    <h2>欢迎, <%= session.getAttribute("username") %></h2>
    <h1>用户管理</h1>

    <!-- 用户封禁/激活 -->
    <h3>封禁/解封</h3>
    <form action="javascript:void(0);" onsubmit="handleUserAction('ban', document.getElementById('username').value)">
        <label>用户名:</label>
        <input type="text" id="" required>
        <select name="action">
            <option value="ban">封禁</option>
            <option value="activate">激活</option>
        </select>
        <input type="submit" value="执行">
    </form>

    <!-- 用户添加 -->
    <h3>用户添加</h3>
    <form id="add-user-form" action="javascript:void(0);" onsubmit="handleAddUser()">
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

    <!-- 更新密码 -->
    <h3>更新密码</h3>
    <form id="update-password-form" action="javascript:void(0);" onsubmit="handleUpdatePassword()">
        <label for="username">用户名</label>
        <input type="text" id="username" name="username" required>
        <label for="currentPassword">当前密码</label>
        <input type="password" id="currentPassword" name="currentPassword" required>
        <label for="newPassword">新密码</label>
        <input type="password" id="newPassword" name="newPassword" required>
        <input type="submit" value="更新密码">
    </form>

    <div class="message"></div>

    <h3>用户列表</h3>
    <table>
        <thead>
        <tr>
            <th>用户名</th>
            <th>角色</th>
            <th>状态</th>
        </tr>
        </thead>
        <tbody>
        <% for (int i = 0; i < userCount; i++) { %>
        <tr>
            <td><%= userList[i][0] %></td>
            <td><%= userList[i][1] %></td>
            <td><%= userList[i][2] %></td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <a href="login.jsp" class="button-link">返回登录页面</a>
</div>
</body>
</html>
