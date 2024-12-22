document.addEventListener('DOMContentLoaded', () => {
    let currentIndex = 0;
    const items = document.querySelectorAll('.carousel-item');
    const totalItems = items.length;

    function showSlide(index) {
        const offset = -index * 100;
        document.querySelector('.carousel-inner').style.transform = `translateX(${offset}%)`;

        items.forEach((item, i) => {
            if (i === index) {
                item.querySelector('.carousel-caption').style.display = 'block';
            } else {
                item.querySelector('.carousel-caption').style.display = 'none';
            }
        });
    }

    function nextSlide() {
        currentIndex = (currentIndex + 1) % totalItems;
        showSlide(currentIndex);
    }

    function prevSlide() {
        currentIndex = (currentIndex - 1 + totalItems) % totalItems;
        showSlide(currentIndex);
    }

    setInterval(nextSlide, 3000);
    showSlide(currentIndex);
});

// 打开模态窗口函数
function openModal(imageSrc, description) {
    const modal = document.getElementById("modal");
    const modalImg = document.getElementById("modal-image");
    const captionText = document.getElementById("modal-caption");

    modal.style.display = "block";
    modalImg.src = imageSrc;
    captionText.innerHTML = description;
}

// 关闭模态窗口函数
document.addEventListener('DOMContentLoaded', function () {
    const audioElement = document.getElementById('background-music');

    if (!sessionStorage.getItem('musicStarted')) {
        audioElement.play();  // 开始播放音乐
        sessionStorage.setItem('musicStarted', 'true');  // 标记音乐已开始
    }

    document.body.addEventListener('click', function () {
        if (audioElement.muted) {
            audioElement.muted = false;
        }
    });

    audioElement.addEventListener('pause', function () {
        audioElement.play();
    });

    audioElement.addEventListener('volumechange', function () {
        if (audioElement.muted) {
            audioElement.muted = false;
        }
    });

    window.addEventListener('beforeunload', function () {
        sessionStorage.setItem('audioTime', audioElement.currentTime);
    });

    if (sessionStorage.getItem('audioTime')) {
        audioElement.currentTime = sessionStorage.getItem('audioTime');
    }
});
//注册验证
document.getElementById('register-form').addEventListener('submit', function(event) {
    event.preventDefault();

    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    const phone = document.getElementById('phone').value;

    // 验证手机号格式
    const phoneRegex = /^[1][3-9][0-9]{9}$/;
    if (!phoneRegex.test(phone)) {
        alert('请输入有效的手机号！');
        return;
    }

    if (username && password) {
        registerUser(username, password, phone);
    } else {
        alert('请填写所有字段！');
    }
});

function registerUser(username, password, phone) {
    const userData = {
        username: username,
        password: password,
        phone: phone
    };

    // 发送注册信息到后端
    fetch('/api/register', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(userData),
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('注册成功！即将跳转到登录页面。');
                window.location.href = 'login.html';
            } else {
                alert('注册失败：' + data.message);
            }
        })
        .catch((error) => {
            console.error('错误:', error);
            alert('注册过程中出现错误，请稍后再试。');
        });
}
//登录验证
document.getElementById('login-form').addEventListener('submit', function(event) {
    event.preventDefault(); // 阻止表单默认提交

    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    // 发送 AJAX 请求
    fetch('/login', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ username, password })
    })
        .then(response => {
            if (response.ok) {
                // 登录成功，重定向到 index.html
                window.location.href = 'index.html';
            } else {
                // 处理错误情况
                alert('用户名或密码错误');
            }
        })
        .catch(error => {
            console.error('请求失败:', error);
            alert('登录请求失败');
        });
});
//修改密码验证
document.getElementById('change-password-form').addEventListener('submit', function(event) {
    event.preventDefault(); // 防止默认表单提交

    // 获取输入值
    const oldPassword = document.getElementById('old-password').value;
    const newPassword = document.getElementById('new-password').value;
    const verificationCode = document.getElementById('verification-code').value;

    // 假设这里是验证旧密码的逻辑
    const isOldPasswordCorrect = validateOldPassword(oldPassword); // 这里是伪函数，请您根据系统返回值进行处理

    if (!isOldPasswordCorrect) {
        alert('旧密码不正确！');
        return;
    }

    // 发送新密码和验证码到服务器的逻辑
    if (shouldVerify()) { // 弹出手机号和验证码时的逻辑
        if (verificationCode === '') {
            alert('请填写验证码！');
            return;
        }

        const isVerificationSuccessful = validateVerificationCode(verificationCode); // 再次这里是伪函数

        if (!isVerificationSuccessful) {
            alert('验证码不正确！');
            return;
        }
    }

    // 假设设置新密码成功
    const isPasswordChanged = changePassword(oldPassword, newPassword); // 伪逻辑，请您根据实际情况处理结果

    if (isPasswordChanged) {
        alert('密码修改成功！');
        window.location.href = 'login.html'; // 成功跳转到登录页面
    } else {
        alert('修改密码失败，请稍后重试！');
    }
});

function shouldVerify() {
    const verificationContainer = document.getElementById('verification-container');
    return verificationContainer.style.display === 'block';
}

function validateOldPassword(oldPassword) {
    // 这里判断旧密码是否正确
    // 这是一个伪函数，您需要替换为实际验证逻辑
    return oldPassword === '正确的旧密码'; // 示例，实际应该与后端交互
}

function validateVerificationCode(code) {
    // 这里验证验证码的逻辑
    // 这是一个伪函数
    return code === '正确的验证码'; // 示例
}

function changePassword(oldPassword, newPassword) {
    // 这里处理新密码设置的实际逻辑
    // 这是一个伪函数，实际应该与后端交互
    return true; // 示例，意味着密码更改成功
}

function sendVerificationCode() {
    // 这里发送验证码的逻辑
    alert('验证码已发送！'); // 作为示例，您需要实现实际的发送逻辑
    document.getElementById('verification-container').style.display = 'block'; // 显示验证码输入框
}