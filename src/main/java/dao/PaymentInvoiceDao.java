package dao;

import util.DBConnection;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import model.UsedSparePart;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PaymentInvoiceDao {

    public int savePaymentInvoice(int salesStaffId, Integer customerId, Integer vehicleId) throws SQLException {
        String sql = "INSERT INTO payment_invoice (date, status, sales_staff_id, customer_id, vehicle_id) " +
                     "VALUES (?, 'UNPAID', ?, ?, ?)";
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            
            stmt.setObject(1, LocalDate.now());
            stmt.setInt(2, salesStaffId);
            stmt.setInt(3, customerId);
            if (vehicleId != null) {
                stmt.setInt(4, vehicleId);
            } else {
                stmt.setNull(4, java.sql.Types.INTEGER);
            }
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Creating payment invoice failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    throw new SQLException("Creating payment invoice failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }

    public List<Integer> savePaymentInvoiceServices(int paymentInvoiceId, JsonArray services) throws SQLException {
        List<Integer> paymentInvoiceServiceIds = new ArrayList<>();
        String sql = "INSERT INTO payment_invoice_service (unit_price, payment_invoice_id, service_id) " +
                     "VALUES (?, ?, ?)";
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                for (int i = 0; i < services.size(); i++) {
                    JsonObject service = services.get(i).getAsJsonObject();
                    
                    stmt.setDouble(1, service.get("price").getAsDouble());
                    stmt.setInt(2, paymentInvoiceId);
                    stmt.setInt(3, service.get("id").getAsInt());
                    
                    int rowsAffected = stmt.executeUpdate();
                    if (rowsAffected == 0) {
                        conn.rollback();
                        throw new SQLException("Creating payment invoice service failed, no rows affected.");
                    }
                    
                    try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            paymentInvoiceServiceIds.add(generatedKeys.getInt(1));
                        } else {
                            conn.rollback();
                            throw new SQLException("Creating payment invoice service failed, no ID obtained.");
                        }
                    }
                }
            }

            Map<Integer, Integer> sparePartQuantities = new HashMap<>();
            for (int i = 0; i < services.size(); i++) {
                JsonObject service = services.get(i).getAsJsonObject();
                int serviceId = service.get("id").getAsInt();
                
                List<UsedSparePart> usedSpareParts = getUsedSparePartsByServiceId(conn, serviceId);
                for (UsedSparePart usedSparePart : usedSpareParts) {
                    int sparePartId = usedSparePart.getSparePartId();
                    int quantity = usedSparePart.getQuantity();
                    sparePartQuantities.put(sparePartId, 
                        sparePartQuantities.getOrDefault(sparePartId, 0) + quantity);
                }
            }

            for (Map.Entry<Integer, Integer> entry : sparePartQuantities.entrySet()) {
                int sparePartId = entry.getKey();
                int requiredQuantity = entry.getValue();
                int currentQuantity = getSparePartAvailableQuantity(conn, sparePartId);
                if (currentQuantity < requiredQuantity) {
                    conn.rollback();
                    throw new SQLException("Số lượng phụ tùng không đủ. Phụ tùng ID " + sparePartId + 
                                         " cần " + requiredQuantity + " nhưng chỉ còn " + currentQuantity + " sản phẩm.");
                }
            }

            String updateSql = "UPDATE spare_part SET available_quantity = available_quantity - ? WHERE id = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                for (Map.Entry<Integer, Integer> entry : sparePartQuantities.entrySet()) {
                    int sparePartId = entry.getKey();
                    int quantity = entry.getValue();
                    
                    updateStmt.setInt(1, quantity);
                    updateStmt.setInt(2, sparePartId);
                    
                    int rowsAffected = updateStmt.executeUpdate();
                    if (rowsAffected == 0) {
                        conn.rollback();
                        throw new SQLException("Updating spare part quantity failed, no rows affected for spare part ID: " + sparePartId);
                    }
                }
            }
            
            conn.commit();
            
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing connection: " + e.getMessage());
                }
            }
        }
        
        return paymentInvoiceServiceIds;
    }

    public void savePaymentInvoiceSpareParts(int paymentInvoiceId, JsonArray spareParts) throws SQLException {
        if (spareParts == null || spareParts.size() == 0) {
            return;
        }
        
        String insertSql = "INSERT INTO payment_invoice_spare_part (quantity, unit_price, payment_invoice_id, spare_part_id) " +
                     "VALUES (?, ?, ?, ?)";
        String updateSql = "UPDATE spare_part SET available_quantity = available_quantity - ? WHERE id = ?";
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            for (int i = 0; i < spareParts.size(); i++) {
                JsonObject sparePart = spareParts.get(i).getAsJsonObject();
                int sparePartId = sparePart.get("id").getAsInt();
                int quantity = sparePart.get("quantity").getAsInt();
                
                int currentQuantity = getSparePartAvailableQuantity(conn, sparePartId);
                if (currentQuantity < quantity) {
                    conn.rollback();
                    throw new SQLException("Số lượng phụ tùng không đủ. Phụ tùng ID " + sparePartId + 
                                         " chỉ còn " + currentQuantity + " sản phẩm.");
                }
            }
            
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                 PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                
                for (int i = 0; i < spareParts.size(); i++) {
                    JsonObject sparePart = spareParts.get(i).getAsJsonObject();
                    int sparePartId = sparePart.get("id").getAsInt();
                    int quantity = sparePart.get("quantity").getAsInt();
                    double price = sparePart.get("price").getAsDouble();

                    insertStmt.setInt(1, quantity);
                    insertStmt.setDouble(2, price);
                    insertStmt.setInt(3, paymentInvoiceId);
                    insertStmt.setInt(4, sparePartId);
                    
                    int rowsAffected = insertStmt.executeUpdate();
                    if (rowsAffected == 0) {
                        conn.rollback();
                        throw new SQLException("Creating payment invoice spare part failed, no rows affected.");
                    }

                    updateStmt.setInt(1, quantity);
                    updateStmt.setInt(2, sparePartId);
                    
                    int updateRowsAffected = updateStmt.executeUpdate();
                    if (updateRowsAffected == 0) {
                        conn.rollback();
                        throw new SQLException("Updating spare part quantity failed, no rows affected for spare part ID: " + sparePartId);
                    }
                }
                
                conn.commit();
            } catch (SQLException e) {
                if (conn != null) {
                    conn.rollback();
                }
                throw e;
            }
        } catch (SQLException e) {
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing connection: " + e.getMessage());
                }
            }
        }
    }

    private int getSparePartAvailableQuantity(Connection conn, int sparePartId) throws SQLException {
        String sql = "SELECT available_quantity FROM spare_part WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, sparePartId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("available_quantity");
                } else {
                    throw new SQLException("Spare part not found with ID: " + sparePartId);
                }
            }
        }
    }

    public void saveUsedServices(List<Integer> paymentInvoiceServiceIds, JsonArray serviceTechnicianAssignments) throws SQLException {
        if (paymentInvoiceServiceIds == null || paymentInvoiceServiceIds.isEmpty() || 
            serviceTechnicianAssignments == null || serviceTechnicianAssignments.size() == 0) {
            System.out.println(">>> saveUsedServices: Skipping - paymentInvoiceServiceIds or serviceTechnicianAssignments is empty");
            return;
        }
        
        System.out.println(">>> saveUsedServices: paymentInvoiceServiceIds size = " + paymentInvoiceServiceIds.size());
        System.out.println(">>> saveUsedServices: serviceTechnicianAssignments size = " + serviceTechnicianAssignments.size());
        
        String sql = "INSERT INTO used_service (start_at, payment_invoice_service_id, technician_id) " +
                     "VALUES (NOW(), ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            for (int paymentInvoiceServiceId : paymentInvoiceServiceIds) {

                int serviceId = getServiceIdFromPaymentInvoiceService(conn, paymentInvoiceServiceId);
                System.out.println(">>> saveUsedServices: paymentInvoiceServiceId = " + paymentInvoiceServiceId + ", serviceId = " + serviceId);

                boolean foundMatch = false;
                for (int i = 0; i < serviceTechnicianAssignments.size(); i++) {
                    JsonObject assignment = serviceTechnicianAssignments.get(i).getAsJsonObject();

                    int assignmentServiceId;
                    if (assignment.get("serviceId").isJsonPrimitive() && assignment.get("serviceId").getAsJsonPrimitive().isString()) {
                        assignmentServiceId = Integer.parseInt(assignment.get("serviceId").getAsString());
                    } else {
                        assignmentServiceId = assignment.get("serviceId").getAsInt();
                    }
                    System.out.println(">>> saveUsedServices: Checking assignment - serviceId = " + assignmentServiceId + " (from DB: " + serviceId + ")");
                    
                    if (assignmentServiceId == serviceId) {
                        foundMatch = true;
                        int technicianId;
                        if (assignment.get("technicianId").isJsonPrimitive() && assignment.get("technicianId").getAsJsonPrimitive().isString()) {
                            technicianId = Integer.parseInt(assignment.get("technicianId").getAsString());
                        } else {
                            technicianId = assignment.get("technicianId").getAsInt();
                        }
                        System.out.println(">>> saveUsedServices: Found match! Creating used_service for paymentInvoiceServiceId = " + 
                                         paymentInvoiceServiceId + ", technicianId = " + technicianId);
                        
                        stmt.setInt(1, paymentInvoiceServiceId);
                        stmt.setInt(2, technicianId);
                        
                        int rowsAffected = stmt.executeUpdate();
                        if (rowsAffected == 0) {
                            throw new SQLException("Creating used service failed, no rows affected.");
                        }
                        System.out.println(">>> saveUsedServices: Successfully created used_service");
                    }
                }
                if (!foundMatch) {
                    System.out.println(">>> saveUsedServices: WARNING - No matching assignment found for serviceId = " + serviceId);
                }
            }
        }
    }

    private int getServiceIdFromPaymentInvoiceService(Connection conn, int paymentInvoiceServiceId) throws SQLException {
        String sql = "SELECT service_id FROM payment_invoice_service WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, paymentInvoiceServiceId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("service_id");
                } else {
                    throw new SQLException("Payment invoice service not found with ID: " + paymentInvoiceServiceId);
                }
            }
        }
    }

    private List<UsedSparePart> getUsedSparePartsByServiceId(Connection conn, int serviceId) throws SQLException {
        List<UsedSparePart> usedSpareParts = new ArrayList<>();
        String sql = "SELECT id, quantity, service_id, spare_part_id FROM used_spare_part WHERE service_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, serviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    UsedSparePart usedSparePart = new UsedSparePart();
                    usedSparePart.setId(rs.getInt("id"));
                    usedSparePart.setQuantity(rs.getInt("quantity"));
                    usedSparePart.setServiceId(rs.getInt("service_id"));
                    usedSparePart.setSparePartId(rs.getInt("spare_part_id"));
                    usedSpareParts.add(usedSparePart);
                }
            }
        }
        return usedSpareParts;
    }
}

