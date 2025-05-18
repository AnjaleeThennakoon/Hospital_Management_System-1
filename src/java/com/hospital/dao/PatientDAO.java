package com.hospital.dao;

import com.hospital.beans.Patient;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Patient-related database operations
 */
public class PatientDAO {
    
    /**
     * Create a new patient
     * @param patient The patient to create
     * @param userId The associated user ID
     * @return The patient ID of the created patient, or -1 if operation failed
     */
    public int createPatient(Patient patient, int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int patientId = -1;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO patients (user_id, first_name, last_name, gender, date_of_birth, phone, address) " +
                           "VALUES (?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            stmt.setInt(1, userId);
            stmt.setString(2, patient.getFirstName());
            stmt.setString(3, patient.getLastName());
            stmt.setString(4, patient.getGender());
            
            if (patient.getDateOfBirth() != null) {
                stmt.setDate(5, new java.sql.Date(patient.getDateOfBirth().getTime()));
            } else {
                stmt.setNull(5, java.sql.Types.DATE);
            }
            
            stmt.setString(6, patient.getPhone());
            stmt.setString(7, patient.getAddress());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    patientId = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating patient: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return patientId;
    }
    
    /**
     * Get a patient by their patient ID
     * @param patientId The patient ID
     * @return Patient object if found, null otherwise
     */
    public Patient getPatientById(int patientId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Patient patient = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT p.*, u.username, u.email FROM patients p " +
                          "JOIN users u ON p.user_id = u.user_id " +
                          "WHERE p.patient_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, patientId);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                patient = new Patient();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setUserId(rs.getInt("user_id"));
                patient.setFirstName(rs.getString("first_name"));
                patient.setLastName(rs.getString("last_name"));
                patient.setGender(rs.getString("gender"));
                
                java.sql.Date dob = rs.getDate("date_of_birth");
                if (dob != null) {
                    patient.setDateOfBirth(new java.util.Date(dob.getTime()));
                }
                
                patient.setPhone(rs.getString("phone"));
                patient.setAddress(rs.getString("address"));
                
                // Additional fields from the users table
                patient.setUsername(rs.getString("username"));
                patient.setEmail(rs.getString("email"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting patient by ID: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return patient;
    }
    
    /**
     * Get a patient by their user ID
     * @param userId The user ID
     * @return Patient object if found, null otherwise
     */
    public Patient getPatientByUserId(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Patient patient = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT p.*, u.username, u.email FROM patients p " +
                          "JOIN users u ON p.user_id = u.user_id " +
                          "WHERE p.user_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                patient = new Patient();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setUserId(rs.getInt("user_id"));
                patient.setFirstName(rs.getString("first_name"));
                patient.setLastName(rs.getString("last_name"));
                patient.setGender(rs.getString("gender"));
                
                java.sql.Date dob = rs.getDate("date_of_birth");
                if (dob != null) {
                    patient.setDateOfBirth(new java.util.Date(dob.getTime()));
                }
                
                patient.setPhone(rs.getString("phone"));
                patient.setAddress(rs.getString("address"));
                
                // Additional fields from the users table
                patient.setUsername(rs.getString("username"));
                patient.setEmail(rs.getString("email"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting patient by user ID: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return patient;
    }
    
    /**
     * Get all patients
     * @return List of all patients
     */
    public List<Patient> getAllPatients() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Patient> patients = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT p.*, u.username, u.email FROM patients p " +
                          "JOIN users u ON p.user_id = u.user_id " +
                          "WHERE u.active = true";
            stmt = conn.prepareStatement(sql);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Patient patient = new Patient();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setUserId(rs.getInt("user_id"));
                patient.setFirstName(rs.getString("first_name"));
                patient.setLastName(rs.getString("last_name"));
                patient.setGender(rs.getString("gender"));
                
                java.sql.Date dob = rs.getDate("date_of_birth");
                if (dob != null) {
                    patient.setDateOfBirth(new java.util.Date(dob.getTime()));
                }
                
                patient.setPhone(rs.getString("phone"));
                patient.setAddress(rs.getString("address"));
                
                // Additional fields from the users table
                patient.setUsername(rs.getString("username"));
                patient.setEmail(rs.getString("email"));
                
                patients.add(patient);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all patients: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return patients;
    }
    
    /**
     * Search patients by name or phone
     * @param searchTerm The search term (name or phone)
     * @return List of matching patients
     */
    public List<Patient> searchPatients(String searchTerm) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Patient> patients = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT p.*, u.username, u.email FROM patients p " +
                          "JOIN users u ON p.user_id = u.user_id " +
                          "WHERE (p.first_name LIKE ? OR p.last_name LIKE ? OR p.phone LIKE ?) " +
                          "AND u.active = true";
            stmt = conn.prepareStatement(sql);
            
            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Patient patient = new Patient();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setUserId(rs.getInt("user_id"));
                patient.setFirstName(rs.getString("first_name"));
                patient.setLastName(rs.getString("last_name"));
                patient.setGender(rs.getString("gender"));
                
                java.sql.Date dob = rs.getDate("date_of_birth");
                if (dob != null) {
                    patient.setDateOfBirth(new java.util.Date(dob.getTime()));
                }
                
                patient.setPhone(rs.getString("phone"));
                patient.setAddress(rs.getString("address"));
                
                // Additional fields from the users table
                patient.setUsername(rs.getString("username"));
                patient.setEmail(rs.getString("email"));
                
                patients.add(patient);
            }
        } catch (SQLException e) {
            System.err.println("Error searching patients: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return patients;
    }
    
    /**
     * Update a patient's information
     * @param patient The patient to update
     * @return true if update successful, false otherwise
     */
    public boolean updatePatient(Patient patient) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE patients SET first_name = ?, last_name = ?, gender = ?, " +
                           "date_of_birth = ?, phone = ?, address = ? WHERE patient_id = ?";
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, patient.getFirstName());
            stmt.setString(2, patient.getLastName());
            stmt.setString(3, patient.getGender());
            
            if (patient.getDateOfBirth() != null) {
                stmt.setDate(4, new java.sql.Date(patient.getDateOfBirth().getTime()));
            } else {
                stmt.setNull(4, java.sql.Types.DATE);
            }
            
            stmt.setString(5, patient.getPhone());
            stmt.setString(6, patient.getAddress());
            stmt.setInt(7, patient.getPatientId());
            
            int affectedRows = stmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            System.err.println("Error updating patient: " + e.getMessage());
        } finally {
            DBConnection.closeResources(null, stmt, conn);
        }
        
        return success;
    }
}