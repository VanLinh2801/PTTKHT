package dao;

import model.SparePart;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SparePartDao {

    public List<SparePart> searchSpareParts(String query) {
        List<SparePart> spareParts = new ArrayList<>();
        String sql = "SELECT * FROM spare_part WHERE LOWER(name) LIKE LOWER(?) ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + query + "%";
            stmt.setString(1, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    spareParts.add(mapResultSetToSparePart(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return spareParts;
    }

    public List<SparePart> getAllSpareParts() {
        List<SparePart> spareParts = new ArrayList<>();
        String sql = "SELECT * FROM spare_part ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    spareParts.add(mapResultSetToSparePart(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return spareParts;
    }

    public SparePart getSparePartById(int id) {
        String sql = "SELECT * FROM spare_part WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSparePart(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    public boolean addSparePart(SparePart sparePart) {
        String sql = "INSERT INTO spare_part (name, price, description, available_quantity, " +
                    "manufacturer, warranty_period) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, sparePart.getName());
            stmt.setDouble(2, sparePart.getPrice());
            stmt.setString(3, sparePart.getDescription());
            stmt.setInt(4, sparePart.getAvailableQuantity());
            stmt.setString(5, sparePart.getManufacturer());
            stmt.setObject(6, sparePart.getWarrantyPeriod());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean updateSparePart(SparePart sparePart) {
        String sql = "UPDATE spare_part SET name = ?, price = ?, description = ?, " +
                    "available_quantity = ?, manufacturer = ?, warranty_period = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, sparePart.getName());
            stmt.setDouble(2, sparePart.getPrice());
            stmt.setString(3, sparePart.getDescription());
            stmt.setInt(4, sparePart.getAvailableQuantity());
            stmt.setString(5, sparePart.getManufacturer());
            stmt.setObject(6, sparePart.getWarrantyPeriod());
            stmt.setInt(7, sparePart.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean deleteSparePart(int id) {
        String sql = "DELETE FROM spare_part WHERE id = ?";
        
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

    private SparePart mapResultSetToSparePart(ResultSet rs) throws SQLException {
        SparePart sparePart = new SparePart();
        sparePart.setId(rs.getInt("id"));
        sparePart.setName(rs.getString("name"));
        sparePart.setPrice(rs.getDouble("price"));
        sparePart.setDescription(rs.getString("description"));
        sparePart.setAvailableQuantity(rs.getInt("available_quantity"));
        sparePart.setManufacturer(rs.getString("manufacturer"));
        sparePart.setWarrantyPeriod(rs.getDate("warranty_period") != null ? 
            rs.getDate("warranty_period").toLocalDate() : null);
        return sparePart;
    }
}
