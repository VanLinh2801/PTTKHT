package dao;

import model.User;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TechnicianDao {

    public List<User> searchAvailableTechnicians(String query) throws SQLException {
        List<User> technicians = new ArrayList<>();

        String sql = "SELECT DISTINCT u.id, u.full_name, u.phone_number, u.email " +
                    "FROM users u " +
                    "WHERE u.role = 'TECHNICIAN' " +
                    "AND (u.full_name LIKE ? OR u.phone_number LIKE ? OR u.email LIKE ?) " +
                    "AND NOT EXISTS (" +
                    "    SELECT 1 " +
                    "    FROM used_service us " +
                    "    WHERE us.technician_id = u.id " +
                    "    AND (us.end_at IS NULL OR us.end_at > CURRENT_TIMESTAMP)" +
                    ") " +
                    "ORDER BY u.full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + query + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    technicians.add(mapResultSetToUser(rs));
                }
            }
        }
        
        return technicians;
    }

    public List<User> getAllAvailableTechnicians() throws SQLException {
        List<User> technicians = new ArrayList<>();

        String sql = "SELECT DISTINCT u.id, u.full_name, u.phone_number, u.email " +
                    "FROM users u " +
                    "WHERE u.role = 'TECHNICIAN' " +
                    "AND NOT EXISTS (" +
                    "    SELECT 1 " +
                    "    FROM used_service us " +
                    "    WHERE us.technician_id = u.id " +
                    "    AND (us.end_at IS NULL OR us.end_at > CURRENT_TIMESTAMP)" +
                    ") " +
                    "ORDER BY u.full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                technicians.add(mapResultSetToUser(rs));
            }
        }
        
        return technicians;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User technician = new User();
        technician.setId(rs.getInt("id"));
        technician.setFullName(rs.getString("full_name"));
        technician.setPhone(rs.getString("phone_number"));
        technician.setEmail(rs.getString("email"));
        technician.setRole("TECHNICIAN");
        return technician;
    }
}

