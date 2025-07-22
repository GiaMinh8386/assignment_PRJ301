
<!-- BANNER V?I ?NH CÓ S?N + BUTTONS -->
<!-- Thay th? banner c? trong index.jsp -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div id="bannerCarousel" class="carousel slide" data-bs-ride="carousel" data-bs-interval="4000">
    <!-- Indicators -->
    <div class="carousel-indicators">
        <button type="button" data-bs-target="#bannerCarousel" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#bannerCarousel" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#bannerCarousel" data-bs-slide-to="2"></button>
    </div>

    <!-- Slides -->
    <div class="carousel-inner">
        <!-- Slide 1: Whey Isolate -->
        <div class="carousel-item active">
            <div class="banner-container">
                <img src="assets/images/banner1.jpg" class="d-block w-100 banner-img" alt="Gi?m giá l?n Whey Isolate">
                <!-- Overlay buttons -->
                <div class="banner-overlay">
                    <div class="banner-buttons">
                        
                    
                    </div>
                </div>
            </div>
        </div>

        <!-- Slide 2: Creatine -->
        <div class="carousel-item">
            <div class="banner-container">
                <img src="assets/images/banner2.jpg" class="d-block w-100 banner-img" alt="T?ng c? nhanh Creatine">
                <!-- Overlay buttons -->
                <div class="banner-overlay">
                    <div class="banner-buttons">
                       
                    </div>
                </div>
            </div>
        </div>

        <!-- Slide 3: Creatine Monohydrate -->
        <div class="carousel-item">
            <div class="banner-container">
                <img src="assets/images/banner3.jpg" class="d-block w-100 banner-img" alt="Creatine s?c m?nh t?ng v?t">
                <!-- Overlay buttons -->
                <div class="banner-overlay">
                    <div class="banner-buttons">
                        
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Controls -->
    <button class="carousel-control-prev" type="button" data-bs-target="#bannerCarousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Previous</span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#bannerCarousel" data-bs-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Next</span>
    </button>
</div>

<style>
/* ===== BANNER CONTAINER ===== */
.banner-container {
    position: relative;
    overflow: hidden;
}

/* THAY TH? ph?n .banner-img hi?n t?i */
.banner-img {
    height: 300px;           
    object-fit: cover;
    width: 100%;
    transition: transform 0.3s ease;
    
    /* ===== THÊM CÁC DÒNG NÀY ===== */
    object-position: center top;    /* ? ?u tiên ph?n trên c?a ?nh (có ch?) */
    filter: contrast(1.1) brightness(1.05); /* ? T?ng ?? s?c nét */
    image-rendering: crisp-edges;   /* ? Render ?nh s?c nét h?n */
}

/* ===== OVERLAY VÀ BUTTONS ===== */
.banner-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.3); /* L?p ph? m? */
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    transition: all 0.4s ease;
}

.banner-container:hover .banner-overlay {
    opacity: 1; /* Hi?n buttons khi hover */
}

.banner-container:hover .banner-img {
    transform: scale(1.05); /* Zoom ?nh nh? khi hover */
}

.banner-buttons {
    text-align: center;
    animation: slideInUp 0.6s ease;
}

.banner-buttons .btn {
    margin: 5px;
    padding: 12px 24px;
    font-weight: 600;
    border-radius: 50px;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

.banner-buttons .btn:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
}

/* ===== CUSTOM BUTTON COLORS ===== */
.btn-primary {
    background: linear-gradient(45deg, #007bff, #0056b3);
    border: none;
}

.btn-warning {
    background: linear-gradient(45deg, #ffc107, #e0a800);
    border: none;
    color: #000;
}

.btn-success {
    background: linear-gradient(45deg, #28a745, #1e7e34);
    border: none;
}

.btn-outline-light {
    border: 2px solid #fff;
    backdrop-filter: blur(10px);
}

.btn-outline-light:hover {
    background: rgba(255, 255, 255, 0.2);
    border-color: #fff;
    color: #fff;
}

/* ===== CAROUSEL CUSTOMIZATION ===== */
.carousel-control-prev,
.carousel-control-next {
    width: 5%;
    opacity: 0.8;
}

.carousel-control-prev:hover,
.carousel-control-next:hover {
    opacity: 1;
}

.carousel-indicators {
    bottom: 20px;
}

.carousel-indicators button {
    width: 12px;
    height: 12px;
    border-radius: 50%;
    margin: 0 5px;
    background-color: rgba(255, 255, 255, 0.6);
    border: 2px solid #fff;
}

.carousel-indicators button.active {
    background-color: #fff;
}

/* ===== ANIMATIONS ===== */
@keyframes slideInUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* ===== SMOOTH TRANSITIONS ===== */
.carousel-item {
    transition: transform 0.6s ease-in-out;
}

/* ===== AUTO-SHOW BUTTONS (Tùy ch?n) ===== */
.banner-overlay.always-show {
    opacity: 1 !important;
}

/* N?u mu?n buttons luôn hi?n, thêm class 'always-show' vào .banner-overlay */
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Smooth carousel transitions
    const carousel = document.querySelector('#bannerCarousel');
    if (carousel) {
        // Pause on hover
        carousel.addEventListener('mouseenter', function() {
            bootstrap.Carousel.getInstance(this).pause();
        });
        
        // Resume on mouse leave
        carousel.addEventListener('mouseleave', function() {
            bootstrap.Carousel.getInstance(this).cycle();
        });
    }

    // Button click analytics (optional)
    const bannerButtons = document.querySelectorAll('.banner-buttons .btn');
    bannerButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            // Add loading state
            const originalText = this.innerHTML;
            this.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
            
            // Restore after 2 seconds if still on page
            setTimeout(() => {
                if (this.innerHTML.includes('Đang xử lý')) {
                    this.innerHTML = originalText;
                }
            }, 2000);
        });
    });

    // Auto-show buttons after 3 seconds (optional)
    setTimeout(() => {
        const overlays = document.querySelectorAll('.banner-overlay');
        overlays.forEach(overlay => {
            overlay.classList.add('always-show');
        });
    }, 3000);
});
</script>

