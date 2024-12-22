<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>敦煌壁画 - 知识与互动</title>
    <link rel="stylesheet" href="styles.css">
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
            <li><a href="filemanager.jsp">文件</a></li>
            <li><a href="login.jsp">登录</a></li>
            <li><a href="register.jsp">注册</a></li>
            <li><a href="index.jsp">首页</a></li>
            <li><a href="explore.html">探索</a></li>
            <li><a href="history.html">历史</a></li>
            <li><a href="gallery.html">画廊</a></li>
            <li><a href="about.html">关于</a></li>
        </ul>
    </nav>
</header>

<main>
    <section class="hero">
        <h2>探索美丽的敦煌壁画</h2>
        <p>探索敦煌的古代艺术，在这里历史与文化栩栩如生。</p>
        <button onclick="window.location.href='explore.html'">开始探索</button>
    </section>

    <section class="features">
        <div class="feature">
            <a href="explore.html" target="_blank">
                <img src="images/img.png">
            </a>
            <h3>历史洞察</h3>
            <meta name="description" content="了解敦煌壁画的历史意义。">
        </div>
        <div class="feature">
            <a href="gallery.html" target="_blank">
                <img src="images/img4.png">
            </a>
            <h3>魅力画廊</h3>
            <meta name="description" content="观察和分析壁画的复杂细节。">
        </div>
        <div class="feature">
            <a href="about.html" target="_blank">
                <img src="images/img6.png">
            </a>
            <h3>关于我们</h3>
            <meta name="description" content="快来和我们一起交流吧。">
        </div>
    </section>
    <jsp:include page="news.jsp" />
</body>
</html>