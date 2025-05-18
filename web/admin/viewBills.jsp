<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Bills</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <style>
        .filter-section {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .status-paid {
            color: #198754;
            font-weight: bold;
        }
        .status-pending {
            color: #fd7e14;
            font-weight: bold;
        }
        .status-cancelled {
            color: #dc3545;
            font-weight: bold;
        }
        .action-btns .btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header.jsp" />
    
    <div class="container mt-4">
        <h2 class="mb-4">Bills Management</h2>
        
        <div class="filter-section">
            <form id="filterForm" class="row g-3">
                <div class="col-md-3">
                    <label for="patientId" class="form-label">Patient ID</label>
                    <input type="text" class="form-control" id="patientId" name="patientId" placeholder="Enter patient ID">
                </div>
                <div class="col-md-3">
                    <label for="patientName" class="form-label">Patient Name</label>
                    <input type="text" class="form-control" id="patientName" name="patientName" placeholder="Enter patient name">
                </div>
                <div class="col-md-3">
                    <label for="dateFrom" class="form-label">Date From</label>
                    <input type="date" class="form-control" id="dateFrom" name="dateFrom">
                </div>
                <div class="col-md-3">
                    <label for="dateTo" class="form-label">Date To</label>
                    <input type="date" class="form-control" id="dateTo" name="dateTo">
                </div>
                <div class="col-md-3">
                    <label for="status" class="form-label">Payment Status</label>
                    <select class="form-select" id="status" name="status">
                        <option value="">All Statuses</option>
                        <option value="PAID">Paid</option>
                        <option value="PENDING">Pending</option>
                        <option value="PARTIAL">Partial</option>
                        <option value="CANCELLED">Cancelled</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="amountMin" class="form-label">Min Amount</label>
                    <input type="number" class="form-control" id="amountMin" name="amountMin" placeholder="Min amount">
                </div>
                <div class="col-md-3">
                    <label for="amountMax" class="form-label">Max Amount</label>
                    <input type="number" class="form-control" id="amountMax" name="amountMax" placeholder="Max amount">
                </div>
                <div class="col-md-3 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary me-2">Filter</button>
                    <button type="reset" class="btn btn-outline-secondary">Reset</button>
                </div>
            </form>
        </div>
        
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">All Bills</h5>
                <a href="generateBill.jsp" class="btn btn-success btn-sm">
                    <i class="bi bi-plus-circle"></i> Generate New Bill
                </a>
            </div>
            <div class="card-body">
                <table id="billsTable" class="table table-striped" style="width:100%">
                    <thead>
                        <tr>
                            <th>Bill ID</th>
                            <th>Patient</th>
                            <th>Date</th>
                            <th>Doctor</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="bill" items="${billsList}">
                            <tr>
                                <td>${bill.billId}</td>
                                <td>${bill.patient.firstName} ${bill.patient.lastName}<br>
                                    <small class="text-muted">ID: ${bill.patient.patientId}</small>
                                </td>
                                <td><fmt:formatDate value="${bill.billDate}" pattern="dd-MMM-yyyy" /></td>
                                <td>Dr. ${bill.doctor.firstName} ${bill.doctor.lastName}</td>
                                <td><fmt:formatNumber value="${bill.totalAmount}" type="currency" currencySymbol="$"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${bill.paymentStatus == 'PAID'}">
                                            <span class="status-paid">Paid</span>
                                        </c:when>
                                        <c:when test="${bill.paymentStatus == 'PENDING'}">
                                            <span class="status-pending">Pending</span>
                                        </c:when>
                                        <c:when test="${bill.paymentStatus == 'PARTIAL'}">
                                            <span class="status-pending">Partial</span>
                                        </c:when>
                                        <c:when test="${bill.paymentStatus == 'CANCELLED'}">
                                            <span class="status-cancelled">Cancelled</span>
                                        </c:when>
                                        <c:otherwise>
                                            ${bill.paymentStatus}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="action-btns">
                                    <div class="d-flex">
                                        <a href="BillController?action=view&billId=${bill.billId}" class="btn btn-info btn-sm me-1" title="View">
                                            <i class="bi bi-eye"></i> View
                                        </a>
                                        <a href="generateBill.jsp?billId=${bill.billId}" class="btn btn-warning btn-sm me-1" title="Edit">
                                            <i class="bi bi-pencil"></i> Edit
                                        </a>
                                        <c:if test="${bill.paymentStatus != 'PAID' && bill.paymentStatus != 'CANCELLED'}">
                                            <form action="BillController" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="markPaid">
                                                <input type="hidden" name="billId" value="${bill.billId}">
                                                <button type="submit" class="btn btn-success btn-sm me-1" title="Mark as Paid">
                                                    <i class="bi bi-check-circle"></i> Paid
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${bill.paymentStatus != 'CANCELLED'}">
                                            <form action="BillController" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="cancel">
                                                <input type="hidden" name="billId" value="${bill.billId}">
                                                <button type="submit" class="btn btn-danger btn-sm" title="Cancel" onclick="return confirm('Are you sure you want to cancel this bill?')">
                                                    <i class="bi bi-x-circle"></i> Cancel
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <jsp:include page="../common/footer.jsp" />
    
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script>
        $(document).ready(function() {
            // Initialize DataTable
            var table = $('#billsTable').DataTable({
                responsive: true,
                dom: '<"top"lf>rt<"bottom"ip>',
                language: {
                    search: "_INPUT_",
                    searchPlaceholder: "Search bills...",
                }
            });
            
            // Apply filters
            $('#filterForm').on('submit', function(e) {
                e.preventDefault();
                
                var patientId = $('#patientId').val();
                var patientName = $('#patientName').val();
                var dateFrom = $('#dateFrom').val();
                var dateTo = $('#dateTo').val();
                var status = $('#status').val();
                var amountMin = $('#amountMin').val();
                var amountMax = $('#amountMax').val();
                
                // Filter by patient ID
                if (patientId) {
                    table.column(0).search(patientId).draw();
                }
                
                // Filter by patient name
                if (patientName) {
                    table.column(1).search(patientName).draw();
                }
                
                // Filter by date range
                if (dateFrom || dateTo) {
                    $.fn.dataTable.ext.search.push(
                        function(settings, data, dataIndex) {
                            var billDate = new Date(data[2]);
                            var fromDate = dateFrom ? new Date(dateFrom) : null;
                            var toDate = dateTo ? new Date(dateTo) : null;
                            
                            if (fromDate && toDate) {
                                return billDate >= fromDate && billDate <= toDate;
                            } else if (fromDate) {
                                return billDate >= fromDate;
                            } else if (toDate) {
                                return billDate <= toDate;
                            }
                            return true;
                        }
                    );
                    table.draw();
                    $.fn.dataTable.ext.search.pop();
                }
                
                // Filter by status
                if (status) {
                    table.column(5).search(status).draw();
                }
                
                // Filter by amount range
                if (amountMin || amountMax) {
                    $.fn.dataTable.ext.search.push(
                        function(settings, data, dataIndex) {
                            var amount = parseFloat(data[4].replace(/[^0-9.-]+/g,""));
                            var min = amountMin ? parseFloat(amountMin) : null;
                            var max = amountMax ? parseFloat(amountMax) : null;
                            
                            if (min && max) {
                                return amount >= min && amount <= max;
                            } else if (min) {
                                return amount >= min;
                            } else if (max) {
                                return amount <= max;
                            }
                            return true;
                        }
                    );
                    table.draw();
                    $.fn.dataTable.ext.search.pop();
                }
            });
            
            // Reset filters
            $('#filterForm').on('reset', function() {
                table.search('').columns().search('').draw();
            });
        });
    </script>
</body>
</html>