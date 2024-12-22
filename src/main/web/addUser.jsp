<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String newUser = request.getParameter("newUser");
    String newRole = request.getParameter("newRole");
    String newPassword = request.getParameter("newPassword");
    String resultMessage = "";

    if (newUser != null && newRole != null && newPassword != null) {
        String url = "jdbc:mysql://localhost:3306/web?useSSL=false&serverTimezone=UTC";
        String dbUser = "root";
        String dbPass = "123456";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, dbUser, dbPass)) {
                String sql = "INSERT INTO users (username, role, password, status) VALUES (?, ?, ?, 'active')";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, newUser);
                pstmt.setString(2, newRole);
                pstmt.setString(3, newPassword);
                pstmt.executeUpdate();
                resultMessage = "用户 " + newUser + " 已成功添加!";
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultMessage = "添加用户失败！请检查信息是否正确。";
        }
    }
    response.setContentType("text/plain");
    out.print(resultMessage);
%>
