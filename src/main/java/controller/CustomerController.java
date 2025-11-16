package controller;

import model.User;
import dao.CustomerDao;
import dao.UserDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/customer")
public class CustomerController extends HttpServlet {
    private CustomerDao customerDao;
    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        super.init();
        customerDao = new CustomerDao();
        userDao = new UserDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addCustomerGet(request, response);
        } else if ("search".equals(action) || action == null) {

            searchCustomer(request, response);
        } else {

            response.sendRedirect("search-customer.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addCustomer(request, response);
        } else if ("search".equals(action)) {
            searchCustomer(request, response);
        } else {
            response.sendRedirect("search-customer.jsp");
        }
    }

    private void addCustomerGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.getRequestDispatcher("add-customer.jsp").forward(request, response);
    }

    private void addCustomer(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {

            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String dateOfBirth = request.getParameter("dateOfBirth");
            String account = request.getParameter("account");
            String password = request.getParameter("password");

            if (fullName == null || fullName.trim().isEmpty()) {
                request.setAttribute("error", "Họ tên là bắt buộc");
                request.getRequestDispatcher("add-customer.jsp").forward(request, response);
                return;
            }

            if (phone == null || phone.trim().isEmpty()) {
                request.setAttribute("error", "Số điện thoại là bắt buộc");
                request.getRequestDispatcher("add-customer.jsp").forward(request, response);
                return;
            }

            if (account == null || account.trim().isEmpty()) {
                request.setAttribute("error", "Tài khoản là bắt buộc");
                request.getRequestDispatcher("add-customer.jsp").forward(request, response);
                return;
            }

            if (password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "Mật khẩu là bắt buộc");
                request.getRequestDispatcher("add-customer.jsp").forward(request, response);
                return;
            }

            if (userDao.isAccountExists(account.trim())) {
                request.setAttribute("error", "Tài khoản đã tồn tại trong hệ thống");
                request.getRequestDispatcher("add-customer.jsp").forward(request, response);
                return;
            }

            if (customerDao.isPhoneExists(phone.trim())) {
                request.setAttribute("error", "Số điện thoại đã tồn tại trong hệ thống");
                request.getRequestDispatcher("add-customer.jsp").forward(request, response);
                return;
            }

            if (email != null && !email.trim().isEmpty()) {
                if (customerDao.isEmailExists(email.trim())) {
                    request.setAttribute("error", "Email đã tồn tại trong hệ thống");
                    request.getRequestDispatcher("add-customer.jsp").forward(request, response);
                    return;
                }
            }

            User newCustomer = new User();
            newCustomer.setFullName(fullName.trim());
            newCustomer.setPhone(phone.trim());
            newCustomer.setEmail(email != null ? email.trim() : "");
            newCustomer.setAccount(account.trim());
            newCustomer.setPassword(password.trim());
            if (dateOfBirth != null && !dateOfBirth.trim().isEmpty()) {
                newCustomer.setDateOfBirth(java.time.LocalDate.parse(dateOfBirth));
            }
            newCustomer.setRole("CUSTOMER");

            boolean success = customerDao.addCustomer(newCustomer);

            if (success) {
                request.setAttribute("message", "Thêm khách hàng thành công!");

                response.sendRedirect("search-customer.jsp");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi thêm khách hàng");
                request.getRequestDispatcher("add-customer.jsp").forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("add-customer.jsp").forward(request, response);
        }
    }

    private void searchCustomer(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String query = request.getParameter("query");
        System.out.println(">>> CustomerController.searchCustomer: query = " + query);
        
        try {
            if (query != null && !query.trim().isEmpty()) {

                List<User> customers = customerDao.searchCustomers(query.trim());
                System.out.println(">>> CustomerController.searchCustomer: found " + customers.size() + " customers");
                request.setAttribute("customers", customers);
                request.setAttribute("searchQuery", query.trim());
            } else {

                List<User> customers = customerDao.getAllCustomers();
                System.out.println(">>> CustomerController.searchCustomer: showing all " + customers.size() + " customers");
                request.setAttribute("customers", customers);
                request.setAttribute("searchQuery", "");
            }
        } catch (Exception e) {
            System.err.println(">>> CustomerController.searchCustomer: Error - " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách khách hàng: " + e.getMessage());
        }

        request.getRequestDispatcher("search-customer.jsp").forward(request, response);
    }
}

