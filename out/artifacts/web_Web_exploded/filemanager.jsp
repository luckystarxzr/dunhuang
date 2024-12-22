<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>文件管理</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-image: url('background.jpg'); background-color: #f4f4f4; }
        .container { max-width: 800px; margin: 20px auto; padding: 20px; background: #fff; border-radius: 5px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { text-align: center; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border-bottom: 1px solid #ddd; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>

<div class="container">
    <%
        String userRole = (String) session.getAttribute("role");
        String username = (String) session.getAttribute("username");

        if (userRole == null) {
            userRole = "guest"; // 默认角色
        }
    %>

    <h1>文件管理</h1>

    <% if (userRole.equals("guest")) { %>
    <p>您当前以游客身份访问,只能查看文件列表。 <a href="login.jsp">登录</a></p>
    <% } else { %>
    <p>欢迎您<%= username %>来到文件管理</p>
    <p>您当前以<%= userRole %>身份登录。</p>
    <form action="upload" method="post" enctype="multipart/form-data">
        <label>选择文件:</label>
        <input type="file" name="file" required>
        <label>文件类型:</label>
        <label>
            <select name="file_type">
                <option value="public">公开</option>
                <option value="private">私有</option>
            </select>
        </label>
        <input type="submit" value="上传文件">
    </form>
    <% } %>

    <h2>文件列表</h2>
    <table>
        <thead>
        <tr>
            <th>文件名</th>
            <th>文件类型</th>
            <th>上传者</th>
            <th>下载次数</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <%
            String dbUrl = "jdbc:mysql://localhost:3306/web?useSSL=false&characterEncoding=UTF-8&serverTimezone=UTC";
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                throw new RuntimeException(e);
            }
            try (
                    Connection conn = DriverManager.getConnection(dbUrl, "root", "123456");
                    PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM files");
                    ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    String fileName = rs.getString("file_name");
                    String fileType = rs.getString("file_type");
                    String owner = rs.getString("owner");
                    int downloadCount = rs.getInt("download_count");
                    int fileId = rs.getInt("id");
        %>
        <tr>
            <td><%= fileName %></td>
            <td><%= fileType %></td>
            <td><%= owner %></td>
            <td><%= downloadCount %></td>
            <td>
                <%
                    boolean isPublic = "public".equals(fileType);
                    boolean isOwner = owner.equals(username);

                    if (userRole.equals("guest")) {
                        // 游客不显示任何链接
                %>
                <span>无权限</span>
                <%
                } else {
                    if (isPublic) {
                %>
                <a href="download?fileId=<%= fileId %>">下载</a>
                <%
                } else if (isOwner) {
                %>
                <a href="download?fileId=<%= fileId %>">下载</a>
                <%
                } else {
                %>
                <span>无权限</span>
                <%
                    }

                    // 管理员可以看到封存链接
                    if (userRole.equals("admin")) {
                %>
                <a href="banResource?fileId=<%= fileId %>">封存/解封</a>
                <%
                        }
                    }
                %>
            </td>

        </tr>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<tr><td colspan='5'>数据库错误：" + e.getMessage() + "</td></tr>");
            }
        %>
        </tbody>
    </table>
</div>
</body>
</html>
