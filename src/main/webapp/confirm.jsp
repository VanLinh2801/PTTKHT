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
    
    String customerId = request.getParameter("customerId");
    String vehicleId = request.getParameter("vehicleId");
    String noCar = request.getParameter("noCar");
    boolean isNoCarMode = "true".equals(noCar);
    
    if (customerId == null || customerId.trim().isEmpty()) {
        response.sendRedirect("search-customer.jsp");
        return;
    }
    
    if (!isNoCarMode && (vehicleId == null || vehicleId.trim().isEmpty())) {
        response.sendRedirect("search-customer.jsp");
        return;
    }
    
    User customer = (User) request.getAttribute("customer");
    Car vehicle = (Car) request.getAttribute("vehicle");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận thông tin - Garage Management</title>
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
            box-shadow: 0 5px 15px rgba(255, 154, 158, 0.3);
            position: sticky;
            top: 0;
            z-index: 100;
            backdrop-filter: blur(10px);
        }
        
        .header-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo h1 {
            font-size: 1.4rem;
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
            padding: 0.5rem 1rem;
            height: calc(100vh - 70px);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            position: relative;
            z-index: 1;
        }
        
        .main-content {
            background: rgba(255, 255, 255, 0.95);
            padding: 1rem;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(255, 182, 193, 0.2);
            border-left: 4px solid #ff9a9e;
            animation: slideInDown 0.5s ease-out;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 182, 193, 0.3);
            flex: 1;
            min-height: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
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
        
        .page-header {
            text-align: center;
            margin-bottom: 0.8rem;
            padding-bottom: 0.6rem;
            border-bottom: 2px solid #e2e8f0;
            flex-shrink: 0;
        }
        
        .page-header h2 {
            color: #2d3748;
            margin-bottom: 0.3rem;
            font-size: 1.2rem;
            font-weight: 700;
        }
        
        .page-header p {
            color: #718096;
            font-size: 0.85rem;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.8rem;
            margin-bottom: 0.8rem;
            flex-shrink: 0;
        }
        
        @media (max-width: 768px) {
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
        
        .info-section {
            background: #f8f9fa;
            padding: 0.7rem;
            border-radius: 8px;
            border-left: 3px solid #ff9a9e;
            animation: fadeInUp 0.6s ease-out;
            animation-fill-mode: both;
        }
        
        .info-section:nth-child(1) { animation-delay: 0.1s; }
        .info-section:nth-child(2) { animation-delay: 0.2s; }
        .info-section:nth-child(3) { animation-delay: 0.3s; }
        
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
        
        .info-section h3 {
            color: #2d3748;
            margin-bottom: 0.5rem;
            border-bottom: 2px solid #28a745;
            padding-bottom: 0.25rem;
            font-size: 0.85rem;
            font-weight: 700;
        }
        
        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 0.25rem 0;
            border-bottom: 1px solid #e2e8f0;
            font-size: 0.8rem;
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #2d3748;
        }
        
        .info-value {
            color: #718096;
        }
        
        .selected-items {
            background: #f8f9fa;
            padding: 0.8rem;
            border-radius: 10px;
            margin-bottom: 0.8rem;
            border-left: 3px solid #28a745;
            animation: fadeInUp 0.6s ease-out 0.5s both;
            flex: 1;
            min-height: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        
        .selected-items h3 {
            color: #2d3748;
            margin-bottom: 0.5rem;
            border-bottom: 2px solid #28a745;
            padding-bottom: 0.25rem;
            font-size: 0.9rem;
            font-weight: 700;
            flex-shrink: 0;
        }
        
        .selected-items-content {
            flex: 1;
            min-height: 0;
            overflow-y: auto;
            padding-right: 0.5rem;
        }
        
        .selected-items-content::-webkit-scrollbar {
            width: 6px;
        }
        
        .selected-items-content::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }
        
        .selected-items-content::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 10px;
        }
        
        .selected-items-content::-webkit-scrollbar-thumb:hover {
            background: #555;
        }
        
        .selected-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem;
            border-bottom: 1px solid #e2e8f0;
            background: #f7fafc;
            margin-bottom: 0.35rem;
            border-radius: 6px;
        }
        
        .selected-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }
        
        .selected-item-info {
            display: flex;
            flex-direction: column;
            gap: 0.2rem;
        }
        
        .selected-item-name {
            font-weight: 700;
            color: #2d3748;
            font-size: 0.9rem;
        }
        
        .selected-item-details {
            font-size: 0.8rem;
            color: #718096;
        }
        
        .selected-item-price {
            font-weight: 700;
            color: #28a745;
            font-size: 0.95rem;
        }
        
        .total-amount {
            font-size: 1rem;
            font-weight: 800;
            color: #28a745;
            margin-top: 0.6rem;
            padding-top: 0.6rem;
            border-top: 2px solid #28a745;
            flex-shrink: 0;
        }
        
        .action-buttons {
            display: flex;
            gap: 0.8rem;
            justify-content: center;
            margin-top: 0.8rem;
            flex-shrink: 0;
        }
        
        .btn {
            padding: 0.6rem 1.5rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 700;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 0.85rem;
            letter-spacing: 0.3px;
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
        
        .btn-success {
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #ff9a9e 100%);
            color: white;
            box-shadow: 0 15px 35px rgba(255, 154, 158, 0.4);
            position: relative;
            overflow: hidden;
        }
        
        .btn-success::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.6s;
        }
        
        .btn-success:hover::before {
            left: 100%;
        }
        
        .btn-success:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 20px 40px rgba(255, 154, 158, 0.5);
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 30%, #ff9a9e 100%);
        }
        
        .technician-list {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
            margin-top: 1rem;
        }
        
        .technician-tag {
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 50%, #ff9a9e 100%);
            color: white;
            padding: 0.6rem 1.2rem;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            box-shadow: 0 8px 20px rgba(255, 154, 158, 0.3);
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <div class="logo">
                <h1>Xác nhận thông tin</h1>
            </div>
            <div class="user-info">
                <span>Xin chào, <%= user.getFullName() %>!</span>
                <a href="user?action=logout" class="logout-btn">Đăng xuất</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="main-content">
            <div class="page-header">
                <h2>Xác nhận thông tin đơn hàng</h2>
                <p>Vui lòng kiểm tra lại thông tin trước khi lưu đơn hàng.</p>
            </div>
            
            <div class="info-grid">
                <div class="info-section">
                    <h3>👤 Thông tin khách hàng</h3>
                    <% if (customer != null) { %>
                        <div class="info-item">
                            <span class="info-label">Họ tên:</span>
                            <span class="info-value"><%= customer.getFullName() %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Số điện thoại:</span>
                            <span class="info-value"><%= customer.getPhone() != null ? customer.getPhone() : "N/A" %></span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Email:</span>
                            <span class="info-value"><%= customer.getEmail() != null ? customer.getEmail() : "N/A" %></span>
                        </div>
                    <% } else { %>
                        <div class="info-item">
                            <span class="info-label">Khách hàng:</span>
                            <span class="info-value">Không có thông tin</span>
                        </div>
                    <% } %>
                </div>
                
                <% if (!isNoCarMode) { %>
                <div class="info-section">
                    <h3>🚗 Thông tin xe</h3>
                    <% if (vehicle != null) { %>
                        <div class="info-item">
                            <span class="info-label">Biển số:</span>
                            <span class="info-value"><%= vehicle.getLicensePlate() %></span>
                        </div>
                        <% if (vehicle.getBrand() != null && !vehicle.getBrand().trim().isEmpty()) { %>
                        <div class="info-item">
                            <span class="info-label">Hãng xe:</span>
                            <span class="info-value"><%= vehicle.getBrand() %></span>
                        </div>
                        <% } %>
                        <% if (vehicle.getModel() != null && !vehicle.getModel().trim().isEmpty()) { %>
                        <div class="info-item">
                            <span class="info-label">Dòng xe:</span>
                            <span class="info-value"><%= vehicle.getModel() %></span>
                        </div>
                        <% } %>
                    <% } else { %>
                        <div class="info-item">
                            <span class="info-label">Xe:</span>
                            <span class="info-value">Không có thông tin</span>
                        </div>
                    <% } %>
                </div>
                <% } else { %>
                <div class="info-section">
                    <h3>📦 Thông tin đơn hàng</h3>
                    <div class="info-item">
                        <span class="info-label">Loại đơn hàng:</span>
                        <span class="info-value">Chỉ mua phụ tùng</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Dịch vụ:</span>
                        <span class="info-value" id="serviceCount">0</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Phụ tùng:</span>
                        <span class="info-value" id="partCount">0</span>
                    </div>
                </div>
                <% } %>
            </div>
            
            <div class="selected-items">
                <h3>📋 Dịch vụ và phụ tùng đã chọn</h3>
                <div class="selected-items-content">
                    <div id="selectedServices">
                        <p style="color: #718096; font-style: italic;">Đang tải...</p>
                    </div>
                    <div id="selectedSpareParts">
                        <p style="color: #718096; font-style: italic;">Đang tải...</p>
                    </div>
                </div>
                <div id="totalAmount" class="total-amount">Tổng cộng: ₫0</div>
            </div>
            
            <div class="action-buttons">
                <a href="#" onclick="goBackToAssignTechnician(); return false;" class="btn btn-secondary">Quay lại</a>
                <button type="button" class="btn btn-success" onclick="saveOrder()" id="saveBtn">
                    💾 Lưu đơn hàng
                </button>
            </div>
        </div>
    </div>

    <script>
        let selectedServices = [];
        let selectedSpareParts = [];
        let selectedTechnicians = [];
        let serviceTechnicianAssignments = [];
        
        window.addEventListener('load', function() {
            console.log('Window loaded, loading data...');

            loadFromLocalStorage();

            const urlParams = new URLSearchParams(window.location.search);
            const noCar = urlParams.get('noCar');
            const isNoCarMode = noCar === 'true';
            const lastServiceIds = localStorage.getItem('lastServiceIds');

            if (!isNoCarMode && (!lastServiceIds || lastServiceIds.trim() === '')) {
                console.log('No services selected, clearing selectedServices from localStorage');
                selectedServices = [];
                localStorage.setItem('selectedServices', '[]');
            }
            
            renderAllData();
        });
        
        function loadFromLocalStorage() {
            selectedServices = JSON.parse(localStorage.getItem('selectedServices') || '[]');
            selectedSpareParts = JSON.parse(localStorage.getItem('selectedSpareParts') || '[]');
            selectedTechnicians = JSON.parse(localStorage.getItem('selectedTechnicians') || '[]');
            serviceTechnicianAssignments = JSON.parse(localStorage.getItem('serviceTechnicianAssignments') || '[]');
            console.log('Loaded from localStorage:', { selectedServices, selectedSpareParts, selectedTechnicians, serviceTechnicianAssignments });
        }
        
        function renderAllData() {
            renderSelectedServices();
            renderSelectedSpareParts();
            updateTotalAmount();
        }
        
        function renderSelectedServices() {
            const container = document.getElementById('selectedServices');
            container.innerHTML = '';
            
            if (selectedServices.length === 0) {
                container.innerHTML = '<p style="color: #718096; font-style: italic;">Không có dịch vụ nào được chọn</p>';
                return;
            }
            
            selectedServices.forEach(service => {
                const div = document.createElement('div');
                div.className = 'selected-item';
                const serviceName = service.name || 'Unknown Service';
                const servicePrice = service.price || 0;

                const assignment = serviceTechnicianAssignments.find(a => a.serviceId == service.id);
                const technicianInfo = assignment ? `👨‍🔧 ${assignment.technicianName}` : 'Chưa phân công kỹ thuật viên';
                
                div.innerHTML = `
                    <div class="selected-item-info">
                        <div class="selected-item-name">🔧 ${serviceName}</div>
                        <div class="selected-item-details">Dịch vụ - ${technicianInfo}</div>
                    </div>
                    <div class="selected-item-price">₫${servicePrice.toLocaleString()}</div>
                `;
                container.appendChild(div);
            });
        }
        
        function renderSelectedSpareParts() {
            const container = document.getElementById('selectedSpareParts');
            container.innerHTML = '';
            
            if (selectedSpareParts.length === 0) {
                container.innerHTML = '<p style="color: #718096; font-style: italic;">Không có phụ tùng nào được chọn</p>';
                return;
            }
            
            selectedSpareParts.forEach(part => {
                const div = document.createElement('div');
                div.className = 'selected-item';
                const partName = part.name || 'Unknown Spare Part';
                const partPrice = part.price || 0;
                const partQuantity = part.quantity || 1;
                const totalPrice = partPrice * partQuantity;
                div.innerHTML = `
                    <div class="selected-item-info">
                        <div class="selected-item-name">🔩 ${partName}</div>
                        <div class="selected-item-details">Phụ tùng (x${partQuantity})</div>
                    </div>
                    <div class="selected-item-price">₫${totalPrice.toLocaleString()}</div>
                `;
                container.appendChild(div);
            });
        }

        function updateTotalAmount() {
            const totalServices = selectedServices.reduce((sum, service) => sum + (service.price || 0), 0);
            const totalSpareParts = selectedSpareParts.reduce((sum, part) => sum + ((part.price || 0) * (part.quantity || 1)), 0);
            const total = totalServices + totalSpareParts;
            
            const totalElement = document.getElementById('totalAmount');
            totalElement.textContent = `Tổng cộng: ₫${total.toLocaleString()}`;

            const serviceCountElement = document.getElementById('serviceCount');
            const partCountElement = document.getElementById('partCount');
            if (serviceCountElement) {
                serviceCountElement.textContent = selectedServices.length;
            }
            if (partCountElement) {
                partCountElement.textContent = selectedSpareParts.length;
            }
        }
        
        function saveOrder() {
            if (selectedServices.length === 0 && selectedSpareParts.length === 0) {
                alert('Vui lòng chọn ít nhất một dịch vụ hoặc phụ tùng!');
                return;
            }
            
            const urlParams = new URLSearchParams(window.location.search);
            const customerId = urlParams.get('customerId');
            const vehicleId = urlParams.get('vehicleId');
            const noCar = urlParams.get('noCar');
            const isNoCarMode = noCar === 'true';
            
            if (!customerId) {
                alert('Thiếu thông tin khách hàng!');
                return;
            }
            
            if (!isNoCarMode) {
                if (!vehicleId) {
                    alert('Thiếu thông tin xe!');
                    return;
                }

                if (selectedServices.length > 0) {

                    const assignedServiceIds = serviceTechnicianAssignments.map(a => String(a.serviceId));
                    const serviceIds = selectedServices.map(s => String(s.id));
                    const unassignedServices = serviceIds.filter(id => !assignedServiceIds.includes(id));
                    
                    if (unassignedServices.length > 0) {
                        alert(`Vui lòng phân công kỹ thuật viên cho tất cả các dịch vụ! Còn ${unassignedServices.length} dịch vụ chưa được phân công.`);
                        return;
                    }
                }
            }
            
            const orderData = {
                customerId: customerId,
                vehicleId: isNoCarMode ? null : vehicleId,
                services: selectedServices,
                spareParts: selectedSpareParts,
                technicians: isNoCarMode ? [] : selectedTechnicians,
                serviceTechnicianAssignments: isNoCarMode ? [] : serviceTechnicianAssignments,
                isNoCarMode: isNoCarMode
            };
            
            console.log('Saving order:', orderData);
            
            localStorage.removeItem('selectedServices');
            localStorage.removeItem('selectedSpareParts');
            localStorage.removeItem('selectedTechnicians');
            localStorage.removeItem('serviceTechnicianAssignments');
            localStorage.removeItem('noCarSelected');
            localStorage.removeItem('selectedCustomerId');
            console.log('LocalStorage cleared');
            
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'payment-invoice';
            
            const dataInput = document.createElement('input');
            dataInput.type = 'hidden';
            dataInput.name = 'orderData';
            dataInput.value = JSON.stringify(orderData);
            form.appendChild(dataInput);
            
            document.body.appendChild(form);
            form.submit();
        }
        
        function goBackToAssignTechnician() {
            const urlParams = new URLSearchParams(window.location.search);
            const customerId = urlParams.get('customerId');
            const vehicleId = urlParams.get('vehicleId');
            const noCar = urlParams.get('noCar');
            const isNoCarMode = noCar === 'true';
            
            if (!customerId) {
                alert('Thiếu thông tin khách hàng!');
                return;
            }

            if (isNoCarMode) {
                window.location.href = `service?customerId=${customerId}&noCar=true`;
                return;
            }

            const lastServiceIds = localStorage.getItem('lastServiceIds');
            const hasServiceIds = lastServiceIds && lastServiceIds.trim() !== '';
            const hasServices = selectedServices && selectedServices.length > 0;

            if (!hasServiceIds && !hasServices) {

                if (vehicleId) {
                    window.location.href = `service?customerId=${customerId}&vehicleId=${vehicleId}`;
                } else {
                    window.location.href = `service?customerId=${customerId}`;
                }
                return;
            }

            if (!vehicleId) {
                alert('Thiếu thông tin xe!');
                return;
            }

            let serviceIds = lastServiceIds;
            if (!serviceIds && hasServices) {
                serviceIds = selectedServices.map(s => s.id).join(',');
            }
            
            if (serviceIds && serviceIds.trim() !== '') {
                window.location.href = `technician?customerId=${customerId}&vehicleId=${vehicleId}&serviceIds=${serviceIds}`;
            } else {

                window.location.href = `service?customerId=${customerId}&vehicleId=${vehicleId}`;
            }
        }
    </script>
    
</body>
</html>
