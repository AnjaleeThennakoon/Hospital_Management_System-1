package com.hospital.dao;

import com.hospital.beans.MedicalRecord;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Data Access Object for MedicalRecord-related database operations
 */
public class MedicalRecordDAO {
    
    /**
     * Create a new medical record
     * @param medicalRecord The medical record to create
     * @return The record ID of the created medical record, or -1 if operation failed
     */
    public int createMedicalRecord(MedicalRecord medicalRecord) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int recordId = -1;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO medical_records (patient_id, doctor_id, record_date, diagnosis, prescription, notes) " +
                           "VALUES (?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            stmt.setInt(1, medicalRecord.getPatientId());
            stmt.setInt(2, medicalRecord.getDoctorId());
            
            if (medicalRecord.getRecordDate() != null) {
                stmt.setDate(3, new java.sql.Date(medicalRecord.getRecordDate().getTime()));
            } else {
                // If no date provided, use current date
                stmt.setDate(3, new java.sql.Date(new Date().getTime()));
            }
            
            stmt.setString(4, medicalRecord.getDiagnosis());
            stmt.setString(5, medicalRecord.getPrescription());
            stmt.setString(6, medicalRecord.getNotes());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    recordId = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating medical record: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return recordId;
    }
    
    /**
     * Get a medical record by its record ID
     * @param recordId The record ID
     * @return MedicalRecord object if found, null otherwise
     */
    public MedicalRecord getMedicalRecordById(int recordId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        MedicalRecord medicalRecord = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT mr.*, CONCAT(p.first_name, ' ', p.last_name) as patient_name, " +
                          "CONCAT(d.first_name, ' ', d.last_name) as doctor_name " +
                          "FROM medical_records mr " +
                          "JOIN patients p ON mr.patient_id = p.patient_id " +
                          "JOIN doctors d ON mr.doctor_id = d.doctor_id " +
                          "WHERE mr.record_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, recordId);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                medicalRecord = new MedicalRecord();
                medicalRecord.setRecordId(rs.getInt("record_id"));
                medicalRecord.setPatientId(rs.getInt("patient_id"));
                medicalRecord.setDoctorId(rs.getInt("doctor_id"));
                
                java.sql.Date date = rs.getDate("record_date");
                if (date != null) {
                    medicalRecord.setRecordDate(new Date(date.getTime()));
                }
                
                medicalRecord.setDiagnosis(rs.getString("diagnosis"));
                medicalRecord.setPrescription(rs.getString("prescription"));
                medicalRecord.setNotes(rs.getString("notes"));
                
                // Additional fields for display
                medicalRecord.setPatientName(rs.getString("patient_name"));
                medicalRecord.setDoctorName(rs.getString("doctor_name"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting medical record by ID: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return medicalRecord;
    }
    
    /**
     * Get medical records by patient ID
     * @param patientId The patient ID
     * @return List of medical records for the patient
     */
    public List<MedicalRecord> getMedicalRecordsByPatient(int patientId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<MedicalRecord> medicalRecords = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT mr.*, CONCAT(p.first_name, ' ', p.last_name) as patient_name, " +
                          "CONCAT(d.first_name, ' ', d.last_name) as doctor_name " +
                          "FROM medical_records mr " +
                          "JOIN patients p ON mr.patient_id = p.patient_id " +
                          "JOIN doctors d ON mr.doctor_id = d.doctor_id " +
                          "WHERE mr.patient_id = ? " +
                          "ORDER BY mr.record_date DESC";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, patientId);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                MedicalRecord medicalRecord = new MedicalRecord();
                medicalRecord.setRecordId(rs.getInt("record_id"));
                medicalRecord.setPatientId(rs.getInt("patient_id"));
                medicalRecord.setDoctorId(rs.getInt("doctor_id"));
                
                java.sql.Date date = rs.getDate("record_date");
                if (date != null) {
                    medicalRecord.setRecordDate(new Date(date.getTime()));
                }
                
                medicalRecord.setDiagnosis(rs.getString("diagnosis"));
                medicalRecord.setPrescription(rs.getString("prescription"));
                medicalRecord.setNotes(rs.getString("notes"));
                
                // Additional fields for display
                medicalRecord.setPatientName(rs.getString("patient_name"));
                medicalRecord.setDoctorName(rs.getString("doctor_name"));
                
                medicalRecords.add(medicalRecord);
            }
        } catch (SQLException e) {
            System.err.println("Error getting medical records by patient: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return medicalRecords;
    }
    
    /**
     * Get medical records by doctor ID
     * @param doctorId The doctor ID
     * @return List of medical records created by the doctor
     */
    public List<MedicalRecord> getMedicalRecordsByDoctor(int doctorId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<MedicalRecord> medicalRecords = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT mr.*, CONCAT(p.first_name, ' ', p.last_name) as patient_name, " +
                          "CONCAT(d.first_name, ' ', d.last_name) as doctor_name " +
                          "FROM medical_records mr " +
                          "JOIN patients p ON mr.patient_id = p.patient_id " +
                          "JOIN doctors d ON mr.doctor_id = d.doctor_id " +
                          "WHERE mr.doctor_id = ? " +
                          "ORDER BY mr.record_date DESC";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, doctorId);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                MedicalRecord medicalRecord = new MedicalRecord();
                medicalRecord.setRecordId(rs.getInt("record_id"));
                medicalRecord.setPatientId(rs.getInt("patient_id"));
                medicalRecord.setDoctorId(rs.getInt("doctor_id"));
                
                java.sql.Date date = rs.getDate("record_date");
                if (date != null) {
                    medicalRecord.setRecordDate(new Date(date.getTime()));
                }
                
                medicalRecord.setDiagnosis(rs.getString("diagnosis"));
                medicalRecord.setPrescription(rs.getString("prescription"));
                medicalRecord.setNotes(rs.getString("notes"));
                
                // Additional fields for display
                medicalRecord.setPatientName(rs.getString("patient_name"));
                medicalRecord.setDoctorName(rs.getString("doctor_name"));
                
                medicalRecords.add(medicalRecord);
            }
        } catch (SQLException e) {
            System.err.println("Error getting medical records by doctor: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return medicalRecords;
    }
    
    /**
     * Update a medical record
     * @param medicalRecord The medical record to update
     * @return true if update successful, false otherwise
     */
    public boolean updateMedicalRecord(MedicalRecord medicalRecord) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE medical_records SET diagnosis = ?, prescription = ?, notes = ? " +
                           "WHERE record_id = ?";
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, medicalRecord.getDiagnosis());
            stmt.setString(2, medicalRecord.getPrescription());
            stmt.setString(3, medicalRecord.getNotes());
            stmt.setInt(4, medicalRecord.getRecordId());
            
            int affectedRows = stmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            System.err.println("Error updating medical record: " + e.getMessage());
        } finally {
            DBConnection.closeResources(null, stmt, conn);
        }
        
        return success;
    }
    
    /**
     * Search medical records by diagnosis
     * @param diagnosis The diagnosis to search for
     * @return List of matching medical records
     */
    public List<MedicalRecord> searchMedicalRecordsByDiagnosis(String diagnosis) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<MedicalRecord> medicalRecords = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT mr.*, CONCAT(p.first_name, ' ', p.last_name) as patient_name, " +
                          "CONCAT(d.first_name, ' ', d.last_name) as doctor_name " +
                          "FROM medical_records mr " +
                          "JOIN patients p ON mr.patient_id = p.patient_id " +
                          "JOIN doctors d ON mr.doctor_id = d.doctor_id " +
                          "WHERE mr.diagnosis LIKE ? " +
                          "ORDER BY mr.record_date DESC";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%" + diagnosis + "%");
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                MedicalRecord medicalRecord = new MedicalRecord();
                medicalRecord.setRecordId(rs.getInt("record_id"));
                medicalRecord.setPatientId(rs.getInt("patient_id"));
                medicalRecord.setDoctorId(rs.getInt("doctor_id"));
                
                java.sql.Date date = rs.getDate("record_date");
                if (date != null) {
                    medicalRecord.setRecordDate(new Date(date.getTime()));
                }
                
                medicalRecord.setDiagnosis(rs.getString("diagnosis"));
                medicalRecord.setPrescription(rs.getString("prescription"));
                medicalRecord.setNotes(rs.getString("notes"));
                
                // Additional fields for display
                medicalRecord.setPatientName(rs.getString("patient_name"));
                medicalRecord.setDoctorName(rs.getString("doctor_name"));
                
                medicalRecords.add(medicalRecord);
            }
        } catch (SQLException e) {
            System.err.println("Error searching medical records by diagnosis: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return medicalRecords;
    }
}