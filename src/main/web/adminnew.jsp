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

        #addNewsModal {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 50%;
            padding: 20px;
            background-color: #f9f9f9;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.3);
            border-radius: 10px;
            z-index: 1000;
        }

        #addNewsModal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 999;
        }

        .button-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        button {
            margin-top: 10px;
            padding: 10px 20px;
            font-size: 16px;
            color: white;
            background-color: #4CAF50;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #45a049;
        }

        button:active {
            background-color: #3e8e41;
        }

        .button-container a button {
            background-color: #007BFF;
        }

        .button-container a button:hover {
            background-color: #0056b3;
        }

        .button-container a button:active {
            background-color: #003d80;
        }

        #addNewsModal h2 {
            text-align: center;
            color: #333;
        }

        #addNewsModal form label {
            display: block;
            margin: 10px 0 5px;
            font-weight: bold;
        }

        #addNewsModal form input, #addNewsModal form textarea {
            width: calc(100% - 20px);
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }

        #addNewsModal form button {
            width: 48%;
            font-size: 14px;
            margin: 5px 1%;
        }

        #addNewsModal form button[type="submit"] {
            background-color: #4CAF50;
        }

        #addNewsModal form button[type="submit"]:hover {
            background-color: #45a049;
        }

        #addNewsModal form button[type="button"] {
            background-color: #f44336;
        }

        #addNewsModal form button[type="button"]:hover {
            background-color: #e53935;
        }

    </style>
    <script>
        function openAddNewsModal() {
            document.getElementById('addNewsModal').style.display = 'block';
            document.getElementById('addNewsModal-overlay').style.display = 'block';
        }

        function closeAddNewsModal() {
            document.getElementById('addNewsModal').style.display = 'none';
            document.getElementById('addNewsModal-overlay').style.display = 'none';
        }
    </script>
</head>
<body>
<h1>新闻列表</h1>

<table>
    <thead>
    <tr>
        <th>编号</th>
        <th>标题</th>
        <th>作者</th>
        <th>内容</th>
        <th>URL</th>
        <th>时间</th>
        <th>操作</th>
        <th>操作</th>
    </tr>
    </thead>
    <tbody id="newsList">
    </tbody>
</table>

<div class="button-container">
    <button onclick="openAddNewsModal()">添加新闻</button>
    <a href="adminboard.jsp"><button type="button">返回</button></a>
</div>

<div id="addNewsModal-overlay" onclick="closeAddNewsModal()"></div>
<div id="addNewsModal">
    <form action="AddNewsServlet" method="post" enctype="multipart/form-data">
        <h2>添加新闻</h2>
        <label for="title">标题:</label>
        <input type="text" id="title" name="title" placeholder="请输入标题" required>

        <label for="author">作者:</label>
        <input type="text" id="author" name="author" placeholder="请输入作者" required>

        <label for="content">内容:</label>
        <textarea id="content" name="content" rows="5" cols="40" placeholder="请输入内容" required></textarea>

        <label for="fileName">上传文件:</label>
        <input type="file" id="fileName" name="fileName" required>

        <div style="display: flex; justify-content: space-between;">
            <button type="submit">提交新闻</button>
            <button type="button" onclick="closeAddNewsModal()">取消</button>
        </div>
    </form>
</div>

<script>
    $(document).ready(function () {
        console.log("页面已加载，准备加载新闻列表");
        loadNewsList();
    });

    function loadNewsList() {
        $.ajax({
            url: 'LoadNewsServlet',
            type: 'GET',
            dataType: 'json', // 确保返回数据按 JSON 解析
            success: function (data) {
                console.log("服务器返回数据：", data);

                const newsList = $('#newsList');
                newsList.empty(); // 清空现有内容

                if (data.length === 0) {
                    newsList.append('<tr><td colspan="8">暂无记录。</td></tr>');
                } else {
                    data.forEach(function (news) {
                        let row = '<tr>' +
                            '<td>' + news.id + '</td>' +
                            '<td>' + news.title + '</td>' +
                            '<td>' + news.author + '</td>' +
                            '<td>' + news.content + '</td>' +
                            '<td>' + news.filePath + '</td>' +
                            '<td>' + news.createdAt + '</td>' +
                            '<td><button class="delete-btn" data-news-id="' + news.id + '">删除新闻</button></td>' +
                            '<td><button class="update-btn" data-news-id="' + news.id + '">修改新闻</button></td>' +
                            '</tr>';
                        newsList.append(row);
                    });
                }
            },
            error: function (xhr, status, error) {
                console.error("加载信息失败：", xhr, status, error);
                alert('加载信息失败');
            }
        });
    }

    $(document).on('click', '.delete-btn', function () {
        const newsId = $(this).data('news-id'); // 获取新闻 ID
        if (confirm(`确认要删除编号为 ${newsId} 的新闻吗？`)) {
            deleteNews(newsId);
        }
    });

    function deleteNews(newsId) {
        $.ajax({
            url: 'DeleteNewsServlet',
            type: 'POST',
            data: { newsId: newsId },
            success: function (response) {
                if (response.success) {
                    alert(response.message);
                    loadNewsList(); // 重新加载新闻列表
                } else {
                    alert(response.message);
                }
            },
            error: function () {
                alert('删除新闻失败，请稍后重试');
            }
        });
    }

    $(document).on('click', '.update-btn', function () {
        const newsId = $(this).data('news-id');
        const newTitle = prompt("请输入新的标题：");
        const newAuthor = prompt("请输入新的作者：");
        const newContent = prompt("请输入新的内容：");

        if (newTitle && newContent && newAuthor) {
            updateNews(newsId, newTitle, newContent, newAuthor);
        } else {
            alert("所有字段均不能为空！");
        }
    });

    function updateNews(newsId, title, content, author) {
        $.ajax({
            url: 'UpdateNewsServlet',
            type: 'POST',
            data: { newsId: newsId, title: title, content: content, author: author },
            success: function (response) {
                if (response.success) {
                    alert(response.message);
                    loadNewsList(); // 重新加载新闻列表
                } else {
                    alert(response.message);
                }
            },
            error: function () {
                alert('修改新闻失败，请稍后重试');
            }
        });
    }
</script>
</body>
</html>
