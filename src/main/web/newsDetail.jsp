<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.ArrayList, java.util.List" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="Model.Comment" %>
<%@ page import="java.io.IOException" %>

<!DOCTYPE html>
<html>
<head>
    <title>新闻详情</title>
    <style>
        /* 通用样式 */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
            background-image: url('background.jpg');
            background-size: cover;
            color: #333;
            background-position: center;
            background-attachment: fixed;
        }

        /* 标题样式 */
        h1 {
            color: #333;
            border-bottom: 2px solid #007BFF;
            padding-bottom: 10px;
        }

        /* 新闻内容样式 */
        p {
            line-height: 1.6;
            color: #555;
        }

        /* 图片样式 */
        img {
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            margin: 15px 0;
        }

        /* 评论区域样式 */
        #commentsSection {
            background-color: #fff;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        /* 添加评论表单样式 */
        form {
            background-color: #fff;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            margin-top: 20px;
        }

        /* 文本区域样式 */
        textarea {
            width: 100%;
            border: 1px solid #ccc;
            border-radius: 4px;
            padding: 10px;
            resize: vertical;
        }

        /* 按钮样式 */
        input[type="submit"] {
            background-color: #007BFF;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 10px 15px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #0056b3;
        }

        /* 返回链接样式 */
        a {
            color: #007BFF;
            text-decoration: none;
            margin-right: 15px;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <%
    String jdbcUrl = "jdbc:mysql://localhost:3306/web";
    String dbUser = "root";
    String dbPassword = "123456";
    String idParam = request.getParameter("id");

    HttpSession userSession3 = request.getSession();
    String username = (String) userSession3.getAttribute("username");

    Connection connection = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // 评论分页设置
    int pageSize = 5; // 每页显示的评论数量
    int currentPage = 1; // 当前页数
    String pageParam = request.getParameter("page");
    if (pageParam != null) {
        currentPage = Integer.parseInt(pageParam);
    }

    int totalComments = 0;
    List<Comment> commentList = new ArrayList<>();
    int totalPages = 0; // 初始化总页数

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        if (idParam != null) {
            connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
            String sql = "SELECT * FROM news WHERE id = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(idParam));
            rs = ps.executeQuery();

            if (rs.next()) {
                String title = rs.getString("title");
                String content = rs.getString("content");
                String file_path = rs.getString("file_path");
                out.println("<h1>" + title + "</h1>");
                out.println("<p>" + content + "</p>");
                // 根据文件扩展名判断是显示图片还是视频
                if (file_path.endsWith(".jpg") || file_path.endsWith(".png") || file_path.endsWith(".gif")) {
                    out.println("<img src=\"" + request.getContextPath() + "/news/" + file_path + "\" alt=\"Image\"/>");
                } else if (file_path.endsWith(".mp4") || file_path.endsWith(".avi") || file_path.endsWith(".mov")) {
                    out.println("<video controls><source src=\"" + request.getContextPath() + "/news/" + file_path + "\" type=\"video/mp4\">您的浏览器不支持视频播放。</video>");
                } else {
                    out.println("<p>不支持的文件格式</p>"); // 显示不支持的文件格式信息
                }
            } else {
                out.println("<p>未找到该新闻。</p>");
            }
        } else {
            out.println("<p>未指定新闻ID。</p>");
            return;
        }

        // 获取评论的总数
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String countSql = "SELECT COUNT(*) FROM comments WHERE news_id = ?";
            try (PreparedStatement countStmt = connection.prepareStatement(countSql)) {
                countStmt.setInt(1, Integer.parseInt(idParam));
                ResultSet countRs = countStmt.executeQuery();
                if (countRs.next()) {
                    totalComments = countRs.getInt(1);
                }
            }

            // 获取当前页的评论
            String commentSql = "SELECT * FROM comments WHERE news_id = ? ORDER BY comment_time DESC LIMIT ?, ?";
            try (PreparedStatement commentStmt = connection.prepareStatement(commentSql)) {
                commentStmt.setInt(1, Integer.parseInt(idParam));
                commentStmt.setInt(2, (currentPage - 1) * pageSize);
                commentStmt.setInt(3, pageSize);
                ResultSet commentRs = commentStmt.executeQuery();
                while (commentRs.next()) {
                    Comment comment = new Comment();
                    comment.setId(commentRs.getInt("id"));
                    comment.setUsername(commentRs.getString("username"));
                    comment.setComment(commentRs.getString("comment"));
                    comment.setCommentTime(commentRs.getTimestamp("comment_time"));
                    commentList.add(comment);
                }
            }
        } catch (SQLException e) {
            out.println("<p>数据库错误: " + e.getMessage() + "</p>");
        }

        // 处理添加评论
        String action = request.getParameter("action");
        if ("addComment".equals(action)) {
            String comment = request.getParameter("comment");
            if (username != null && comment != null && !comment.trim().isEmpty()) {
                // 检查敏感词汇
                String[] badWords = {"cnm", "sb", "nm"};
                for (String badWord : badWords) {
                    if (comment.contains(badWord)) {
                        out.print("error: 评论包含敏感词汇");
                        return;
                    }
                }

                String addCommentSQL = "INSERT INTO comments (news_id, username, comment, comment_time) VALUES (?, ?, ?, NOW())";
                try (PreparedStatement addCommentStmt = connection.prepareStatement(addCommentSQL)) {
                    addCommentStmt.setInt(1, Integer.parseInt(idParam));
                    addCommentStmt.setString(2, username);
                    addCommentStmt.setString(3, comment);
                    addCommentStmt.executeUpdate();
                    out.print("success");
                } catch (SQLException e) {
                    out.print("error: " + e.getMessage());
                }
            } else {
                out.print("error: 请先登录并输入评论内容");
            }
            return;
        }

        // 计算总页数
        totalPages = (int) Math.ceil((double) totalComments / pageSize);

    } catch (SQLException e) {
        out.println("<p>数据库错误: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (connection != null) try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<!-- 评论显示区域 -->
    <h2>评论区</h2>
    <div id="commentsSection">
        <%
            for (Comment comment : commentList) {
                out.println("<div class='comment'>");
                out.println("<p><strong>" + comment.getUsername() + "</strong> (时间: " + comment.getCommentTime() + "):</p>");
                out.println("<p>" + comment.getComment() +
                        "<a href='#' onclick='showReportForm(" + comment.getId() + ", " + idParam + ")'>举报</a>" +
                        "</p>");
                out.println("</div>");
            }
        %>
    </div>

    <!-- 添加评论表单 -->
    <h2>添加评论</h2>
    <% if (username != null) { %>
    <form action="newsDetail.jsp?id=<%= idParam %>&action=addComment" method="post">
        <p>用户名: <%= username %></p>
        评论: <textarea id="commentInput" name="comment" rows="5" cols="50" required></textarea><br>
        <input type="submit" value="提交评论">
    </form>
    <!-- 举报原因表单 -->
    <div id="reportForm" style="display:none; position:fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background-color: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.3);">
        <h3>举报原因</h3>
        <form action="reportComment.jsp" method="post">
            <input type="hidden" id="reportCommentId" name="commentId">
            <input type="hidden" id="reportNewsId" name="newsId">
            <label for="reason">原因:</label><br>
            <textarea id="reason" name="reason" rows="4" cols="50" required></textarea><br>
            <input type="submit" value="提交举报">
            <button type="button" onclick="closeReportForm()">取消</button>
        </form>
    </div>
    <% } else { %>
    <p>请登录后评论和举报。</p>
    <% } %>
    <!-- 分页导航 -->
    <div>
        <%
            // 显示分页导航
            if (totalPages > 1) {
                if (currentPage > 1) {
                    out.println("<a href='newsDetail.jsp?id=" + idParam + "&page=" + (currentPage - 1) + "'>上一页</a>");
                }

                for (int i = 1; i <= totalPages; i++) {
                    if (i == currentPage) {
                        out.println("<strong>" + i + "</strong> "); // 当前页不链接
                    } else {
                        out.println("<a href='newsDetail.jsp?id=" + idParam + "&page=" + i + "'>" + i + "</a> ");
                    }
                }

                if (currentPage < totalPages) {
                    out.println("<a href='newsDetail.jsp?id=" + idParam + "&page=" + (currentPage + 1) + "'>下一页</a>");
                }
            }
        %>
    </div>

    <script>
        function showReportForm(commentId, newsId) {
            document.getElementById('reportForm').style.display = 'block';
            document.getElementById('reportCommentId').value = commentId;
            document.getElementById('reportNewsId').value = newsId;
        }

        function closeReportForm() {
            document.getElementById('reportForm').style.display = 'none';
        }
    </script>
</body>
</html>