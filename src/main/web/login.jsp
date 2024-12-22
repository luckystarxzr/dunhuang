<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    String message = "";
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if (username != null && password != null) {
        String url = "jdbc:mysql://localhost:3306/web?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        String user = "root";
        String pass = "123456";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(url, user, pass)) {
                String sql = "SELECT role, status FROM users WHERE username=? AND password=?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.setString(2, password); // 确保这里是哈希过的密码

                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    String status = rs.getString("status");
                    String role = rs.getString("role");

                    if ("banned".equals(status)) {
                        message = "您的账户已被禁止登录。";
                    } else {
                        // 使用隐式 session 对象
                        session.setAttribute("username", username);
                        session.setAttribute("role", role);
                        response.sendRedirect(role.equals("admin") ? "adminboard.jsp" : "userboard.jsp");
                        return; // 确保不再执行后续代码
                    }
                } else {
                    message = "用户名或密码错误。";
                }
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            message = "MySQL JDBC 驱动未找到。";
        } catch (SQLException e) {
            e.printStackTrace();
            message = "数据库连接失败：" + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<form action="" method="post">
    <h2>用户登录</h2>
    <label>用户名:</label>
    <input type="text" name="username" placeholder="用户名" required>
    <label>密码:</label>
    <input type="password" name="password" placeholder="密码" required>
    <input type="submit" value="登录">
    <p><%= message %></p>
    <a href="register.jsp">注册新用户</a>
</form>
</body>
</html>