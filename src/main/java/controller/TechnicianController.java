package controller;

import dao.ServiceDao;
import dao.TechnicianDao;
import model.User;
import model.Service;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/technician")
public class TechnicianController extends HttpServlet {
    private ServiceDao serviceDao;
    private TechnicianDao technicianDao;
    
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println(">>> Servlet initialized: " + getServletName());
        getServletContext().getServletRegistrations().forEach((k, v) -> {
            System.out.println(">>> Registered servlet: " + v.getClassName() + " → " + v.getMappings());
        });
        try {
            serviceDao = new ServiceDao();
            technicianDao = new TechnicianDao();
            System.out.println(">>> DAOs initialized successfully");
        } catch (Exception e) {
            System.err.println(">>> Error initializing DAOs: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        listTechnicians(request, response);
    }

    private void listTechnicians(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println(">>> customerId = " + request.getParameter("customerId"));
        System.out.println(">>> Query string = " + request.getQueryString());
        System.out.println(">>> Request URI = " + request.getRequestURI());
        System.out.println(">>> Request URL = " + request.getRequestURL());
        System.out.println(">>> Request Protocol = " + request.getProtocol());
        System.out.println(">>> Request Method = " + request.getMethod());
        System.out.println(">>> Request Context Path = " + request.getContextPath());
        System.out.println(">>> Request Servlet Path = " + request.getServletPath());
        System.out.println(">>> Request Path Info = " + request.getPathInfo());
        System.out.println(">>> Request Path Translated = " + request.getPathTranslated());

        String customerId = request.getParameter("customerId");
        String vehicleId = request.getParameter("vehicleId");
        
        if (customerId == null || customerId.trim().isEmpty()) {
            request.getRequestDispatcher("search-customer.jsp").forward(request, response);
            System.out.println(">>> Redirecting to search-customer.jsp");
            System.out.println(">>> Customer ID: " + customerId);
            return;
        } else {
            System.out.println(">>> Customer ID: " + customerId);
        }
        
        if (vehicleId == null || vehicleId.trim().isEmpty()) {
            request.getRequestDispatcher("search-customer.jsp").forward(request, response);
            System.out.println(">>> Redirecting to search-customer.jsp");
            System.out.println(">>> Vehicle ID: " + vehicleId);
            return;
        } else {
            System.out.println(">>> Vehicle ID: " + vehicleId);
        }

        List<User> technicians = new ArrayList<>();
        List<Service> allServices = new ArrayList<>();
        
        try {
            String technicianQuery = request.getParameter("technicianQuery");
            
            if (technicianQuery != null && !technicianQuery.trim().isEmpty()) {
                System.out.println(">>> Searching technicians with query: " + technicianQuery);
                technicians = technicianDao.searchAvailableTechnicians(technicianQuery.trim());
                request.setAttribute("technicianQuery", technicianQuery.trim());
            } else {
                System.out.println(">>> Getting all available technicians");
                technicians = technicianDao.getAllAvailableTechnicians();
            }

            if (serviceDao != null) {
                String serviceIdsParam = request.getParameter("serviceIds");
                if (serviceIdsParam != null && !serviceIdsParam.trim().isEmpty()) {

                    List<Integer> serviceIds = new ArrayList<>();
                    String[] ids = serviceIdsParam.split(",");
                    for (String idStr : ids) {
                        try {
                            int id = Integer.parseInt(idStr.trim());
                            serviceIds.add(id);
                        } catch (NumberFormatException e) {
                            System.err.println(">>> Invalid service ID: " + idStr);
                        }
                    }
                    System.out.println(">>> Getting services by IDs: " + serviceIds);
                    allServices = serviceDao.getServicesByIds(serviceIds);
                } else {

                    System.out.println(">>> No serviceIds parameter, no services to assign");
                    allServices = new ArrayList<>();
                }
            } else {
                System.err.println(">>> ERROR: ServiceDao is null!");
                request.setAttribute("error", "Lỗi khởi tạo ServiceDao. Vui lòng kiểm tra lại cấu hình.");
            }
            
            System.out.println(">>> Found " + technicians.size() + " technicians");
            System.out.println(">>> Found " + allServices.size() + " services");
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println(">>> Exception in TechnicianController: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tìm kiếm kỹ thuật viên: " + e.getMessage());
        } finally {

            request.setAttribute("technicians", technicians);
            request.setAttribute("services", allServices);
        }
        
        System.out.println(">>> Forwarding to assign-technician.jsp");
        System.out.println("Real path: " + getServletContext().getRealPath("assign-technician.jsp"));
        request.getRequestDispatcher("/assign-technician.jsp").forward(request, response);
    }
}

