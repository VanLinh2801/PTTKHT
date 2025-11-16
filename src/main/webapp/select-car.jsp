<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<%@ page import="model.User" %>
<%@ page import="model.Car" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Car> vehicles = (List<Car>) request.getAttribute("vehicles");
    User customer = (User) request.getAttribute("customer");
    String customerId = request.getParameter("customerId");
    if (customerId == null || customerId.trim().isEmpty()) {
        response.sendRedirect("search-customer.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chọn xe - Garage Management</title>
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
            box-shadow: 0 2px 10px rgba(255, 154, 158, 0.3);
            backdrop-filter: blur(10px);
            position: relative;
            z-index: 100;
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
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .user-info span {
            font-size: 1.1rem;
        }
        
        .logout-btn {
            background: rgba(255,255,255,0.2);
            color: white;
            border: 1px solid rgba(255,255,255,0.3);
            padding: 0.5rem 1rem;
            border-radius: 5px;
            text-decoration: none;
            transition: background 0.3s ease;
        }
        
        .logout-btn:hover {
            background: rgba(255,255,255,0.3);
        }
        
        .container {
            max-width: 1200px;
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
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 0.5rem;
            flex-shrink: 0;
        }
        
        .page-header h2 {
            color: #333;
            margin-bottom: 0.4rem;
            font-size: 1.2rem;
        }
        
        .page-header p {
            color: #666;
            font-size: 0.9rem;
        }
        
        .customer-info {
            background: #f8f9fa;
            padding: 0.6rem;
            border-radius: 5px;
            margin-top: 0.6rem;
        }
        
        .customer-info h4 {
            color: #333;
            margin-bottom: 0.4rem;
            font-size: 0.9rem;
        }
        
        .customer-info p {
            font-size: 0.85rem;
            margin-bottom: 0.3rem;
        }
        
        .vehicles-section {
            background: white;
            padding: 0.8rem;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            flex: 1;
            min-height: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        
        .vehicles-section h3 {
            flex-shrink: 0;
        }
        
        .vehicles-section .action-buttons {
            flex-shrink: 0;
        }
        
        .vehicles-section h3 {
            color: #333;
            margin-bottom: 0.6rem;
            font-size: 1rem;
            flex-shrink: 0;
        }
        
        .action-buttons {
            display: flex;
            gap: 0.6rem;
            justify-content: flex-start;
            margin-bottom: 0.6rem;
            flex-wrap: wrap;
            flex-shrink: 0;
            position: relative;
            z-index: 20;
        }
        
        .btn {
            padding: 0.5rem 1rem;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 0.85rem;
            position: relative;
            z-index: 21;
        }
        
        .btn-primary {
            background: #007bff;
            color: white;
        }
        
        .btn-primary:hover {
            background: #0056b3;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .btn-success {
            background: #28a745;
            color: white;
        }
        
        .btn-success:hover {
            background: #218838;
        }
        
        .btn-warning {
            background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
            color: #212529;
            box-shadow: 0 4px 12px rgba(255, 193, 7, 0.2);
            pointer-events: auto !important;
        }
        
        .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 193, 7, 0.3);
        }
        
        .btn-warning:active {
            transform: translateY(0);
        }
        
        .table-container {
            overflow-x: auto;
            overflow-y: auto;
            flex: 1;
            min-height: 0;
            position: relative;
            z-index: 10;
            display: flex;
            flex-direction: column;
        }
        
        .table-container table {
            flex-shrink: 0;
        }

        .table-container::-webkit-scrollbar {
            width: 6px;
            height: 6px;
        }
        
        .table-container::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }
        
        .table-container::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 10px;
        }
        
        .table-container::-webkit-scrollbar-thumb:hover {
            background: #555;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th, td {
            padding: 0.6rem;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
            font-size: 0.85rem;
        }
        
        th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #333;
            font-size: 0.8rem;
            position: sticky;
            top: 0;
            z-index: 5;
        }
        
        tr:hover {
            background-color: #f8f9fa;
        }
        
        .no-vehicles {
            text-align: center;
            padding: 1rem;
            color: #666;
            font-style: italic;
            font-size: 0.85rem;
        }
        
        .vehicle-actions {
            display: flex;
            gap: 0.5rem;
        }
        
        .btn-sm {
            padding: 0.4rem 0.8rem;
            font-size: 0.8rem;
        }
        
        .vehicle-card {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 5px;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        
        .vehicle-card h4 {
            color: #333;
            margin-bottom: 0.5rem;
        }
        
        .vehicle-card p {
            color: #666;
            margin-bottom: 0.25rem;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
        }
        
        .modal-content {
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #ff9a9e 100%);
            margin: 10% auto;
            padding: 2rem;
            border-radius: 20px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 20px 60px rgba(255, 154, 158, 0.3);
            animation: modalSlideIn 0.3s ease-out;
            position: relative;
            overflow: hidden;
        }
        
        .modal-content::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
            animation: shimmer 2s infinite;
        }
        
        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(-50px) scale(0.9);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }
        
        @keyframes shimmer {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .modal-header {
            text-align: center;
            margin-bottom: 1.5rem;
            position: relative;
            z-index: 1;
        }
        
        .modal-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            animation: bounce 1s infinite;
        }
        
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-10px); }
            60% { transform: translateY(-5px); }
        }
        
        .modal-title {
            color: white;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }
        
        .modal-message {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1rem;
            line-height: 1.5;
            margin-bottom: 0;
        }
        
        .modal-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
            position: relative;
            z-index: 1;
        }
        
        .modal-btn {
            padding: 0.8rem 2rem;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 1rem;
            min-width: 120px;
        }
        
        .modal-btn-confirm {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }
        
        .modal-btn-confirm:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
        }
        
        .modal-btn-cancel {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 2px solid rgba(255, 255, 255, 0.3);
        }
        
        .modal-btn-cancel:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <div class="logo">
                <h1>Chọn xe</h1>
            </div>
            <div class="user-info">
                <span>Xin chào, <%= user.getFullName() %>!</span>
                <a href="user?action=logout" class="logout-btn">Đăng xuất</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="page-header">
            <h2>Chọn xe của khách hàng</h2>
            <p>Chọn xe để nhận yêu cầu dịch vụ.</p>
            
            <% if (customer != null) { %>
                <div class="customer-info">
                    <h4>Thông tin khách hàng</h4>
                    <p><strong>Họ tên:</strong> <%= customer.getFullName() %></p>
                    <p><strong>Số điện thoại:</strong> <%= customer.getPhone() %></p>
                    <p><strong>Email:</strong> <%= customer.getEmail() %></p>
                </div>
            <% } %>
        </div>
        
        <div class="vehicles-section">
            <div class="action-buttons">
                <a href="search-customer.jsp" class="btn btn-secondary">Quay lại</a>
                <a href="vehicle?action=add&customerId=<%= customerId %>" class="btn btn-success">Thêm xe mới</a>
                <button type="button" class="btn btn-warning" id="proceedWithoutCarBtn">
                    Tiếp tục không chọn xe
                </button>
            </div>
            
            <h3>Danh sách xe</h3>
            
            <% if (vehicles != null && !vehicles.isEmpty()) { %>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Biển số</th>
                                <th>Hãng</th>
                                <th>Model</th>
                                <th>Năm sản xuất</th>
                                <th>Số km</th>
                                <th>Mô tả</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Car vehicle : vehicles) { %>
                                <tr>
                                    <td><strong><%= vehicle.getLicensePlate() %></strong></td>
                                    <td><%= vehicle.getBrand() %></td>
                                    <td><%= vehicle.getModel() != null ? vehicle.getModel() : "" %></td>
                                    <td><%= vehicle.getYearOfManufacture() != null ? vehicle.getYearOfManufacture().toString() : "" %></td>
                                    <td><%= vehicle.getMileage() != null ? vehicle.getMileage().toString() + " km" : "" %></td>
                                    <td><%= vehicle.getDescription() != null ? vehicle.getDescription() : "" %></td>
                                    <td class="vehicle-actions">
                                        <a href="service?customerId=<%= customerId %>&vehicleId=<%= vehicle.getId() %>" 
                                           class="btn btn-primary btn-sm">Nhận yêu cầu</a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="no-vehicles">
                    <p>Khách hàng chưa có xe nào trong hệ thống</p>
                    <p>Vui lòng <a href="vehicle?action=add&customerId=<%= customerId %>">thêm xe mới</a> cho khách hàng</p>
                </div>
            <% } %>
        </div>
    </div>

    <div id="noCarModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-icon">🚗❌</div>
                <h3 class="modal-title">Xác nhận tiếp tục không chọn xe</h3>
                <p class="modal-message">
                    Bạn có chắc chắn muốn tiếp tục mà không chọn xe?<br>
                    Điều này có nghĩa là khách hàng chỉ mua phụ tùng mà không sử dụng dịch vụ.
                </p>
            </div>
            <div class="modal-actions">
                <button type="button" class="modal-btn modal-btn-confirm">
                    ✅ Xác nhận
                </button>
                <button type="button" class="modal-btn modal-btn-cancel">
                    ❌ Hủy
                </button>
            </div>
        </div>
    </div>

    <script>

        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded');

            const proceedBtn = document.getElementById('proceedWithoutCarBtn');
            const modal = document.getElementById('noCarModal');
            const confirmBtn = document.querySelector('.modal-btn-confirm');
            const cancelBtn = document.querySelector('.modal-btn-cancel');
            
            console.log('Button:', proceedBtn);
            console.log('Modal:', modal);

            if (!proceedBtn) {
                console.error('Proceed button not found!');
                return;
            }
            
            if (!modal) {
                console.error('Modal not found!');
                return;
            }

            proceedBtn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                console.log('Button clicked!');
                modal.style.display = 'block';
            });

            if (confirmBtn) {
                confirmBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    const urlParams = new URLSearchParams(window.location.search);
                    const customerId = urlParams.get('customerId');
                    
                    if (!customerId) {
                        alert('Thiếu thông tin khách hàng!');
                        return;
                    }
                    
                    localStorage.setItem('noCarSelected', 'true');
                    localStorage.setItem('selectedCustomerId', customerId);
                    
                    window.location.href = `service?customerId=${customerId}&noCar=true`;
                });
            }

            if (cancelBtn) {
                cancelBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    modal.style.display = 'none';
                });
            }

            window.addEventListener('click', function(event) {
                if (event.target === modal) {
                    modal.style.display = 'none';
                }
            });
        });

        window.addEventListener('DOMContentLoaded', function() {
            const tableContainer = document.querySelector('.table-container');
            const tbody = tableContainer?.querySelector('tbody');
            const vehiclesSection = document.querySelector('.vehicles-section');
            
            if (tableContainer && tbody && vehiclesSection) {
                const rows = tbody.querySelectorAll('tr');
                const rowCount = rows.length;
                
                if (rowCount > 0) {

                    const firstRow = rows[0];
                    const rowHeight = firstRow.offsetHeight;

                    const thead = tableContainer.querySelector('thead');
                    const headerHeight = thead ? thead.offsetHeight : 0;

                    const vehiclesSectionHeight = vehiclesSection.offsetHeight;
                    const h3Height = vehiclesSection.querySelector('h3')?.offsetHeight || 0;
                    const actionButtonsHeight = vehiclesSection.querySelector('.action-buttons')?.offsetHeight || 0;

                    const marginSpacing = 19.2;
                    const availableHeight = vehiclesSectionHeight - h3Height - actionButtonsHeight - marginSpacing;

                    const maxVisibleRows = Math.floor((availableHeight - headerHeight) / rowHeight);
                    const displayRows = Math.min(maxVisibleRows, 4);
                    
                    if (rowCount <= displayRows) {

                        tableContainer.style.maxHeight = (headerHeight + rowCount * rowHeight) + 'px';
                        tableContainer.style.overflowY = 'hidden';
                    } else {

                        tableContainer.style.maxHeight = (headerHeight + displayRows * rowHeight) + 'px';
                        tableContainer.style.overflowY = 'auto';
                    }
                } else {

                    tableContainer.style.overflowY = 'hidden';
                }
            }
        });
    </script>
    
</body>
</html>
