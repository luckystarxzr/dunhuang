<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<html>
<head>
    <style>
        .news-container {
            display: grid;
            grid-template-columns: repeat(5, 1fr); /* 每行5个新闻项 */
            gap: 20px; /* 新闻项之间的间距 */
        }

        .news-item {
            border: 1px solid #ccc;
            padding: 10px;
            box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.1);
            text-align: center; /* 内容居中 */
            width: 100%; /* 确保占满格子宽度 */
            max-width: 300px; /* 设置固定最大宽度 */
            height: 300px; /* 固定高度 */
            overflow: hidden; /* 避免内容溢出 */
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .news-item img, .news-item video {
            width: 100%; /* 让图片或视频占满宽度 */
            height: 200px; /* 固定图片或视频的高度 */
            object-fit: cover; /* 确保图片/视频裁剪且填满容器 */
            margin-bottom: 5px; /* 图片和文字之间的间距 */
        }

        .news-item h3 {
            font-size: 16px;
            font-weight: bold;
            margin: 0 0 10px;
            text-overflow: ellipsis;
            white-space: nowrap;
            overflow: hidden; /* 防止标题溢出 */
        }

        .news-item p {
            font-size: 12px;
            color: #666;
            margin: 0;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap; /* 防止长文本溢出 */
        }

        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .pagination a {
            color: #333;
            padding: 8px 16px;
            text-decoration: none;
            border: 1px solid #ddd;
            margin: 0 4px;
        }

        .pagination a.active {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }

    </style>
</head>
<body>
<%
    String jdbcUrl = "jdbc:mysql://localhost:3306/web";
    String dbUser = "root";
    String dbPassword = "123456";

    Connection connection = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String keyword = request.getParameter("keyword");
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

        int currentPage = 1;
        try {
            currentPage = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException ignored) {}

        int pageSize = 5; // 每页显示5条新闻
        int startRow = (currentPage - 1) * pageSize; // 计算起始行

        // 修改SQL查询，加入搜索条件，并按时间倒序排序
        String sql = "SELECT * FROM news WHERE title LIKE ? ORDER BY created_at DESC LIMIT ? OFFSET ?";
        ps = connection.prepareStatement(sql);
        ps.setString(1, "%" + (keyword != null ? keyword : "") + "%"); // 添加搜索条件
        ps.setInt(2, pageSize);
        ps.setInt(3, startRow);
        rs = ps.executeQuery();

        out.println("<h2>新闻列表</h2>");
        out.println("<div class='news-container'>"); // 新闻容器
        while (rs.next()) {
            String newsId = rs.getString("id");
            String newsTitle = rs.getString("title");
            String newsAuthor = rs.getString("author");
            String created_at = rs.getString("created_at");
            String file_path = rs.getString("file_path");

            out.println("<div class='news-item'>"); // 新闻项容器
            out.println("<h3><a href=\"newsDetail.jsp?id=" + newsId + "\">" + newsTitle + "</a></h3>");
            out.println("<p>作者: " + newsAuthor + "</p>");
            out.println("<p>时间: " + created_at + "</p>");
            // 根据文件扩展名判断是显示图片还是视频
            if (file_path.endsWith(".jpg") || file_path.endsWith(".png") || file_path.endsWith(".gif")) {
                out.println("<img src=\"" + request.getContextPath() + "/news/" + file_path + "\" alt=\"Image\"/>");
            } else if (file_path.endsWith(".mp4") || file_path.endsWith(".avi") || file_path.endsWith(".mov")) {
                out.println("<video controls><source src=\"" + request.getContextPath() + "/news/" + file_path + "\" type=\"video/mp4\">您的浏览器不支持视频播放。</video>");
            } else {
                out.println("<p>不支持的文件格式</p>"); // 显示不支持的文件格式信息
            }
            out.println("</div>"); // 结束新闻项
        }
        out.println("</div>"); // 结束新闻容器

        // 分页导航
        int totalRows = 0;
        sql = "SELECT COUNT(*) FROM news WHERE title LIKE ?";
        ps = connection.prepareStatement(sql);
        ps.setString(1, "%" + (keyword != null ? keyword : "") + "%"); // 搜索条件
        rs = ps.executeQuery();
        if (rs.next()) {
            totalRows = rs.getInt(1);
        }
        int totalPages = (int) Math.ceil((double) totalRows / pageSize);

        out.println("<div class='pagination'>");
        for (int i = 1; i <= totalPages; i++) {
            // 判断当前页是否是目标页，如果是就添加active类
            if (i == currentPage) {
                // 如果keyword不为空，则在链接中加入keyword参数
                if (keyword != null && !keyword.isEmpty()) {
                    out.println("<a href='index.jsp?page=" + i + "&keyword=" + keyword + "' class='active'>" + i + "</a>");
                } else {
                    out.println("<a href='index.jsp?page=" + i + "' class='active'>" + i + "</a>");
                }
            } else {
                // 如果keyword不为空，则在链接中加入keyword参数
                if (keyword != null && !keyword.isEmpty()) {
                    out.println("<a href='index.jsp?page=" + i + "&keyword=" + keyword + "'>" + i + "</a>");
                } else {
                    out.println("<a href='index.jsp?page=" + i + "'>" + i + "</a>");
                }
            }
        }
        out.println("</div>");
    } catch (SQLException e) {
        out.println("<p>数据库访问错误: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
        if (connection != null) try { connection.close(); } catch (SQLException ignored) {}
    }
%>
<form method="get" action="">
    <input type="text" name="keyword" placeholder="搜索新闻" value="<%= keyword != null ? keyword : "" %>">
    <input type="submit" value="搜索">
</form>
</body>
</html>
