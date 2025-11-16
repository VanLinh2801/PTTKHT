package dao;

import model.Appointment;
import util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDao {
    
    public boolean createAppointment(Appointment appointment) {
        String sql = "INSERT INTO appointment (appointment_date, appointment_time, status, note, customer_id) VALUES (?, ?, ?::appointment_status, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDate(1, Date.valueOf(appointment.getAppointmentDate()));
            stmt.setTime(2, Time.valueOf(appointment.getAppointmentTime()));
            stmt.setString(3, appointment.getStatus());
            stmt.setString(4, appointment.getNote());
            stmt.setInt(5, appointment.getCustomerId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean hasExistingAppointment(int customerId, LocalDate appointmentDate, LocalTime appointmentTime) {
        String sql = "SELECT COUNT(*) FROM appointment WHERE customer_id = ? AND appointment_date = ? AND appointment_time = ? AND status = 'BOOKED'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            stmt.setDate(2, Date.valueOf(appointmentDate));
            stmt.setTime(3, Time.valueOf(appointmentTime));
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean hasExistingAppointmentOnDate(int customerId, LocalDate appointmentDate) {
        String sql = "SELECT COUNT(*) FROM appointment WHERE customer_id = ? AND appointment_date = ? AND status = 'BOOKED'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            stmt.setDate(2, Date.valueOf(appointmentDate));
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean cancelAppointment(int appointmentId) {
        String sql = "UPDATE appointment SET status = 'CANCELLED' WHERE id = ? AND status = 'BOOKED'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
                stmt.setInt(1, appointmentId);
                int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Appointment> getAppointmentsByCustomerId(int customerId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT * FROM appointment " +
                     "WHERE customer_id = ? AND status = 'BOOKED' " +
                     "ORDER BY appointment_date, appointment_time";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Appointment appointment = new Appointment();
                appointment.setId(rs.getInt("id"));
                appointment.setCreationDate(rs.getTimestamp("creation_date").toLocalDateTime());
                appointment.setAppointmentDate(rs.getDate("appointment_date").toLocalDate());
                appointment.setAppointmentTime(rs.getTime("appointment_time").toLocalTime());
                appointment.setStatus(rs.getString("status"));
                appointment.setNote(rs.getString("note"));
                appointment.setCustomerId(rs.getInt("customer_id"));
                appointments.add(appointment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return appointments;
    }

    public int countAppointmentsByDateTime(LocalDate appointmentDate, LocalTime appointmentTime) {
        String sql = "SELECT COUNT(*) FROM appointment WHERE appointment_date = ? AND appointment_time = ? AND status = 'BOOKED'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDate(1, Date.valueOf(appointmentDate));
            stmt.setTime(2, Time.valueOf(appointmentTime));
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
}
