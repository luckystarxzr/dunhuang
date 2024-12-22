<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>

<%
    // 数据库连接参数
    String jdbcUrl = "jdbc:mysql://localhost:3306/web";
    String dbUser = "root";
    String dbPassword = "123456";

    // 获取会话中的用户名
    HttpSession session2 = request.getSession();
    String username = (String) session2.getAttribute("username");

    // 获取新闻ID和评论内容
    String newsId = request.getParameter("id");
    String comment = request.getParameter("comment");

    // 验证用户登录状态和评论内容
    if (username == null || comment == null || comment.trim().isEmpty()) {
        out.print("error: 请先登录并输入评论内容");
        return;
    }

    Connection connection = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        // 创建数据库连接
        connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

        // 准备插入评论的 SQL 语句
        String sql = "INSERT INTO comments (news_id, username, comment, comment_time) VALUES (?, ?, ?, NOW())";
        ps = connection.prepareStatement(sql);

        // 设置参数
        ps.setInt(1, Integer.parseInt(newsId));
        ps.setString(2, username);
        ps.setString(3, comment);

        // 执行插入操作
        int rows = ps.executeUpdate();

        // 返回插入结果
        if (rows > 0) {
            response.sendRedirect("newsDetail.jsp?id=" + Integer.parseInt(newsId));
            out.print("success");
        } else {
            out.print("error: 添加评论失败");
            response.sendRedirect("newsDetail.jsp?id=" + Integer.parseInt(newsId));
        }
    } catch (SQLException e) {
        out.print("error: 数据库错误：" + e.getMessage());
    } finally {
        // 关闭数据库连接和 PreparedStatement
        if (ps != null) {
            try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        if (connection != null) {
            try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>
