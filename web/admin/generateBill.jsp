<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Generate Bill</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .bill-container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
            border: 1px solid #ddd;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .bill-header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #0d6efd;
            padding-bottom: 10px;
        }
        .bill-details {
            margin-bottom: 20px;
        }
        .bill-table {
            width: 100%;
            margin-bottom: 20px;
        }
        .bill-table th {
            background-color: #f8f9fa;
        }
        .total-section {
            text-align: right;
            font-weight: bold;
            font-size: 1.2em;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    <div class="container bill-container">
        <div class="bill-header">
            <h2>Hospital Management System</h2>
            <h3>Medical Bill</h3>
        </div>
        
        <div class="row bill-details">
            <div class="col-md-6">
                <p><strong>Bill ID:</strong> ${bill.billId}</p>
                <p><strong>Date:</strong> ${bill.billDate}</p>
                <p><strong>Patient ID:</strong> ${bill.patient.patientId}</p>
                <p><strong>Patient Name:</strong> ${bill.patient.firstName} ${bill.patient.lastName}</p>
            </div>
            <div class="col-md-6">
                <p><strong>Doctor:</strong> Dr. ${bill.doctor.firstName} ${bill.doctor.lastName}</p>
                <p><strong>Appointment ID:</strong> ${bill.appointment.appointmentId}</p>
                <p><strong>Appointment Date:</strong> ${bill.appointment.appointmentDate}</p>
            </div>
        </div>
        
        <table class="table table-bordered bill-table">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Description</th>
                    <th>Quantity</th>
                    <th>Unit Price</th>
                    <th>Amount</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>1</td>
                    <td>Consultation Fee</td>
                    <td>1</td>
                    <td>${bill.consultationFee}</td>
                    <td>${bill.consultationFee}</td>
                </tr>
                <c:forEach var="item" items="${bill.medicines}" varStatus="loop">
                    <tr>
                        <td>${loop.index + 2}</td>
                        <td>${item.medicineName}</td>
                        <td>${item.quantity}</td>
                        <td>${item.price}</td>
                        <td>${item.price * item.quantity}</td>
                    </tr>
                </c:forEach>
                <c:forEach var="item" items="${bill.tests}" varStatus="loop">
                    <tr>
                        <td>${loop.index + 2 + bill.medicines.size()}</td>
                        <td>${item.testName} (Lab Test)</td>
                        <td>1</td>
                        <td>${item.testFee}</td>
                        <td>${item.testFee}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <div class="total-section">
            <p>Subtotal: $${bill.subtotal}</p>
            <p>Tax (${bill.taxRate}%): $${bill.taxAmount}</p>
            <p>Discount: $${bill.discount}</p>
            <p>Total Amount: $${bill.totalAmount}</p>
        </div>
        
        <div class="row mt-4">
            <div class="col-md-6">
                <div class="form-group">
                    <label for="paymentMethod" class="form-label">Payment Method:</label>
                    <select class="form-select" id="paymentMethod" name="paymentMethod">
                        <option value="CASH">Cash</option>
                        <option value="CARD">Credit/Debit Card</option>
                        <option value="INSURANCE">Insurance</option>
                        <option value="BANK_TRANSFER">Bank Transfer</option>
                    </select>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group">
                    <label for="paymentStatus" class="form-label">Payment Status:</label>
                    <select class="form-select" id="paymentStatus" name="paymentStatus">
                        <option value="PENDING">Pending</option>
                        <option value="PAID">Paid</option>
                        <option value="PARTIAL">Partial</option>
                    </select>
                </div>
            </div>
        </div>
        
        <div class="row mt-4">
            <div class="col-md-12">
                <label for="notes" class="form-label">Notes:</label>
                <textarea class="form-control" id="notes" name="notes" rows="3"></textarea>
            </div>
        </div>
        
        <div class="d-flex justify-content-between mt-4">
            <button class="btn btn-secondary" onclick="window.print()">Print Bill</button>
            <div>
                <button class="btn btn-primary" id="saveBill">Save Bill</button>
                <a href="viewBills.jsp" class="btn btn-outline-danger">Cancel</a>
            </div>
        </div>
    </div>
    
    <jsp:include page="../common/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('saveBill').addEventListener('click', function() {
            // Get form data
            const paymentMethod = document.getElementById('paymentMethod').value;
            const paymentStatus = document.getElementById('paymentStatus').value;
            const notes = document.getElementById('notes').value;
            
            // Create request data
            const requestData = {
                billId: ${bill.billId},
                paymentMethod: paymentMethod,
                paymentStatus: paymentStatus,
                notes: notes
            };
            
            // Send AJAX request to save the bill
            fetch('${pageContext.request.contextPath}/BillController?action=save', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(requestData)
            })
            .then(response => response.json())
            .then(data => {
                if(data.success) {
                    alert('Bill saved successfully!');
                    window.location.href = 'viewBills.jsp';
                } else {
                    alert('Error saving bill: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred while saving the bill.');
            });
        });
    </script>
</body>
</html>