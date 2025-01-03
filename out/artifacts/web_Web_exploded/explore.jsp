<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>探索敦煌壁画</title>
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

<main>
    <section class="explore-content">
        <h1>探索壁画</h1>
        <h3>让我们通过壁画感受这里面的历史意义!</h3>
        <div class="carousel">
            <div class="carousel-inner">
                <%-- 动态加载壁画数据 --%>
                <%
                    String[] images = {"img1.png", "img2.png", "img3.png", "img5.png", "img7.png", "img8.png", "img9.png"};
                    String[] captions = {
                            "虹桥前有一五层灯轮，两名点灯人正在添油点灯，右边的人站在四腿凳上，点灯人身后各有一人双手端着油碗。",
                            "舞伎披巾、展臂、张手指，曲膝高提等姿，舞伎气质刚健；鼓形稍大，纹饰清晰。",
                            "在陡峭的山岭上有河流流过，临水处建有寺庙，山岭下的大河两侧生长着杉树。",
                            "垂幔下，一身飞天献花供养，另一身演奏凤首琴，琴张四弦，飞天右手握琴颈，左手拇指和食指抚弦。",
                            "四周山峦重重，树木茂盛，水波荡漾。山中还画出飞禽走兽，生动活泼。",
                            "猎人正在捕鹿、射虎，场面十分惊险，山峦小于人物，以不同的颜色染出，具有凹凸的效果，上部画出远山，表现出空间感。",
                            "倒立是现代体操运动中是常见的基础动作，不过这个唐代的小胖墩，选择了极富挑战的倒立来完成礼佛，他能成功吗？"
                    };

                    for (int i = 0; i < images.length; i++) {
                %>
                <div class="carousel-item <%= (i == 0) ? "active" : "" %>">
                    <img src="images/<%= images[i] %>" alt="壁画图片">
                    <div class="carousel-caption"><%= captions[i] %></div>
                </div>
                <% } %>
            </div>
        </div>
    </section>
</main>

<footer>
    <p>&copy; 2024 敦煌壁画 & xzr</p>
</footer>

<script src="js/scripts.js"></script>
</body>
</html>
