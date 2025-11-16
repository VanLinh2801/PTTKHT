<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - Garage Management</title>
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
            padding-bottom: 2rem;
            position: relative;
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
        
        .header {
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #ff9a9e 100%);
            color: white;
            padding: 1.5rem 0;
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
            max-width: 1200px;
            margin: 2.5rem auto;
            padding: 0 2rem;
        }
        
        .welcome-section {
            background: white;
            padding: 2.5rem;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            margin-bottom: 2.5rem;
            text-align: center;
            border-left: 5px solid #6c757d;
            animation: slideInDown 0.5s ease-out;
        }
        
        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .welcome-section h2 {
            color: #2d3748;
            margin-bottom: 0.75rem;
            font-size: 1.8rem;
            font-weight: 700;
        }
        
        .welcome-section p {
            color: #718096;
            font-size: 1.05rem;
            line-height: 1.7;
        }
        
        .role-info {
            background: linear-gradient(135deg, #e9ecef 0%, #dee2e6 100%);
            padding: 1.2rem 1.5rem;
            border-radius: 10px;
            margin-top: 1.5rem;
            display: inline-block;
            border-left: 4px solid #6c757d;
        }
        
        .role-info strong {
            color: #495057;
            font-weight: 700;
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 2rem;
            margin-bottom: 2.5rem;
        }
        
        .feature-card {
            background: white;
            padding: 2.5rem;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            text-align: center;
            transition: all 0.3s ease;
            border-top: 4px solid #6c757d;
            animation: fadeInUp 0.6s ease-out;
            animation-fill-mode: both;
        }
        
        .feature-card:nth-child(1) { animation-delay: 0.1s; }
        .feature-card:nth-child(2) { animation-delay: 0.2s; }
        .feature-card:nth-child(3) { animation-delay: 0.3s; }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .feature-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(108, 117, 125, 0.15);
        }
        
        .feature-icon {
            font-size: 3.5rem;
            margin-bottom: 1.5rem;
            display: inline-block;
        }
        
        .feature-card h3 {
            color: #2d3748;
            margin-bottom: 1rem;
            font-size: 1.4rem;
            font-weight: 700;
        }
        
        .feature-card p {
            color: #718096;
            margin-bottom: 1.75rem;
            line-height: 1.7;
            font-size: 0.95rem;
        }
        
        .feature-btn {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
            border: none;
            padding: 0.9rem 2rem;
            border-radius: 10px;
            text-decoration: none;
            display: inline-block;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: 0 10px 25px rgba(108, 117, 125, 0.2);
        }
        
        .feature-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 35px rgba(108, 117, 125, 0.3);
        }
        
        .quick-actions {
            background: white;
            padding: 2.5rem;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            border-left: 5px solid #495057;
        }
        
        .quick-actions h3 {
            color: #2d3748;
            margin-bottom: 2rem;
            text-align: center;
            font-size: 1.5rem;
            font-weight: 700;
        }
        
        .action-buttons {
            display: flex;
            gap: 1.5rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .action-btn {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            border: none;
            padding: 0.9rem 1.8rem;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 700;
            transition: all 0.3s ease;
            box-shadow: 0 10px 25px rgba(23, 162, 184, 0.2);
        }
        
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 35px rgba(23, 162, 184, 0.3);
        }
        
        .action-btn.secondary {
            background: #e2e8f0;
            color: #2d3748;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
        }
        
        .action-btn.secondary:hover {
            background: #cbd5e0;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.12);
        }
        
        .toast {
            position: fixed;
            top: 80px;
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
    <div id="toast" class="toast"></div>
    <% if (request.getParameter("success") != null && request.getParameter("success").equals("order_saved")) { %>
        <script>

            window.orderSuccessMessage = '✨ Đơn hàng đã được lưu thành công! ✨';
        </script>
    <% } %>
    <div class="header">
        <div class="header-content">
            <div class="logo">
                <h1>🏢 Garage Management</h1>
            </div>
            <div class="user-info">
                <span>Xin chào, <%= user.getFullName() %>!</span>
                <a href="user?action=logout" class="logout-btn">Đăng xuất</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="welcome-section">
            <h2>Chào mừng bạn đến với Garage Management!</h2>
            <p>Hệ thống quản lý garage chuyên nghiệp với đầy đủ tính năng hỗ trợ.</p>
            <div class="role-info">
                <strong>Vai trò:</strong> <%= user.getRole() %>
            </div>
        </div>
        
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">🏢</div>
                <h3>Quản lý hệ thống</h3>
                <p>Truy cập các tính năng quản lý dành cho quản trị viên và nhân viên.</p>
                <a href="#" class="feature-btn">Truy cập hệ thống</a>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">📊</div>
                <h3>Báo cáo & Thống kê</h3>
                <p>Xem các báo cáo chi tiết về hoạt động và hiệu suất của garage.</p>
                <a href="#" class="feature-btn">Xem báo cáo</a>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">⚙️</div>
                <h3>Cài đặt hệ thống</h3>
                <p>Cấu hình và quản lý các thiết lập của hệ thống garage.</p>
                <a href="#" class="feature-btn">Cài đặt</a>
            </div>
        </div>
        
        <div class="quick-actions">
            <h3>Thao tác nhanh</h3>
            <div class="action-buttons">
                <a href="#" class="action-btn">Quản lý người dùng</a>
                <a href="#" class="action-btn">Cài đặt dịch vụ</a>
                <a href="#" class="action-btn secondary">Lịch sử hoạt động</a>
                <a href="#" class="action-btn secondary">Hỗ trợ kỹ thuật</a>
            </div>
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

        window.addEventListener('load', function() {
            if (window.orderSuccessMessage) {
                showToast(window.orderSuccessMessage);
                window.orderSuccessMessage = null;
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
