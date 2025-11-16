package dao;

import model.User;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CustomerDao {

    public User getCustomerById(int id) {
        String sql = "SELECT * FROM users WHERE id = ? AND role = 'CUSTOMER'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    public List<User> getAllCustomers() {
        List<User> customers = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'CUSTOMER' ORDER BY full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    customers.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return customers;
    }

    public List<User> searchCustomers(String query) {
        List<User> customers = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'CUSTOMER' AND " +
                    "(LOWER(full_name) LIKE LOWER(?) OR LOWER(phone_number) LIKE LOWER(?)) ORDER BY full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + query + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    customers.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return customers;
    }

    public boolean addCustomer(User customer) {
        String sql = "INSERT INTO users (full_name, account, password, date_of_birth, email, phone_number, role) " +
                    "VALUES (?, ?, ?, ?, ?, ?, 'CUSTOMER')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, customer.getFullName());
            stmt.setString(2, customer.getAccount());
            stmt.setString(3, customer.getPassword());
            stmt.setObject(4, customer.getDateOfBirth());
            stmt.setString(5, customer.getEmail());
            stmt.setString(6, customer.getPhone());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean isPhoneExists(String phone) {
        String sql = "SELECT COUNT(*) FROM users WHERE phone_number = ? AND role = 'CUSTOMER'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, phone);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean isEmailExists(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email.trim());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setFullName(rs.getString("full_name"));
        user.setAccount(rs.getString("account"));
        user.setPassword(rs.getString("password"));
        user.setDateOfBirth(rs.getDate("date_of_birth") != null ? 
            rs.getDate("date_of_birth").toLocalDate() : null);
        user.setEmail(rs.getString("email"));
        user.setPhoneNumber(rs.getString("phone_number"));
        user.setRole(rs.getString("role"));
        
        return user;
    }
}

