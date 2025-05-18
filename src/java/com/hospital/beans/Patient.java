package com.hospital.beans;

import java.util.Date;

/**
 * Represents a patient in the system
 */
public class Patient {
    private int patientId;
    private int userId;
    private String firstName;
    private String lastName;
    private String gender;
    private Date dateOfBirth;
    private String phone;
    private String address;
    
    // Additional fields not in DB but useful for UI
    private String email;
    private String username;
    
    // Constructors
    public Patient() {
    }
    
    public Patient(int patientId, int userId, String firstName, String lastName, String gender, Date dateOfBirth, String phone, String address) {
        this.patientId = patientId;
        this.userId = userId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.phone = phone;
        this.address = address;
    }
    
    // Getters and Setters
    public int getPatientId() {
        return patientId;
    }
    
    public void setPatientId(int patientId) {
        this.patientId = patientId;
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
    
    public String getGender() {
        return gender;
    }
    
    public void setGender(String gender) {
        this.gender = gender;
    }
    
    public Date getDateOfBirth() {
        return dateOfBirth;
    }
    
    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
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
    
    // Calculate age based on date of birth
    public int getAge() {
        if (dateOfBirth == null) {
            return 0;
        }
        Date now = new Date();
        long diffInMillis = now.getTime() - dateOfBirth.getTime();
        return (int) (diffInMillis / (1000L * 60 * 60 * 24 * 365));
    }
    
    @Override
    public String toString() {
        return "Patient{" + "patientId=" + patientId + ", firstName=" + firstName + ", lastName=" + lastName + '}';
    }
}