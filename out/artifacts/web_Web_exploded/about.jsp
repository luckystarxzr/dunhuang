<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>关于 - 敦煌壁画</title>
    <link rel="stylesheet" href="css/styles.css">
    <audio id="background-music" autoplay loop>
        <source src="dunhuan.mp3" type="audio/mpeg">
    </audio>
</head>
<body>
<header>
    <nav style="display: flex; align-items: center;">
        <img src="images/logo.png" alt="Logo" style="width: 50px; height: 50px; margin-right: 10px;">
        <h1>敦煌壁画</h1>
        <ul>
            <li><a href="login.jsp">登录</a></li>
            <li><a href="register.jsp">注册</a></li>
            <li><a href="index.jsp">首页</a></li>
            <li><a href="explore.jsp">探索</a></li>
            <li><a href="history.jsp">历史</a></li>
            <li><a href="gallery.jsp">画廊</a></li>
            <li><a href="about.jsp">关于</a></li>
        </ul>
    </nav>
</header>

<head>
    <style>
        /* 使整个section居中 */
        .about-content {
            max-width: 800px;
            margin: 0 auto;
            text-align: center;
        }
        .team-grid {
            display: flex;
            justify-content: center;
        }

        .team-member {
            text-align: center;
            margin: 20px;
        }

        /* 调整 ul 列表的居中对齐 */
        ul {
            list-style: none;
            padding: 0;
            text-align: left;
            display: inline-block;
        }
    </style>
</head>
<body>
<main>
    <section class="about-content">
        <h1>关于这个项目</h1>
        <p></p>
        <p>坐落在河西走廊西端的敦煌，以精美的壁画和塑像闻名于世。</p>
        <p></p>
        <h2>这个项目致力于为大家展现敦煌壁画的文化遗产.</h2>
        <h3>作者</h3>
        <div class="team-grid">
            <div class="team-member">
                <img src="images/auther.jpg" width="200px" height="200px">
                <h1>xzr</h1>
            </div>
        </div>
        <p>如果你有什么想要和我交流的可以通过下方的方式联系我:</p>
        <ul>
            <li>邮箱: <a href="mailto:3447470174@qq.com">3447470174@qq.com</a></li>
            <li>电话: +86 191 4707 5279</li>
            <li>地址: 福建理工大学旗山北校区</li>
        </ul>
        <h3>我十分期待你的来信</h3>
    </section>
</main>
</body>
<footer>
    <p>&copy; 2024 敦煌壁画 & xzr</p>
</footer>
</body>
</html>
