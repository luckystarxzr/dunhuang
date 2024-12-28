<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>管理员举报管理</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* 样式与之前一致 */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-image: url('background.jpg');
            background-size: cover;
            color: #333;
            background-position: center;
            background-attachment: fixed;
        }

        h1 {
            text-align: center;
            color: #333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

        table, th, td {
            border: 1px solid #ddd;
        }

        th, td {
            padding: 12px;
            text-align: left;
        }

        th {
            background-color: #4CAF50;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        tr:hover {
            background-color: #ddd;
        }

        .btn-container {
            text-align: center;
            margin: 20px 0;
        }

        .btn-container button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }

        .btn-container button:hover {
            background-color: #45a049;
        }

        .delete-btn {
            background-color: #e74c3c;
            color: white;
            padding: 8px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        .delete-btn:hover {
            background-color: #c0392b;
        }

        .delete-btn:active {
            background-color: #a93226;
        }
    </style>
</head>
<body>
<h1>用户举报列表</h1>

<div class="btn-container">
    <button onclick="window.location.href='adminboard.jsp'">返回</button>
</div>

<table>
    <thead>
    <tr>
        <th>举报ID</th>
        <th>新闻ID</th>
        <th>评论ID</th>
        <th>举报用户</th>
        <th>举报原因</th>
        <th>举报时间</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody id="reportList">
    </tbody>
</table>

<script>
    // 页面加载时加载举报列表
    $(document).ready(function () {
        console.log("页面已加载，准备加载举报列表");
        loadReportList();
    });

    // 加载举报列表
    function loadReportList() {
        console.log("开始加载举报列表");
        $.ajax({
            url: 'LoadReportsServlet',
            type: 'GET',
            dataType: 'json', // 确保返回数据按 JSON 解析
            success: function (data) {
                console.log("服务器返回数据：", data);

                const reportList = $('#reportList');
                reportList.empty(); // 清空现有内容

                if (data.length === 0) {
                    console.log("举报列表为空");
                    reportList.append('<tr><td colspan="7">暂无举报记录。</td></tr>');
                } else {
                    console.log("举报列表数据：", data);
                    data.forEach(function (report) {
                        let row = '<tr>' +
                            '<td>' + report.reportId + '</td>' +
                            '<td>' + report.newsId + '</td>' +
                            '<td>' + report.commentId + '</td>' +
                            '<td>' + report.reportedBy + '</td>' +
                            '<td>' + report.reportReason + '</td>' +
                            '<td>' + report.reportTime + '</td>' +
                            '<td><button class="delete-btn" data-comment-id="' + report.commentId + '">删除评论</button></td>' +
                            '</tr>';
                        console.log("生成的行内容：", row); // 验证生成的 HTML
                        reportList.append(row);
                    });

                    console.log("举报列表渲染完成，当前表格内容：", reportList.html());
                }
            },
            error: function (xhr, status, error) {
                console.error("加载举报信息失败：", xhr, status, error);
                alert('加载举报信息失败');
            }
        });
    }

    // 绑定动态事件，删除评论
    $(document).on('click', '.delete-btn', function () {
        console.log("删除按钮被点击");
        const commentId = $(this).data('comment-id'); // 获取 data-comment-id 的值
        console.log(`获取到的评论ID：${commentId}`);
        if (confirm('确认删除评论吗？')) {
            deleteComment(commentId);
        }
    });

    // 删除评论
    function deleteComment(commentId) {
        console.log(`调用 deleteComment 函数，评论ID：${commentId}`);
        if (!commentId) {
            console.error("评论ID 未传递");
            return;
        }
        $.ajax({
            url: 'DeleteCommentServlet',
            type: 'POST',
            data: { commentId: commentId },
            contentType: 'application/x-www-form-urlencoded;charset=UTF-8',
            beforeSend: function(xhr) {
                console.log("发送的数据：", { commentId: commentId });
            },
            success: function (response) {
                console.log("删除评论返回结果：", response);
                if (response.success) {
                    alert(response.message);
                    loadReportList(); // 重新加载列表
                } else {
                    alert(response.message);
                }
            },
            error: function (xhr, status, error) {
                console.error("删除评论失败：", xhr, status, error);
                alert('删除评论失败');
            }
        });
    }
</script>
</body>
</html>
