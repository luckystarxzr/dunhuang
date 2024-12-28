<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>敦煌壁画的历史</title>
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
    <section class="history">
        <h2>敦煌壁画的历史</h2>
        <h4>敦煌壁画代表了佛教艺术和文化的重要组成部分，为我们提供了对古代中国宗教和社会生活的深入了解。</h4>
        <div class="timeline">
            <%-- 动态加载历史事件数据 --%>
            <%
                String[] periods = {
                        "4世纪", "9世纪", "13世纪", "14-17世纪", "18世纪末-20世纪初", "20世纪中期至今"
                };
                String[] descriptions = {
                        "敦煌莫高窟壁画的创作起始，受到佛教僧侣和艺术家的推动。",
                        "壁画创作的高峰期，设计精美，复杂程度不断增加，反映了佛教艺术的丰富性。",
                        "由于政治和经济变化，壁画创作逐渐衰退，但现存的壁画仍继续启发和教育人们。",
                        "这一时期敦煌壁画的创作几乎停止，但壁画的保存和维护依然受到重视，修复了部分壁画。",
                        "敦煌壁画引起了西方考古学者关注，开始了系统的研究和修复工作，推动了对敦煌艺术的国际了解。",
                        "敦煌壁画得到了更广泛的保护和研究，让更多人对敦煌壁画的兴趣不断增加，促进了文化交流和艺术教育。"
                };

                for (int i = 0; i < periods.length; i++) {
            %>
            <div class="timeline-item">
                <h3><%= periods[i] %></h3>
                <p><%= descriptions[i] %></p>
            </div>
            <% } %>
        </div>
    </section>
</main>

<footer>
    <p>&copy; 2024 敦煌壁画 & xzr</p>
</footer>
</body>
</html>
