<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Bills</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css" rel="stylesheet">
</head>
<body>
    <!-- Include header and navbar -->
    <jsp:include page="../common/header.jsp" />
    
    
    <div class="container mt-4">
        <h2>My Bills</h2>
        
        <!-- Bills Summary Card -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card bg-light">
                    <div class="card-body">
                        <h5 class="card-title">Total Due</h5>
                        <h3 class="text-danger">${totalDue}</h3>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card bg-light">
                    <div class="card-body">
                        <h5 class="card-title">Total Paid</h5>
                        <h3 class="text-success">${totalPaid}</h3>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card bg-light">
                    <div class="card-body">
                        <h5 class="card-title">Payment Status</h5>
                        <h3 class="${paymentStatus == 'Good Standing' ? 'text-success' : 'text-warning'}">${paymentStatus}</h3>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Filter options -->
        <div class="card mb-4">
            <div class="card-header">
                <h5>Filter Bills</h5>
            </div>
            <div class="card-body">
                <form id="filterForm" class="row g-3">
                    <div class="col-md-3">
                        <label for="statusFilter" class="form-label">Payment Status</label>
                        <select class="form-select" id="statusFilter">
                            <option value="">All</option>
                            <option value="PAID">Paid</option>
                            <option value="PENDING">Pending</option>
                            <option value="OVERDUE">Overdue</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="fromDate" class="form-label">From Date</label>
                        <input type="date" class="form-control" id="fromDate">
                    </div>
                    <div class="col-md-3">
                        <label for="toDate" class="form-label">To Date</label>
                        <input type="date" class="form-control" id="toDate">
                    </div>
                    <div class="col-md-3">
                        <label for="amountMin" class="form-label">Min Amount</label>
                        <input type="number" class="form-control" id="amountMin" min="0" step="0.01">
                    </div>
                    <div class="col-12 mt-3">
                        <button type="button" id="applyFilter" class="btn btn-primary">Apply Filters</button>
                        <button type="button" id="resetFilter" class="btn btn-secondary">Reset</button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Bills Table -->
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table id="billsTable" class="table table-striped">
                        <thead>
                            <tr>
                                <th>Bill ID</th>
                                <th>Date</th>
                                <th>Description</th>
                                <th>Amount</th>
                                <th>Insurance Coverage</th>
                                <th>Your Responsibility</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${bills}" var="bill">
                                <tr>
                                    <td>${bill.id}</td>
                                    <td>${bill.date}</td>
                                    <td>${bill.description}</td>
                                    <td>${bill.totalAmount}</td>
                                    <td>${bill.insuranceCoverage}</td>
                                    <td>${bill.patientResponsibility}</td>
                                    <td>
                                        <span class="badge bg-${bill.status == 'PAID' ? 'success' : 
                                                          bill.status == 'PENDING' ? 'warning' : 
                                                          'danger'}">
                                            ${bill.status}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/patient/viewBillDetails.jsp?id=${bill.id}" 
                                           class="btn btn-sm btn-info">View Details</a>
                                           
                                        <c:if test="${bill.status != 'PAID'}">
                                            <button class="btn btn-sm btn-success" 
                                                    onclick="payBill(${bill.id}, ${bill.patientResponsibility})">Pay Now</button>
                                        </c:if>
                                        
                                        <a href="${pageContext.request.contextPath}/bill/download?id=${bill.id}" 
                                           class="btn btn-sm btn-secondary">Download PDF</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Payment Modal -->
    <div class="modal fade" id="paymentModal" tabindex="-1" aria-labelledby="paymentModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="paymentModalLabel">Make Payment</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="paymentForm">
                        <input type="hidden" id="billId" name="billId">
                        
                        <div class="mb-3">
                            <label for="amountToPay" class="form-label">Amount to Pay</label>
                            <input type="number" class="form-control" id="amountToPay" name="amountToPay" readonly>
                        </div>
                        
                        <div class="mb-3">
                            <label for="paymentMethod" class="form-label">Payment Method</label>
                            <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                                <option value="">Select Payment Method</option>
                                <option value="CREDIT_CARD">Credit Card</option>
                                <option value="DEBIT_CARD">Debit Card</option>
                                <option value="INSURANCE">Insurance</option>
                                <option value="BANK_TRANSFER">Bank Transfer</option>
                            </select>
                        </div>
                        
                        <!-- Credit/Debit Card Details (shown conditionally) -->
                        <div id="cardDetails" style="display: none;">
                            <div class="mb-3">
                                <label for="cardNumber" class="form-label">Card Number</label>
                                <input type="text" class="form-control" id="cardNumber" name="cardNumber" 
                                       placeholder="XXXX XXXX XXXX XXXX">
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="expiryDate" class="form-label">Expiry Date</label>
                                    <input type="text" class="form-control" id="expiryDate" name="expiryDate" 
                                           placeholder="MM/YY">
                                </div>
                                <div class="col-md-6">
                                    <label for="cvv" class="form-label">CVV</label>
                                    <input type="text" class="form-control" id="cvv" name="cvv" 
                                           placeholder="XXX">
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="cardholderName" class="form-label">Cardholder Name</label>
                                <input type="text" class="form-control" id="cardholderName" name="cardholderName">
                            </div>
                        </div>
                        
                        <!-- Insurance Details -->
                        <div id="insuranceDetails" style="display: none;">
                            <div class="mb-3">
                                <label for="insuranceProvider" class="form-label">Insurance Provider</label>
                                <input type="text" class="form-control" id="insuranceProvider" name="insuranceProvider">
                            </div>
                            
                            <div class="mb-3">
                                <label for="policyNumber" class="form-label">Policy Number</label>
                                <input type="text" class="form-control" id="policyNumber" name="policyNumber">
                            </div>
                        </div>
                        
                        <!-- Bank Transfer Details -->
                        <div id="bankDetails" style="display: none;">
                            <div class="mb-3">
                                <label for="accountName" class="form-label">Account Name</label>
                                <input type="text" class="form-control" id="accountName" name="accountName">
                            </div>
                            
                            <div class="mb-3">
                                <label for="accountNumber" class="form-label">Account Number</label>
                                <input type="text" class="form-control" id="accountNumber" name="accountNumber">
                            </div>
                            
                            <div class="mb-3">
                                <label for="bankName" class="form-label">Bank Name</label>
                                <input type="text" class="form-control" id="bankName" name="bankName">
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="confirmPayment">Make Payment</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Include footer -->
    <jsp:include page="../common/footer.jsp" />
    
    <!-- Bootstrap JS and jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Initialize DataTable
            const billsTable = $('#billsTable').DataTable({
                order: [[1, 'desc']], // Sort by date (column 1) in descending order
                language: {
                    emptyTable: "No bills found",
                    zeroRecords: "No matching bills found"
                },
                pageLength: 10,
                responsive: true
            });
            
            // Apply filters
            $('#applyFilter').click(function() {
                applyFilters();
            });
            
            // Reset filters
            $('#resetFilter').click(function() {
                $('#filterForm')[0].reset();
                applyFilters();
            });
            
            // Show/hide payment details based on selection
            $('#paymentMethod').change(function() {
                const method = $(this).val();
                $('#cardDetails, #insuranceDetails, #bankDetails').hide();
                
                if (method === 'CREDIT_CARD' || method === 'DEBIT_CARD') {
                    $('#cardDetails').show();
                } else if (method === 'INSURANCE') {
                    $('#insuranceDetails').show();
                } else if (method === 'BANK_TRANSFER') {
                    $('#bankDetails').show();
                }
            });
            
            // Confirm payment
            $('#confirmPayment').click(function() {
                const billId = $('#billId').val();
                const paymentMethod = $('#paymentMethod').val();
                
                if (!paymentMethod) {
                    alert("Please select a payment method");
                    return;
                }
                
                // Different validation based on payment method
                let isValid = true;
                let paymentDetails = {
                    billId: billId,
                    paymentMethod: paymentMethod,
                    amount: $('#amountToPay').val()
                };
                
                if (paymentMethod === 'CREDIT_CARD' || paymentMethod === 'DEBIT_CARD') {
                    if (!$('#cardNumber').val() || !$('#expiryDate').val() || !$('#cvv').val() || !$('#cardholderName').val()) {
                        alert("Please fill all card details");
                        isValid = false;
                        return;
                    }
                    
                    paymentDetails.cardNumber = $('#cardNumber').val();
                    paymentDetails.expiryDate = $('#expiryDate').val();
                    paymentDetails.cardholderName = $('#cardholderName').val();
                } else if (paymentMethod === 'INSURANCE') {
                    if (!$('#insuranceProvider').val() || !$('#policyNumber').val()) {
                        alert("Please fill all insurance details");
                        isValid = false;
                        return;
                    }
                    
                    paymentDetails.insuranceProvider = $('#insuranceProvider').val();
                    paymentDetails.policyNumber = $('#policyNumber').val();
                } else if (paymentMethod === 'BANK_TRANSFER') {
                    if (!$('#accountName').val() || !$('#accountNumber').val() || !$('#bankName').val()) {
                        alert("Please fill all bank details");
                        isValid = false;
                        return;
                    }
                    
                    paymentDetails.accountName = $('#accountName').val();
                    paymentDetails.accountNumber = $('#accountNumber').val();
                    paymentDetails.bankName = $('#bankName').val();
                }
                
                if (isValid) {
                    // Process payment
                    $.ajax({
                        url: "${pageContext.request.contextPath}/bill/processPayment",
                        type: "POST",
                        data: paymentDetails,
                        success: function(response) {
                            alert("Payment processed successfully!");
                            $('#paymentModal').modal('hide');
                            location.reload();
                        },
                        error: function(xhr, status, error) {
                            alert("Error processing payment: " + error);
                        }
                    });
                }
            });
            
            function applyFilters() {
                const status = $('#statusFilter').val();
                const fromDate = $('#fromDate').val();
                const toDate = $('#toDate').val();
                const amountMin = $('#amountMin').val();
                
                // AJAX call to get filtered bills
                $.ajax({
                    url: "${pageContext.request.contextPath}/bill/getFilteredBills",
                    type: "GET",
                    data: {
                        status: status,
                        fromDate: fromDate,
                        toDate: toDate,
                        amountMin: amountMin
                    },
                    dataType: "json",
                    success: function(data) {
                        // Clear and reload the table with new data
                        billsTable.clear();
                        
                        $.each(data, function(index, bill) {
                            const statusClass = bill.status === 'PAID' ? 'success' :
                                              bill.status === 'PENDING' ? 'warning' : 'danger';
                            
                            let actions = `
                                <a href="${pageContext.request.contextPath}/patient/viewBillDetails.jsp?id=${bill.id}" 
                                   class="btn btn-sm btn-info">View Details</a>
                            `;
                            
                            if (bill.status !== 'PAID') {
                                actions += `
                                    <button class="btn btn-sm btn-success" 
                                            onclick="payBill(${bill.id}, ${bill.patientResponsibility})">Pay Now</button>
                                `;
                            }
                            
                            actions += `
                                <a href="${pageContext.request.contextPath}/bill/download?id=${bill.id}" 
                                   class="btn btn-sm btn-secondary">Download PDF</a>
                            `;
                            
                            billsTable.row.add([
                                bill.id,
                                bill.date,
                                bill.description,
                                bill.totalAmount,
                                bill.insuranceCoverage,
                                bill.patientResponsibility,
                                `<span class="badge bg-${statusClass}">${bill.status}</span>`,
                                actions
                            ]);
                        });
                        
                        billsTable.draw();
                    },
                    error: function(xhr, status, error) {
                        console.error("Error loading bills: " + error);
                        alert("Failed to load bills. Please try again.");
                    }
                });
            }
        });
        
        // Function to open payment modal
        function payBill(billId, amount) {
            $('#billId').val(billId);
            $('#amountToPay').val(amount);
            $('#paymentMethod').val('');
            $('#cardDetails, #insuranceDetails, #bankDetails').hide();
            $('#paymentForm')[0].reset();
            $('#paymentModal').modal('show');
        }
    </script>
</body>
</html>