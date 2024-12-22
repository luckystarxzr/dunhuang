<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    String url = "jdbc:mysql://localhost:3306/web";
    String user = "root";
    String password = "123456";

    Connection connection = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(url, user, password);

        String listSql = "SELECT * FROM news ORDER BY created_at DESC";
        ps = connection.prepareStatement(listSql);
        rs = ps.executeQuery();
%>
<table>
    <tr>
        <th>编号</th>
        <th>标题</th>
        <th>作者</th>
        <th>内容</th>
        <th>文件路径</th>
        <th>操作</th>
    </tr>
    <%
        while (rs.next()) {
            int id = rs.getInt("id");
            String newsTitle = rs.getString("title");
            String newsAuthor = rs.getString("author");
            String newsContent = rs.getString("content");
            String newsFilePath = rs.getString("file_path");
    %>
    <tr>
        <td><%= id %></td>
        <td><%= newsTitle %></td>
        <td><%= newsAuthor %></td>
        <td><%= newsContent %></td>
        <td><%= newsFilePath != null ? newsFilePath : "无" %></td>
        <td class="actions">
            <form action="editNews.jsp?id=<%= id %>" method="post" enctype="multipart/form-data" style="display:inline;">
                <input type="hidden" name="id" value="<%= id %>">
                <input type="submit" value="修改">
            </form>
            <form action="deleteNews.jsp" method="post" style="display:inline;">
                <input type="hidden" name="id" value="<%= id %>">
                <input type="submit" value="删除">
            </form>
        </td>
    </tr>
    <%
            }
        } catch (Exception e) {
            out.println("<p>操作失败：" + e.getMessage() + "</p>");
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
            try { if (ps != null) ps.close(); } catch (SQLException ignored) {}
            try { if (connection != null) connection.close(); } catch (SQLException ignored) {}
        }
    %>
</table>
