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
</head>
<body>
<div class="news-form">
    <!-- 使用JSP Include来包含添加新闻的表单 -->
    <jsp:include page="addNews.jsp" />
</div>
<div class="news-list">
    <h2>新闻列表</h2>
    <div id="news-container">
        <!-- 新闻列表将动态加载在这里 -->
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // 加载新闻列表
        function loadNews() {
            fetch('newsList.jsp')
                .then(response => response.text())
                .then(data => {
                    document.getElementById('news-container').innerHTML = data;
                })
                .catch(error => console.error('Error loading news:', error));
        }

        // 提交添加新闻表单
        const newsForm = document.getElementById('news-form');
        if (newsForm) {
            newsForm.addEventListener('submit', function (event) {
                event.preventDefault();

                const formData = new FormData(newsForm);

                fetch('addNews.jsp', {
                    method: 'POST',
                    body: formData
                })
                    .then(response => response.text())
                    .then(message => {
                        alert(message);
                        loadNews(); // 刷新新闻列表
                    })
                    .catch(error => console.error('Error submitting news:', error));
            });
        }

        // 删除新闻
        document.body.addEventListener('click', function (event) {
            if (event.target && event.target.classList.contains('delete-btn')) {
                fetch('deleteNews.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                })
                    .then(response => response.text())
                    .then(message => {
                        alert(message);
                        loadNews(); // 刷新新闻列表
                    })
                    .catch(error => console.error('Error deleting news:', error));
            }
        });

        // 初次加载新闻列表
        loadNews();
    });
</script>
</body>
</html>
