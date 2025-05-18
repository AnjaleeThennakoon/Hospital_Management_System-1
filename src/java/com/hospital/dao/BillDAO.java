package com.hospital.dao;

import com.hospital.beans.Bill;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Data Access Object for Bill-related database operations
 */
public class BillDAO {
    
    /**
     * Create a new bill
     * @param bill The bill to create
     * @return The bill ID of the created bill, or -1 if operation failed
     */
    public int createBill(Bill bill) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int billId = -1;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO bills (patient_id, amount, bill_date, status, description) " +
                           "VALUES (?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            stmt.setInt(1, bill.getPatientId());
            stmt.setBigDecimal(2, bill.getAmount());
            
            if (bill.getBillDate() != null) {
                stmt.setDate(3, new java.sql.Date(bill.getBillDate().getTime()));
            } else {
                // If no date provided, use current date
                stmt.setDate(3, new java.sql.Date(new Date().getTime()));
            }
            
            stmt.setString(4, bill.getStatus());
            stmt.setString(5, bill.getDescription());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    billId = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating bill: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return billId;
    }
    
    /**
     * Get a bill by its bill ID
     * @param billId The bill ID
     * @return Bill object if found, null otherwise
     */
    public Bill getBillById(int billId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Bill bill = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT b.*, CONCAT(p.first_name, ' ', p.last_name) as patient_name " +
                          "FROM bills b " +
                          "JOIN patients p ON b.patient_id = p.patient_id " +
                          "WHERE b.bill_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, billId);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setPatientId(rs.getInt("patient_id"));
                bill.setAmount(rs.getBigDecimal("amount"));
                
                java.sql.Date date = rs.getDate("bill_date");
                if (date != null) {
                    bill.setBillDate(new Date(date.getTime()));
                }
                
                bill.setStatus(rs.getString("status"));
                bill.setDescription(rs.getString("description"));
                
                // Additional field for display
                bill.setPatientName(rs.getString("patient_name"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting bill by ID: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return bill;
    }
    
    /**
     * Get bills by patient ID
     * @param patientId The patient ID
     * @return List of bills for the patient
     */
    public List<Bill> getBillsByPatient(int patientId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Bill> bills = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT b.*, CONCAT(p.first_name, ' ', p.last_name) as patient_name " +
                          "FROM bills b " +
                          "JOIN patients p ON b.patient_id = p.patient_id " +
                          "WHERE b.patient_id = ? " +
                          "ORDER BY b.bill_date DESC";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, patientId);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setPatientId(rs.getInt("patient_id"));
                bill.setAmount(rs.getBigDecimal("amount"));
                
                java.sql.Date date = rs.getDate("bill_date");
                if (date != null) {
                    bill.setBillDate(new Date(date.getTime()));
                }
                
                bill.setStatus(rs.getString("status"));
                bill.setDescription(rs.getString("description"));
                
                // Additional field for display
                bill.setPatientName(rs.getString("patient_name"));
                
                bills.add(bill);
            }
        } catch (SQLException e) {
            System.err.println("Error getting bills by patient: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return bills;
    }
    
    /**
     * Get bills by status
     * @param status The bill status
     * @return List of bills with the specified status
     */
    public List<Bill> getBillsByStatus(String status) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Bill> bills = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT b.*, CONCAT(p.first_name, ' ', p.last_name) as patient_name " +
                          "FROM bills b " +
                          "JOIN patients p ON b.patient_id = p.patient_id " +
                          "WHERE b.status = ? " +
                          "ORDER BY b.bill_date DESC";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, status);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setPatientId(rs.getInt("patient_id"));
                bill.setAmount(rs.getBigDecimal("amount"));
                
                java.sql.Date date = rs.getDate("bill_date");
                if (date != null) {
                    bill.setBillDate(new Date(date.getTime()));
                }
                
                bill.setStatus(rs.getString("status"));
                bill.setDescription(rs.getString("description"));
                
                // Additional field for display
                bill.setPatientName(rs.getString("patient_name"));
                
                bills.add(bill);
            }
        } catch (SQLException e) {
            System.err.println("Error getting bills by status: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return bills;
    }
    
    /**
     * Get all bills
     * @return List of all bills
     */
    public List<Bill> getAllBills() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Bill> bills = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT b.*, CONCAT(p.first_name, ' ', p.last_name) as patient_name " +
                          "FROM bills b " +
                          "JOIN patients p ON b.patient_id = p.patient_id " +
                          "ORDER BY b.bill_date DESC";
            stmt = conn.prepareStatement(sql);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setPatientId(rs.getInt("patient_id"));
                bill.setAmount(rs.getBigDecimal("amount"));
                
                java.sql.Date date = rs.getDate("bill_date");
                if (date != null) {
                    bill.setBillDate(new Date(date.getTime()));
                }
                
                bill.setStatus(rs.getString("status"));
                bill.setDescription(rs.getString("description"));
                
                // Additional field for display
                bill.setPatientName(rs.getString("patient_name"));
                
                bills.add(bill);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all bills: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return bills;
    }
    
    /**
     * Update bill status
     * @param billId The bill ID
     * @param status The new status
     * @return true if update successful, false otherwise
     */
    public boolean updateBillStatus(int billId, String status) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE bills SET status = ? WHERE bill_id = ?";
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, status);
            stmt.setInt(2, billId);
            
            int affectedRows = stmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            System.err.println("Error updating bill status: " + e.getMessage());
        } finally {
            DBConnection.closeResources(null, stmt, conn);
        }
        
        return success;
    }
    
    /**
     * Get total amount of unpaid bills for a patient
     * @param patientId The patient ID
     * @return Total amount of unpaid bills
     */
    public BigDecimal getTotalUnpaidBillsForPatient(int patientId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        BigDecimal totalAmount = BigDecimal.ZERO;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT SUM(amount) FROM bills " +
                          "WHERE patient_id = ? AND status = 'UNPAID'";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, patientId);
            
            rs = stmt.executeQuery();
            
            if (rs.next() && rs.getBigDecimal(1) != null) {
                totalAmount = rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting total unpaid bills: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return totalAmount;
    }
    
    /**
     * Get total revenue (paid bills) for a date range
     * @param startDate The start date
     * @param endDate The end date
     * @return Total revenue for the date range
     */
    public BigDecimal getTotalRevenueForDateRange(Date startDate, Date endDate) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        BigDecimal totalRevenue = BigDecimal.ZERO;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT SUM(amount) FROM bills " +
                          "WHERE status = 'PAID' AND bill_date BETWEEN ? AND ?";
            stmt = conn.prepareStatement(sql);
            stmt.setDate(1, new java.sql.Date(startDate.getTime()));
            stmt.setDate(2, new java.sql.Date(endDate.getTime()));
            
            rs = stmt.executeQuery();
            
            if (rs.next() && rs.getBigDecimal(1) != null) {
                totalRevenue = rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting total revenue: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return totalRevenue;
    }
}