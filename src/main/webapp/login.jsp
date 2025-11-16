<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Garage Management</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #fecfef 100%);
            background-attachment: fixed;
            background-size: cover;
            padding-bottom: 2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
            min-height: 100vh;
        }

        body::before {
            content: '';
            position: absolute;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(255, 182, 193, 0.3) 0%, rgba(255, 192, 203, 0.1) 100%);
            border-radius: 50%;
            top: -150px;
            left: -150px;
            animation: float 8s ease-in-out infinite;
            box-shadow: 0 0 50px rgba(255, 182, 193, 0.3);
        }
        
        body::after {
            content: '';
            position: absolute;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(255, 192, 203, 0.4) 0%, rgba(255, 182, 193, 0.2) 100%);
            border-radius: 50%;
            bottom: -100px;
            right: -100px;
            animation: float 10s ease-in-out infinite reverse;
            box-shadow: 0 0 40px rgba(255, 192, 203, 0.4);
        }
        
        body::before {
            animation: float 8s ease-in-out infinite, rotate 20s linear infinite;
        }
        
        body::after {
            animation: float 10s ease-in-out infinite reverse, rotate 25s linear infinite reverse;
        }
        
        @keyframes float {
            0%, 100% { 
                transform: translateY(0px) rotate(0deg); 
            }
            50% { 
                transform: translateY(-30px) rotate(180deg); 
            }
        }
        
        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        .particle {
            position: absolute;
            width: 6px;
            height: 6px;
            background: rgba(255, 182, 193, 0.6);
            border-radius: 50%;
            animation: particleFloat 15s linear infinite;
        }
        
        @keyframes particleFloat {
            0% {
                transform: translateY(100vh) translateX(0px);
                opacity: 0;
            }
            10% {
                opacity: 1;
            }
            90% {
                opacity: 1;
            }
            100% {
                transform: translateY(-100px) translateX(100px);
                opacity: 0;
            }
        }
        
        .login-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 3rem;
            border-radius: 25px;
            box-shadow: 0 30px 60px rgba(255, 182, 193, 0.3), 
                        0 0 0 1px rgba(255, 192, 203, 0.2);
            width: 100%;
            max-width: 420px;
            position: relative;
            z-index: 1;
            backdrop-filter: blur(20px);
            animation: slideUp 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            border: 1px solid rgba(255, 182, 193, 0.3);
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }
        
        .login-header h1 {
            color: #2d3748;
            margin-bottom: 0.5rem;
            font-size: 2.2rem;
            font-weight: 700;
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #ff9a9e 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: gradientShift 3s ease-in-out infinite;
        }
        
        @keyframes gradientShift {
            0%, 100% { 
                background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #ff9a9e 100%);
            }
            50% { 
                background: linear-gradient(135deg, #fecfef 0%, #ff9a9e 50%, #fecfef 100%);
            }
        }
        
        .login-header p {
            color: #718096;
            font-size: 0.95rem;
            font-weight: 500;
        }
        
        .form-group {
            margin-bottom: 1.75rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.75rem;
            color: #2d3748;
            font-weight: 600;
            font-size: 0.95rem;
            letter-spacing: 0.3px;
        }
        
        .form-group input {
            width: 100%;
            padding: 0.95rem 1.2rem;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f7fafc;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .password-container {
            position: relative;
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            font-size: 1.3rem;
            color: #718096;
            padding: 0;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: all 0.3s ease;
        }
        
        .password-toggle:hover {
            color: #667eea;
            background: rgba(102, 126, 234, 0.1);
        }
        
        .form-group input[type="password"],
        .form-group input[type="text"] {
            padding-left: 45px;
            padding-right: 50px;
        }
        
        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #718096;
            font-size: 1.1rem;
            pointer-events: none;
            z-index: 1;
        }
        
        .form-group input[name="account"] {
            padding-left: 45px;
            padding-right: 1.2rem;
        }
        
        .btn-login {
            width: 100%;
            padding: 1.1rem;
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #ff9a9e 100%);
            color: white;
            border: none;
            border-radius: 15px;
            font-size: 1.1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            letter-spacing: 0.5px;
            box-shadow: 0 15px 35px rgba(255, 154, 158, 0.4);
            position: relative;
            overflow: hidden;
        }
        
        .btn-login::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.6s;
        }
        
        .btn-login:hover::before {
            left: 100%;
        }
        
        .btn-login:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 20px 40px rgba(255, 154, 158, 0.5);
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 30%, #ff9a9e 100%);
        }
        
        .btn-login:active {
            transform: translateY(-1px) scale(0.98);
        }
        
        .btn-login:active {
            transform: translateY(0);
        }
        
        .register-link {
            text-align: center;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e2e8f0;
        }
        
        .register-link p {
            color: #718096;
            font-size: 0.95rem;
        }
        
        .register-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 700;
            transition: all 0.3s ease;
        }
        
        .register-link a:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        
        .alert {
            padding: 1rem 1.2rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
            animation: slideDown 0.4s ease-out;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .alert-error {
            background-color: #fed7d7;
            color: #742a2a;
            border: 1px solid #fc8181;
        }
        
        .alert-success {
            background-color: #c6f6d5;
            color: #22543d;
            border: 1px solid #9ae6b4;
        }
        
        .toast {
            position: fixed;
            top: 20px;
            right: 20px;
            background: #28a745;
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            z-index: 1000;
            display: none;
            align-items: center;
            gap: 0.8rem;
            font-weight: 500;
            animation: slideIn 0.3s ease-out;
            max-width: 400px;
        }
        
        .toast.show {
            display: flex;
        }
        
        .toast.hide {
            animation: slideOut 0.3s ease-in forwards;
        }
        
        @keyframes slideIn {
            from {
                transform: translateX(400px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        @keyframes slideOut {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(400px);
                opacity: 0;
            }
        }
        
        .toast::before {
            content: '✓';
            font-size: 1.5rem;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h1>✨ Đăng nhập ✨</h1>
            <p>🌸 Chào mừng bạn đến với Garage Management 🌸</p>
        </div>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>
        
        <div id="toast" class="toast"></div>
        <% if (request.getParameter("message") != null && request.getParameter("message").equals("logout_success")) { %>
            <script>

                window.logoutSuccessMessage = '✨ Đăng xuất thành công! ✨';
            </script>
        <% } %>
        
        <form action="<%= request.getContextPath() %>/user" method="post">
            <input type="hidden" name="action" value="login">
            <div class="form-group">
                <label for="account">👤 Tài khoản:</label>
                <div style="position: relative;">
                    <span class="input-icon">💎</span>
                    <input type="text" id="account" name="account" required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="password">🔐 Mật khẩu:</label>
                <div class="password-container">
                    <span class="input-icon">🛡️</span>
                    <input type="password" id="password" name="password" required>
                    <button type="button" class="password-toggle" onclick="togglePassword()">
                        <span id="password-eye">👁</span>
                    </button>
                </div>
            </div>
            
            <button type="submit" class="btn-login">Đăng nhập</button>
        </form>
        
        <div class="register-link">
            <p>Chưa có tài khoản? <a href="register.jsp">Đăng ký ngay</a></p>
        </div>
    </div>

    <div class="particle" style="left: 10%; animation-delay: 0s;"></div>
    <div class="particle" style="left: 20%; animation-delay: 2s;"></div>
    <div class="particle" style="left: 30%; animation-delay: 4s;"></div>
    <div class="particle" style="left: 40%; animation-delay: 6s;"></div>
    <div class="particle" style="left: 50%; animation-delay: 8s;"></div>
    <div class="particle" style="left: 60%; animation-delay: 10s;"></div>
    <div class="particle" style="left: 70%; animation-delay: 12s;"></div>
    <div class="particle" style="left: 80%; animation-delay: 14s;"></div>
    <div class="particle" style="left: 90%; animation-delay: 16s;"></div>

    <script>
        function togglePassword() {
            const passwordField = document.getElementById('password');
            const eyeIcon = document.getElementById('password-eye');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                eyeIcon.textContent = '🙈';
            } else {
                passwordField.type = 'password';
                eyeIcon.textContent = '👁';
            }
        }
        
        window.addEventListener('load', function() {
            localStorage.removeItem('selectedServices');
            localStorage.removeItem('selectedSpareParts');
            localStorage.removeItem('selectedTechnicians');
            console.log('LocalStorage cleared on login page');

            if (window.logoutSuccessMessage) {
                showToast(window.logoutSuccessMessage);
                window.logoutSuccessMessage = null;
            }
        });

        function showToast(message) {
            const toast = document.getElementById('toast');
            if (toast) {
                toast.textContent = message;
                toast.classList.add('show');

                setTimeout(function() {
                    toast.classList.remove('show');
                    toast.classList.add('hide');

                    setTimeout(function() {
                        toast.classList.remove('hide');
                    }, 300);
                }, 3000);
            }
        }
    </script>
</body>
</html>
