package controller;

import dao.CustomerDao;
import dao.CarDao;
import dao.PaymentInvoiceDao;
import model.User;
import model.Car;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;

@WebServlet("/payment-invoice")
public class PaymentInvoiceController extends HttpServlet {
    private CustomerDao customerDao;
    private CarDao carDao;
    private PaymentInvoiceDao paymentInvoiceDao;
    
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println(">>> Servlet initialized: " + getServletName());
        try {
            customerDao = new CustomerDao();
            carDao = new CarDao();
            paymentInvoiceDao = new PaymentInvoiceDao();
            System.out.println(">>> DAOs initialized successfully");
        } catch (Exception e) {
            System.err.println(">>> Error initializing DAOs: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String customerId = request.getParameter("customerId");
        String vehicleId = request.getParameter("vehicleId");
        String noCar = request.getParameter("noCar");
        String success = request.getParameter("success");
        String paymentInvoiceId = request.getParameter("paymentInvoiceId");
        
        if (customerId == null || customerId.trim().isEmpty()) {
            response.sendRedirect("search-customer.jsp");
            return;
        }
        
        boolean isNoCarMode = "true".equals(noCar);
        request.setAttribute("isNoCarMode", isNoCarMode);
        
        if ("true".equals(success) && paymentInvoiceId != null) {
            request.setAttribute("success", "Đơn hàng đã được lưu thành công!");
            request.setAttribute("paymentInvoiceId", paymentInvoiceId);
        }
        
        try {
            User customer = customerDao.getCustomerById(Integer.parseInt(customerId));
            request.setAttribute("customer", customer);
            
            if (!isNoCarMode && vehicleId != null && !vehicleId.trim().isEmpty()) {
                Car car = carDao.getCarById(Integer.parseInt(vehicleId));
                request.setAttribute("vehicle", car);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải thông tin: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/confirm.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String orderDataJson = request.getParameter("orderData");
            if (orderDataJson == null || orderDataJson.trim().isEmpty()) {
                request.setAttribute("error", "Không có dữ liệu đơn hàng");
                request.getRequestDispatcher("/confirm.jsp").forward(request, response);
                return;
            }
            
            Gson gson = new Gson();
            JsonObject orderData = gson.fromJson(orderDataJson, JsonObject.class);
            
            JsonArray services = orderData.getAsJsonArray("services");
            JsonArray spareParts = orderData.getAsJsonArray("spareParts");
            
            boolean isNoCarMode = orderData.has("isNoCarMode") && orderData.get("isNoCarMode").getAsBoolean();
            Integer vehicleId = null;
            if (!isNoCarMode && orderData.has("vehicleId") && !orderData.get("vehicleId").isJsonNull()) {
                vehicleId = orderData.get("vehicleId").getAsInt();
            }
            
            User salesStaff = (User) request.getSession().getAttribute("user");
            if (salesStaff == null) {
                request.setAttribute("error", "Phiên đăng nhập đã hết hạn");
                request.getRequestDispatcher("/confirm.jsp").forward(request, response);
                return;
            }

            Integer customerId = null;
            if (orderData.has("customerId") && !orderData.get("customerId").isJsonNull()) {
                customerId = orderData.get("customerId").getAsInt();
            }
            
            if (customerId == null) {
                request.setAttribute("error", "Thiếu thông tin khách hàng");
                request.getRequestDispatcher("/confirm.jsp").forward(request, response);
                return;
            }
            
            int paymentInvoiceId = paymentInvoiceDao.savePaymentInvoice(salesStaff.getId(), customerId, vehicleId);
            
            List<Integer> paymentInvoiceServiceIds = new ArrayList<>();
            JsonArray serviceTechnicianAssignments = orderData.has("serviceTechnicianAssignments") ? 
                orderData.getAsJsonArray("serviceTechnicianAssignments") : null;
            
            System.out.println(">>> PaymentInvoiceController: isNoCarMode = " + isNoCarMode);
            System.out.println(">>> PaymentInvoiceController: serviceTechnicianAssignments = " + 
                (serviceTechnicianAssignments != null ? serviceTechnicianAssignments.size() : "null"));
            
            if (!isNoCarMode && services != null && services.size() > 0) {
                paymentInvoiceServiceIds = paymentInvoiceDao.savePaymentInvoiceServices(paymentInvoiceId, services);
                System.out.println(">>> PaymentInvoiceController: paymentInvoiceServiceIds size = " + paymentInvoiceServiceIds.size());
            }
            
            paymentInvoiceDao.savePaymentInvoiceSpareParts(paymentInvoiceId, spareParts);
            
            if (!isNoCarMode && !paymentInvoiceServiceIds.isEmpty() && 
                serviceTechnicianAssignments != null && serviceTechnicianAssignments.size() > 0) {
                System.out.println(">>> PaymentInvoiceController: Calling saveUsedServices...");
                paymentInvoiceDao.saveUsedServices(paymentInvoiceServiceIds, serviceTechnicianAssignments);
            } else {
                System.out.println(">>> PaymentInvoiceController: Skipping saveUsedServices - isNoCarMode=" + isNoCarMode + 
                    ", paymentInvoiceServiceIds.isEmpty()=" + paymentInvoiceServiceIds.isEmpty() + 
                    ", serviceTechnicianAssignments=" + (serviceTechnicianAssignments != null ? serviceTechnicianAssignments.size() : "null"));
            }

            String redirectUrl = "sales-staff-home.jsp?success=order_saved";
            if (salesStaff != null && "SALES_STAFF".equals(salesStaff.getRole())) {
                redirectUrl = "sales-staff-home.jsp?success=order_saved";
            } else {
                redirectUrl = "home.jsp?success=order_saved";
            }
            response.sendRedirect(redirectUrl);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi lưu đơn hàng: " + e.getMessage());
            request.getRequestDispatcher("/confirm.jsp").forward(request, response);
        }
    }
    
    private double calculateTotalAmount(JsonArray services, JsonArray spareParts) {
        double total = 0;
        
        if (services != null) {
            for (int i = 0; i < services.size(); i++) {
                JsonObject service = services.get(i).getAsJsonObject();
                double price = service.get("price").getAsDouble();
                total += price;
            }
        }
        
        if (spareParts != null) {
            for (int i = 0; i < spareParts.size(); i++) {
                JsonObject sparePart = spareParts.get(i).getAsJsonObject();
                double price = sparePart.get("price").getAsDouble();
                int quantity = sparePart.get("quantity").getAsInt();
                total += price * quantity;
            }
        }
        
        return total;
    }
    
}

