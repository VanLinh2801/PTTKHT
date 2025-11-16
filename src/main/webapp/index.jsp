<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user != null) {
        String redirectUrl = "home.jsp";
        if ("CUSTOMER".equals(user.getRole())) {
            redirectUrl = "customer-home.jsp";
        } else if ("SALES_STAFF".equals(user.getRole())) {
            redirectUrl = "sales-staff-home.jsp";
        }
        response.sendRedirect(redirectUrl);
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Garage Management System</title>
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
            padding-bottom: 2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
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
        
        .welcome-container {
            background: rgba(255, 255, 255, 0.95);
            padding: 4rem;
            border-radius: 25px;
            box-shadow: 0 30px 60px rgba(255, 182, 193, 0.3);
            text-align: center;
            max-width: 700px;
            width: 100%;
            animation: fadeInScale 0.7s ease-out;
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 182, 193, 0.3);
            position: relative;
            z-index: 1;
        }
        
        @keyframes fadeInScale {
            from {
                opacity: 0;
                transform: scale(0.95);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }
        
        .logo {
            margin-bottom: 2.5rem;
        }
        
        .logo h1 {
            font-size: 3.5rem;
            color: #2d3748;
            margin-bottom: 0.75rem;
            font-weight: 800;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .logo p {
            color: #718096;
            font-size: 1.2rem;
            font-weight: 500;
        }
        
        .description {
            margin-bottom: 3.5rem;
        }
        
        .description h2 {
            color: #2d3748;
            margin-bottom: 1.2rem;
            font-size: 2rem;
            font-weight: 700;
        }
        
        .description p {
            color: #718096;
            font-size: 1.1rem;
            line-height: 1.8;
        }
        
        .action-buttons {
            display: flex;
            gap: 1.5rem;
            justify-content: center;
            flex-wrap: wrap;
            margin-bottom: 3rem;
        }
        
        .btn {
            padding: 1.1rem 2.5rem;
            border: none;
            border-radius: 12px;
            font-size: 1.05rem;
            font-weight: 700;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            cursor: pointer;
            letter-spacing: 0.5px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #ff9a9e 100%);
            color: white;
            box-shadow: 0 15px 35px rgba(255, 154, 158, 0.4);
            position: relative;
            overflow: hidden;
        }
        
        .btn-primary::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.6s;
        }
        
        .btn-primary:hover::before {
            left: 100%;
        }
        
        .btn-primary:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 20px 45px rgba(255, 154, 158, 0.5);
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 30%, #ff9a9e 100%);
        }
        
        .btn-secondary {
            background: #e2e8f0;
            color: #2d3748;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }
        
        .btn-secondary:hover {
            background: #cbd5e0;
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        }
        
        .features {
            margin-top: 3rem;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 2rem;
            padding-top: 2rem;
            border-top: 2px solid #e2e8f0;
        }
        
        .feature {
            text-align: center;
            animation: fadeInUp 0.6s ease-out;
            animation-fill-mode: both;
        }
        
        .feature:nth-child(1) { animation-delay: 0.1s; }
        .feature:nth-child(2) { animation-delay: 0.2s; }
        .feature:nth-child(3) { animation-delay: 0.3s; }
        .feature:nth-child(4) { animation-delay: 0.4s; }
        
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
        
        .feature-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            display: inline-block;
            animation: bounce 2s ease-in-out infinite;
        }
        
        .feature:nth-child(1) .feature-icon { animation-delay: 0s; }
        .feature:nth-child(2) .feature-icon { animation-delay: 0.2s; }
        .feature:nth-child(3) .feature-icon { animation-delay: 0.4s; }
        .feature:nth-child(4) .feature-icon { animation-delay: 0.6s; }
        
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        
        .feature h3 {
            color: #2d3748;
            margin-bottom: 0.75rem;
            font-size: 1.15rem;
            font-weight: 700;
        }
        
        .feature p {
            color: #718096;
            font-size: 0.95rem;
            line-height: 1.6;
        }
        
        @media (max-width: 768px) {
            .welcome-container {
                padding: 2.5rem;
            }
            
            .logo h1 {
                font-size: 2.5rem;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn {
                width: 100%;
                max-width: 300px;
            }
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <div class="logo">
            <h1>🏢 Garage Management</h1>
            <p>Hệ thống quản lý garage chuyên nghiệp</p>
        </div>
        
        <div class="description">
            <h2>Chào mừng bạn đến với Garage Management!</h2>
            <p>Chúng tôi cung cấp giải pháp quản lý garage toàn diện với các tính năng hiện đại, giúp bạn quản lý khách hàng, dịch vụ và doanh thu một cách hiệu quả.</p>
        </div>
        
        <div class="action-buttons">
            <a href="login.jsp" class="btn btn-primary">Đăng nhập</a>
            <a href="register.jsp" class="btn btn-secondary">Đăng ký</a>
        </div>
        
        <div class="features">
            <div class="feature">
                <div class="feature-icon">👥</div>
                <h3>Quản lý khách hàng</h3>
                <p>Theo dõi thông tin khách hàng và lịch sử dịch vụ</p>
            </div>
            
            <div class="feature">
                <div class="feature-icon">🔧</div>
                <h3>Dịch vụ sửa chữa</h3>
                <p>Quản lý các dịch vụ sửa chữa và bảo dưỡng xe</p>
            </div>
            
            <div class="feature">
                <div class="feature-icon">💰</div>
                <h3>Quản lý tài chính</h3>
                <p>Theo dõi doanh thu và chi phí hoạt động</p>
            </div>
            
            <div class="feature">
                <div class="feature-icon">📊</div>
                <h3>Báo cáo thống kê</h3>
                <p>Báo cáo chi tiết về hoạt động kinh doanh</p>
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
</body>
</html>
