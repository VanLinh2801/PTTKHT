<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm khách hàng mới - Garage Management</title>
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
            line-height: 1.6;
            position: relative;
            overflow-x: hidden;
            overflow-y: hidden;
            height: 100vh;
            margin: 0;
            padding: 0;
        }

        body::before {
            content: '';
            position: fixed;
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(255, 182, 193, 0.3) 0%, rgba(255, 192, 203, 0.1) 100%);
            border-radius: 50%;
            top: -150px;
            right: -150px;
            animation: float 8s ease-in-out infinite, rotate 20s linear infinite;
            box-shadow: 0 0 50px rgba(255, 182, 193, 0.3);
            z-index: 0;
            pointer-events: none;
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

        .header {
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #ff9a9e 100%);
            color: white;
            padding: 0.6rem 0;
            box-shadow: 0 10px 30px rgba(255, 154, 158, 0.3);
            position: sticky;
            top: 0;
            z-index: 100;
            backdrop-filter: blur(10px);
        }
        
        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo h1 {
            font-size: 1.8rem;
            font-weight: 800;
            letter-spacing: -0.5px;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }
        
        .user-info span {
            font-size: 1rem;
            font-weight: 500;
        }
        
        .logout-btn {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 2px solid rgba(255, 255, 255, 0.3);
            padding: 0.6rem 1.2rem;
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s ease;
            font-weight: 600;
            font-size: 0.95rem;
        }
        
        .logout-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }
        
        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 0.5rem 1rem;
            position: relative;
            z-index: 1;
            height: calc(100vh - 70px);
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        
        .page-header {
            background: white;
            padding: 0.8rem;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            margin-bottom: 0.5rem;
            border-left: 5px solid #28a745;
            flex-shrink: 0;
        }
        
        .page-header h2 {
            color: #2d3748;
            margin-bottom: 0.4rem;
            font-size: 1.2rem;
            font-weight: 700;
        }
        
        .page-header p {
            color: #718096;
            font-size: 0.85rem;
        }
        
        .form-section {
            background: white;
            padding: 1.2rem;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            flex: 1;
            min-height: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        
        .form-section h3 {
            color: #2d3748;
            margin-bottom: 1rem;
            font-size: 1.1rem;
            font-weight: 700;
            border-bottom: 2px solid #28a745;
            padding-bottom: 0.6rem;
            flex-shrink: 0;
        }
        
        .form-content {
            flex: 1;
            min-height: 0;
            overflow-y: auto;
            padding-right: 0.5rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        
        .form-content::-webkit-scrollbar {
            width: 6px;
        }
        
        .form-content::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }
        
        .form-content::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 10px;
        }
        
        .form-content::-webkit-scrollbar-thumb:hover {
            background: #555;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.6rem;
            font-weight: 700;
            color: #2d3748;
            font-size: 0.95rem;
            letter-spacing: 0.3px;
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 0.9rem 1.2rem;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f7fafc;
            font-family: inherit;
        }
        
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #28a745;
            background: white;
            box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.1);
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 120px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.2rem;
        }
        
        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            margin-top: 1.5rem;
            padding-top: 1.2rem;
            border-top: 2px solid #e2e8f0;
            flex-shrink: 0;
        }
        
        .btn {
            padding: 0.8rem 1.8rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 700;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 0.95rem;
            letter-spacing: 0.3px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            box-shadow: 0 10px 25px rgba(40, 167, 69, 0.2);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 35px rgba(40, 167, 69, 0.3);
        }
        
        .btn-secondary {
            background: #e2e8f0;
            color: #2d3748;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
        }
        
        .btn-secondary:hover {
            background: #cbd5e0;
            transform: translateY(-2px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.12);
        }
        
        .alert {
            padding: 0.8rem;
            border-radius: 8px;
            margin-bottom: 0.8rem;
            flex-shrink: 0;
            font-size: 0.85rem;
        }
        
        .alert-success {
            background-color: #c6f6d5;
            border: 1px solid #9ae6b4;
            color: #22543d;
        }
        
        .alert-danger {
            background-color: #fed7d7;
            border: 1px solid #fc8181;
            color: #742a2a;
        }
        
        .required {
            color: #dc3545;
            font-weight: 700;
        }
        
        small {
            display: block;
            margin-top: 0.5rem;
            color: #718096;
            font-size: 0.8rem;
        }
        
        .password-container {
            position: relative;
            display: flex;
            align-items: center;
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
            padding: 0.5rem;
            border-radius: 5px;
            transition: all 0.3s ease;
        }
        
        .password-toggle:hover {
            background: rgba(0, 0, 0, 0.1);
        }
        
        .error-message {
            color: #e53e3e;
            font-size: 0.85rem;
            margin-top: 0.5rem;
            display: none;
        }
        
        .input-icon {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.1rem;
            z-index: 1;
        }
        
        .form-group input[type="password"],
        .form-group input[type="email"],
        .form-group input[type="tel"] {
            padding-left: 3rem;
        }
        
        .form-group input.error {
            border-color: #e53e3e;
            box-shadow: 0 0 0 3px rgba(229, 62, 62, 0.1);
        }
        
        .form-group input.success {
            border-color: #28a745;
            box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.1);
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <div class="logo">
                <h1>Thêm khách hàng mới</h1>
            </div>
            <div class="user-info">
                <span>Xin chào, <%= user.getFullName() %>!</span>
                <a href="user?action=logout" class="logout-btn">Đăng xuất</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="page-header">
            <h2>Thêm khách hàng mới</h2>
            <p>Nhập thông tin khách hàng để thêm vào hệ thống.</p>
        </div>
        
        <div class="form-section">
            <% if (message != null) { %>
                <div class="alert alert-success">
                    <%= message %>
                </div>
            <% } %>
            
            <% if (error != null) { %>
                <div class="alert alert-danger">
                    <%= error %>
                </div>
            <% } %>
            
            <h3>Thông tin khách hàng</h3>
            
            <div class="form-content">
            <form id="customerForm" action="customer" method="POST" style="display: flex; flex-direction: column; flex: 1;">
                <input type="hidden" name="action" value="add">
                <div style="flex: 1; display: flex; flex-direction: column; justify-content: space-around;">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="fullName">Họ và tên <span class="required">*</span></label>
                            <input type="text" id="fullName" name="fullName" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="phone">Số điện thoại <span class="required">*</span></label>
                            <div class="password-container">
                                <span class="input-icon">📞</span>
                                <input type="tel" id="phone" name="phone" required>
                            </div>
                            <div class="error-message" id="phone-error"></div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="email">Email</label>
                            <div class="password-container">
                                <span class="input-icon">💌</span>
                                <input type="email" id="email" name="email">
                            </div>
                            <div class="error-message" id="email-error"></div>
                        </div>
                        
                        <div class="form-group">
                            <label for="dateOfBirth">Ngày sinh</label>
                            <input type="date" id="dateOfBirth" name="dateOfBirth">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="account">Tài khoản <span class="required">*</span></label>
                            <input type="text" id="account" name="account" required>
                            <small>Có thể sử dụng số điện thoại làm tài khoản</small>
                        </div>
                        
                        <div class="form-group">
                            <label for="password">Mật khẩu <span class="required">*</span></label>
                            <div class="password-container">
                                <span class="input-icon">🔒</span>
                                <input type="password" id="password" name="password" required minlength="8">
                                <button type="button" class="password-toggle" onclick="togglePassword('password')">
                                    <span id="password-eye">👁</span>
                                </button>
                            </div>
                            <div class="error-message" id="password-error"></div>
                            <small>Mật khẩu tạm thời cho khách hàng</small>
                        </div>
                    </div>
                </div>
            </form>
            </div>
            
            <div class="form-actions">
                <a href="search-customer.jsp" class="btn btn-secondary">Hủy</a>
                <button type="submit" form="customerForm" class="btn btn-primary">Lưu khách hàng</button>
            </div>
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
            if (password.length < 8) {
                return "Mật khẩu phải có ít nhất 8 ký tự!";
            }
            if (!password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/)) {
                return "Mật khẩu phải chứa ít nhất 1 chữ hoa, 1 chữ thường, 1 số và 1 ký tự đặc biệt (@$!%*?&)!";
            }
            return null;
        }
        
        function validateEmail(email) {
            if (email && !email.match(/^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/)) {
                return "Email không hợp lệ!";
            }
            return null;
        }
        
        function validatePhone(phone) {
            const cleanPhone = phone.replace(/\D/g, '');
            if (cleanPhone.length < 10 || cleanPhone.length > 11) {
                return "Số điện thoại phải có 10-11 chữ số!";
            }
            if (!cleanPhone.startsWith('0')) {
                return "Số điện thoại phải bắt đầu bằng 0!";
            }
            return null;
        }
        
        function showError(fieldId, message) {
            const field = document.getElementById(fieldId);
            const errorDiv = document.getElementById(fieldId + '-error');
            
            field.classList.remove('success');
            field.classList.add('error');
            errorDiv.textContent = message;
            errorDiv.style.display = 'block';
        }
        
        function showSuccess(fieldId) {
            const field = document.getElementById(fieldId);
            const errorDiv = document.getElementById(fieldId + '-error');
            
            field.classList.remove('error');
            field.classList.add('success');
            errorDiv.style.display = 'none';
        }
        
        document.getElementById('password').addEventListener('input', function() {
            const error = validatePassword(this.value);
            if (error) {
                showError('password', error);
            } else {
                showSuccess('password');
            }
        });
        
        document.getElementById('email').addEventListener('input', function() {
            if (this.value) {
                const error = validateEmail(this.value);
                if (error) {
                    showError('email', error);
                } else {
                    showSuccess('email');
                }
            } else {
                showSuccess('email');
            }
        });
        
        document.getElementById('phone').addEventListener('input', function() {
            const error = validatePhone(this.value);
            if (error) {
                showError('phone', error);
            } else {
                showSuccess('phone');
            }
        });
        
        document.getElementById('customerForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const email = document.getElementById('email').value;
            const phone = document.getElementById('phone').value;
            
            let hasError = false;
            
            const passwordError = validatePassword(password);
            if (passwordError) {
                showError('password', passwordError);
                hasError = true;
            }
            
            if (email) {
                const emailError = validateEmail(email);
                if (emailError) {
                    showError('email', emailError);
                    hasError = true;
                }
            }
            
            const phoneError = validatePhone(phone);
            if (phoneError) {
                showError('phone', phoneError);
                hasError = true;
            }
            
            if (hasError) {
                e.preventDefault();
            }
        });
    </script>
</body>
</html>
