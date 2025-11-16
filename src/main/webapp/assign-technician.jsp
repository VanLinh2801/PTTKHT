<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<%@ page import="model.User" %>
<%@ page import="model.Service" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String customerId = request.getParameter("customerId");
    String vehicleId = request.getParameter("vehicleId");
    if (customerId == null || customerId.trim().isEmpty() || vehicleId == null || vehicleId.trim().isEmpty()) {
        response.sendRedirect("search-customer.jsp");
        return;
    }
    
    List<User> technicians = (List<User>) request.getAttribute("technicians");
    List<Service> services = (List<Service>) request.getAttribute("services");
    String technicianQuery = (String) request.getAttribute("technicianQuery");
    if (technicianQuery == null) technicianQuery = "";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phân công kỹ thuật viên - Garage Management</title>
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
            max-width: 1400px;
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
            max-width: 1400px;
            margin: 0 auto;
            padding: 0.5rem 1rem;
            height: calc(100vh - 70px);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            position: relative;
            z-index: 1;
        }
        
        .action-buttons {
            display: flex;
            gap: 0.6rem;
            justify-content: flex-start;
            margin-bottom: 0.5rem;
            flex-shrink: 0;
        }
        
        .btn {
            padding: 0.6rem 1.2rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 0.85rem;
            letter-spacing: 0.3px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
            box-shadow: 0 10px 25px rgba(0, 123, 255, 0.2);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 35px rgba(0, 123, 255, 0.3);
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
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            box-shadow: 0 10px 25px rgba(40, 167, 69, 0.2);
        }
        
        .btn-success:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 15px 35px rgba(40, 167, 69, 0.3);
        }
        
        .btn-success:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        .btn-warning {
            background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
            color: #212529;
            box-shadow: 0 10px 25px rgba(255, 193, 7, 0.2);
        }
        
        .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 15px 35px rgba(255, 193, 7, 0.3);
        }
        
        .results-section {
            background: white;
            padding: 1.2rem;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
            flex: 1;
            min-height: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        
        .results-section h3 {
            color: #2d3748;
            margin-bottom: 1rem;
            font-size: 1.1rem;
            font-weight: 700;
            flex-shrink: 0;
        }
        
        .table-container {
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 1rem;
        }
        
        th, td {
            padding: 1.2rem;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }
        
        th {
            background-color: #f7fafc;
            font-weight: 700;
            color: #2d3748;
            letter-spacing: 0.3px;
        }
        
        tr:hover {
            background-color: #f7fafc;
        }
        
        .no-results {
            text-align: center;
            padding: 2rem;
            color: #718096;
            font-style: italic;
        }
        
        .services-assignment {
            display: grid;
            grid-template-columns: 1fr;
            gap: 0;
            overflow-y: auto;
            flex: 1;
            min-height: 0;
            padding: 0.5rem 0.5rem 0.5rem 0;
        }
        
        .services-assignment::-webkit-scrollbar {
            width: 8px;
        }
        
        .services-assignment::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }
        
        .services-assignment::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 10px;
        }
        
        .services-assignment::-webkit-scrollbar-thumb:hover {
            background: #555;
        }
        
        .service-assignment-item {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            padding: 0.9rem;
            border-radius: 10px;
            border: 2px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            flex-shrink: 0;
            margin: 0.5rem 0;
        }
        
        .service-assignment-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
            transform: scaleY(0);
            transition: transform 0.3s ease;
        }
        
        .service-assignment-item:hover {
            box-shadow: 0 8px 24px rgba(255, 154, 158, 0.2);
            transform: translateY(-3px);
            border-color: #ff9a9e;
        }
        
        .service-assignment-item:hover::before {
            transform: scaleY(1);
        }
        
        .service-info {
            flex: 1;
            margin-right: 1.5rem;
            position: relative;
            z-index: 1;
        }
        
        .service-info h4 {
            color: #2d3748;
            font-size: 0.95rem;
            font-weight: 700;
            margin-bottom: 0.4rem;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }
        
        .service-info h4::before {
            content: '🔧';
            font-size: 1rem;
        }
        
        .service-description {
            color: #718096;
            font-size: 0.8rem;
            margin-bottom: 0.4rem;
            line-height: 1.4;
        }
        
        .service-price {
            color: #28a745;
            font-weight: 700;
            font-size: 0.85rem;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            background: rgba(40, 167, 69, 0.1);
            padding: 0.3rem 0.7rem;
            border-radius: 18px;
        }
        
        .technician-selection {
            min-width: 220px;
            position: relative;
            z-index: 1;
        }
        
        .technician-selection label {
            display: block;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 0.4rem;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }
        
        .technician-selection label::before {
            content: '👨‍🔧';
            font-size: 0.9rem;
        }
        
        .technician-selection select {
            width: 100%;
            padding: 0.6rem 0.9rem;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 0.85rem;
            background: white;
            transition: all 0.3s ease;
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23333' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 0.7rem center;
            padding-right: 2.2rem;
        }
        
        .technician-selection select:hover {
            border-color: #ff9a9e;
            background-color: #fff5f7;
        }
        
        .technician-selection select:focus {
            outline: none;
            border-color: #ff9a9e;
            box-shadow: 0 0 0 4px rgba(255, 154, 158, 0.15);
            background-color: white;
        }
        
        .technician-selection select option {
            padding: 0.75rem;
        }
        
        .technician-selection select option:disabled {
            color: #999;
            background-color: #f5f5f5;
            font-style: italic;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <div class="logo">
                <h1>Phân công kỹ thuật viên</h1>
            </div>
            <div class="user-info">
                <span>Xin chào, <%= user.getFullName() %>!</span>
                <a href="user?action=logout" class="logout-btn">Đăng xuất</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <% if (request.getAttribute("error") != null) { %>
            <div style="background: #fee; color: #c33; padding: 1rem; border-radius: 8px; margin-bottom: 1rem; border-left: 4px solid #c33;">
                <strong>Lỗi:</strong> <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <div class="action-buttons">
            <a href="service?customerId=<%= customerId %>&vehicleId=<%= vehicleId %>" class="btn btn-secondary">Quay lại</a>
            <button type="button" class="btn btn-warning" onclick="clearAllSelections()" id="clearBtn" style="display: none;">
                Xóa tất cả
            </button>
            <button type="button" class="btn btn-success" onclick="proceedToNext()" id="proceedBtn" disabled>
                Tiếp tục (0 kỹ thuật viên đã chọn)
            </button>
        </div>
        
        <div class="results-section">
            <h3>Phân công kỹ thuật viên cho từng dịch vụ</h3>
            
            <% 
                if (services == null) {
                    services = new java.util.ArrayList<Service>();
                }
                if (technicians == null) {
                    technicians = new java.util.ArrayList<User>();
                }
            %>
            
            <% if (services != null && !services.isEmpty()) { %>
                <div class="services-assignment">
                    <% for (Service service : services) { %>
                        <% if (service != null) { %>
                        <div class="service-assignment-item">
                            <div class="service-info">
                                <h4><%= service.getName() != null ? service.getName() : "Dịch vụ không tên" %></h4>
                                <p class="service-description"><%= service.getDescription() != null ? service.getDescription() : "Không có mô tả" %></p>
                                <p class="service-price">Giá: ₫<%= service.getPrice() != null ? String.format("%,.0f", service.getPrice()) : "0" %></p>
                            </div>
                            <div class="technician-selection">
                                <label for="technician_<%= service.getId() != null ? service.getId() : "" %>">Chọn kỹ thuật viên:</label>
                                <select id="technician_<%= service.getId() != null ? service.getId() : "" %>" 
                                        name="serviceTechnician" 
                                        data-service-id="<%= service.getId() != null ? service.getId() : "" %>"
                                        data-service-name="<%= service.getName() != null ? service.getName() : "" %>"
                                        onchange="onTechnicianChange(this)">
                                    <option value="">-- Chọn kỹ thuật viên --</option>
                                    <% if (technicians != null && !technicians.isEmpty()) { %>
                                        <% for (User technician : technicians) { %>
                                            <% if (technician != null) { %>
                                            <option value="<%= technician.getId() != null ? technician.getId() : "" %>" 
                                                    data-technician-name="<%= technician.getFullName() != null ? technician.getFullName() : "" %>"
                                                    data-technician-phone="<%= technician.getPhone() != null ? technician.getPhone() : "" %>">
                                                <%= technician.getFullName() != null ? technician.getFullName() : "Không tên" %> 
                                                <% if (technician.getPhone() != null && !technician.getPhone().isEmpty()) { %>
                                                    (<%= technician.getPhone() %>)
                                                <% } %>
                                            </option>
                                            <% } %>
                                        <% } %>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                        <% } %>
                    <% } %>
                </div>
            <% } else { %>
                <div class="no-results">
                    <p>Không có dịch vụ nào để phân công</p>
                </div>
            <% } %>
        </div>
    </div>

    <script>
        let serviceTechnicianAssignments = [];
        
        window.addEventListener('load', function() {
            console.log('Window loaded, initializing...');
            
            const urlParams = new URLSearchParams(window.location.search);
            const serviceIdsParam = urlParams.get('serviceIds');

            const lastServiceIds = localStorage.getItem('lastServiceIds');
            let actualServiceIds = serviceIdsParam;
            
            if (lastServiceIds && lastServiceIds.trim() !== '') {

                if (serviceIdsParam !== lastServiceIds) {
                    console.log('ServiceIds mismatch. URL:', serviceIdsParam, 'LocalStorage:', lastServiceIds);
                    console.log('Redirecting to update URL with latest serviceIds...');
                    const customerId = urlParams.get('customerId');
                    const vehicleId = urlParams.get('vehicleId');
                    if (customerId && vehicleId) {
                        if (lastServiceIds.trim() === '') {

                            window.location.href = `payment-invoice?customerId=${customerId}&vehicleId=${vehicleId}`;
                            return;
                        } else {

                            window.location.href = `technician?customerId=${customerId}&vehicleId=${vehicleId}&serviceIds=${lastServiceIds}`;
                            return;
                        }
                    }
                }
                actualServiceIds = lastServiceIds;
            } else if (serviceIdsParam) {

                localStorage.setItem('lastServiceIds', serviceIdsParam);
            }
            
            loadFromLocalStorage();
            updateProceedButton();
            syncSelectsWithData();
        });
        
        function saveToLocalStorage() {
            localStorage.setItem('serviceTechnicianAssignments', JSON.stringify(serviceTechnicianAssignments));
            console.log('Saved to localStorage:', { serviceTechnicianAssignments });
        }
        
        function loadFromLocalStorage() {
            serviceTechnicianAssignments = JSON.parse(localStorage.getItem('serviceTechnicianAssignments') || '[]');
            console.log('Loaded from localStorage:', { serviceTechnicianAssignments });

            const urlParams = new URLSearchParams(window.location.search);
            const serviceIdsParam = urlParams.get('serviceIds');
            const lastServiceIds = localStorage.getItem('lastServiceIds');
            const actualServiceIds = lastServiceIds || serviceIdsParam;
            
            if (actualServiceIds) {
                const validServiceIds = actualServiceIds.split(',').map(id => id.trim());
                const originalLength = serviceTechnicianAssignments.length;
                serviceTechnicianAssignments = serviceTechnicianAssignments.filter(assignment => 
                    validServiceIds.includes(String(assignment.serviceId))
                );
                
                if (serviceTechnicianAssignments.length !== originalLength) {
                    console.log('Filtered out assignments for removed services');
                    saveToLocalStorage();
                }
            }
        }
        
        function syncSelectsWithData() {
            console.log('Syncing selects with localStorage data...');

            document.querySelectorAll('select[name="serviceTechnician"]').forEach(select => {
                select.value = '';
            });

            serviceTechnicianAssignments.forEach(assignment => {
                const select = document.querySelector(`select[name="serviceTechnician"][data-service-id="${assignment.serviceId}"]`);
                if (select) {
                    select.value = assignment.technicianId;
                    console.log('Synced assignment:', assignment.serviceName, '->', assignment.technicianName);
                }
            });

            updateTechnicianOptions();
        }
        
        function updateTechnicianOptions() {

            const assignedTechnicianIds = serviceTechnicianAssignments.map(a => String(a.technicianId));

            document.querySelectorAll('select[name="serviceTechnician"]').forEach(select => {
                const currentServiceId = select.dataset.serviceId;
                const currentAssignment = serviceTechnicianAssignments.find(a => String(a.serviceId) === String(currentServiceId));
                const currentTechnicianId = currentAssignment ? String(currentAssignment.technicianId) : null;

                Array.from(select.options).forEach(option => {
                    const technicianId = option.value;
                    if (!technicianId) {

                        option.disabled = false;
                        option.style.display = '';
                        return;
                    }

                    if (currentTechnicianId && String(technicianId) === currentTechnicianId) {
                        option.disabled = false;
                        option.style.display = '';
                    } else {

                        if (assignedTechnicianIds.includes(String(technicianId))) {
                            option.style.display = 'none';
                        } else {
                            option.style.display = '';
                            option.disabled = false;
                        }
                    }
                });
            });
        }
        
        function onTechnicianChange(selectElement) {
            console.log('Technician selection changed for service:', selectElement.dataset.serviceName);
            
            const serviceId = selectElement.dataset.serviceId;
            const serviceName = selectElement.dataset.serviceName;
            const technicianId = selectElement.value;
            const technicianName = selectElement.selectedOptions[0]?.dataset.technicianName || '';
            const technicianPhone = selectElement.selectedOptions[0]?.dataset.technicianPhone || '';

            const oldAssignment = serviceTechnicianAssignments.find(a => String(a.serviceId) === String(serviceId));
            const oldTechnicianId = oldAssignment ? oldAssignment.technicianId : null;
            
            if (technicianId) {

                const alreadyAssigned = serviceTechnicianAssignments.find(a => 
                    String(a.technicianId) === String(technicianId) && 
                    String(a.serviceId) !== String(serviceId)
                );
                
                if (alreadyAssigned) {
                    alert(`Kỹ thuật viên "${technicianName}" đã được phân công cho dịch vụ "${alreadyAssigned.serviceName}". Vui lòng chọn kỹ thuật viên khác.`);

                    selectElement.value = oldTechnicianId || '';
                    return;
                }

                const existingIndex = serviceTechnicianAssignments.findIndex(a => String(a.serviceId) === String(serviceId));
                const assignment = {
                    serviceId: serviceId,
                    serviceName: serviceName,
                    technicianId: technicianId,
                    technicianName: technicianName,
                    technicianPhone: technicianPhone
                };
                
                if (existingIndex >= 0) {
                    serviceTechnicianAssignments[existingIndex] = assignment;
                } else {
                    serviceTechnicianAssignments.push(assignment);
                }
            } else {

                serviceTechnicianAssignments = serviceTechnicianAssignments.filter(a => String(a.serviceId) !== String(serviceId));
            }
            
            console.log('Updated assignments:', serviceTechnicianAssignments);

            updateTechnicianOptions();
            
            updateProceedButton();
            saveToLocalStorage();
        }
        
        function updateProceedButton() {
            const proceedBtn = document.getElementById('proceedBtn');
            const clearBtn = document.getElementById('clearBtn');
            const totalAssignments = serviceTechnicianAssignments.length;
            
            if (totalAssignments > 0) {
                proceedBtn.disabled = false;
                proceedBtn.textContent = `Tiếp tục (${totalAssignments} dịch vụ đã phân công)`;
                clearBtn.style.display = 'inline-block';
            } else {
                proceedBtn.disabled = true;
                proceedBtn.textContent = 'Tiếp tục (0 dịch vụ đã phân công)';
                clearBtn.style.display = 'none';
            }
        }
        
        function proceedToNext() {
            const totalAssignments = serviceTechnicianAssignments.length;
            if (totalAssignments === 0) {
                alert('Vui lòng phân công kỹ thuật viên cho ít nhất một dịch vụ!');
                return;
            }

            const urlParams = new URLSearchParams(window.location.search);
            const serviceIdsParam = urlParams.get('serviceIds');
            if (serviceIdsParam) {
                const serviceIds = serviceIdsParam.split(',').map(id => id.trim());
                const assignedServiceIds = serviceTechnicianAssignments.map(a => String(a.serviceId));
                const unassignedServices = serviceIds.filter(id => !assignedServiceIds.includes(id));
                
                if (unassignedServices.length > 0) {
                    alert(`Vui lòng phân công kỹ thuật viên cho tất cả các dịch vụ! Còn ${unassignedServices.length} dịch vụ chưa được phân công.`);
                    return;
                }
            }
            
            const customerId = urlParams.get('customerId');
            const vehicleId = urlParams.get('vehicleId');
            
            if (!customerId || !vehicleId) {
                alert('Thiếu thông tin khách hàng hoặc xe!');
                return;
            }

            if (serviceIdsParam) {
                localStorage.setItem('lastServiceIds', serviceIdsParam);
            }
            localStorage.setItem('serviceTechnicianAssignments', JSON.stringify(serviceTechnicianAssignments));
            
            window.location.href = `payment-invoice?customerId=${customerId}&vehicleId=${vehicleId}`;
        }
        
        function clearAllSelections() {
            console.log('Clearing all selections...');
            
            serviceTechnicianAssignments = [];
            
            document.querySelectorAll('select[name="serviceTechnician"]').forEach(select => select.value = '');
            
            localStorage.removeItem('serviceTechnicianAssignments');
            
            updateProceedButton();
            
            console.log('All selections cleared');
        }

        function adjustServicesAssignmentHeight() {
            const servicesAssignment = document.querySelector('.services-assignment');
            if (!servicesAssignment) return;
            
            const serviceItems = servicesAssignment.querySelectorAll('.service-assignment-item');
            if (serviceItems.length === 0) return;
            
            const resultsSection = servicesAssignment.closest('.results-section');
            if (!resultsSection) return;
            
            const h3 = resultsSection.querySelector('h3');
            const h3Height = h3 ? h3.offsetHeight + 1 * 16 : 0;
            
            const sectionPadding = 1.2 * 16 * 2;
            const availableHeight = resultsSection.offsetHeight - h3Height - sectionPadding;

            const firstItem = serviceItems[0];
            const itemHeight = firstItem.offsetHeight;
            const gap = 1 * 16;

            const maxVisibleItems = Math.floor((availableHeight + gap) / (itemHeight + gap));
            
            if (maxVisibleItems <= 0) return;

            if (serviceItems.length <= maxVisibleItems) {
                servicesAssignment.style.maxHeight = (serviceItems.length * itemHeight + (serviceItems.length - 1) * gap) + 'px';
                servicesAssignment.style.overflowY = 'hidden';
            } else {

                servicesAssignment.style.maxHeight = (maxVisibleItems * itemHeight + (maxVisibleItems - 1) * gap) + 'px';
                servicesAssignment.style.overflowY = 'auto';
            }
        }

        window.addEventListener('DOMContentLoaded', function() {
            setTimeout(adjustServicesAssignmentHeight, 100);
        });

        window.addEventListener('resize', function() {
            setTimeout(adjustServicesAssignmentHeight, 100);
        });
    </script>
    
</body>
</html>
