<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>更新密码</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .password-form {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 400px;
        }
        .password-form h2 {
            margin-bottom: 20px;
            font-size: 24px;
        }
        .password-form label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }
        .password-form input {
            width: 100%;
            padding: 8px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .password-form button {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px;
            width: 100%;
            border-radius: 4px;
            cursor: pointer;
        }
        .password-form button:hover {
            background-color: #0056b3;
        }
        .message {
            margin-top: 15px;
            padding: 10px;
            border-radius: 4px;
            display: none;
        }
        .message.success {
            background-color: #d4edda;
            color: #155724;
        }
        .message.error {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            $("#update-password-form").on("submit", function (event) {
                event.preventDefault();

                const formData = {
                    username: $("#username").val(),
                    currentPassword: $("#currentPassword").val(),
                    newPassword: $("#newPassword").val()
                };

                $.ajax({
                    type: "POST",
                    url: "updatePassword",
                    data: formData,
                    dataType: "json",
                    success: function (response) {
                        if (response.success) {
                            $(".message")
                                .removeClass("error")
                                .addClass("success")
                                .text(response.message)
                                .show();
                        } else if (response.error) {
                            $(".message")
                                .removeClass("success")
                                .addClass("error")
                                .text(response.message)
                                .show();
                        }
                    },
                    error: function () {
                        $(".message")
                            .removeClass("success")
                            .addClass("error")
                            .text("服务器错误，请稍后再试。")
                            .show();
                    }
                });
            });
        });
    </script>
</head>
<body>
<div class="password-form">
    <h2>更新密码</h2>
    <form id="update-password-form">
        <label for="username">用户名</label>
        <input type="text" id="username" name="username" required>

        <label for="currentPassword">当前密码</label>
        <input type="password" id="currentPassword" name="currentPassword" required>

        <label for="newPassword">新密码</label>
        <input type="password" id="newPassword" name="newPassword" required>

        <button type="submit">更新密码</button>
    </form>
    <div class="message"></div>
</div>
</body>
</html>
