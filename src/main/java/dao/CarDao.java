package dao;

import model.Car;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CarDao {

    public List<Car> getCarsByCustomerId(int customerId) {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT * FROM car WHERE customer_id = ? ORDER BY id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    cars.add(mapResultSetToCar(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return cars;
    }

    public boolean addCar(Car car) {
        String sql = "INSERT INTO car (license_plate, brand, model, description, " +
                    "year_of_manufacture, mileage, customer_id) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, car.getLicensePlate());
            stmt.setString(2, car.getBrand());
            stmt.setString(3, car.getModel());
            stmt.setString(4, car.getDescription());
            stmt.setObject(5, car.getYearOfManufacture());
            stmt.setObject(6, car.getMileage());
            stmt.setInt(7, car.getCustomerId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean isLicensePlateExists(String licensePlate) {
        if (licensePlate == null || licensePlate.trim().isEmpty()) {
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM car WHERE license_plate = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, licensePlate.trim());
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

    public Car getCarById(int id) {
        String sql = "SELECT * FROM car WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCar(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    public boolean updateCar(Car car) {
        String sql = "UPDATE car SET license_plate = ?, brand = ?, model = ?, " +
                    "description = ?, year_of_manufacture = ?, mileage = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, car.getLicensePlate());
            stmt.setString(2, car.getBrand());
            stmt.setString(3, car.getModel());
            stmt.setString(4, car.getDescription());
            stmt.setObject(5, car.getYearOfManufacture());
            stmt.setObject(6, car.getMileage());
            stmt.setInt(7, car.getId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean deleteCar(int id) {
        String sql = "DELETE FROM car WHERE id = ?";
        
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

    private Car mapResultSetToCar(ResultSet rs) throws SQLException {
        Car car = new Car();
        car.setId(rs.getInt("id"));
        car.setLicensePlate(rs.getString("license_plate"));
        car.setBrand(rs.getString("brand"));
        car.setModel(rs.getString("model"));
        car.setDescription(rs.getString("description"));
        car.setYearOfManufacture(rs.getObject("year_of_manufacture", Integer.class));
        car.setMileage(rs.getObject("mileage", Integer.class));
        car.setCustomerId(rs.getInt("customer_id"));
        return car;
    }
}

