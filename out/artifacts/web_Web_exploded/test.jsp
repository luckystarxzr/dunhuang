<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>JSTL 测试页面</title>
</head>
<body>
<!-- 测试变量输出 -->
<h2>变量输出测试</h2>
<c:set var="message" value="Hello, JSTL!" />
<p>消息内容: ${message}</p>

<!-- 测试条件判断 -->
<h2>条件判断测试</h2>
<c:set var="userRole" value="admin" />
<c:if test="${userRole == 'admin'}">
    <p>欢迎管理员！</p>
</c:if>
<c:choose>
    <c:when test="${userRole == 'user'}">
        <p>普通用户访问。</p>
    </c:when>
    <c:otherwise>
        <p>您当前是访客身份。</p>
    </c:otherwise>
</c:choose>

<!-- 测试循环 -->
<h2>循环测试</h2>
<c:set var="numbers" value="${[1, 2, 3, 4, 5]}" />
<ul>
    <c:forEach var="num" items="${numbers}">
        <li>数字: ${num}</li>
    </c:forEach>
</ul>

<!-- 测试遍历对象列表 -->
<h2>对象列表测试</h2>
<c:set var="newsList">
    <c:set var="news1">
        <c:set var="title" value="新闻1" />
        <c:set var="author" value="作者1" />
    </c:set>
    <c:set var="news2">
        <c:set var="title" value="新闻2" />
        <c:set var="author" value="作者2" />
    </c:set>
</c:set>
<c:forEach var="news" items="${newsList}">
    <p>
        标题: ${news.title}<br/>
        作者: ${news.author}
    </p>
</c:forEach>
</body>
</html>
