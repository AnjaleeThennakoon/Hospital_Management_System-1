package com.hospital.beans;

import java.util.Date;

/**
 * Represents a medical record in the system
 */
public class MedicalRecord {
    private int recordId;
    private int patientId;
    private int doctorId;
    private Date recordDate;
    private String diagnosis;
    private String prescription;
    private String notes;
    
    // Additional fields for UI display
    private String patientName;
    private String doctorName;
    
    // Constructors
    public MedicalRecord() {
    }
    
    public MedicalRecord(int recordId, int patientId, int doctorId, Date recordDate, 
                         String diagnosis, String prescription, String notes) {
        this.recordId = recordId;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.recordDate = recordDate;
        this.diagnosis = diagnosis;
        this.prescription = prescription;
        this.notes = notes;
    }
    
    // Getters and Setters
    public int getRecordId() {
        return recordId;
    }
    
    public void setRecordId(int recordId) {
        this.recordId = recordId;
    }
    
    public int getPatientId() {
        return patientId;
    }
    
    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }
    
    public int getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }
    
    public Date getRecordDate() {
        return recordDate;
    }
    
    public void setRecordDate(Date recordDate) {
        this.recordDate = recordDate;
    }
    
    public String getDiagnosis() {
        return diagnosis;
    }
    
    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }
    
    public String getPrescription() {
        return prescription;
    }
    
    public void setPrescription(String prescription) {
        this.prescription = prescription;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public String getPatientName() {
        return patientName;
    }
    
    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }
    
    public String getDoctorName() {
        return doctorName;
    }
    
    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }
    
    @Override
    public String toString() {
        return "MedicalRecord{" + "recordId=" + recordId + ", patientId=" + patientId + 
               ", doctorId=" + doctorId + ", recordDate=" + recordDate + 
               ", diagnosis=" + diagnosis + '}';
    }
}