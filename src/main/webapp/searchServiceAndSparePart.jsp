<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<%@ page import="model.User" %>
<%@ page import="model.Service" %>
<%@ page import="model.SparePart" %>
<%@ page import="model.UsedSparePart" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
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
    
    List<Service> services = (List<Service>) request.getAttribute("services");
    List<SparePart> spareParts = (List<SparePart>) request.getAttribute("spareParts");
    Map<Integer, List<UsedSparePart>> usedSparePartsMap = (Map<Integer, List<UsedSparePart>>) request.getAttribute("usedSparePartsMap");
    String serviceQuery = (String) request.getAttribute("serviceQuery");
    String sparePartQuery = (String) request.getAttribute("sparePartQuery");
    if (serviceQuery == null) serviceQuery = "";
    if (sparePartQuery == null) sparePartQuery = "";
    if (usedSparePartsMap == null) usedSparePartsMap = new java.util.HashMap<>();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm dịch vụ và phụ tùng - Garage Management</title>
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
            padding: 0.5rem 1rem;
            position: relative;
            z-index: 1;
            height: calc(100vh - 80px);
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        
        .page-header {
            background: white;
            padding: 1.2rem;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            margin-bottom: 1rem;
            animation: slideUp 0.5s ease;
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .page-header h2 {
            color: #1a1a1a;
            margin-bottom: 0.4rem;
            font-size: 1.4rem;
            font-weight: 700;
        }
        
        .page-header p {
            color: #666;
            font-size: 0.9rem;
            font-weight: 400;
        }
        
        .search-sections-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.6rem;
            margin-bottom: 0.5rem;
            flex-shrink: 0;
        }
        
        @media (max-width: 768px) {
            .search-sections-container {
                grid-template-columns: 1fr;
            }
        }
        
        .search-section {
            background: white;
            padding: 0.8rem;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            animation: slideUp 0.5s ease 0.1s both;
        }
        
        .search-section h3 {
            color: #1a1a1a;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
            font-weight: 700;
        }
        
        .search-form {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }
        
        .search-input {
            flex: 1;
            min-width: 150px;
            padding: 0.6rem 1rem;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            background: #fafafa;
        }
        
        .search-input:focus {
            outline: none;
            border-color: #28a745;
            background: white;
            box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.1);
        }
        
        .search-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border: none;
            padding: 0.6rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.2);
            font-size: 0.85rem;
        }
        
        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.3);
        }
        
        .action-buttons {
            display: flex;
            gap: 0.6rem;
            justify-content: flex-start;
            margin-bottom: 0.5rem;
            flex-wrap: wrap;
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
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(0, 123, 255, 0.2);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 123, 255, 0.3);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.2);
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(108, 117, 125, 0.3);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.2);
        }
        
        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.3);
        }
        
        .btn-warning {
            background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
            color: #212529;
            box-shadow: 0 4px 12px rgba(255, 193, 7, 0.2);
        }
        
        .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 193, 7, 0.3);
        }
        
        .results-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.6rem;
            flex: 1;
            min-height: 0;
            overflow: hidden;
        }
        
        @media (max-width: 768px) {
            .results-grid {
                grid-template-columns: 1fr;
            }
        }
        
        .results-container {
            background: white;
            padding: 0.6rem;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            overflow: hidden;
            height: 100%;
            position: relative;
            z-index: 10;
            display: flex;
            flex-direction: column;
        }
        
        .results-section {
            background: transparent;
            padding: 0;
            border-radius: 0;
            box-shadow: none;
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        
        .results-section h3 {
            color: #1a1a1a;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
            font-weight: 700;
            flex-shrink: 0;
        }
        
        .table-container {
            overflow-x: auto;
            overflow-y: auto;
            border-radius: 0 0 8px 8px;
            position: relative;
            flex: 1;
            min-height: 0;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 0;
        }
        
        th, td {
            padding: 0.5rem;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
            font-size: 0.85rem;
            vertical-align: middle;
        }
        
        tr {
            height: auto;
        }
        
        td {
            height: auto;
            min-height: 2.5rem;
        }
        
        thead {
            position: sticky;
            top: 0;
            z-index: 5;
        }
        
        th {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            font-weight: 700;
            color: #1a1a1a;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
            position: sticky;
            top: 0;
            z-index: 5;
        }
        
        tr {
            transition: all 0.2s ease;
        }
        
        tr:hover {
            background-color: #f8f9fa;
            box-shadow: inset 0 0 10px rgba(40, 167, 69, 0.05);
        }
        
        .no-results {
            text-align: center;
            padding: 1rem;
            color: #666;
            font-style: italic;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 8px;
            font-size: 0.85rem;
        }
        
        .selected-items {
            background: white;
            padding: 0.6rem;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            margin-bottom: 0.5rem;
            animation: slideUp 0.5s ease 0.3s both;
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 0.8rem;
            flex-shrink: 0;
        }
        
        @media (max-width: 768px) {
            .selected-items {
                grid-template-columns: 1fr;
            }
        }
        
        .selected-items-summary {
            display: flex;
            flex-direction: column;
            justify-content: center;
            gap: 0.5rem;
        }
        
        .selected-items-summary h3 {
            color: #1a1a1a;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
            font-weight: 700;
        }
        
        .summary-info {
            display: flex;
            flex-direction: column;
            gap: 0.4rem;
        }
        
        .summary-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.85rem;
            color: #666;
        }
        
        .summary-item strong {
            color: #1a1a1a;
            font-weight: 600;
        }
        
        .selected-items-list {
            overflow-y: auto;
            padding-right: 0.5rem;
        }
        
        .selected-items-list::-webkit-scrollbar {
            width: 6px;
        }
        
        .selected-items-list::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }
        
        .selected-items-list::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 10px;
        }
        
        .selected-items-list::-webkit-scrollbar-thumb:hover {
            background: #555;
        }
        
        .selected-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.35rem 0.4rem;
            border-bottom: 1px solid #e9ecef;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            margin-bottom: 0.3rem;
            border-radius: 6px;
            transition: all 0.2s ease;
            font-size: 0.8rem;
        }
        
        .selected-item:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transform: translateX(4px);
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
            color: #1a1a1a;
            font-size: 0.85rem;
        }
        
        .selected-item-details {
            font-size: 0.7rem;
            color: #666;
        }
        
        .selected-item-actions {
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }
        
        .remove-btn {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
            border: none;
            padding: 0.3rem 0.7rem;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.7rem;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.2);
        }
        
        .remove-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(220, 53, 69, 0.3);
        }
        
        .total-amount {
            font-size: 1.1rem;
            font-weight: 700;
            color: #28a745;
            padding-top: 0.5rem;
            border-top: 2px solid #28a745;
            margin-top: 0.5rem;
        }
        
        .checkbox {
            margin-right: 0.5rem;
        }
        
        .price {
            font-weight: 700;
            color: #28a745;
            font-size: 0.9rem;
        }
        
        .quantity-input {
            width: 60px;
            padding: 0.3rem 0.4rem;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            text-align: center;
            font-weight: 600;
            font-size: 0.8rem;
            transition: all 0.2s ease;
            margin-left: 0.4rem;
            display: inline-block;
            vertical-align: middle;
            box-sizing: border-box;
        }
        
        .quantity-input:focus {
            outline: none;
            border-color: #28a745;
            box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.1);
        }
        
        .quantity-input.error {
            border-color: #dc3545;
            background-color: #fff5f5;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1);
            animation: shake 0.3s ease-in-out;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }
        
        .quantity-error-message {
            display: none;
            color: #dc3545;
            font-size: 0.7rem;
            margin-top: 0.2rem;
            margin-left: 0.4rem;
            font-weight: 500;
            animation: slideDown 0.3s ease-out;
        }
        
        .quantity-error-message.show {
            display: block;
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
        
        .quantity-wrapper {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }

        .toast-container {
            position: fixed;
            top: 80px;
            right: 20px;
            z-index: 10000;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        
        .toast {
            background: white;
            padding: 1rem 1.5rem;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            min-width: 300px;
            max-width: 400px;
            display: flex;
            align-items: center;
            gap: 1rem;
            animation: slideInRight 0.3s ease-out;
            border-left: 4px solid #dc3545;
        }
        
        .toast.success {
            border-left-color: #28a745;
        }
        
        .toast.warning {
            border-left-color: #ffc107;
        }
        
        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(100%);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        .toast-icon {
            font-size: 1.5rem;
            flex-shrink: 0;
        }
        
        .toast-content {
            flex: 1;
        }
        
        .toast-title {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 0.25rem;
            font-size: 0.9rem;
        }
        
        .toast-message {
            color: #718096;
            font-size: 0.85rem;
            line-height: 1.4;
        }
        
        .toast-close {
            background: none;
            border: none;
            font-size: 1.2rem;
            cursor: pointer;
            color: #718096;
            padding: 0;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
            transition: all 0.2s ease;
        }
        
        .toast-close:hover {
            background: #f7fafc;
            color: #2d3748;
        }
        
        td:first-child {
            white-space: nowrap;
        }
        
        input[type="checkbox"] {
            vertical-align: middle;
            margin: 0;
        }
        
        .out-of-stock {
            opacity: 0.45;
        }
        .stock-badge {
            display: inline-block;
            padding: 0.2rem 0.5rem;
            border-radius: 999px;
            font-size: 0.75rem;
            font-weight: 700;
        }
        .stock-badge.out {
            background: #ffe5e7;
            color: #c82333;
            border: 1px solid #f5c6cb;
        }
        
        tr.insufficient-stock {
            background-color: #fff3cd !important;
            border-left: 3px solid #ffc107;
        }
        tr.insufficient-stock:hover {
            background-color: #ffe69c !important;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <div class="logo">
                <h1>Tìm kiếm dịch vụ và phụ tùng</h1>
            </div>
            <div class="user-info">
                <span>Xin chào, <%= user.getFullName() %>!</span>
                <a href="user?action=logout" class="logout-btn">Đăng xuất</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="selected-items">
            <div class="selected-items-summary">
                <h3>Đã chọn</h3>
                <div class="summary-info">
                    <div class="summary-item">
                        <span>Dịch vụ:</span>
                        <strong id="serviceCount">0</strong>
                    </div>
                    <div class="summary-item">
                        <span>Phụ tùng:</span>
                        <strong id="sparePartCount">0</strong>
                    </div>
                    <div class="summary-item">
                        <span>Tổng mục:</span>
                        <strong id="totalItemsCount">0</strong>
                    </div>
                </div>
                <div id="totalAmount" class="total-amount">Tổng cộng: ₫0</div>
            </div>
            <div class="selected-items-list">
                <div id="selectedItems">
                    <p style="color: #666; font-style: italic; text-align: center; padding: 1rem;">Chưa có dịch vụ hoặc phụ tùng nào được chọn</p>
                </div>
            </div>
        </div>
        
        <div class="action-buttons">
            <% if (isNoCarMode) { %>
                <a href="vehicle?action=list&customerId=<%= customerId %>" class="btn btn-secondary">Quay lại</a>
            <% } else { %>
                <a href="vehicle?action=list&customerId=<%= customerId %>" class="btn btn-secondary">Quay lại</a>
            <% } %>
            <button type="button" class="btn btn-warning" onclick="clearAllSelections()" id="clearBtn" style="display: none;">
                Xóa tất cả
            </button>
            <button type="button" class="btn btn-success" onclick="proceedToNext()" id="proceedBtn" disabled>
                Tiếp tục (0 mục đã chọn)
            </button>
        </div>
        
        <div class="search-sections-container">
            <% if (!isNoCarMode) { %>
            <div class="search-section">
                <h3>Tìm kiếm dịch vụ</h3>
                <form action="service" method="GET" class="search-form">
                    <input type="hidden" name="action" value="search">
                    <input type="hidden" name="customerId" value="<%= customerId %>">
                    <input type="hidden" name="vehicleId" value="<%= vehicleId %>">
                    <input type="hidden" name="sparePartQuery" value="<%= sparePartQuery %>">
                    <input type="text" name="serviceQuery" class="search-input" 
                           placeholder="Nhập tên dịch vụ..." 
                           value="<%= serviceQuery %>">
                    <button type="submit" class="search-btn">Tìm dịch vụ</button>
                </form>
            </div>
            <% } %>
            
            <div class="search-section">
                <h3>Tìm kiếm phụ tùng</h3>
                <form action="spare-part" method="GET" class="search-form">
                    <input type="hidden" name="action" value="search">
                    <input type="hidden" name="customerId" value="<%= customerId %>">
                    <input type="hidden" name="vehicleId" value="<%= vehicleId %>">
                    <input type="hidden" name="serviceQuery" value="<%= serviceQuery %>">
                    <% if (isNoCarMode) { %>
                    <input type="hidden" name="noCar" value="true">
                    <% } %>
                    <input type="text" name="sparePartQuery" class="search-input" 
                           placeholder="Nhập tên phụ tùng..." 
                           value="<%= sparePartQuery %>">
                    <button type="submit" class="search-btn">Tìm phụ tùng</button>
                </form>
            </div>
        </div>
        
        <div class="results-grid">
            <% if (!isNoCarMode) { %>
            <div class="results-container">
                <div class="results-section">
                    <h3>Dịch vụ</h3>
                    
                    <% if (services != null && !services.isEmpty()) { %>
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Chọn</th>
                                        <th>Tên dịch vụ</th>
                                        <th>Giá</th>
                                        <th>Thời gian</th>
                                        <th>Danh mục</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Service service : services) { 
                                        List<UsedSparePart> usedSpareParts = usedSparePartsMap.get(service.getId());
                                        if (usedSpareParts == null) usedSpareParts = new java.util.ArrayList<>();

                                        StringBuilder usedSparePartsJson = new StringBuilder("[");
                                        for (int i = 0; i < usedSpareParts.size(); i++) {
                                            UsedSparePart usp = usedSpareParts.get(i);
                                            if (i > 0) usedSparePartsJson.append(",");
                                            usedSparePartsJson.append("{")
                                                .append("\"sparePartId\":").append(usp.getSparePartId())
                                                .append(",\"quantity\":").append(usp.getQuantity())
                                                .append("}");
                                        }
                                        usedSparePartsJson.append("]");
                                    %>
                                        <tr>
                                            <td>
                                                <input type="checkbox" name="selectedServices" 
                                                       value="<%= service.getId() %>"
                                                       data-name="<%= service.getName() %>"
                                                       data-price="<%= service.getPrice() %>"
                                                       data-used-spare-parts='<%= usedSparePartsJson.toString() %>'
                                                       onchange="onCheckboxChange()">
                                            </td>
                                            <td><%= service.getName() %></td>
                                            <td class="price">₫<%= String.format("%.0f", service.getPrice()) %></td>
                                            <td><%= service.getEstimateDuration() != null ? service.getEstimateDuration() : "" %></td>
                                            <td><%= service.getCategory() != null ? service.getCategory() : "" %></td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } else if (serviceQuery != null && !serviceQuery.isEmpty()) { %>
                        <div class="no-results">
                            <p>Không tìm thấy dịch vụ nào với từ khóa "<%= serviceQuery %>"</p>
                        </div>
                    <% } else { %>
                        <div class="no-results">
                            <p>Nhập từ khóa tìm kiếm để bắt đầu tìm kiếm dịch vụ</p>
                        </div>
                    <% } %>
                </div>
            </div>
            <% } %>
            
            <div class="results-container">
                <div class="results-section">
                    <h3>Phụ tùng</h3>
                    
                    <% if (spareParts != null && !spareParts.isEmpty()) { %>
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Chọn</th>
                                        <th>Tên phụ tùng</th>
                                        <th>Giá</th>
                                        <th>Số lượng</th>
                                        <th>Nhà sản xuất</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (SparePart sparePart : spareParts) { %>
                                        <tr class="<%= (sparePart.getAvailableQuantity() == null || sparePart.getAvailableQuantity() <= 0) ? "out-of-stock" : "" %>">
                                            <td>
                                                <div style="display: flex; align-items: center; gap: 0.4rem;">
                                                    <input type="checkbox" name="selectedSpareParts" 
                                                           value="<%= sparePart.getId() %>"
                                                           data-name="<%= sparePart.getName() %>"
                                                           data-price="<%= sparePart.getPrice() %>"
                                                           data-available-quantity="<%= sparePart.getAvailableQuantity() %>"
                                                           data-quantity="1"
                                                           <%= (sparePart.getAvailableQuantity() == null || sparePart.getAvailableQuantity() <= 0) ? "disabled title='Hết hàng'" : "" %>
                                                           onchange="updateQuantity(this); onCheckboxChange();">
                                                    <div class="quantity-wrapper">
                                                        <input type="number" class="quantity-input" 
                                                               min="<%= (sparePart.getAvailableQuantity() != null && sparePart.getAvailableQuantity() > 0) ? 1 : 0 %>" 
                                                               max="<%= sparePart.getAvailableQuantity() %>" 
                                                               value="<%= (sparePart.getAvailableQuantity() != null && sparePart.getAvailableQuantity() > 0) ? 1 : 0 %>" 
                                                               disabled
                                                               data-available-quantity="<%= sparePart.getAvailableQuantity() %>"
                                                               data-spare-part-name="<%= sparePart.getName() %>"
                                                               onchange="updateSparePartQuantity(this)"
                                                               oninput="validateSparePartQuantityOnInput(this)"
                                                               onblur="validateSparePartQuantity(this, true)">
                                                        <div class="quantity-error-message" id="error-<%= sparePart.getId() %>"></div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><%= sparePart.getName() %></td>
                                            <td class="price">₫<%= String.format("%.0f", sparePart.getPrice()) %></td>
                                             <td>
                                                <% if (sparePart.getAvailableQuantity() != null && sparePart.getAvailableQuantity() > 0) { %>
                                                    <%= sparePart.getAvailableQuantity() %>
                                                <% } else { %>
                                                    <span class="stock-badge out">Hết hàng (0 còn lại)</span>
                                                <% } %>
                                             </td>
                                            <td><%= sparePart.getManufacturer() != null ? sparePart.getManufacturer() : "" %></td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } else if (sparePartQuery != null && !sparePartQuery.isEmpty()) { %>
                        <div class="no-results">
                            <p>Không tìm thấy phụ tùng nào với từ khóa "<%= sparePartQuery %>"</p>
                        </div>
                    <% } else { %>
                        <div class="no-results">
                            <p>Nhập từ khóa tìm kiếm để bắt đầu tìm kiếm phụ tùng</p>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <div class="toast-container" id="toastContainer"></div>

    <script>
        let selectedServices = [];
        let selectedSpareParts = [];
        let isProcessingValidation = false;
        
        window.addEventListener('load', function() {
            console.log('Window loaded, initializing...');

            const urlParams = new URLSearchParams(window.location.search);
            const isNoCarMode = urlParams.get('noCar') === 'true';
            
            loadFromLocalStorage(isNoCarMode);
            renderSelectedItems();
            updateTotalAmount();
            requestAnimationFrame(function() {
                setTimeout(syncCheckboxesWithData, 500);
            });
        });
        
        function saveToLocalStorage() {
            localStorage.setItem('selectedServices', JSON.stringify(selectedServices));
            localStorage.setItem('selectedSpareParts', JSON.stringify(selectedSpareParts));
            console.log('Saved to localStorage:', { selectedServices, selectedSpareParts });
        }
        
        function loadFromLocalStorage(isNoCarMode) {

            if (isNoCarMode) {
                selectedServices = [];
                localStorage.setItem('selectedServices', '[]');
                console.log('NoCar mode detected, cleared selectedServices');
            } else {
                selectedServices = JSON.parse(localStorage.getItem('selectedServices') || '[]');
            }
            selectedSpareParts = JSON.parse(localStorage.getItem('selectedSpareParts') || '[]');
            console.log('Loaded from localStorage:', { selectedServices, selectedSpareParts });
        }
        
        function syncCheckboxesWithData() {
            console.log('Syncing checkboxes with localStorage data...');

            const availableServiceCheckboxes = document.querySelectorAll('input[name="selectedServices"]');
            const availableSparePartCheckboxes = document.querySelectorAll('input[name="selectedSpareParts"]');

            const availableServiceIds = Array.from(availableServiceCheckboxes).map(cb => cb.value);

            const availableSparePartIds = Array.from(availableSparePartCheckboxes).map(cb => cb.value);

            availableServiceCheckboxes.forEach(cb => cb.checked = false);
            availableSparePartCheckboxes.forEach(cb => {
                cb.checked = false;
                const row = cb.closest('tr');
                const quantityInput = row.querySelector('.quantity-input');
                if (quantityInput) {
                    quantityInput.disabled = true;
                    quantityInput.value = '1';
                }
            });

            selectedServices.forEach(service => {
                const checkbox = document.querySelector(`input[name="selectedServices"][value="${service.id}"]`);
                if (checkbox) {
                    checkbox.checked = true;
                    console.log('Synced service:', service.name);
                } else {
                    console.log('Service checkbox not found:', service.id);
                }
            });

            selectedSpareParts = selectedSpareParts.map(part => {
                const checkbox = document.querySelector(`input[name="selectedSpareParts"][value="${part.id}"]`);
                if (checkbox) {
                    checkbox.checked = true;
                    const row = checkbox.closest('tr');
                    const quantityInput = row.querySelector('.quantity-input');
                    if (quantityInput) {
                        quantityInput.disabled = false;
                        const availableQuantity = parseInt(checkbox.dataset.availableQuantity) || 0;
                        let quantity = part.quantity || 1;

                        if (quantity > availableQuantity) {
                            quantity = availableQuantity;
                            console.warn(`Số lượng phụ tùng "${part.name}" đã được điều chỉnh từ ${part.quantity} về ${availableQuantity} (số lượng tối đa có sẵn).`);
                        }
                        
                        quantityInput.value = quantity;

                        part.quantity = quantity;
                    }
                    console.log('Synced spare part:', part.name);
                } else {
                    console.log('Spare part checkbox not found:', part.id);
                }
                return part;
            });

            saveToLocalStorage();
        }

        let sparePartRequiredDetails = new Map();
        
        function calculateRequiredQuantities() {
            sparePartRequiredDetails.clear();

            selectedSpareParts.forEach(part => {
                const partId = String(part.id);
                const quantity = part.quantity || 1;
                let details = sparePartRequiredDetails.get(partId);
                if (!details) {
                    details = {
                        customerOrder: 0,
                        serviceUsage: [],
                        total: 0
                    };
                    sparePartRequiredDetails.set(partId, details);
                }
                details.customerOrder += quantity;
                details.total += quantity;
            });

            selectedServices.forEach(service => {
                const serviceId = service.id;
                const serviceName = service.name || `Dịch vụ ID ${serviceId}`;
                const checkbox = document.querySelector(`input[name="selectedServices"][value="${serviceId}"]`);
                if (checkbox && checkbox.dataset.usedSpareParts) {
                    try {
                        const usedSpareParts = JSON.parse(checkbox.dataset.usedSpareParts);
                        usedSpareParts.forEach(usedPart => {
                            const partId = String(usedPart.sparePartId);
                            const quantity = usedPart.quantity || 0;
                            let details = sparePartRequiredDetails.get(partId);
                            if (!details) {
                                details = {
                                    customerOrder: 0,
                                    serviceUsage: [],
                                    total: 0
                                };
                                sparePartRequiredDetails.set(partId, details);
                            }
                            details.serviceUsage.push({
                                serviceId: serviceId,
                                serviceName: serviceName,
                                quantity: quantity
                            });
                            details.total += quantity;
                        });
                    } catch (e) {
                        console.error('Error parsing used spare parts for service ' + serviceId + ':', e);
                    }
                }
            });
            
            return sparePartRequiredDetails;
        }
        
        function validateSparePartAvailability() {
            const requiredDetails = calculateRequiredQuantities();
            const errors = [];

            requiredDetails.forEach((details, sparePartId) => {
                const requiredQty = details.total;
                const checkbox = document.querySelector(`input[name="selectedSpareParts"][value="${sparePartId}"]`);
                if (checkbox) {
                    const availableQty = parseInt(checkbox.dataset.availableQuantity) || 0;
                    if (requiredQty > availableQty) {
                        const sparePartName = checkbox.dataset.name || `Phụ tùng ID ${sparePartId}`;
                        errors.push({
                            sparePartId: sparePartId,
                            sparePartName: sparePartName,
                            customerOrder: details.customerOrder,
                            serviceUsage: details.serviceUsage,
                            required: requiredQty,
                            available: availableQty,
                            shortage: requiredQty - availableQty
                        });
                    }
                } else {

                    const allSparePartCheckboxes = document.querySelectorAll('input[name="selectedSpareParts"]');
                    let found = false;
                    allSparePartCheckboxes.forEach(cb => {
                        if (cb.value === sparePartId) {
                            found = true;
                            const availableQty = parseInt(cb.dataset.availableQuantity) || 0;
                            if (requiredQty > availableQty) {
                                const sparePartName = cb.dataset.name || `Phụ tùng ID ${sparePartId}`;
                                errors.push({
                                    sparePartId: sparePartId,
                                    sparePartName: sparePartName,
                                    customerOrder: details.customerOrder,
                                    serviceUsage: details.serviceUsage,
                                    required: requiredQty,
                                    available: availableQty,
                                    shortage: requiredQty - availableQty
                                });
                            }
                        }
                    });

                    if (!found) {
                        console.warn('Spare part ID ' + sparePartId + ' not found on page but required: ' + requiredQty);

                        errors.push({
                            sparePartId: sparePartId,
                            sparePartName: `Phụ tùng ID ${sparePartId}`,
                            customerOrder: details.customerOrder,
                            serviceUsage: details.serviceUsage,
                            required: requiredQty,
                            available: 0,
                            shortage: requiredQty
                        });
                    }
                }
            });

            const proceedBtn = document.getElementById('proceedBtn');
            if (errors.length > 0) {

                let errorMessages = [];
                errors.forEach(e => {
                    let message = `📦 "${e.sparePartName}"\n`;
                    message += `   • Tổng cần: ${e.required} sản phẩm\n`;
                    message += `   • Có sẵn: ${e.available} sản phẩm\n`;
                    message += `   • Thiếu: ${e.shortage} sản phẩm\n`;
                    
                    if (e.customerOrder > 0) {
                        message += `   • Từ đơn hàng khách: ${e.customerOrder} sản phẩm\n`;
                    }
                    
                    if (e.serviceUsage && e.serviceUsage.length > 0) {
                        message += `   • Từ dịch vụ:\n`;
                        e.serviceUsage.forEach(su => {
                            message += `     - ${su.serviceName}: ${su.quantity} sản phẩm\n`;
                        });
                    }
                    
                    errorMessages.push(message);
                });
                
                showToast(`⚠️ SỐ LƯỢNG PHỤ TÙNG KHÔNG ĐỦ:\n\n${errorMessages.join('\n')}`, 'warning');

                if (proceedBtn) {
                    proceedBtn.disabled = true;
                }

                errors.forEach(error => {
                    const checkbox = document.querySelector(`input[name="selectedSpareParts"][value="${error.sparePartId}"]`);
                    if (checkbox) {
                        const row = checkbox.closest('tr');
                        if (row) {
                            row.classList.add('insufficient-stock');
                        }
                    }
                });
            } else {

                document.querySelectorAll('tr.insufficient-stock').forEach(row => {
                    row.classList.remove('insufficient-stock');
                });

                if (proceedBtn) {
                    const totalItems = selectedServices.length + selectedSpareParts.length;
                    proceedBtn.disabled = totalItems === 0;
                }
            }
            
            return errors;
        }
        
        function updateSelectedItems() {
            console.log('updateSelectedItems called');
            updateSelectedServices();
            updateSelectedSpareParts();
            renderSelectedItems();
            updateTotalAmount();
            saveToLocalStorage();
        }
        
        function onCheckboxChange() {
            console.log('Checkbox changed, updating...');
            updateSelectedItems();
            validateSparePartAvailability();
        }
        
        function updateSelectedServices() {

            const allServiceCheckboxes = document.querySelectorAll('input[name="selectedServices"]');
            const allServiceIdsOnPage = Array.from(allServiceCheckboxes).map(cb => cb.value);

            const servicesFromPage = Array.from(allServiceCheckboxes)
                .filter(cb => cb.checked)
                .map(cb => {
                    const name = cb.dataset.name || 'Unknown Service';
                    const price = parseFloat(cb.dataset.price) || 0;
                    console.log('Service data:', { id: cb.value, name, price });
                    return {
                        id: cb.value,
                        name: name,
                        price: price
                    };
                });

            const servicesNotOnPage = selectedServices.filter(s => !allServiceIdsOnPage.includes(String(s.id)));

            selectedServices = [...servicesNotOnPage, ...servicesFromPage];
            
            console.log('Updated selectedServices:', selectedServices);

            const serviceIds = selectedServices.map(s => s.id).join(',');
            if (serviceIds) {
                localStorage.setItem('lastServiceIds', serviceIds);
            } else {
                localStorage.removeItem('lastServiceIds');
            }
        }
        
        function updateSelectedSpareParts() {

            const allSparePartCheckboxes = document.querySelectorAll('input[name="selectedSpareParts"]');
            const allSparePartIdsOnPage = Array.from(allSparePartCheckboxes).map(cb => cb.value);

            const sparePartsFromPage = Array.from(allSparePartCheckboxes)
                .filter(cb => cb.checked)
                .map(cb => {
                const row = cb.closest('tr');
                const quantityInput = row.querySelector('.quantity-input');
                const availableQuantity = parseInt(cb.dataset.availableQuantity) || 0;
                let quantity = quantityInput ? parseInt(quantityInput.value) || 1 : 1;

                if (quantity > availableQuantity) {
                    quantity = availableQuantity;
                    if (quantityInput) {

                        const originalOnChange = quantityInput.onchange;
                        const originalOnBlur = quantityInput.onblur;
                        quantityInput.onchange = null;
                        quantityInput.onblur = null;
                        quantityInput.value = availableQuantity;

                        setTimeout(() => {
                            quantityInput.onchange = originalOnChange;
                            quantityInput.onblur = originalOnBlur;
                        }, 0);
                        showError(quantityInput, `Số lượng tối đa: ${availableQuantity}`);
                    }
                    showToast(`Số lượng "${cb.dataset.name}" đã được điều chỉnh về ${availableQuantity} (số lượng tối đa có sẵn).`, 'warning');
                }
                
                const name = cb.dataset.name || 'Unknown Spare Part';
                const price = parseFloat(cb.dataset.price) || 0;
                console.log('Spare part data:', { id: cb.value, name, price, quantity, availableQuantity });
                return {
                    id: cb.value,
                    name: name,
                    price: price,
                    quantity: quantity,
                    availableQuantity: availableQuantity
                };
            });

            const sparePartsNotOnPage = selectedSpareParts.filter(p => !allSparePartIdsOnPage.includes(String(p.id)));

            selectedSpareParts = [...sparePartsNotOnPage, ...sparePartsFromPage];
            
            console.log('Updated selectedSpareParts:', selectedSpareParts);
        }
        
        function renderSelectedItems() {
            const container = document.getElementById('selectedItems');
            container.innerHTML = '';
            
            console.log('Rendering from localStorage data:', { selectedServices, selectedSpareParts });
            
            if (selectedServices.length === 0 && selectedSpareParts.length === 0) {
                container.innerHTML = '<p style="color: #666; font-style: italic; text-align: center; padding: 1rem;">Chưa có dịch vụ hoặc phụ tùng nào được chọn</p>';
                setTimeout(adjustSelectedItemsListHeight, 50);
                return;
            }
            
            selectedServices.forEach(service => {
                const div = document.createElement('div');
                div.className = 'selected-item';
                const serviceName = service.name || 'Unknown Service';
                const servicePrice = service.price || 0;
                div.innerHTML = `
                    <div class="selected-item-info">
                        <div class="selected-item-name">🔧 ${serviceName}</div>
                        <div class="selected-item-details">Dịch vụ</div>
                    </div>
                    <div class="selected-item-actions">
                        <span class="price">₫${servicePrice.toLocaleString()}</span>
                        <button class="remove-btn" onclick="removeServiceById('${service.id}')">Bỏ chọn</button>
                    </div>
                `;
                container.appendChild(div);
            });
            
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
                    <div class="selected-item-actions">
                        <span class="price">₫${totalPrice.toLocaleString()}</span>
                        <button class="remove-btn" onclick="removeSparePartById('${part.id}')">Bỏ chọn</button>
                    </div>
                `;
                container.appendChild(div);
            });

            setTimeout(adjustSelectedItemsListHeight, 50);
        }
        
        function updateTotalAmount() {
            const totalServices = selectedServices.reduce((sum, service) => sum + (service.price || 0), 0);
            const totalSpareParts = selectedSpareParts.reduce((sum, part) => sum + ((part.price || 0) * (part.quantity || 1)), 0);
            const total = totalServices + totalSpareParts;
            
            const totalElement = document.getElementById('totalAmount');
            totalElement.textContent = `Tổng cộng: ₫${total.toLocaleString()}`;

            const serviceCountElement = document.getElementById('serviceCount');
            const sparePartCountElement = document.getElementById('sparePartCount');
            const totalItemsCountElement = document.getElementById('totalItemsCount');
            
            if (serviceCountElement) {
                serviceCountElement.textContent = selectedServices.length;
            }
            if (sparePartCountElement) {
                sparePartCountElement.textContent = selectedSpareParts.length;
            }
            if (totalItemsCountElement) {
                const totalItems = selectedServices.length + selectedSpareParts.length;
                totalItemsCountElement.textContent = totalItems;
            }
            
            const proceedBtn = document.getElementById('proceedBtn');
            const clearBtn = document.getElementById('clearBtn');
            const totalItems = selectedServices.length + selectedSpareParts.length;
            if (totalItems > 0) {
                proceedBtn.disabled = false;
                proceedBtn.textContent = `Tiếp tục (${totalItems} mục đã chọn)`;
                clearBtn.style.display = 'inline-block';
            } else {
                proceedBtn.disabled = true;
                proceedBtn.textContent = 'Tiếp tục (0 mục đã chọn)';
                clearBtn.style.display = 'none';
            }
        }
        
        function updateQuantity(checkbox) {
            const row = checkbox.closest('tr');
            const quantityInput = row.querySelector('.quantity-input');
            if (checkbox.checked) {
                quantityInput.disabled = false;
                const availableQuantity = parseInt(checkbox.dataset.availableQuantity) || 0;
                const currentValue = parseInt(quantityInput.value) || 1;
                const sparePartName = checkbox.dataset.name || 'phụ tùng';

                clearError(quantityInput);

                if (currentValue > availableQuantity) {

                    const originalOnChange = quantityInput.onchange;
                    quantityInput.onchange = null;
                    quantityInput.value = availableQuantity;

                    setTimeout(() => {
                        quantityInput.onchange = originalOnChange;
                    }, 0);
                    showError(quantityInput, `Số lượng tối đa: ${availableQuantity}`);
                    showToast(`Số lượng "${sparePartName}" đã được điều chỉnh về ${availableQuantity} (số lượng tối đa có sẵn).`, 'warning');
                } else if (currentValue < 1) {
                    const originalOnChange = quantityInput.onchange;
                    quantityInput.onchange = null;
                    quantityInput.value = 1;
                    setTimeout(() => {
                        quantityInput.onchange = originalOnChange;
                    }, 0);
                } else {
                    quantityInput.value = currentValue;
                }
            } else {
                quantityInput.disabled = true;
                quantityInput.value = '1';
                clearError(quantityInput);
            }
            onCheckboxChange();
        }
        
        function showError(quantityInput, message) {

            quantityInput.classList.add('error');

            const checkbox = quantityInput.closest('tr').querySelector('input[name="selectedSpareParts"]');
            if (checkbox) {
                const errorId = checkbox.value;
                const errorElement = document.getElementById(`error-${errorId}`);
                if (errorElement) {
                    errorElement.textContent = message;
                    errorElement.classList.add('show');
                }
            }
        }
        
        function clearError(quantityInput) {
            quantityInput.classList.remove('error');
            const errorId = quantityInput.closest('tr').querySelector('input[name="selectedSpareParts"]').value;
            const errorElement = document.getElementById(`error-${errorId}`);
            if (errorElement) {
                errorElement.classList.remove('show');
                errorElement.textContent = '';
            }
        }
        
        function showToast(message, type = 'error') {
            const toastContainer = document.getElementById('toastContainer');
            if (!toastContainer) return;
            
            const toast = document.createElement('div');
            toast.className = `toast ${type}`;
            
            const icons = {
                error: '❌',
                success: '✅',
                warning: '⚠️'
            };
            
            toast.innerHTML = `
                <div class="toast-icon">${icons[type] || icons.error}</div>
                <div class="toast-content">
                    <div class="toast-message">${message}</div>
                </div>
                <button class="toast-close" onclick="this.parentElement.remove()">×</button>
            `;
            
            toastContainer.appendChild(toast);

            setTimeout(() => {
                toast.style.animation = 'slideInRight 0.3s ease-out reverse';
                setTimeout(() => toast.remove(), 300);
            }, 5000);
        }
        
        function validateSparePartQuantityOnInput(quantityInput) {

            const availableQuantity = parseInt(quantityInput.dataset.availableQuantity) || 0;
            const requestedQuantity = parseInt(quantityInput.value) || 0;
            
            if (requestedQuantity < 1 || requestedQuantity > availableQuantity) {

                if (requestedQuantity > availableQuantity) {
                    showError(quantityInput, `Số lượng tối đa: ${availableQuantity}`);
                } else if (requestedQuantity < 1) {
                    showError(quantityInput, 'Số lượng phải lớn hơn 0!');
                }
            } else {

                clearError(quantityInput);
            }
        }
        
        function validateSparePartQuantity(quantityInput, preventUpdate = false) {
            const availableQuantity = parseInt(quantityInput.dataset.availableQuantity) || 0;
            const requestedQuantity = parseInt(quantityInput.value) || 0;
            const sparePartName = quantityInput.dataset.sparePartName || 'phụ tùng';
            
            if (requestedQuantity < 1) {

                const originalOnChange = quantityInput.onchange;
                const originalOnInput = quantityInput.oninput;
                quantityInput.onchange = null;
                quantityInput.oninput = null;
                quantityInput.value = 1;

                setTimeout(() => {
                    quantityInput.onchange = originalOnChange;
                    quantityInput.oninput = originalOnInput;
                }, 0);
                showError(quantityInput, 'Số lượng phải lớn hơn 0!');
                if (!preventUpdate) {

                    updateSelectedSparePartsSilently();
                }
                return false;
            }
            
            if (requestedQuantity > availableQuantity) {

                const originalOnChange = quantityInput.onchange;
                const originalOnInput = quantityInput.oninput;
                quantityInput.onchange = null;
                quantityInput.oninput = null;
                quantityInput.value = availableQuantity;

                setTimeout(() => {
                    quantityInput.onchange = originalOnChange;
                    quantityInput.oninput = originalOnInput;
                }, 0);
                showError(quantityInput, `Số lượng tối đa: ${availableQuantity}`);
                showToast(`Số lượng "${sparePartName}" đã được điều chỉnh về ${availableQuantity} (số lượng tối đa có sẵn).`, 'warning');
                if (!preventUpdate) {

                    updateSelectedSparePartsSilently();
                }
                return false;
            }

            clearError(quantityInput);
            return true;
        }
        
        function updateSelectedSparePartsSilently() {

            if (isProcessingValidation) {
                console.log('Skipping updateSelectedSparePartsSilently - validation in progress');
                return;
            }

            const allSparePartCheckboxes = document.querySelectorAll('input[name="selectedSpareParts"]');
            const allSparePartIdsOnPage = Array.from(allSparePartCheckboxes).map(cb => cb.value);

            const sparePartsFromPage = Array.from(allSparePartCheckboxes)
                .filter(cb => cb.checked)
                .map(cb => {
                    const row = cb.closest('tr');
                    const quantityInput = row.querySelector('.quantity-input');
                    const availableQuantity = parseInt(cb.dataset.availableQuantity) || 0;
                    let quantity = quantityInput ? parseInt(quantityInput.value) || 1 : 1;

                    if (quantity > availableQuantity) {
                        quantity = availableQuantity;
                    }
                    
                    const name = cb.dataset.name || 'Unknown Spare Part';
                    const price = parseFloat(cb.dataset.price) || 0;
                    return {
                        id: cb.value,
                        name: name,
                        price: price,
                        quantity: quantity,
                        availableQuantity: availableQuantity
                    };
                });

            const sparePartsNotOnPage = selectedSpareParts.filter(p => !allSparePartIdsOnPage.includes(String(p.id)));

            selectedSpareParts = [...sparePartsNotOnPage, ...sparePartsFromPage];

            renderSelectedItems();
            updateTotalAmount();
            saveToLocalStorage();
        }
        
        function updateSparePartQuantity(quantityInput) {

            if (!validateSparePartQuantity(quantityInput, false)) {
                return;
            }

            clearError(quantityInput);
            
            const row = quantityInput.closest('tr');
            const checkbox = row.querySelector('input[name="selectedSpareParts"]');
            if (checkbox && checkbox.checked) {
                onCheckboxChange();
            }
        }
        
        function removeServiceById(serviceId) {
            console.log('Removing service by ID:', serviceId);
            selectedServices = selectedServices.filter(service => service.id !== serviceId);
            
            const checkbox = document.querySelector(`input[name="selectedServices"][value="${serviceId}"]`);
            if (checkbox) {
                checkbox.checked = false;
            }

            const serviceIds = selectedServices.map(s => s.id).join(',');
            if (serviceIds) {
                localStorage.setItem('lastServiceIds', serviceIds);
            } else {
                localStorage.removeItem('lastServiceIds');
            }
            
            renderSelectedItems();
            updateTotalAmount();
            saveToLocalStorage();
        }
        
        function removeSparePartById(sparePartId) {
            console.log('Removing spare part by ID:', sparePartId);
            selectedSpareParts = selectedSpareParts.filter(part => part.id !== sparePartId);
            
            const checkbox = document.querySelector(`input[name="selectedSpareParts"][value="${sparePartId}"]`);
            if (checkbox) {
                checkbox.checked = false;
                const row = checkbox.closest('tr');
                const quantityInput = row.querySelector('.quantity-input');
                if (quantityInput) {
                    quantityInput.disabled = true;
                    quantityInput.value = '1';
                }
            }
            
            renderSelectedItems();
            updateTotalAmount();
            saveToLocalStorage();
        }
        
        window.removeServiceById = removeServiceById;
        window.removeSparePartById = removeSparePartById;
        window.validateSparePartQuantity = validateSparePartQuantity;
        window.validateSparePartQuantityOnInput = validateSparePartQuantityOnInput;
        
        function proceedToNext() {

            if (isProcessingValidation) {
                console.log('Validation is being processed, blocking navigation');
                return;
            }

            const activeElement = document.activeElement;
            if (activeElement && activeElement.classList.contains('quantity-input')) {
                activeElement.blur();

                setTimeout(() => {
                    proceedToNextInternal();
                }, 50);
                return;
            }
            
            proceedToNextInternal();
        }
        
        function proceedToNextInternal() {

            const proceedBtn = document.getElementById('proceedBtn');
            if (proceedBtn) {
                proceedBtn.disabled = true;
            }

            let hasInvalidQuantity = false;
            let firstInvalidInput = null;
            let invalidParts = [];

            const checkedSparePartCheckboxes = document.querySelectorAll('input[name="selectedSpareParts"]:checked');
            
            checkedSparePartCheckboxes.forEach(checkbox => {
                const row = checkbox.closest('tr');
                const quantityInput = row.querySelector('.quantity-input');
                
                if (quantityInput && !quantityInput.disabled) {
                    const availableQuantity = parseInt(checkbox.dataset.availableQuantity) || 0;
                    const requestedQuantity = parseInt(quantityInput.value) || 0;

                    if (requestedQuantity < 1 || requestedQuantity > availableQuantity) {
                        hasInvalidQuantity = true;
                        if (!firstInvalidInput) {
                            firstInvalidInput = quantityInput;
                        }
                        invalidParts.push({
                            name: checkbox.dataset.name || 'phụ tùng',
                            requested: requestedQuantity,
                            available: availableQuantity,
                            input: quantityInput
                        });
                    }
                }
            });

            if (hasInvalidQuantity) {

                isProcessingValidation = true;

                invalidParts.forEach(part => {
                    const correctedQuantity = Math.min(Math.max(part.requested, 1), part.available);

                    const originalOnChange = part.input.onchange;
                    const originalOnBlur = part.input.onblur;
                    const originalOnInput = part.input.oninput;
                    part.input.onchange = null;
                    part.input.onblur = null;
                    part.input.oninput = null;
                    part.input.value = correctedQuantity;

                    setTimeout(() => {
                        part.input.onchange = originalOnChange;
                        part.input.onblur = originalOnBlur;
                        part.input.oninput = originalOnInput;
                    }, 200);
                    
                    if (part.requested > part.available) {
                        showError(part.input, `Số lượng tối đa: ${part.available}`);
                    } else if (part.requested < 1) {
                        showError(part.input, 'Số lượng phải lớn hơn 0!');
                    }
                });

                if (firstInvalidInput) {
                    showError(firstInvalidInput, `Số lượng không hợp lệ!`);
                }
                
                showToast('Một số phụ tùng có số lượng không hợp lệ. Đã tự động điều chỉnh. Vui lòng kiểm tra lại trước khi tiếp tục.', 'error');

                setTimeout(() => {

                    const wasProcessing = isProcessingValidation;
                    isProcessingValidation = false;
                    updateSelectedSparePartsSilently();
                    isProcessingValidation = wasProcessing;
                }, 250);

                setTimeout(() => {
                    isProcessingValidation = false;
                    if (proceedBtn) {
                        proceedBtn.disabled = false;
                    }
                }, 1500);

                return;
            }

            if (proceedBtn) {
                proceedBtn.disabled = false;
            }

            const validationErrors = validateSparePartAvailability();
            if (validationErrors.length > 0) {

                let errorMessages = [];
                validationErrors.forEach(e => {
                    let message = `📦 "${e.sparePartName}"\n`;
                    message += `   • Tổng cần: ${e.required} sản phẩm\n`;
                    message += `   • Có sẵn: ${e.available} sản phẩm\n`;
                    message += `   • Thiếu: ${e.shortage} sản phẩm\n`;
                    
                    if (e.customerOrder > 0) {
                        message += `   • Từ đơn hàng khách: ${e.customerOrder} sản phẩm\n`;
                    }
                    
                    if (e.serviceUsage && e.serviceUsage.length > 0) {
                        message += `   • Từ dịch vụ:\n`;
                        e.serviceUsage.forEach(su => {
                            message += `     - ${su.serviceName}: ${su.quantity} sản phẩm\n`;
                        });
                    }
                    
                    errorMessages.push(message);
                });
                
                showToast(`❌ KHÔNG THỂ TIẾP TỤC - SỐ LƯỢNG PHỤ TÙNG KHÔNG ĐỦ:\n\n${errorMessages.join('\n')}`, 'error');
                if (proceedBtn) {
                    proceedBtn.disabled = false;
                }
                return;
            }

            updateSelectedItems();
            
            const totalItems = selectedServices.length + selectedSpareParts.length;
            if (totalItems === 0) {
                showToast('Vui lòng chọn ít nhất một dịch vụ hoặc phụ tùng!', 'warning');
                return;
            }
            
            const urlParams = new URLSearchParams(window.location.search);
            const customerId = urlParams.get('customerId');
            const vehicleId = urlParams.get('vehicleId');
            const noCar = urlParams.get('noCar');
            const isNoCarMode = noCar === 'true';
            
            if (!customerId) {
                showToast('Thiếu thông tin khách hàng!', 'error');
                return;
            }

            if (isNoCarMode) {
                selectedServices = [];
            }

            localStorage.setItem('selectedServices', JSON.stringify(selectedServices));
            localStorage.setItem('selectedSpareParts', JSON.stringify(selectedSpareParts));
            
            if (isNoCarMode) {

                localStorage.removeItem('lastServiceIds');
                window.location.href = `payment-invoice?customerId=${customerId}&noCar=true`;
            } else {
                if (!vehicleId) {
                    showToast('Thiếu thông tin xe!', 'error');
                    return;
                }

                const serviceIds = selectedServices.map(s => s.id).join(',');
                if (serviceIds) {

                    localStorage.setItem('lastServiceIds', serviceIds);
                    window.location.href = `technician?customerId=${customerId}&vehicleId=${vehicleId}&serviceIds=${serviceIds}`;
                } else {

                    localStorage.removeItem('lastServiceIds');
                    window.location.href = `payment-invoice?customerId=${customerId}&vehicleId=${vehicleId}`;
                }
            }
        }
        
        function clearAllSelections() {
            console.log('Clearing all selections...');
            
            selectedServices = [];
            selectedSpareParts = [];
            
            document.querySelectorAll('input[name="selectedServices"]:checked').forEach(cb => cb.checked = false);
            document.querySelectorAll('input[name="selectedSpareParts"]:checked').forEach(cb => {
                cb.checked = false;
                const row = cb.closest('tr');
                const quantityInput = row.querySelector('.quantity-input');
                if (quantityInput) {
                    quantityInput.disabled = true;
                    quantityInput.value = '1';
                }
            });
            
            localStorage.removeItem('selectedServices');
            localStorage.removeItem('selectedSpareParts');
            
            renderSelectedItems();
            updateTotalAmount();
            
            console.log('All selections cleared');
        }

        function adjustTableHeight() {
            const tableContainers = document.querySelectorAll('.table-container');
            
            tableContainers.forEach(container => {
                const table = container.querySelector('table');
                if (!table) return;
                
                const tbody = table.querySelector('tbody');
                if (!tbody) return;
                
                const rows = tbody.querySelectorAll('tr');
                if (rows.length === 0) return;
                
                const thead = table.querySelector('thead');
                const headerRow = thead ? thead.querySelector('tr') : null;
                if (!headerRow) return;

                const headerHeight = headerRow.offsetHeight;
                const firstRow = rows[0];
                const rowHeight = firstRow.offsetHeight;

                const resultsContainer = container.closest('.results-container');
                if (!resultsContainer) return;
                
                const resultsSection = resultsContainer.querySelector('.results-section');
                if (!resultsSection) return;
                
                const h3 = resultsSection.querySelector('h3');
                const h3Height = h3 ? h3.offsetHeight + 0.5 * 16 : 0;
                
                const containerPadding = 0.6 * 16 * 2;
                const availableHeight = resultsContainer.offsetHeight - h3Height - containerPadding;

                const maxVisibleRows = Math.floor((availableHeight - headerHeight) / rowHeight);
                
                if (maxVisibleRows <= 0) return;

                if (rows.length <= maxVisibleRows) {
                    container.style.maxHeight = (headerHeight + rows.length * rowHeight) + 'px';
                    container.style.overflowY = 'hidden';
                } else {

                    container.style.maxHeight = (headerHeight + maxVisibleRows * rowHeight) + 'px';
                    container.style.overflowY = 'auto';
                }
            });
        }

        window.addEventListener('DOMContentLoaded', function() {
            setTimeout(adjustTableHeight, 100);
        });

        window.addEventListener('resize', function() {
            setTimeout(adjustTableHeight, 100);
        });

        function adjustSelectedItemsListHeight() {
            const selectedItemsList = document.querySelector('.selected-items-list');
            if (!selectedItemsList) return;
            
            const selectedItems = selectedItemsList.querySelectorAll('.selected-item');
            if (selectedItems.length === 0) {
                selectedItemsList.style.maxHeight = 'auto';
                selectedItemsList.style.overflowY = 'hidden';
                return;
            }

            const firstItem = selectedItems[0];
            const itemHeight = firstItem.offsetHeight;
            const marginBottom = 0.3 * 16;

            const maxVisibleItems = 3;
            const totalHeight = (maxVisibleItems * itemHeight) + ((maxVisibleItems - 1) * marginBottom);
            
            if (selectedItems.length <= maxVisibleItems) {

                selectedItemsList.style.maxHeight = (selectedItems.length * itemHeight + (selectedItems.length - 1) * marginBottom) + 'px';
                selectedItemsList.style.overflowY = 'hidden';
            } else {

                selectedItemsList.style.maxHeight = totalHeight + 'px';
                selectedItemsList.style.overflowY = 'auto';
            }
        }

        window.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                adjustTableHeight();
                adjustSelectedItemsListHeight();
            }, 100);
        });

        window.addEventListener('resize', function() {
            setTimeout(function() {
                adjustTableHeight();
                adjustSelectedItemsListHeight();
            }, 100);
        });
        
    </script>
    
</body>
</html>
