package controller;

import model.User;
import model.Car;
import dao.CustomerDao;
import dao.CarDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/vehicle")
public class CarController extends HttpServlet {
    private CustomerDao customerDao;
    private CarDao carDao;

    @Override
    public void init() throws ServletException {
        super.init();
        customerDao = new CustomerDao();
        carDao = new CarDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addCarGet(request, response);
        } else if ("list".equals(action) || action == null) {

            listCars(request, response);
        } else {

            response.sendRedirect("search-customer.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addCar(request, response);
        } else {
            response.sendRedirect("search-customer.jsp");
        }
    }

    private void addCar(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {

            String customerIdStr = request.getParameter("customerId");
            String licensePlate = request.getParameter("licensePlate");
            String brand = request.getParameter("brand");
            String model = request.getParameter("model");
            String description = request.getParameter("description");
            String yearOfManufactureStr = request.getParameter("yearOfManufacture");
            String mileageStr = request.getParameter("mileage");

            if (customerIdStr == null || customerIdStr.trim().isEmpty()) {
                request.setAttribute("error", "ID khách hàng không hợp lệ");
                request.getRequestDispatcher("add-car.jsp").forward(request, response);
                return;
            }

            if (licensePlate == null || licensePlate.trim().isEmpty()) {
                request.setAttribute("error", "Biển số xe là bắt buộc");
                request.getRequestDispatcher("add-car.jsp").forward(request, response);
                return;
            }

            if (brand == null || brand.trim().isEmpty()) {
                request.setAttribute("error", "Hãng xe là bắt buộc");
                request.getRequestDispatcher("add-car.jsp").forward(request, response);
                return;
            }

            if (carDao.isLicensePlateExists(licensePlate.trim())) {
                request.setAttribute("error", "Biển số xe đã tồn tại trong hệ thống");
                request.getRequestDispatcher("add-car.jsp").forward(request, response);
                return;
            }

            Car newCar = new Car();
            newCar.setLicensePlate(licensePlate.trim());
            newCar.setBrand(brand.trim());
            newCar.setModel(model != null ? model.trim() : "");
            newCar.setDescription(description != null ? description.trim() : "");
            
            if (yearOfManufactureStr != null && !yearOfManufactureStr.trim().isEmpty()) {
                newCar.setYearOfManufacture(Integer.parseInt(yearOfManufactureStr));
            }
            
            if (mileageStr != null && !mileageStr.trim().isEmpty()) {
                newCar.setMileage(Integer.parseInt(mileageStr));
            }
            
            newCar.setCustomerId(Integer.parseInt(customerIdStr));

            boolean success = carDao.addCar(newCar);

            if (success) {
                request.setAttribute("message", "Thêm xe thành công!");

                response.sendRedirect("vehicle?action=list&customerId=" + customerIdStr);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi thêm xe");
                request.getRequestDispatcher("add-car.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu số không hợp lệ");
            request.getRequestDispatcher("add-car.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("add-car.jsp").forward(request, response);
        }
    }

    private void addCarGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession();
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

        request.getRequestDispatcher("add-car.jsp").forward(request, response);
    }

    private void listCars(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String customerIdStr = request.getParameter("customerId");
        if (customerIdStr == null || customerIdStr.trim().isEmpty()) {
            response.sendRedirect("search-customer.jsp");
            return;
        }

        try {
            int customerId = Integer.parseInt(customerIdStr);

            User customer = customerDao.getCustomerById(customerId);
            if (customer == null) {
                request.setAttribute("error", "Không tìm thấy khách hàng");
                request.getRequestDispatcher("search-customer.jsp").forward(request, response);
                return;
            }

            List<Car> cars = carDao.getCarsByCustomerId(customerId);
            
            request.setAttribute("customer", customer);
            request.setAttribute("vehicles", cars);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID khách hàng không hợp lệ");
            response.sendRedirect("search-customer.jsp");
            return;
        } catch (Exception e) {
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect("search-customer.jsp");
            return;
        }

        request.getRequestDispatcher("select-car.jsp").forward(request, response);
    }
}

