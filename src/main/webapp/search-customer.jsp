<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<User> customers = (List<User>) request.getAttribute("customers");
    if (customers == null) {
        response.sendRedirect("customer?action=search");
        return;
    }
    
    String searchQuery = (String) request.getAttribute("searchQuery");
    if (searchQuery == null) searchQuery = "";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm khách hàng - Garage Management</title>
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
            max-width: 1200px;
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
        
        .search-section {
            background: white;
            padding: 0.8rem;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            margin-bottom: 0.5rem;
            flex-shrink: 0;
        }
        
        .search-form {
            display: flex;
            gap: 0.6rem;
            margin-bottom: 0.6rem;
            flex-wrap: wrap;
        }
        
        .search-input {
            flex: 1;
            min-width: 200px;
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
            font-size: 0.9rem;
        }
        
        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.3);
        }
        
        .search-btn:active {
            transform: translateY(0);
        }
        
        .action-buttons {
            display: flex;
            gap: 0.6rem;
            justify-content: flex-start;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 0.5rem 1rem;
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
        
        .results-section {
            background: white;
            padding: 0.8rem;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            flex: 1;
            min-height: 0;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        
        .results-section h3 {
            color: #1a1a1a;
            margin-bottom: 0.6rem;
            font-size: 1rem;
            font-weight: 700;
            flex-shrink: 0;
        }
        
        .table-container {
            overflow-x: auto;
            overflow-y: auto;
            flex: 1;
            min-height: 0;
            border-radius: 8px;
            position: relative;
            z-index: 10;
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
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            font-weight: 700;
            color: #1a1a1a;
            text-transform: uppercase;
            font-size: 0.8rem;
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
            padding: 1.5rem 1rem;
            color: #666;
            font-style: italic;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        
        .no-results p {
            margin-bottom: 0.8rem;
            font-size: 0.9rem;
        }
        
        .no-results a {
            color: #28a745;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }
        
        .no-results a:hover {
            color: #20c997;
            text-decoration: underline;
        }
        
        .customer-actions {
            display: flex;
            gap: 0.5rem;
        }
        
        .btn-sm {
            padding: 0.4rem 0.8rem;
            font-size: 0.8rem;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <div class="logo">
                <h1>Tìm kiếm khách hàng</h1>
            </div>
            <div class="user-info">
                <span>Xin chào, <%= user.getFullName() %>!</span>
                <a href="user?action=logout" class="logout-btn">Đăng xuất</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="search-section">
            <form action="customer" method="GET" class="search-form">
                <input type="hidden" name="action" value="search">
                <input type="text" name="query" class="search-input" 
                       placeholder="Nhập tên hoặc số điện thoại khách hàng..." 
                       value="<%= searchQuery %>">
                <button type="submit" class="search-btn">Tìm kiếm</button>
            </form>
            
            <div class="action-buttons">
                <a href="sales-staff-home.jsp" class="btn btn-secondary">Quay lại</a>
                <a href="customer?action=add" class="btn btn-success">Thêm khách hàng mới</a>
            </div>
        </div>
        
        <div class="results-section">
            <h3>Kết quả tìm kiếm</h3>
            
            <% if (customers != null && !customers.isEmpty()) { %>
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Họ tên</th>
                                <th>Số điện thoại</th>
                                <th>Email</th>
                                <th>Ngày sinh</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (User customer : customers) { %>
                                <tr>
                                    <td><%= customer.getId() %></td>
                                    <td><strong><%= customer.getFullName() %></strong></td>
                                    <td><%= customer.getPhone() %></td>
                                    <td><%= customer.getEmail() %></td>
                                    <td><%= customer.getDateOfBirth() != null ? customer.getDateOfBirth().toString() : "" %></td>
                                    <td class="customer-actions">
                                        <a href="vehicle?action=list&customerId=<%= customer.getId() %>" 
                                           class="btn btn-primary btn-sm">Nhận yêu cầu</a>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else if (searchQuery != null && !searchQuery.isEmpty()) { %>
                <div class="no-results">
                    <p>Không tìm thấy khách hàng nào với từ khóa "<%= searchQuery %>"</p>
                    <p>Vui lòng thử lại với từ khóa khác hoặc <a href="customer?action=add">thêm khách hàng mới</a></p>
                </div>
            <% } else { %>
                <div class="no-results">
                    <p>Nhập từ khóa tìm kiếm để bắt đầu tìm kiếm khách hàng</p>
                </div>
            <% } %>
        </div>
    </div>
    
    <script>

        window.addEventListener('DOMContentLoaded', function() {
            const tableContainer = document.querySelector('.table-container');
            const tbody = tableContainer?.querySelector('tbody');
            const resultsSection = document.querySelector('.results-section');
            
            if (tableContainer && tbody && resultsSection) {
                const rows = tbody.querySelectorAll('tr');
                const rowCount = rows.length;
                
                if (rowCount > 0) {
                    const firstRow = rows[0];
                    const rowHeight = firstRow.offsetHeight;

                    const thead = tableContainer.querySelector('thead');
                    const headerHeight = thead ? thead.offsetHeight : 0;

                    const resultsSectionHeight = resultsSection.offsetHeight;
                    const h3Height = resultsSection.querySelector('h3')?.offsetHeight || 0;

                    const marginInPixels = 0.6 * 16 * 2;
                    const availableHeight = resultsSectionHeight - h3Height - marginInPixels;

                    const maxVisibleRows = Math.floor((availableHeight - headerHeight) / rowHeight);
                    const maxDisplayRows = 15;
                    const displayRows = Math.min(maxVisibleRows, maxDisplayRows);
                    
                    if (rowCount <= maxVisibleRows) {
                        const exactHeight = headerHeight + rowCount * rowHeight;
                        tableContainer.style.maxHeight = exactHeight + 'px';
                        tableContainer.style.overflowY = 'hidden';
                    } else {
                        const exactHeight = headerHeight + displayRows * rowHeight;
                        tableContainer.style.maxHeight = exactHeight + 'px';
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
