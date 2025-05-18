package com.hospital.beans;

/**
 * Represents a doctor in the system
 */
public class Doctor {
    private int doctorId;
    private int userId;
    private String firstName;
    private String lastName;
    private String specialization;
    private String phone;
    
    // Additional fields not in DB but useful for UI
    private String email;
    private String username;
    
    // Constructors
    public Doctor() {
    }
    
    public Doctor(int doctorId, int userId, String firstName, String lastName, String specialization, String phone) {
        this.doctorId = doctorId;
        this.userId = userId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.specialization = specialization;
        this.phone = phone;
    }
    
    // Getters and Setters
    public int getDoctorId() {
        return doctorId;
    }
    
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getFirstName() {
        return firstName;
    }
    
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    
    public String getLastName() {
        return lastName;
    }
    
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    
    public String getSpecialization() {
        return specialization;
    }
    
    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    // Utility methods
    public String getFullName() {
        return firstName + " " + lastName;
    }
    
    @Override
    public String toString() {
        return "Doctor{" + "doctorId=" + doctorId + ", firstName=" + firstName + ", lastName=" + lastName + ", specialization=" + specialization + '}';
    }
}