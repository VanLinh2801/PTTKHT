package controller;

import model.User;
import model.Service;
import model.SparePart;
import model.UsedSparePart;
import dao.ServiceDao;
import dao.SparePartDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/spare-part")
public class SparePartController extends HttpServlet {
    private ServiceDao serviceDao;
    private SparePartDao sparePartDao;

    @Override
    public void init() throws ServletException {
        super.init();
        serviceDao = new ServiceDao();
        sparePartDao = new SparePartDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("search".equals(action) || action == null) {
            searchSparePart(request, response);
        } else {
            response.sendRedirect("search-customer.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void searchSparePart(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String customerId = request.getParameter("customerId");
        
        if (customerId == null || customerId.trim().isEmpty()) {
            request.getRequestDispatcher("search-customer.jsp").forward(request, response);
            return;
        }

        try {
            String serviceQuery = request.getParameter("serviceQuery");
            String sparePartQuery = request.getParameter("sparePartQuery");
            
            List<Service> services = null;
            List<SparePart> spareParts = null;

            if (serviceDao != null) {
                if (serviceQuery != null && !serviceQuery.trim().isEmpty()) {
                    try {
                        services = serviceDao.searchServices(serviceQuery.trim());
                        request.setAttribute("serviceQuery", serviceQuery.trim());
                    } catch (Exception e) {
                        System.out.println(">>> Exception in SparePartController: " + e.getMessage());
                        request.setAttribute("serviceError", "Lỗi tìm kiếm dịch vụ: " + e.getMessage());
                        e.printStackTrace();
                    }
                } else {
                    try {
                        services = serviceDao.getAllServices();
                    } catch (Exception e) {
                        System.out.println(">>> Exception in SparePartController: " + e.getMessage());
                        request.setAttribute("serviceError", "Lỗi lấy danh sách dịch vụ: " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            }

            if (sparePartDao != null) {
                if (sparePartQuery != null && !sparePartQuery.trim().isEmpty()) {
                    try {
                        spareParts = sparePartDao.searchSpareParts(sparePartQuery.trim());
                        request.setAttribute("sparePartQuery", sparePartQuery.trim());
                    } catch (Exception e) {
                        System.out.println(">>> Exception in SparePartController: " + e.getMessage());
                        request.setAttribute("sparePartError", "Lỗi tìm kiếm phụ tùng: " + e.getMessage());
                        e.printStackTrace();
                    }
                } else {
                    try {
                        spareParts = sparePartDao.getAllSpareParts();
                    } catch (Exception e) {
                        System.out.println(">>> Exception in SparePartController: " + e.getMessage());
                        request.setAttribute("sparePartError", "Lỗi lấy danh sách phụ tùng: " + e.getMessage());
                        e.printStackTrace();
                    }
                }
            } else {
                request.setAttribute("sparePartError", "SparePartDao không được khởi tạo");
            }

            Map<Integer, List<UsedSparePart>> usedSparePartsMap = new HashMap<>();
            if (services != null && !services.isEmpty() && serviceDao != null) {
                for (Service service : services) {
                    List<UsedSparePart> usedSpareParts = serviceDao.getUsedSparePartsByServiceId(service.getId());
                    usedSparePartsMap.put(service.getId(), usedSpareParts);
                }
            }
            
            request.setAttribute("services", services);
            request.setAttribute("spareParts", spareParts);
            request.setAttribute("usedSparePartsMap", usedSparePartsMap);
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(">>> Exception in SparePartController: " + e.getMessage());
            request.setAttribute("error", "Có lỗi xảy ra khi tìm kiếm: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/searchServiceAndSparePart.jsp").forward(request, response);
    }
}

