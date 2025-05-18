package com.hospital.dao;

import com.hospital.beans.Doctor;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Doctor-related database operations
 */
public class DoctorDAO {
    
    /**
     * Create a new doctor
     * @param doctor The doctor to create
     * @param userId The associated user ID
     * @return The doctor ID of the created doctor, or -1 if operation failed
     */
    public int createDoctor(Doctor doctor, int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int doctorId = -1;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO doctors (user_id, first_name, last_name, specialization, phone) VALUES (?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            stmt.setInt(1, userId);
            stmt.setString(2, doctor.getFirstName());
            stmt.setString(3, doctor.getLastName());
            stmt.setString(4, doctor.getSpecialization());
            stmt.setString(5, doctor.getPhone());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    doctorId = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating doctor: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return doctorId;
    }
    
    /**
     * Get a doctor by their doctor ID
     * @param doctorId The doctor ID
     * @return Doctor object if found, null otherwise
     */
    public Doctor getDoctorById(int doctorId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Doctor doctor = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT d.*, u.username, u.email FROM doctors d " +
                          "JOIN users u ON d.user_id = u.user_id " +
                          "WHERE d.doctor_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, doctorId);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                doctor = new Doctor();
                doctor.setDoctorId(rs.getInt("doctor_id"));
                doctor.setUserId(rs.getInt("user_id"));
                doctor.setFirstName(rs.getString("first_name"));
                doctor.setLastName(rs.getString("last_name"));
                doctor.setSpecialization(rs.getString("specialization"));
                doctor.setPhone(rs.getString("phone"));
                
                // Additional fields from the users table
                doctor.setUsername(rs.getString("username"));
                doctor.setEmail(rs.getString("email"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting doctor by ID: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return doctor;
    }
    
    /**
     * Get a doctor by their user ID
     * @param userId The user ID
     * @return Doctor object if found, null otherwise
     */
    public Doctor getDoctorByUserId(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Doctor doctor = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT d.*, u.username, u.email FROM doctors d " +
                          "JOIN users u ON d.user_id = u.user_id " +
                          "WHERE d.user_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                doctor = new Doctor();
                doctor.setDoctorId(rs.getInt("doctor_id"));
                doctor.setUserId(rs.getInt("user_id"));
                doctor.setFirstName(rs.getString("first_name"));
                doctor.setLastName(rs.getString("last_name"));
                doctor.setSpecialization(rs.getString("specialization"));
                doctor.setPhone(rs.getString("phone"));
                
                // Additional fields from the users table
                doctor.setUsername(rs.getString("username"));
                doctor.setEmail(rs.getString("email"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting doctor by user ID: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return doctor;
    }
    
    /**
     * Get all doctors
     * @return List of all doctors
     */
    public List<Doctor> getAllDoctors() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Doctor> doctors = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT d.*, u.username, u.email FROM doctors d " +
                          "JOIN users u ON d.user_id = u.user_id " +
                          "WHERE u.active = true";
            stmt = conn.prepareStatement(sql);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setDoctorId(rs.getInt("doctor_id"));
                doctor.setUserId(rs.getInt("user_id"));
                doctor.setFirstName(rs.getString("first_name"));
                doctor.setLastName(rs.getString("last_name"));
                doctor.setSpecialization(rs.getString("specialization"));
                doctor.setPhone(rs.getString("phone"));
                
                // Additional fields from the users table
                doctor.setUsername(rs.getString("username"));
                doctor.setEmail(rs.getString("email"));
                
                doctors.add(doctor);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all doctors: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return doctors;
    }
    
    /**
     * Get doctors by specialization
     * @param specialization The specialization to filter by
     * @return List of doctors with the specified specialization
     */
    public List<Doctor> getDoctorsBySpecialization(String specialization) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Doctor> doctors = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT d.*, u.username, u.email FROM doctors d " +
                          "JOIN users u ON d.user_id = u.user_id " +
                          "WHERE d.specialization = ? AND u.active = true";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, specialization);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setDoctorId(rs.getInt("doctor_id"));
                doctor.setUserId(rs.getInt("user_id"));
                doctor.setFirstName(rs.getString("first_name"));
                doctor.setLastName(rs.getString("last_name"));
                doctor.setSpecialization(rs.getString("specialization"));
                doctor.setPhone(rs.getString("phone"));
                
                // Additional fields from the users table
                doctor.setUsername(rs.getString("username"));
                doctor.setEmail(rs.getString("email"));
                
                doctors.add(doctor);
            }
        } catch (SQLException e) {
            System.err.println("Error getting doctors by specialization: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return doctors;
    }
    
    /**
     * Update a doctor's information
     * @param doctor The doctor to update
     * @return true if update successful, false otherwise
     */
    public boolean updateDoctor(Doctor doctor) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE doctors SET first_name = ?, last_name = ?, specialization = ?, phone = ? WHERE doctor_id = ?";
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, doctor.getFirstName());
            stmt.setString(2, doctor.getLastName());
            stmt.setString(3, doctor.getSpecialization());
            stmt.setString(4, doctor.getPhone());
            stmt.setInt(5, doctor.getDoctorId());
            
            int affectedRows = stmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            System.err.println("Error updating doctor: " + e.getMessage());
        } finally {
            DBConnection.closeResources(null, stmt, conn);
        }
        
        return success;
    }
    
    /**
     * Get all specializations available in the system
     * @return List of all specializations
     */
    public List<String> getAllSpecializations() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<String> specializations = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT DISTINCT specialization FROM doctors WHERE specialization IS NOT NULL";
            stmt = conn.prepareStatement(sql);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                specializations.add(rs.getString("specialization"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all specializations: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return specializations;
    }
}