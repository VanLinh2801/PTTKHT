package dao;

import model.Service;
import model.UsedSparePart;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ServiceDao {

    public List<Service> searchServices(String query) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM service WHERE LOWER(name) LIKE LOWER(?) ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + query + "%";
            stmt.setString(1, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    services.add(mapResultSetToService(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return services;
    }

    public List<Service> getAllServices() {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT * FROM service ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    services.add(mapResultSetToService(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return services;
    }

    public Service getServiceById(int id) {
        String sql = "SELECT * FROM service WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToService(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    public List<Service> getServicesByIds(List<Integer> ids) {
        List<Service> services = new ArrayList<>();
        if (ids == null || ids.isEmpty()) {
            return services;
        }

        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < ids.size(); i++) {
            if (i > 0) placeholders.append(",");
            placeholders.append("?");
        }
        
        String sql = "SELECT * FROM service WHERE id IN (" + placeholders.toString() + ") ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            for (int i = 0; i < ids.size(); i++) {
                stmt.setInt(i + 1, ids.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    services.add(mapResultSetToService(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return services;
    }

    public boolean addService(Service service) {
        String sql = "INSERT INTO service (name, price, description, estimate_duration, category, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, service.getName());
            stmt.setDouble(2, service.getPrice());
            stmt.setString(3, service.getDescription());
            stmt.setString(4, service.getEstimateDuration());
            stmt.setString(5, service.getCategory());
            stmt.setString(6, service.getStatus());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean updateService(Service service) {
        String sql = "UPDATE service SET name = ?, price = ?, description = ?, " +
                    "estimate_duration = ?, category = ?, status = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, service.getName());
            stmt.setDouble(2, service.getPrice());
            stmt.setString(3, service.getDescription());
            stmt.setString(4, service.getEstimateDuration());
            stmt.setString(5, service.getCategory());
            stmt.setString(6, service.getStatus());
            stmt.setInt(7, service.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean deleteService(int id) {
        String sql = "DELETE FROM service WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    private Service mapResultSetToService(ResultSet rs) throws SQLException {
        Service service = new Service();
        service.setId(rs.getInt("id"));
        service.setName(rs.getString("name"));
        service.setPrice(rs.getDouble("price"));
        service.setDescription(rs.getString("description"));
        service.setEstimateDuration(rs.getString("estimate_duration"));
        service.setCategory(rs.getString("category"));
        service.setStatus(rs.getString("status"));
        return service;
    }

    public List<UsedSparePart> getUsedSparePartsByServiceId(int serviceId) {
        List<UsedSparePart> usedSpareParts = new ArrayList<>();
        String sql = "SELECT id, quantity, service_id, spare_part_id FROM used_spare_part WHERE service_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return usedSpareParts;
    }

    public List<UsedSparePart> getUsedSparePartsByServiceIds(List<Integer> serviceIds) {
        List<UsedSparePart> usedSpareParts = new ArrayList<>();
        if (serviceIds == null || serviceIds.isEmpty()) {
            return usedSpareParts;
        }

        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < serviceIds.size(); i++) {
            if (i > 0) placeholders.append(",");
            placeholders.append("?");
        }
        
        String sql = "SELECT id, quantity, service_id, spare_part_id FROM used_spare_part WHERE service_id IN (" + placeholders.toString() + ")";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            for (int i = 0; i < serviceIds.size(); i++) {
                stmt.setInt(i + 1, serviceIds.get(i));
            }
            
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return usedSpareParts;
    }
}
