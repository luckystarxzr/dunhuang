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
    </style>
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
    </tr>
    </thead>
    <tbody id="newsList">
    </tbody>
</table>

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
                    newsList.append('<tr><td colspan="7">暂无记录。</td></tr>');
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

    // 绑定动态事件，删除新闻
    $(document).on('click', '.delete-btn', function () {
        console.log("删除按钮被点击");
        const newId = $(this).data('news-id'); // 获取 data-news-id 的值
        console.log(`获取到的新闻ID：${newId}`);
        if (confirm('确认删除新闻吗？')) {
            deleteNews(newId);
        }
    });

    // 删除新闻
    function deleteNews(newId) {
        console.log(`调用 deleteNews 函数，新闻ID：${newId}`);
        if (!newId) {
            console.error("新闻ID 未传递");
            return;
        }
        $.ajax({
            url: 'DeleteNewsServlet',
            type: 'POST',
            data: { newId: newId },
            contentType: 'application/x-www-form-urlencoded;charset=UTF-8',
            beforeSend: function(xhr) {
                console.log("发送的数据：", { newId: newId });
            },
            success: function (response) {
                console.log("删除新闻返回结果：", response);
                if (response.success) {
                    alert(response.message);
                    loadNewsList(); // 重新加载列表
                } else {
                    alert(response.message);
                }
            },
            error: function (xhr, status, error) {
                console.error("删除新闻失败：", xhr, status, error);
                alert('删除新闻失败');
            }
        });
    }
</script>
</body>
</html>
