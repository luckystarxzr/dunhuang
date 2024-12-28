<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>敦煌壁画画廊</title>
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
  <section class="gallery">
    <h1>敦煌画廊</h1>
    <h2>一起探索美丽的敦煌壁画吧！</h2>
    <div class="gallery-grid">
      <%-- 动态加载画廊数据 --%>
      <%
        String[] images = {
                "img7.png", "img8.png", "img9.png", "img10.png",
                "img11.png", "img12.png", "img13.png", "img14.png",
                "img15.png", "img16.png", "img17.png", "img18.png"
        };
        String[] captions = {
                "山中听法", "山中狩猎", "倒立童子", "扫街、降雨",
                "国王狩猎", "马厩", "二人推磨", "连枷打场",
                "牛环、牛辔导牛", "葡萄石榴纹藻井", "莲花纹套斗藻井", "莲花纹套斗藻井"
        };

        for (int i = 0; i < images.length; i++) {
      %>
      <div class="gallery-item">
        <img src="images/<%= images[i] %>" alt="<%= captions[i] %>">
        <div class="overlay"><%= captions[i] %></div>
      </div>
      <% } %>
    </div>
  </section>

  <div id="modal" class="modal">
    <span class="close" onclick="closeModal()">&times;</span>
    <img id="modal-image" class="modal-content" alt="">
    <div id="modal-caption" class="caption"></div>
  </div>
</main>

<footer>
  <p>&copy; 2024 敦煌壁画 & xzr</p>
</footer>

<script src="js/scripts.js"></script>
</body>
</html>
