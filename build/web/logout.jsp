<%-- 
    Document   : logout
    Created on : May 11, 2025, 8:04:44 PM
    Author     : Asus
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate the session
    session.invalidate();
    
    // Redirect to login page with logout parameter
    response.sendRedirect("login.jsp?logout=true");
%>
