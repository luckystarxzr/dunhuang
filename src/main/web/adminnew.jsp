<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>新闻管理页面</title>
    <style>
        body {
            background-image: url('background.jpg');
            background-size: cover;
            color: #333;
            background-position: center;
            background-attachment: fixed;
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            padding: 20px;
        }
        .news-form, .news-list {
            margin-bottom: 20px;
            padding: 15px;
            border: 1px solid #ddd;
            background-color: #fff;
            border-radius: 5px;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            // 加载新闻列表
            function loadNews() {
                $.get("newsList.jsp", function (data) {
                    $(".news-list").html(data);
                });
            }

            // 初次加载新闻列表
            loadNews();

            // 提交添加新闻表单
            $("#news-form").on("submit", function (event) {
                event.preventDefault();
                $.post("addNews.jsp", $(this).serialize(), function (response) {
                    alert(response);
                    loadNews(); // 刷新新闻列表
                });
            });

            // 删除新闻
            $(document).on("click", ".delete-btn", function () {
                const newsId = $(this).data("id");
                $.post("deleteNews.jsp", { id: newsId }, function (response) {
                    alert(response);
                    loadNews(); // 刷新新闻列表
                });
            });
        });
    </script>
</head>
<body>
<div class="news-form">
    <jsp:include page="addNews.jsp" />
</div>
<div class="news-list">
    <h2>新闻列表</h2>
</div>
</body>
</html>
