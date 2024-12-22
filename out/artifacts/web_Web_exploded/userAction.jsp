<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String action = request.getParameter("action");
    String username = request.getParameter("username");
    String resultMessage = "";

    if (action != null && username != null) {
        String url = "jdbc:mysql://localhost:3306/web?useSSL=false&serverTimezone=UTC";
        String dbUser = "root";
        String dbPass = "123456";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, dbUser, dbPass)) {
                String sql = "";
                if ("ban".equals(action)) {
                    sql = "UPDATE users SET status='banned' WHERE username=?";
                } else if ("activate".equals(action)) {
                    sql = "UPDATE users SET status='active' WHERE username=?";
                }

                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                int rows = pstmt.executeUpdate();

                if (rows > 0) {
                    resultMessage = "操作成功: 用户 " + username + " 已被 " + ("ban".equals(action) ? "封禁" : "激活");
                } else {
                    resultMessage = "操作失败: 未找到用户名 " + username;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            resultMessage = "数据库连接失败";
        }
    }
    response.setContentType("text/plain");
    out.print(resultMessage);
%>
