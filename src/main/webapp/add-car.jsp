<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String customerId = request.getParameter("customerId");
    if (customerId == null || customerId.trim().isEmpty()) {
        response.sendRedirect("search-customer.jsp");
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
    <title>Thêm xe mới - Garage Management</title>
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
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }
        
        .form-group {
            margin-bottom: 0;
            position: relative;
            display: flex;
            flex-direction: column;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 700;
            color: #2d3748;
            font-size: 0.9rem;
            letter-spacing: 0.3px;
            flex-shrink: 0;
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 0.7rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: #f7fafc;
            font-family: inherit;
            box-sizing: border-box;
            height: calc(0.7rem * 2 + 0.95rem + 4px);
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
            resize: none;
            line-height: 1.5;
            overflow-y: auto;
            height: calc(0.7rem * 2 + 0.95rem + 4px);
        }
        
        .form-group textarea::-webkit-scrollbar {
            width: 4px;
        }
        
        .form-group textarea::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        
        .form-group textarea::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 2px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1rem;
        }
        
        .form-row:last-of-type {
            margin-bottom: 0;
        }
        
        .form-group small {
            margin-top: 0.4rem;
            flex-shrink: 0;
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
            margin-top: 0.4rem;
            color: #718096;
            font-size: 0.75rem;
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
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100%;
            pointer-events: none;
        }
        
        .form-group input[type="text"],
        .form-group input[type="number"] {
            padding-left: 2.5rem;
        }
        
        .form-group input[type="number"] {
            padding-right: 1.2rem;
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
                <h1>Thêm xe mới</h1>
            </div>
            <div class="user-info">
                <span>Xin chào, <%= user.getFullName() %>!</span>
                <a href="user?action=logout" class="logout-btn">Đăng xuất</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="page-header">
            <h2>Thêm xe mới</h2>
            <p>Nhập thông tin xe để thêm vào hệ thống.</p>
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
            
            <h3>Thông tin xe</h3>
            
            <div class="form-content">
            <form id="carForm" action="vehicle" method="POST" style="display: flex; flex-direction: column; height: 100%;">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="customerId" value="<%= customerId %>">
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="licensePlate">Biển số xe <span class="required">*</span></label>
                        <span class="input-icon">🚗</span>
                        <input type="text" id="licensePlate" name="licensePlate" required>
                        <div class="error-message" id="licensePlate-error"></div>
                        <small>Nhập biển số xe (VD: 30A-12345)</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="brand">Hãng xe <span class="required">*</span></label>
                        <span class="input-icon">🏭</span>
                        <input type="text" id="brand" name="brand" required>
                        <div class="error-message" id="brand-error"></div>
                        <small>Nhập hãng xe (VD: Toyota, Honda, Ford...)</small>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="model">Model</label>
                        <span class="input-icon">🏷️</span>
                        <input type="text" id="model" name="model">
                        <div class="error-message" id="model-error"></div>
                        <small>Nhập model xe (VD: Camry, Civic, Focus...)</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="yearOfManufacture">Năm sản xuất</label>
                        <span class="input-icon">📅</span>
                        <input type="number" id="yearOfManufacture" name="yearOfManufacture" 
                               min="1900" max="<%= java.time.Year.now().getValue() + 1 %>">
                        <div class="error-message" id="yearOfManufacture-error"></div>
                        <small>Nhập năm sản xuất xe</small>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="mileage">Số km</label>
                        <span class="input-icon">🛣️</span>
                        <input type="number" id="mileage" name="mileage" min="0">
                        <div class="error-message" id="mileage-error"></div>
                        <small>Nhập số km hiện tại của xe</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Mô tả</label>
                        <textarea id="description" name="description"></textarea>
                        <small>Mô tả thêm về xe (màu sắc, tình trạng, đặc điểm...)</small>
                    </div>
                </div>
            </form>
            </div>
            
            <div class="form-actions">
                <a href="vehicle?action=list&customerId=<%= customerId %>" class="btn btn-secondary">Hủy</a>
                <button type="submit" form="carForm" class="btn btn-primary">Lưu xe</button>
            </div>
        </div>
    </div>
    
    <script>
        function validateLicensePlate(licensePlate) {
            if (!licensePlate.trim()) {
                return "Biển số xe không được để trống!";
            }
            if (licensePlate.length < 4 || licensePlate.length > 12) {
                return "Biển số xe phải có từ 4-12 ký tự!";
            }
            return null;
        }
        
        function validateBrand(brand) {
            if (!brand.trim()) {
                return "Hãng xe không được để trống!";
            }
            if (brand.length < 2 || brand.length > 50) {
                return "Hãng xe phải có từ 2-50 ký tự!";
            }
            return null;
        }
        
        function validateModel(model) {
            if (model && (model.length < 2 || model.length > 50)) {
                return "Model phải có từ 2-50 ký tự!";
            }
            return null;
        }
        
        function validateYear(year) {
            if (year) {
                const currentYear = new Date().getFullYear();
                if (year < 1900 || year > currentYear + 1) {
                    return `Năm sản xuất phải từ 1900 đến ${currentYear + 1}!`;
                }
            }
            return null;
        }
        
        function validateMileage(mileage) {
            if (mileage && mileage < 0) {
                return "Số km không được âm!";
            }
            if (mileage && mileage > 1000000) {
                return "Số km không hợp lý (quá lớn)!";
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
        
        document.getElementById('licensePlate').addEventListener('input', function() {
            const error = validateLicensePlate(this.value);
            if (error) {
                showError('licensePlate', error);
            } else {
                showSuccess('licensePlate');
            }
        });
        
        document.getElementById('brand').addEventListener('input', function() {
            const error = validateBrand(this.value);
            if (error) {
                showError('brand', error);
            } else {
                showSuccess('brand');
            }
        });
        
        document.getElementById('model').addEventListener('input', function() {
            if (this.value) {
                const error = validateModel(this.value);
                if (error) {
                    showError('model', error);
                } else {
                    showSuccess('model');
                }
            } else {
                showSuccess('model');
            }
        });
        
        document.getElementById('yearOfManufacture').addEventListener('input', function() {
            if (this.value) {
                const error = validateYear(parseInt(this.value));
                if (error) {
                    showError('yearOfManufacture', error);
                } else {
                    showSuccess('yearOfManufacture');
                }
            } else {
                showSuccess('yearOfManufacture');
            }
        });
        
        document.getElementById('mileage').addEventListener('input', function() {
            if (this.value) {
                const error = validateMileage(parseInt(this.value));
                if (error) {
                    showError('mileage', error);
                } else {
                    showSuccess('mileage');
                }
            } else {
                showSuccess('mileage');
            }
        });
        
        document.getElementById('carForm').addEventListener('submit', function(e) {
            const licensePlate = document.getElementById('licensePlate').value;
            const brand = document.getElementById('brand').value;
            const model = document.getElementById('model').value;
            const year = document.getElementById('yearOfManufacture').value;
            const mileage = document.getElementById('mileage').value;
            
            let hasError = false;
            
            const licensePlateError = validateLicensePlate(licensePlate);
            if (licensePlateError) {
                showError('licensePlate', licensePlateError);
                hasError = true;
            }
            
            const brandError = validateBrand(brand);
            if (brandError) {
                showError('brand', brandError);
                hasError = true;
            }
            
            if (model) {
                const modelError = validateModel(model);
                if (modelError) {
                    showError('model', modelError);
                    hasError = true;
                }
            }
            
            if (year) {
                const yearError = validateYear(parseInt(year));
                if (yearError) {
                    showError('yearOfManufacture', yearError);
                    hasError = true;
                }
            }
            
            if (mileage) {
                const mileageError = validateMileage(parseInt(mileage));
                if (mileageError) {
                    showError('mileage', mileageError);
                    hasError = true;
                }
            }
            
            if (hasError) {
                e.preventDefault();
            }
        });
    </script>
</body>
</html>
