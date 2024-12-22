<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String url = "jdbc:mysql://localhost:3306/web?useSSL=false&serverTimezone=UTC";
    String dbUser = "root";
    String dbPass = "123456";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection(url, dbUser, dbPass)) {
            String sql = "SELECT username,password,role, status FROM users";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户列表</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
        }
        .container {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 90%;
            padding: 20px;
        }
        h2 {
            text-align: center;
            color: #333;
            font-size: 24px;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #3498db;
            color: white;
            font-size: 16px;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #e1e1e1;
        }
        .status {
            text-align: center;
            font-weight: bold;
            padding: 5px;
        }
        .active {
            background-color: #2ecc71;
            color: white;
        }
        .banned {
            background-color: #e74c3c;
            color: white;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>用户列表</h2>
    <table>
        <tr>
            <th>用户名</th>
            <th>密码</th>
            <th>角色</th>
            <th>状态</th>
        </tr>
        <%
            while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("username") %></td>
            <td><%= rs.getString("password") %></td>
            <td><%= rs.getString("role") %></td>
            <td class="status <%= rs.getString("status").equals("active") ? "active" : "banned" %>">
                <%= rs.getString("status") %>
            </td>
        </tr>
        <%
            }
        %>
    </table>
</div>
</body>
</html>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
