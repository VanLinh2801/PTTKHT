<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - Garage Management</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #ff9a9e 100%);
            background-attachment: fixed;
            background-size: cover;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0 3rem 0;
            position: relative;
            overflow-y: auto;
            overflow-x: hidden;
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
            right: -150px;
            animation: float 8s ease-in-out infinite, rotate 20s linear infinite;
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
            left: -100px;
            animation: float 10s ease-in-out infinite reverse, rotate 25s linear infinite reverse;
            box-shadow: 0 0 40px rgba(255, 192, 203, 0.4);
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
            width: 8px;
            height: 8px;
            background: rgba(255, 182, 193, 0.7);
            border-radius: 50%;
            animation: particleFloat 12s linear infinite;
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
        
        .register-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 2.5rem 3rem 3rem 3rem;
            border-radius: 25px;
            box-shadow: 0 30px 60px rgba(255, 182, 193, 0.3), 
                        0 0 0 1px rgba(255, 192, 203, 0.2);
            width: 100%;
            max-width: 550px;
            position: relative;
            z-index: 1;
            animation: slideUp 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            border: 1px solid rgba(255, 182, 193, 0.3);
            backdrop-filter: blur(20px);
            margin-top: -1rem;
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
        
        .register-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }
        
        .register-header h1 {
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
        
        .register-header p {
            color: #718096;
            font-size: 0.95rem;
            font-weight: 500;
        }
        
        .form-row {
            display: flex;
            gap: 1rem;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
            flex: 1;
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
        
        .password-container {
            position: relative;
        }
        
        .password-toggle {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            font-size: 1.2rem;
            color: #718096;
            padding: 0;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: color 0.3s ease;
            z-index: 3;
        }
        
        .password-toggle:hover {
            color: #2d3748;
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
            z-index: 2;
        }
        
        .form-group input[type="email"],
        .form-group input[type="tel"],
        .form-group input[type="date"] {
            padding-left: 45px;
        }
        
        .error-message {
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 0.5rem;
            display: none;
            animation: slideDown 0.3s ease-out;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-5px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .form-group.error input {
            border-color: #dc3545;
            background: #fff5f5;
        }
        
        .form-group.success input {
            border-color: #28a745;
            background: #f0fdf4;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .btn-register {
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
        
        .btn-register::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.6s;
        }
        
        .btn-register:hover::before {
            left: 100%;
        }
        
        .btn-register:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 20px 40px rgba(255, 154, 158, 0.5);
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 30%, #ff9a9e 100%);
        }
        
        .btn-register:active {
            transform: translateY(-1px) scale(0.98);
        }
        
        .btn-register:active {
            transform: translateY(0);
        }
        
        .alert {
            padding: 1rem 1.2rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            font-size: 0.95rem;
            animation: slideDown 0.4s ease-out;
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
        
        .back-to-login-section {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1rem;
        }
        
        .back-to-login-section p {
            color: #718096;
            font-size: 0.85rem;
            margin-bottom: 0.8rem;
            font-weight: 500;
        }
        
        .back-to-login-btn {
            display: inline-block;
            padding: 0.7rem 1.5rem;
            background: rgba(255, 255, 255, 0.9);
            color: #667eea;
            border: 2px solid #667eea;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
        }
        
        .back-to-login-btn:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.3);
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h1>✨ Đăng ký tài khoản ✨</h1>
            <p>🌸 Tạo tài khoản mới để sử dụng dịch vụ 🌸</p>
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
        
        <form action="user" method="post">
            <input type="hidden" name="action" value="register">
            <div class="form-row">
                <div class="form-group">
                    <label for="fullName">👤 Họ và tên:</label>
                    <div style="position: relative;">
                        <span class="input-icon">💎</span>
                    <input type="text" id="fullName" name="fullName" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="account">🏷️ Tài khoản:</label>
                    <div style="position: relative;">
                        <span class="input-icon">🎯</span>
                    <input type="text" id="account" name="account" required>
                    </div>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="password">🔐 Mật khẩu:</label>
                    <div class="password-container">
                        <span class="input-icon">🛡️</span>
                        <input type="password" id="password" name="password" required minlength="8">
                        <button type="button" class="password-toggle" onclick="togglePassword('password')">
                            <span id="password-eye">👁</span>
                        </button>
                    </div>
                    <div class="error-message" id="password-error"></div>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">🔒 Xác nhận mật khẩu:</label>
                    <div class="password-container">
                        <span class="input-icon">🔑</span>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                        <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                            <span id="confirmPassword-eye">👁</span>
                        </button>
                    </div>
                    <div class="error-message" id="confirmPassword-error"></div>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="email">📧 Email:</label>
                    <div style="position: relative;">
                        <span class="input-icon">💌</span>
                    <input type="email" id="email" name="email" required>
                    </div>
                    <div class="error-message" id="email-error"></div>
                </div>
                
                <div class="form-group">
                    <label for="phoneNumber">📱 Số điện thoại:</label>
                    <div style="position: relative;">
                        <span class="input-icon">📞</span>
                    <input type="tel" id="phoneNumber" name="phoneNumber">
                    </div>
                    <div class="error-message" id="phoneNumber-error"></div>
                </div>
            </div>
            
            <div class="form-group">
                <label for="dateOfBirth">🎂 Ngày sinh:</label>
                <div style="position: relative;">
                    <span class="input-icon">🎈</span>
                <input type="date" id="dateOfBirth" name="dateOfBirth">
                </div>
            </div>
            
            <button type="submit" class="btn-register">Đăng ký</button>
        </form>
        
        <div class="back-to-login-section">
            <p>Bạn đã có tài khoản?</p>
            <a href="login.jsp" class="back-to-login-btn">
                ← Quay lại đăng nhập
            </a>
        </div>
    </div>

    <script>
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const eye = document.getElementById(fieldId + '-eye');
            
            if (field.type === 'password') {
                field.type = 'text';
                eye.textContent = '🙈';
            } else {
                field.type = 'password';
                eye.textContent = '👁';
            }
        }

        function validatePassword(password) {
            if (!password || password.trim() === '') {
                return 'Mật khẩu không được để trống!';
            }
            
            const minLength = 8;
            const hasUpperCase = /[A-Z]/.test(password);
            const hasLowerCase = /[a-z]/.test(password);
            const hasNumbers = /\d/.test(password);
            const hasSpecialChar = /[^a-zA-Z0-9]/.test(password);
            
            if (password.length < minLength) {
                return 'Mật khẩu phải có ít nhất 8 ký tự!';
            }
            if (!hasUpperCase) {
                return 'Mật khẩu phải chứa ít nhất 1 chữ hoa!';
            }
            if (!hasLowerCase) {
                return 'Mật khẩu phải chứa ít nhất 1 chữ thường!';
            }
            if (!hasNumbers) {
                return 'Mật khẩu phải chứa ít nhất 1 số!';
            }
            if (!hasSpecialChar) {
                return 'Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt!';
            }
            return '';
        }

        function validateEmail(email) {
            const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
            if (!emailRegex.test(email)) {
                return 'Email không hợp lệ! Vui lòng nhập đúng định dạng email.';
            }
            return '';
        }

        function validatePhone(phone) {
            if (phone.trim() === '') return '';
            
            const cleanPhone = phone.replaceAll(/[^0-9]/g, '');
            if (!cleanPhone.match(/^0[0-9]{9,10}$/)) {
                return 'Số điện thoại không hợp lệ! Vui lòng nhập số điện thoại Việt Nam (10-11 số, bắt đầu bằng 0).';
            }
            return '';
        }

        function showError(fieldId, message) {
            const errorElement = document.getElementById(fieldId + '-error');
            const formGroup = errorElement.closest('.form-group');
            
            if (message) {
                errorElement.textContent = message;
                errorElement.style.display = 'block';
                formGroup.classList.add('error');
                formGroup.classList.remove('success');
            } else {
                errorElement.style.display = 'none';
                formGroup.classList.remove('error');
                formGroup.classList.add('success');
            }
        }

        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            const error = validatePassword(password);
            showError('password', error);
        });

        document.getElementById('confirmPassword').addEventListener('input', function() {
            const confirmPassword = this.value;
            const password = document.getElementById('password').value;
            
            if (confirmPassword && password !== confirmPassword) {
                showError('confirmPassword', 'Mật khẩu xác nhận không khớp!');
            } else if (confirmPassword && password === confirmPassword) {
                showError('confirmPassword', '');
            }
        });

        document.getElementById('email').addEventListener('input', function() {
            const email = this.value;
            const error = validateEmail(email);
            showError('email', error);
        });

        document.getElementById('phoneNumber').addEventListener('input', function() {
            const phone = this.value;
            const error = validatePhone(phone);
            showError('phoneNumber', error);
        });

        document.querySelector('form').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const email = document.getElementById('email').value;
            const phone = document.getElementById('phoneNumber').value;
            
            let hasError = false;
            
            const passwordError = validatePassword(password);
            if (passwordError) {
                showError('password', passwordError);
                hasError = true;
            }
            
            if (password !== confirmPassword) {
                showError('confirmPassword', 'Mật khẩu xác nhận không khớp!');
                hasError = true;
            }
            
            const emailError = validateEmail(email);
            if (emailError) {
                showError('email', emailError);
                hasError = true;
            }
            
            const phoneError = validatePhone(phone);
            if (phoneError) {
                showError('phoneNumber', phoneError);
                hasError = true;
            }
            
            if (hasError) {
                e.preventDefault();
            }
        });
    </script>

    <div class="particle" style="left: 10%; animation-delay: 0s;"></div>
    <div class="particle" style="left: 20%; animation-delay: 2s;"></div>
    <div class="particle" style="left: 30%; animation-delay: 4s;"></div>
    <div class="particle" style="left: 40%; animation-delay: 6s;"></div>
    <div class="particle" style="left: 50%; animation-delay: 8s;"></div>
    <div class="particle" style="left: 60%; animation-delay: 10s;"></div>
    <div class="particle" style="left: 70%; animation-delay: 12s;"></div>
    <div class="particle" style="left: 80%; animation-delay: 14s;"></div>
    <div class="particle" style="left: 90%; animation-delay: 16s;"></div>
</body>
</html>