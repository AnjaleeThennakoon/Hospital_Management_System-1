package com.hospital.beans;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Represents a bill in the system
 */
public class Bill {
    private int billId;
    private int patientId;
    private BigDecimal amount;
    private Date billDate;
    private String status;  // UNPAID, PAID
    private String description;
    
    // Additional fields for UI display
    private String patientName;
    
    // Constructors
    public Bill() {
    }
    
    public Bill(int billId, int patientId, BigDecimal amount, Date billDate, String status, String description) {
        this.billId = billId;
        this.patientId = patientId;
        this.amount = amount;
        this.billDate = billDate;
        this.status = status;
        this.description = description;
    }
    
    // Getters and Setters
    public int getBillId() {
        return billId;
    }
    
    public void setBillId(int billId) {
        this.billId = billId;
    }
    
    public int getPatientId() {
        return patientId;
    }
    
    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public Date getBillDate() {
        return billDate;
    }
    
    public void setBillDate(Date billDate) {
        this.billDate = billDate;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getPatientName() {
        return patientName;
    }
    
    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }
    
    @Override
    public String toString() {
        return "Bill{" + "billId=" + billId + ", patientId=" + patientId + 
               ", amount=" + amount + ", billDate=" + billDate + 
               ", status=" + status + '}';
    }
}
