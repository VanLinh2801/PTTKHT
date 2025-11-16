package controller;

import dao.UserDao;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@WebServlet("/user")
public class UserController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("login".equals(action)) {
            loginGet(request, response);
        } else if ("logout".equals(action)) {
            logout(request, response);
        } else if ("register".equals(action)) {
            registerGet(request, response);
        } else {

            loginGet(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("login".equals(action)) {
            loginPost(request, response);
        } else if ("register".equals(action)) {
            registerPost(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    private void loginGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            String redirectUrl = getRedirectUrlByRole(user.getRole());
            response.sendRedirect(redirectUrl);
            return;
        }
        
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    private void loginPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String account = request.getParameter("account");
        String password = request.getParameter("password");
        
        if (account == null || password == null || account.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }
        
        User user = authenticateUser(account, password);
        
        if (user != null) {

            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("userName", user.getFullName());

            String redirectUrl = getRedirectUrlByRole(user.getRole());
            response.sendRedirect(redirectUrl);
        } else {
            request.setAttribute("error", "Tài khoản hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        response.sendRedirect("login.jsp?message=logout_success");
    }

    private void registerGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    private void registerPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String fullName = request.getParameter("fullName");
        String account = request.getParameter("account");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String role = "CUSTOMER";

        if (!validateInput(request, fullName, account, password, confirmPassword, email, phoneNumber)) {
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        UserDao userDao = new UserDao();
        if (userDao.isAccountExists(account)) {
            request.setAttribute("error", "Tài khoản đã tồn tại!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (userDao.isEmailExists(email)) {
            request.setAttribute("error", "Email đã tồn tại!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        LocalDate dateOfBirth = null;
        if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
            try {
                dateOfBirth = LocalDate.parse(dateOfBirthStr, DateTimeFormatter.ISO_LOCAL_DATE);
            } catch (Exception e) {
                request.setAttribute("error", "Ngày sinh không hợp lệ!");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
        }
        
        User newUser = new User(fullName, account, password, dateOfBirth, email, phoneNumber, role);
        
        if (userDao.register(newUser)) {
            request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi đăng ký. Vui lòng thử lại!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    private User authenticateUser(String account, String password) {
        UserDao userDao = new UserDao();
        return userDao.login(account, password);
    }

    private String getRedirectUrlByRole(String role) {
        switch (role) {
            case "CUSTOMER":
                return "customer-home.jsp";
            case "SALES_STAFF":
                return "sales-staff-home.jsp";
            default:
                return "home.jsp";
        }
    }

    private boolean validateInput(HttpServletRequest request, String fullName, String account, 
                                String password, String confirmPassword, String email, String phoneNumber) {
        
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập họ tên!");
            return false;
        }
        
        if (account == null || account.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập tài khoản!");
            return false;
        }
        
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mật khẩu!");
            return false;
        }
        
        if (password.length() < 8) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự!");
            return false;
        }

        if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$")) {
            request.setAttribute("error", "Mật khẩu phải chứa ít nhất 1 chữ hoa, 1 chữ thường, 1 số và 1 ký tự đặc biệt (@$!%*?&)!");
            return false;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            return false;
        }
        
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email!");
            return false;
        }
        
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            request.setAttribute("error", "Email không hợp lệ! Vui lòng nhập đúng định dạng email.");
            return false;
        }

        if (phoneNumber != null && !phoneNumber.trim().isEmpty()) {

            String cleanPhone = phoneNumber.replaceAll("[^0-9]", "");

            if (!cleanPhone.matches("^0[0-9]{9,10}$")) {
                request.setAttribute("error", "Số điện thoại không hợp lệ! Vui lòng nhập số điện thoại Việt Nam (10-11 số, bắt đầu bằng 0).");
                return false;
            }
        }
        
        return true;
    }
}

