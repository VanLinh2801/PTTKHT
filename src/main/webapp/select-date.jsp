<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<%@ page import="model.User" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%@ page import="controller.AppointmentController.SlotWithAvailability" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    LocalDate selectedDate = (LocalDate) request.getAttribute("selectedDate");
    List<SlotWithAvailability> slots = (List<SlotWithAvailability>) request.getAttribute("slots");
    Boolean isSunday = (Boolean) request.getAttribute("isSunday");
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    String sundayMessage = (String) request.getAttribute("sundayMessage");

    if ("GET".equalsIgnoreCase(request.getMethod()) && selectedDate == null && request.getParameter("date") == null) {
        LocalDate tomorrow = LocalDate.now().plusDays(1);

        if (tomorrow.getDayOfWeek().getValue() == 7) {
            tomorrow = tomorrow.plusDays(1);
        }

        String redirectUrl = "appointment?action=select&date=" + tomorrow.format(DateTimeFormatter.ISO_LOCAL_DATE);
        response.sendRedirect(redirectUrl);
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lịch hẹn - Garage Management</title>
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
        
        .header-btn {
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
        
        .header-btn:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .back-btn {
            background: rgba(255, 255, 255, 0.9);
            color: #2d3748;
            border: 2px solid rgba(255, 154, 158, 0.3);
            padding: 0.4rem 0.8rem;
            border-radius: 6px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 0.8rem;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            flex-shrink: 0;
            backdrop-filter: blur(10px);
            margin-top: auto;
        }
        
        .back-btn:hover {
            background: white;
            border-color: #ff9a9e;
            color: #ff9a9e;
            transform: translateY(-1px);
            box-shadow: 0 3px 10px rgba(255, 154, 158, 0.2);
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0.5rem 1rem;
            height: calc(100vh - 70px);
            display: flex;
            flex-direction: column;
            position: relative;
            z-index: 1;
            gap: 0.5rem;
            overflow: hidden;
        }
        
        .page-title {
            background: white;
            padding: 1rem;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            text-align: center;
            flex-shrink: 0;
        }
        
        .page-title h2 {
            color: #2d3748;
            margin-bottom: 0.4rem;
            font-size: 1.3rem;
            font-weight: 700;
        }
        
        .page-title p {
            color: #718096;
            font-size: 0.9rem;
        }
        
        .date-selector {
            background: white;
            padding: 0.6rem 0.8rem;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            flex-shrink: 0;
        }
        
        .date-selector h3 {
            color: #2d3748;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
            font-weight: 700;
        }
        
        .date-input-group {
            display: flex;
            gap: 0.8rem;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .date-input {
            padding: 0.6rem 0.6rem 0.6rem 2.5rem;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 0.9rem;
            min-width: 200px;
            flex: 1;
            background: #f7fafc;
            transition: all 0.3s ease;
        }
        
        .date-input:focus {
            outline: none;
            border-color: #ff9a9e;
            background: white;
            box-shadow: 0 0 0 3px rgba(255, 154, 158, 0.1);
        }
        
        .btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 50%, #28a745 100%);
            color: white;
            border: none;
            padding: 0.6rem 1.2rem;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            font-size: 0.9rem;
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
        }
        
        .slots-container {
            background: white;
            padding: 0.6rem;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            flex: 1;
            min-height: 0;
            display: flex;
            flex-direction: column;
            margin-bottom: 0.5rem;
            overflow: hidden;
        }
        
        .slots-container h3 {
            color: #2d3748;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
            font-weight: 700;
            flex-shrink: 0;
            padding-bottom: 0.4rem;
            border-bottom: 2px solid #f1f1f1;
        }
        
        .slots-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 0.5rem;
            overflow-y: auto;
            overflow-x: hidden;
            padding: 0.4rem;
            flex: 1;
            min-height: 0;
        }
        
        @media (max-width: 1400px) {
            .slots-grid {
                grid-template-columns: repeat(4, 1fr);
            }
        }
        
        @media (max-width: 1100px) {
            .slots-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }
        
        @media (max-width: 800px) {
            .slots-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        .slots-grid::-webkit-scrollbar {
            width: 8px;
        }
        
        .slots-grid::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
            margin: 0.5rem 0;
        }
        
        .slots-grid::-webkit-scrollbar-thumb {
            background: #ff9a9e;
            border-radius: 10px;
        }
        
        .slots-grid::-webkit-scrollbar-thumb:hover {
            background: #fecfef;
        }
        
        .slot-card {
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            padding: 0.7rem;
            transition: all 0.3s ease;
            flex-shrink: 0;
            display: flex;
            flex-direction: column;
            min-height: 90px;
            position: relative;
        }
        
        .slot-card.available {
            border-color: #28a745;
            background: #f8fff9;
            cursor: pointer;
        }
        
        .slot-card.available:hover {
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.25);
            transform: translateY(-3px);
            border-color: #20c997;
        }
        
        .slot-card.available.selected {
            border-color: #20c997;
            background: #e8f5e9;
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }
        
        .slot-card input[type="radio"] {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }
        
        .slot-card.unavailable {
            border-color: #dc3545;
            background: #fff8f8;
            opacity: 0.7;
        }
        
        .slot-card.existing {
            border-color: #ffc107;
            background: #fffdf5;
        }
        
        .slot-time {
            font-size: 0.9rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 0.4rem;
            line-height: 1.2;
        }
        
        .slot-info {
            color: #718096;
            margin-bottom: 0.5rem;
            font-size: 0.8rem;
            line-height: 1.3;
        }
        
        .slot-status {
            padding: 0.4rem 0.7rem;
            border-radius: 10px;
            font-size: 0.75rem;
            font-weight: 600;
            text-align: center;
            margin-top: auto;
        }

        .status-available {
            background: #d4edda;
            color: #155724;
        }
        
        .status-unavailable {
            background: #f8d7da;
            color: #721c24;
        }
        
        .status-existing {
            background: #fff3cd;
            color: #856404;
        }
        
        .slot-radio {
            margin-right: 0.5rem;
        }
        
        .form-content {
            display: flex;
            flex-direction: column;
        }
        
        .action-buttons {
            display: none;
        }
        
        .bottom-buttons {
            display: flex;
            gap: 0.8rem;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            flex-shrink: 0;
            padding: 0.5rem 0;
        }
        
        .btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            transform: none;
        }
        
        .btn:disabled:hover {
            transform: none;
            box-shadow: 0 4px 12px rgba(255, 154, 158, 0.2);
        }
        
        .note-section {
            background: white;
            padding: 0.6rem;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            margin-bottom: 0.5rem;
            flex-shrink: 0;
            display: none;
            max-height: 100px;
        }
        
        .note-section.show {
            display: block;
        }
        
        .note-section h3 {
            color: #2d3748;
            margin-bottom: 0.4rem;
            font-size: 0.85rem;
            font-weight: 700;
        }
        
        .note-textarea {
            width: 100%;
            padding: 0.5rem;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 0.8rem;
            font-family: inherit;
            resize: none;
            min-height: 50px;
            max-height: 60px;
            background: #f7fafc;
            transition: all 0.3s ease;
        }
        
        .note-textarea:focus {
            outline: none;
            border-color: #ff9a9e;
            background: white;
            box-shadow: 0 0 0 3px rgba(255, 154, 158, 0.1);
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.9);
            color: #2d3748;
            border: 2px solid rgba(255, 154, 158, 0.3);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }
        
        .btn-secondary:hover {
            background: white;
            border-color: #ff9a9e;
            color: #ff9a9e;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 154, 158, 0.2);
        }
        
        .alert {
            padding: 0.5rem 0.8rem;
            border-radius: 8px;
            margin-bottom: 0.5rem;
            font-size: 0.8rem;
            flex-shrink: 0;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .no-slots {
            text-align: center;
            color: #718096;
            font-style: italic;
            padding: 1rem;
            font-size: 0.9rem;
        }
        
        .no-slots h4 {
            color: #2d3748;
            margin-bottom: 0.8rem;
            font-size: 1.1rem;
            font-weight: 700;
        }
        
        .no-slots ul {
            list-style-type: none;
            padding: 0;
        }
        
        .no-slots li {
            padding: 0.5rem 0;
            border-bottom: 1px solid #eee;
        }
        
        .no-slots li:last-child {
            border-bottom: none;
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
        
        .toast-success {
            background: #28a745;
        }
        
        .toast-success::before {
            content: '✓';
        }
        
        .toast-warning {
            background: #ffc107;
            color: #856404;
        }
        
        .toast-warning::before {
            content: '⚠️';
        }
        
        .toast-error {
            background: #dc3545;
        }
        
        .toast-error::before {
            content: '✕';
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <div class="logo">
                <h1>Đặt Lịch Hẹn</h1>
            </div>
            <div class="user-info">
                <span>Xin chào, <%= user.getFullName() %>!</span>
                <a href="user?action=logout" class="header-btn">Đăng xuất</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        
        <% if (error != null) { %>
            <div class="alert alert-error">
                <%= error %>
            </div>
        <% } %>
        
        <div id="toast" class="toast"></div>
        <% if (success != null) { %>
            <script>

                window.successMessage = '<%= success %>';
            </script>
        <% } %>
        <% if (sundayMessage != null) { %>
            <script>

                window.sundayMessage = '<%= sundayMessage %>';
            </script>
        <% } %>
        
        <% if (message != null) { %>
            <div class="alert alert-error">
                <%= message %>
            </div>
        <% } %>
        
        <div class="date-selector">
            <h3>📅 Chọn ngày</h3>
            <form method="get" action="appointment">
                <input type="hidden" name="action" value="select">
                <div class="date-input-group">
                    <div style="position: relative; flex: 1;">
                        <span style="position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #718096; font-size: 1.1rem; pointer-events: none; z-index: 2;">📅</span>
                        <input type="date" name="date" class="date-input" 
                               value="<%= selectedDate != null ? selectedDate.format(DateTimeFormatter.ISO_LOCAL_DATE) : "" %>"
                               min="<%= LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE) %>"
                               style="padding-left: 45px;">
                    </div>
                    <button type="submit" class="btn">🔍 Xem lịch trống</button>
                </div>
            </form>
        </div>
        
        <% if (selectedDate != null) { %>
            <div class="slots-container">
                <h3>Khung giờ có sẵn ngày <%= selectedDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) %></h3>
                
                <% if (message != null && !message.isEmpty()) { %>
                    <div class="no-slots" style="flex: 1; display: flex; flex-direction: column; justify-content: center; align-items: center;">
                        <h4>⚠️ Thông báo</h4>
                        <p><%= message %></p>
                        <p><strong>Lưu ý:</strong> Mỗi khách hàng chỉ có thể đặt 1 lịch hẹn trong 1 ngày.</p>
                    </div>
                <% } else if (isSunday != null && isSunday) { %>
                    <div class="no-slots" style="flex: 1; display: flex; flex-direction: column; justify-content: center; align-items: center;">
                        <h4>🏖️ Chủ nhật nghỉ làm việc</h4>
                        <p>Chúng tôi không hoạt động vào chủ nhật. Vui lòng chọn ngày khác trong tuần.</p>
                        <p><strong>Lịch làm việc:</strong></p>
                        <ul style="text-align: left; max-width: 400px; margin: 1rem auto;">
                            <li>Thứ 2 - Thứ 6: 7h-12h và 13h-18h</li>
                            <li>Thứ 7: 7h-12h</li>
                            <li>Chủ nhật: Nghỉ</li>
                        </ul>
                    </div>
                <% } else if (slots != null && !slots.isEmpty()) { %>
                    <form method="post" action="appointment" class="form-content" id="appointmentForm">
                        <input type="hidden" name="action" value="create">
                        <input type="hidden" name="date" value="<%= selectedDate.format(DateTimeFormatter.ISO_LOCAL_DATE) %>">
                        
                        <div class="slots-grid">
                            <% for (SlotWithAvailability slotWithAvailability : slots) { %>
                                <div class="slot-card <%= slotWithAvailability.hasExistingAppointment() ? "existing" : (slotWithAvailability.isPast() ? "unavailable" : "available") %>">
                                    <div class="slot-time">
                                        <%= slotWithAvailability.getStartAt().toString() %> - <%= slotWithAvailability.getEndAt().toString() %>
                                    </div>
                                    
                                    <% if (slotWithAvailability.hasExistingAppointment()) { %>
                                        <div class="slot-status status-existing">
                                            ✅ Bạn đã có lịch hẹn
                                        </div>
                                    <% } else if (slotWithAvailability.isPast()) { %>
                                        <div class="slot-status status-unavailable">
                                            ⏰ Đã qua
                                        </div>
                                    <% } else { %>
                                        <div class="slot-status status-available">
                                            🟢 Còn trống
                                        </div>
                                        <input type="radio" name="slotTime" value="<%= slotWithAvailability.getStartAt().toString() %>" 
                                               class="slot-radio" id="slot_<%= slotWithAvailability.getStartAt().toString().replace(":", "") %>"
                                               onchange="showNoteSection(); updateSelectedSlot(this);">
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                        
                    </form>
                <% } else { %>
                    <div class="no-slots" style="flex: 1; display: flex; flex-direction: column; justify-content: center; align-items: center;">
                        Không có khung giờ nào có sẵn cho ngày này.
                    </div>
                <% } %>
            </div>
            
            <% if (slots != null && !slots.isEmpty() && (message == null || message.isEmpty()) && (isSunday == null || !isSunday)) { %>
                <div class="note-section" id="noteSection">
                    <h3>📝 Ghi chú (tùy chọn)</h3>
                    <textarea name="note" form="appointmentForm" class="note-textarea" 
                              placeholder="Nhập ghi chú về lịch hẹn của bạn..."></textarea>
                </div>
            <% } %>
        <% } %>
        
        <% if (selectedDate != null && slots != null && !slots.isEmpty() && (message == null || message.isEmpty()) && (isSunday == null || !isSunday)) { %>
            <div class="bottom-buttons">
                <a href="customer-home.jsp" class="back-btn">← Trở về trang chủ</a>
                <button type="submit" form="appointmentForm" class="btn" id="submitBtn" disabled>Đặt lịch →</button>
            </div>
        <% } else { %>
        <a href="customer-home.jsp" class="back-btn">← Trở về trang chủ</a>
        <% } %>
    </div>
    
    <script>

        function showNoteSection() {
            const noteSection = document.getElementById('noteSection');
            if (noteSection) {
                noteSection.classList.add('show');
            }
        }

        function updateSelectedSlot(radio) {

            const allSlots = document.querySelectorAll('.slot-card.available');
            allSlots.forEach(slot => {
                slot.classList.remove('selected');
            });

            const submitBtn = document.getElementById('submitBtn');

            if (radio && radio.checked) {
                const slotCard = radio.closest('.slot-card');
                if (slotCard) {
                    slotCard.classList.add('selected');
                }
                if (submitBtn) {
                    submitBtn.disabled = false;
                }
            } else {

                if (submitBtn) {
                    submitBtn.disabled = true;
                }
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const submitBtn = document.getElementById('submitBtn');
            const selectedRadio = document.querySelector('input[name="slotTime"]:checked');
            if (submitBtn) {
                submitBtn.disabled = !selectedRadio;
            }
        });

        document.addEventListener('DOMContentLoaded', function() {
            const slotCards = document.querySelectorAll('.slot-card.available');
            slotCards.forEach(card => {
                card.addEventListener('click', function(e) {

                    if (e.target.type === 'radio') {
                        return;
                    }
                    
                    const radio = this.querySelector('input[type="radio"]');
                    if (radio && !radio.disabled) {
                        radio.checked = true;
                        radio.dispatchEvent(new Event('change'));
                    }
                });
            });

            if (window.successMessage) {
                showToast(window.successMessage);
                window.successMessage = null;
            }

            if (window.sundayMessage) {

                showToast(window.sundayMessage, 'warning');
                window.sundayMessage = null;
            }
        });

        function showToast(message, type) {
            const toast = document.getElementById('toast');
            if (toast) {
                toast.textContent = message;

                toast.classList.remove('toast-success', 'toast-warning', 'toast-error');

                if (type === 'warning') {
                    toast.classList.add('toast-warning');
                } else if (type === 'error') {
                    toast.classList.add('toast-error');
                } else {
                    toast.classList.add('toast-success');
                }
                
                toast.classList.add('show');

                const hideDelay = type === 'warning' ? 4000 : 3000;
                setTimeout(function() {
                    toast.classList.remove('show');
                    toast.classList.add('hide');

                    setTimeout(function() {
                        toast.classList.remove('hide');
                    }, 300);
                }, hideDelay);
            }
        }
    </script>
</body>
</html>
