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
    <title>Trang chủ khách hàng - Garage Management</title>
    <style>
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 0.8rem 1.5rem;
            height: calc(100vh - 70px);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            position: relative;
            z-index: 1;
            gap: 1rem;
        }
        
        .welcome-section {
            background: white;
            padding: 1.2rem;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #667eea;
            animation: slideInDown 0.5s ease-out;
            flex-shrink: 0;
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
            margin-bottom: 0.5rem;
            font-size: 1.4rem;
            font-weight: 700;
        }
        
        .welcome-section p {
            color: #718096;
            font-size: 0.95rem;
            line-height: 1.5;
        }
        
        .services-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
            flex: 1;
            min-height: 0;
            overflow: hidden;
        }
        
        @media (max-width: 768px) {
            .services-grid {
                grid-template-columns: 1fr;
            }
        }
        
        .service-card {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
            text-align: center;
            transition: all 0.3s ease;
            border-top: 4px solid #667eea;
            animation: fadeInUp 0.6s ease-out;
            animation-fill-mode: both;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        
        .service-card:nth-child(1) { animation-delay: 0.1s; }
        .service-card:nth-child(2) { animation-delay: 0.2s; }
        .service-card:nth-child(3) { animation-delay: 0.3s; }
        
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
        
        .service-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 32px rgba(102, 126, 234, 0.15);
        }
        
        .service-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            display: inline-block;
        }
        
        .service-card h3 {
            color: #2d3748;
            margin-bottom: 0.6rem;
            font-size: 1.2rem;
            font-weight: 700;
        }
        
        .service-card p {
            color: #718096;
            margin-bottom: 1rem;
            line-height: 1.5;
            font-size: 0.9rem;
            flex: 1;
        }
        
        .service-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            text-decoration: none;
            display: inline-block;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
            font-size: 0.9rem;
        }
        
        .service-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.3);
        }
        
        .quick-actions {
            background: white;
            padding: 1.2rem;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
            border-left: 4px solid #764ba2;
            flex-shrink: 0;
        }
        
        .quick-actions h3 {
            color: #2d3748;
            margin-bottom: 1rem;
            text-align: center;
            font-size: 1.2rem;
            font-weight: 700;
        }
        
        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .action-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
            font-size: 0.9rem;
        }
        
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.3);
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
    </style>
</head>
<body>
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
            <p>Chúng tôi cung cấp các dịch vụ sửa chữa và bảo dưỡng xe chuyên nghiệp với đội ngũ kỹ thuật viên giàu kinh nghiệm.</p>
        </div>
        
        <div class="services-grid">
            <div class="service-card">
                <div class="service-icon">🔧</div>
                <h3>Sửa chữa xe</h3>
                <p>Dịch vụ sửa chữa xe chuyên nghiệp với trang thiết bị hiện đại và đội ngũ kỹ thuật viên giàu kinh nghiệm.</p>
                <a href="appointment?action=select" class="service-btn">Đặt lịch sửa chữa</a>
            </div>
            
            <div class="service-card">
                <div class="service-icon">🛠️</div>
                <h3>Bảo dưỡng định kỳ</h3>
                <p>Bảo dưỡng xe định kỳ để đảm bảo xe luôn hoạt động tốt và an toàn trên đường.</p>
                <a href="appointment?action=select" class="service-btn">Đặt lịch bảo dưỡng</a>
            </div>
            
            <div class="service-card">
                <div class="service-icon">🔍</div>
                <h3>Kiểm tra xe</h3>
                <p>Kiểm tra tổng thể xe để phát hiện sớm các vấn đề và đưa ra giải pháp tối ưu.</p>
                <a href="appointment?action=select" class="service-btn">Đặt lịch kiểm tra</a>
            </div>
        </div>
        
        <div class="quick-actions">
            <h3>Thao tác nhanh</h3>
            <div class="action-buttons">
                <a href="#" class="action-btn">Xem lịch hẹn</a>
                <a href="#" class="action-btn">Lịch sử dịch vụ</a>
                <a href="#" class="action-btn secondary">Thông tin xe</a>
                <a href="#" class="action-btn secondary">Liên hệ hỗ trợ</a>
            </div>
        </div>
    </div>
    
</body>
</html>
