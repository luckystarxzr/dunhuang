<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理员举报管理</title>
    <style>
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

        p {
            color: red;
            text-align: center;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            loadReports();

            $(document).on('click', '.delete-comment', function(e) {
                e.preventDefault();
                var commentId = $(this).data('commentid');
                var confirmDelete = confirm('确认删除评论吗?');
                if (confirmDelete) {
                    deleteReport(commentId, $(this).closest('tr'));
                }
            });
        });

        function loadReports() {
            $.ajax({
                url: 'AdminReportServlet',
                method: 'GET',
                success: function(response) {
                    var reports = response.reports;
                    console.log(reports);
                    var html = '';
                    reports.forEach(function(report) {
                        console.log(report);
                        html += `<tr>
                            <td>${report.reportId}</td>
                            <td>${report.newsId}</td>
                            <td>${report.commentId}</td>
                            <td>${report.reportedBy}</td>
                            <td>${report.reportReason}</td>
                            <td>${report.reportTime}</td>
                            <td><button class="delete-comment" data-commentid="${report.commentId}">删除</button></td>
                          </tr>`;
                    });
                    $('#reportList').html(html);
                },
                error: function() {
                    alert('加载举报数据失败，请稍后再试。');
                }
            });
        }

        function deleteReport(commentId, rowElement) {
            $.ajax({
                url: 'AdminReportServlet',
                method: 'POST',
                data: { deleteCommentId: commentId },
                success: function(response) {
                    if (response.success) {
                        alert('评论删除成功');
                        rowElement.remove();
                    } else {
                        alert('删除失败，请稍后再试。');
                    }
                },
                error: function() {
                    alert('删除操作失败，请稍后再试。');
                }
            });
        }
    </script>
</head>
<body>
<h1>用户举报列表</h1>
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
</body>
</html>
