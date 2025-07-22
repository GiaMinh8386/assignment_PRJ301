<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.ProductDTO" %>
<%@ page import="utils.AuthUtils" %>
<%@ page errorPage="error.jsp" %>

<%
    // Kiểm tra quyền admin
    if (!AuthUtils.isAdmin(request)) {
        response.sendRedirect("MainController?action=home");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Quản lý sản phẩm</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', sans-serif;
        }
        
        .admin-header {
            background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
            color: white;
            padding: 20px 0;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .admin-header h1 {
            margin: 0;
            font-weight: 700;
        }
        
        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
            height: 100%;
        }
        
        .stats-card:hover {
            transform: translateY(-5px);
        }
        
        .stats-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-bottom: 15px;
        }
        
        .stats-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: #333;
            margin-bottom: 5px;
        }
        
        .stats-label {
            color: #666;
            font-weight: 500;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }
        
        .icon-primary { background: linear-gradient(135deg, #007bff, #0056b3); color: white; }
        .icon-success { background: linear-gradient(135deg, #28a745, #1e7e34); color: white; }
        .icon-warning { background: linear-gradient(135deg, #ffc107, #e0a800); color: #333; }
        .icon-danger { background: linear-gradient(135deg, #dc3545, #c82333); color: white; }
        .icon-info { background: linear-gradient(135deg, #17a2b8, #138496); color: white; }
        
        .chart-container {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .products-table {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .table th {
            background-color: #f8f9fa;
            border: none;
            font-weight: 600;
            color: #333;
            padding: 15px;
        }
        
        .table td {
            border: none;
            padding: 15px;
            vertical-align: middle;
        }
        
        .table tbody tr {
            border-bottom: 1px solid #e9ecef;
        }
        
        .product-image {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 8px;
        }
        
        .product-name {
            font-weight: 600;
            color: #333;
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .status-active {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .btn-action {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 0.8rem;
            margin: 2px;
        }
        
        .quick-actions {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .action-btn {
            display: block;
            width: 100%;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 10px;
            text-decoration: none;
            color: white;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .action-btn:hover {
            transform: translateY(-2px);
            color: white;
            text-decoration: none;
        }
        
        .btn-add { background: linear-gradient(135deg, #28a745, #20c997); }
        .btn-manage { background: linear-gradient(135deg, #007bff, #6610f2); }
        .btn-orders { background: linear-gradient(135deg, #fd7e14, #e83e8c); }
        .btn-reports { background: linear-gradient(135deg, #6f42c1, #e83e8c); }
    </style>
</head>
<body>

    <!-- Include Header -->
    <%@ include file="header.jsp" %>
    
    <!-- Admin Header -->
    <div class="admin-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-8">
                    <h1><i class="fas fa-tachometer-alt me-3"></i>Dashboard Quản lý</h1>
                    <p class="mb-0">Tổng quan và quản lý sản phẩm của cửa hàng</p>
                </div>
                <div class="col-4 text-end">
                    <div class="text-white-50">
                        <i class="fas fa-calendar me-2"></i>
                        <span id="currentDate"></span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-2 mb-3">
                <div class="stats-card text-center">
                    <div class="stats-icon icon-primary mx-auto">
                        <i class="fas fa-box"></i>
                    </div>
                    <div class="stats-number" id="totalProducts">
                        <%
                            List<ProductDTO> allProducts = (List<ProductDTO>) request.getAttribute("allProducts");
                            int totalProducts = allProducts != null ? allProducts.size() : 0;
                            out.print(totalProducts);
                        %>
                    </div>
                    <div class="stats-label">Tổng sản phẩm</div>
                </div>
            </div>
            
            <div class="col-2 mb-3">
                <div class="stats-card text-center">
                    <div class="stats-icon icon-success mx-auto">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stats-number" id="activeProducts">
                        <%
                            int activeProducts = 0;
                            if (allProducts != null) {
                                for (ProductDTO p : allProducts) {
                                    if (p.isStatus()) activeProducts++;
                                }
                            }
                            out.print(activeProducts);
                        %>
                    </div>
                    <div class="stats-label">Đang bán</div>
                </div>
            </div>
            
            <div class="col-2 mb-3">
                <div class="stats-card text-center">
                    <div class="stats-icon icon-warning mx-auto">
                        <i class="fas fa-star"></i>
                    </div>
                    <div class="stats-number">85</div>
                    <div class="stats-label">Đánh giá cao</div>
                </div>
            </div>
            
           
        </div>

        <div class="row">
            <!-- Quick Actions -->
            <div class="col-3 mb-4">
                <div class="quick-actions">
                    <h5 class="mb-4"><i class="fas fa-bolt me-2"></i>Thao tác nhanh</h5>
                    
                    <a href="productForm.jsp" class="action-btn btn-add">
                        <i class="fas fa-plus me-2"></i>Thêm sản phẩm mới
                    </a>
                    
                    <a href="MainController?action=listProducts" class="action-btn btn-manage">
                        <i class="fas fa-list me-2"></i>Quản lý sản phẩm
                    </a>
                    
                    <a href="OrderController?action=viewAllOrders" class="action-btn btn-orders">
                        <i class="fas fa-shopping-cart me-2"></i>Quản lý đơn hàng
                    </a>
                    
                    
                </div>
            </div>

            <!-- Charts Section -->
            <div class="col-9 mb-4">
                <div class="chart-container">
                    <h5 class="mb-4"><i class="fas fa-chart-line me-2"></i>Thống kê bán hàng</h5>
                    <div class="row">
                        <div class="col-6 mb-3">
                            <canvas id="salesChart" width="400" height="200"></canvas>
                        </div>
                        <div class="col-6 mb-3">
                            <canvas id="categoryChart" width="400" height="200"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- FIX 1: ✅ FIXED - Products Table with proper all products display -->
        <div class="products-table">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5><i class="fas fa-table me-2"></i>Danh sách sản phẩm</h5>
                <div>
                    <button class="btn btn-outline-primary btn-sm me-2" onclick="refreshData()">
                        <i class="fas fa-sync-alt me-1"></i>Làm mới
                    </button>
                    <a href="productForm.jsp" class="btn btn-primary btn-sm">
                        <i class="fas fa-plus me-1"></i>Thêm mới
                    </a>
                </div>
            </div>
            
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Hình ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Thương hiệu</th>
                            <th>Giá</th>
                            <th>Danh mục</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            // FIX 1: ✅ FIXED - Check if we should show all products or just preview
                            Boolean showAllProducts = (Boolean) request.getAttribute("showAllProducts");
                            boolean showAll = showAllProducts != null && showAllProducts;
                            
                            if (allProducts != null && !allProducts.isEmpty()) {
                                int count = 0;
                                int maxDisplay = showAll ? allProducts.size() : 10; // Show all or just 10
                                
                                for (ProductDTO product : allProducts) {
                                    if (count >= maxDisplay) break;
                                    count++;
                        %>
                        <tr>
                            <td>
                                <%
                                    String imagePath = product.getImageURL();
                                    if (imagePath != null && !imagePath.trim().isEmpty()) {
                                        if (!imagePath.startsWith("http")) {
                                            imagePath = request.getContextPath() + "/assets/images/products/" + imagePath;
                                        }
                                %>
                                    <img src="<%= imagePath %>" class="product-image" alt="<%= product.getName() %>" 
                                         onerror="this.src='<%= request.getContextPath() %>/assets/images/no-image.png'">
                                <%
                                    } else {
                                %>
                                    <div class="product-image bg-light d-flex align-items-center justify-content-center">
                                        <i class="fas fa-image text-muted"></i>
                                    </div>
                                <%
                                    }
                                %>
                            </td>
                            <td>
                                <div class="product-name"><%= product.getName() %></div>
                                <small class="text-muted">ID: <%= product.getId() %></small>
                            </td>
                            <td><%= product.getBrand() != null ? product.getBrand() : "N/A" %></td>
                            <td>
                                <strong class="text-primary"><%= product.getFormattedPrice() %></strong>
                            </td>
                            <td>
                                <span class="badge bg-secondary">Danh mục <%= product.getCategoryId() %></span>
                            </td>
                            <td>
                                <span class="status-badge <%= product.isStatus() ? "status-active" : "status-inactive" %>">
                                    <%= product.isStatus() ? "Đang bán" : "Ngừng bán" %>
                                </span>
                            </td>
                            <td>
                                <a href="MainController?action=productDetail&id=<%= product.getId() %>" 
                                   class="btn btn-outline-primary btn-action" title="Xem chi tiết">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="ProductController?action=editProduct&id=<%= product.getId() %>" 
                                   class="btn btn-outline-warning btn-action" title="Chỉnh sửa">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="ProductController?action=deleteProduct&id=<%= product.getId() %>" 
                                   class="btn btn-outline-danger btn-action" title="Xóa"
                                   onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?')">
                                    <i class="fas fa-trash"></i>
                                </a>
                            </td>
                        </tr>
                        <%
                                }
                                
                                // FIX 1: ✅ FIXED - Show "View All" button only when not showing all and there are more products
                                if (!showAll && allProducts.size() > 10) {
                        %>
                        <tr>
                            <td colspan="7" class="text-center py-3">
                                <button onclick="showAllProducts()" class="btn btn-outline-primary">
                                    <i class="fas fa-list me-2"></i>Xem tất cả <%= allProducts.size() %> sản phẩm
                                </button>
                            </td>
                        </tr>
                        <%
                                }
                                
                                // FIX 1: ✅ FIXED - Show "Show Less" button when showing all products and there are more than 10
                                if (showAll && allProducts.size() > 10) {
                        %>
                        <tr>
                            <td colspan="7" class="text-center py-3">
                                <button onclick="showLessProducts()" class="btn btn-outline-secondary">
                                    <i class="fas fa-compress me-2"></i>Thu gọn (hiển thị 10 sản phẩm đầu)
                                </button>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="7" class="text-center py-5">
                                <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                                <p class="text-muted">Chưa có sản phẩm nào</p>
                                <a href="productForm.jsp" class="btn btn-primary">
                                    <i class="fas fa-plus me-2"></i>Thêm sản phẩm đầu tiên
                                </a>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Include Footer -->
    <%@ include file="footer.jsp" %>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Display current date
            const currentDate = new Date().toLocaleDateString('vi-VN', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
            document.getElementById('currentDate').textContent = currentDate;
            
            // Sales Chart
            const salesCtx = document.getElementById('salesChart').getContext('2d');
            new Chart(salesCtx, {
                type: 'line',
                data: {
                    labels: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
                    datasets: [{
                        label: 'Doanh thu (triệu VND)',
                        data: [12, 19, 15, 25, 22, 30, 28],
                        borderColor: '#b02a20',
                        backgroundColor: 'rgba(176, 42, 32, 0.1)',
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        title: {
                            display: true,
                            text: 'Doanh thu 7 ngày qua'
                        }
                    }
                }
            });
            
            // Category Chart
            const categoryCtx = document.getElementById('categoryChart').getContext('2d');
            new Chart(categoryCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Whey Protein', 'Creatine', 'Vitamin', 'Pre-workout', 'Mass Gainer'],
                    datasets: [{
                        data: [35, 25, 20, 12, 8],
                        backgroundColor: [
                            '#b02a20',
                            '#28a745',
                            '#ffc107',
                            '#17a2b8',
                            '#6f42c1'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        title: {
                            display: true,
                            text: 'Phân bố theo danh mục'
                        },
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
            
            console.log('✅ Admin Dashboard loaded successfully!');
        });
        
        // FIX 1: ✅ FIXED - Functions to show/hide all products in dashboard
        function showAllProducts() {
            window.location.href = 'ProductController?action=listAllProducts';
        }
        
        function showLessProducts() {
            window.location.href = 'ProductController?action=adminDashboard';
        }
        
        function refreshData() {
            const btn = event.target.closest('button');
            const originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang tải...';
            btn.disabled = true;
            
            // Simulate refresh
            setTimeout(() => {
                btn.innerHTML = originalText;
                btn.disabled = false;
                window.location.reload();
            }, 1000);
        }
        
        // Auto refresh stats every 5 minutes
        setInterval(() => {
            console.log('🔄 Auto refreshing dashboard stats...');
            // You can implement AJAX calls here to update stats without page reload
        }, 300000);
    </script>

</body>
</html>