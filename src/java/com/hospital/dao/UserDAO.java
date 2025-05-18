package com.hospital.dao;

import com.hospital.beans.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for User-related database operations
 */
public class UserDAO {
    
    /**
     * Authenticate user by username and password
     * @param username The username
     * @param password The password
     * @return User object if authentication successful, null otherwise
     */
    public User authenticate(String username, String password) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        User user = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM users WHERE username = ? AND password = ? AND active = true";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password); // In a real app, you'd use password hashing
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setActive(rs.getBoolean("active"));
            }
        } catch (SQLException e) {
            System.err.println("Error authenticating user: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return user;
    }
    
    /**
     * Create a new user
     * @param user The user to create
     * @return The userId of the created user, or -1 if operation failed
     */
    public int createUser(User user) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int userId = -1;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO users (username, password, email, role, active) VALUES (?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword()); // In a real app, you'd hash the password
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getRole());
            stmt.setBoolean(5, user.isActive());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    userId = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating user: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return userId;
    }
    
    /**
     * Check if a username already exists
     * @param username The username to check
     * @return true if username exists, false otherwise
     */
    public boolean usernameExists(String username) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        boolean exists = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT 1 FROM users WHERE username = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            
            rs = stmt.executeQuery();
            exists = rs.next();
        } catch (SQLException e) {
            System.err.println("Error checking username: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return exists;
    }
    
    /**
     * Get a user by their user ID
     * @param userId The user ID
     * @return User object if found, null otherwise
     */
    public User getUserById(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        User user = null;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM users WHERE user_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setActive(rs.getBoolean("active"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting user by ID: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return user;
    }
    
    /**
     * Get all users
     * @return List of all users
     */
    public List<User> getAllUsers() {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<User> users = new ArrayList<>();
        
        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM users";
            stmt = conn.prepareStatement(sql);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setActive(rs.getBoolean("active"));
                
                users.add(user);
            }
        } catch (SQLException e) {
            System.err.println("Error getting all users: " + e.getMessage());
        } finally {
            DBConnection.closeResources(rs, stmt, conn);
        }
        
        return users;
    }
    
    /**
     * Update a user's information
     * @param user The user to update
     * @return true if update successful, false otherwise
     */
    public boolean updateUser(User user) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE users SET username = ?, email = ?, role = ?, active = ? WHERE user_id = ?";
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getRole());
            stmt.setBoolean(4, user.isActive());
            stmt.setInt(5, user.getUserId());
            
            int affectedRows = stmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            System.err.println("Error updating user: " + e.getMessage());
        } finally {
            DBConnection.closeResources(null, stmt, conn);
        }
        
        return success;
    }
    
    /**
     * Update a user's password
     * @param userId The user ID
     * @param newPassword The new password
     * @return true if update successful, false otherwise
     */
    public boolean updatePassword(int userId, String newPassword) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE users SET password = ? WHERE user_id = ?";
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, newPassword); // In a real app, you'd hash the password
            stmt.setInt(2, userId);
            
            int affectedRows = stmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            System.err.println("Error updating password: " + e.getMessage());
        } finally {
            DBConnection.closeResources(null, stmt, conn);
        }
        
        return success;
    }
    
    /**
     * Deactivate a user
     * @param userId The user ID
     * @return true if deactivation successful, false otherwise
     */
    public boolean deactivateUser(int userId) {
        Connection conn = null;
        PreparedStatement stmt = null;
        boolean success = false;
        
        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE users SET active = false WHERE user_id = ?";
            stmt = conn.prepareStatement(sql);
            
            stmt.setInt(1, userId);
            
            int affectedRows = stmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            System.err.println("Error deactivating user: " + e.getMessage());
        } finally {
            DBConnection.closeResources(null, stmt, conn);
        }
        
        return success;
    }
}