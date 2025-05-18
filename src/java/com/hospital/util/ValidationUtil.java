package com.hospital.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Utility class for validation functions
 */
public class ValidationUtil {
    
    // Regex patterns
    private static final String EMAIL_PATTERN = 
            "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
            + "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
    
    private static final String PHONE_PATTERN = "^[0-9]{10}$";
    
    /**
     * Validate if a string is not null or empty
     * @param str The string to validate
     * @return true if string is not null or empty, false otherwise
     */
    public static boolean isNotNullOrEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }
    
    /**
     * Validate email format
     * @param email The email to validate
     * @return true if email format is valid, false otherwise
     */
    public static boolean isValidEmail(String email) {
        if (!isNotNullOrEmpty(email)) {
            return false;
        }
        
        Pattern pattern = Pattern.compile(EMAIL_PATTERN);
        Matcher matcher = pattern.matcher(email);
        return matcher.matches();
    }
    
    /**
     * Validate phone number format (10 digits only)
     * @param phone The phone number to validate
     * @return true if phone format is valid, false otherwise
     */
    public static boolean isValidPhone(String phone) {
        if (!isNotNullOrEmpty(phone)) {
            return false;
        }
        
        Pattern pattern = Pattern.compile(PHONE_PATTERN);
        Matcher matcher = pattern.matcher(phone);
        return matcher.matches();
    }
    
    /**
     * Validate date format (yyyy-MM-dd)
     * @param dateStr The date string to validate
     * @return true if date format is valid, false otherwise
     */
    public static boolean isValidDate(String dateStr) {
        if (!isNotNullOrEmpty(dateStr)) {
            return false;
        }
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        sdf.setLenient(false);
        
        try {
            sdf.parse(dateStr);
            return true;
        } catch (ParseException e) {
            return false;
        }
    }
    
    /**
     * Validate password strength (at least 8 characters, 1 uppercase, 1 lowercase, 1 digit)
     * @param password The password to validate
     * @return true if password meets strength requirements, false otherwise
     */
    public static boolean isStrongPassword(String password) {
        if (!isNotNullOrEmpty(password) || password.length() < 8) {
            return false;
        }
        
        boolean hasUppercase = false;
        boolean hasLowercase = false;
        boolean hasDigit = false;
        
        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) {
                hasUppercase = true;
            } else if (Character.isLowerCase(c)) {
                hasLowercase = true;
            } else if (Character.isDigit(c)) {
                hasDigit = true;
            }
            
            if (hasUppercase && hasLowercase && hasDigit) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * Convert string to date
     * @param dateStr The date string (yyyy-MM-dd)
     * @return Date object if conversion successful, null otherwise
     */
    public static Date parseDate(String dateStr) {
        if (!isValidDate(dateStr)) {
            return null;
        }
        
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            return sdf.parse(dateStr);
        } catch (ParseException e) {
            return null;
        }
    }
    
    /**
     * Format date to string (yyyy-MM-dd)
     * @param date The date to format
     * @return Formatted date string
     */
    public static String formatDate(Date date) {
        if (date == null) {
            return "";
        }
        
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(date);
    }
}