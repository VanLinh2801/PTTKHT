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
    <title>Trang chủ nhân viên bán hàng - Garage Management</title>
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
            box-shadow: 0 8px 32px rgba(255, 154, 158, 0.3);
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
            font-weight: 700;
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
            background: rgba(255,255,255,0.2);
            color: white;
            border: 1px solid rgba(255,255,255,0.3);
            padding: 0.6rem 1.2rem;
            border-radius: 6px;
            text-decoration: none;
            transition: all 0.3s ease;
            font-weight: 500;
            font-size: 0.95rem;
        }
        
        .logout-btn:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0.8rem 1.5rem;
            position: relative;
            z-index: 1;
            height: calc(100vh - 70px);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            gap: 0.8rem;
        }
        
        .welcome-section {
            background: white;
            padding: 1rem;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            flex-shrink: 0;
        }
        
        .welcome-section h2 {
            color: #1a1a1a;
            margin-bottom: 0.4rem;
            font-size: 1.3rem;
            font-weight: 700;
        }
        
        .welcome-section p {
            color: #666;
            font-size: 0.9rem;
            font-weight: 400;
        }
        
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 0.8rem;
            flex-shrink: 0;
        }
        
        @media (max-width: 768px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }
        
        .dashboard-card {
            background: white;
            padding: 1rem;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            text-align: center;
            transition: all 0.3s ease;
            border-top: 4px solid #28a745;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        
        .dashboard-card:nth-child(2) {
            border-top-color: #007bff;
        }
        
        .dashboard-card:nth-child(3) {
            border-top-color: #ffc107;
        }
        
        .dashboard-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 32px rgba(0,0,0,0.15);
        }
        
        .card-icon {
            font-size: 2.5rem;
            margin-bottom: 0.6rem;
            display: inline-block;
        }
        
        .dashboard-card h3 {
            color: #1a1a1a;
            margin-bottom: 0.5rem;
            font-size: 1rem;
            font-weight: 700;
        }
        
        .dashboard-card p {
            color: #666;
            margin-bottom: 0.8rem;
            font-size: 0.85rem;
            line-height: 1.4;
            flex: 1;
        }
        
        .card-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border: none;
            padding: 0.6rem 1.2rem;
            border-radius: 8px;
            text-decoration: none;
            display: inline-block;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.2);
            font-size: 0.85rem;
        }
        
        .card-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.3);
        }
        
        .stats-section {
            background: white;
            padding: 1rem;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            flex-shrink: 0;
            overflow: hidden;
        }
        
        .stats-section h3 {
            color: #1a1a1a;
            margin-bottom: 0.8rem;
            text-align: center;
            font-size: 1.1rem;
            font-weight: 700;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 0.8rem;
        }
        
        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        .stat-item {
            text-align: center;
            padding: 0.9rem;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 8px;
            transition: all 0.3s ease;
            border-left: 4px solid #28a745;
        }
        
        .stat-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .stat-number {
            font-size: 1.6rem;
            font-weight: 700;
            color: #28a745;
            margin-bottom: 0.4rem;
        }
        
        .stat-label {
            color: #666;
            font-size: 0.8rem;
            font-weight: 500;
        }
        
        .quick-actions {
            background: white;
            padding: 1rem;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            flex-shrink: 0;
        }
        
        .quick-actions h3 {
            color: #1a1a1a;
            margin-bottom: 0.8rem;
            text-align: center;
            font-size: 1.1rem;
            font-weight: 700;
        }
        
        .action-buttons {
            display: flex;
            gap: 0.8rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .action-btn {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
            border: none;
            padding: 0.6rem 1.2rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0, 123, 255, 0.2);
            font-size: 0.85rem;
        }
        
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 123, 255, 0.3);
        }
        
        .action-btn.secondary {
            background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.2);
        }
        
        .action-btn.secondary:hover {
            box-shadow: 0 6px 20px rgba(108, 117, 125, 0.3);
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
                <h1>Garage Management - Sales Staff</h1>
            </div>
            <div class="user-info">
                <span>Xin chào, <%= user.getFullName() %>!</span>
                <a href="user?action=logout" class="logout-btn">Đăng xuất</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="welcome-section">
            <h2>Bảng điều khiển nhân viên bán hàng</h2>
            <p>Quản lý khách hàng, đơn hàng và dịch vụ một cách hiệu quả.</p>
        </div>
        
        <div class="dashboard-grid">
            <div class="dashboard-card">
                <div class="card-icon">🎯</div>
                <h3>Nhận yêu cầu khách hàng</h3>
                <p>Tìm kiếm khách hàng và nhận yêu cầu dịch vụ từ khách hàng.</p>
                <a href="search-customer.jsp" class="card-btn">Nhận yêu cầu</a>
            </div>
            
            <div class="dashboard-card">
                <div class="card-icon">👥</div>
                <h3>Quản lý khách hàng</h3>
                <p>Xem danh sách khách hàng, thông tin chi tiết và lịch sử dịch vụ.</p>
                <a href="#" class="card-btn">Quản lý khách hàng</a>
            </div>
            
            <div class="dashboard-card">
                <div class="card-icon">📋</div>
                <h3>Đơn hàng mới</h3>
                <p>Tạo và quản lý các đơn hàng dịch vụ cho khách hàng.</p>
                <a href="#" class="card-btn">Tạo đơn hàng</a>
            </div>
        </div>
        
        <div class="stats-section">
            <h3>Thống kê nhanh</h3>
            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-number">24</div>
                    <div class="stat-label">Khách hàng hôm nay</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">8</div>
                    <div class="stat-label">Đơn hàng chờ xử lý</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">₫2.5M</div>
                    <div class="stat-label">Doanh thu hôm nay</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">15</div>
                    <div class="stat-label">Dịch vụ hoàn thành</div>
                </div>
            </div>
        </div>
        
        <div class="quick-actions">
            <h3>Thao tác nhanh</h3>
            <div class="action-buttons">
                <a href="#" class="action-btn">Thêm khách hàng mới</a>
                <a href="#" class="action-btn">Tạo hóa đơn</a>
                <a href="#" class="action-btn secondary">Lịch hẹn hôm nay</a>
                <a href="#" class="action-btn secondary">Báo cáo chi tiết</a>
            </div>
        </div>
    </div>
    
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
