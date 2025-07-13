<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!-- Footer -->
<footer class="bg-dark text-white py-3 mt-4">
  <div class="container">
    <div class="row align-items-start">
      <div class="col-md-6 mb-3">
        <h5 class="text-uppercase fw-bold">GYMLIFE</h5>
        <p class="mb-0">Chuyên cung cấp thực phẩm bổ sung, tăng cơ, giảm mỡ và hỗ trợ luyện tập thể hình chất lượng cao.</p>
      </div>
      <div class="col-md-6 mb-3">
        <h5 class="text-uppercase">Liên hệ</h5>
        <ul class="list-unstyled mb-0">
          <li><i class="fas fa-envelope me-2"></i>Email: support@gym-life.vn</li>
          <li><i class="fas fa-phone me-2"></i>Hotline: 0917971420</li>
          <li><i class="fas fa-map-marker-alt me-2"></i>Địa chỉ: 36 Trần Quang Diệu,quận 3,TP.HCM</li>
          <li><i class="fab fa-facebook me-2"></i>Facebook: <a href="https://www.facebook.com/ghetnhatkethu3/" target="_blank" class="text-light text-decoration-none">Chat với chúng tôi</a></li>
          <li><i class="fas fa-comments me-2"></i>Chat: <span class="text-info">Facebook • Zalo • Hotline</span></li>
        </ul>
      </div>
    </div>
    <hr class="border-light my-2">
    <div class="text-center" style="font-size: 0.9rem;">
      © 2025 GymLife. All rights reserved.
    </div>
  </div>
</footer>

<!-- Multi-Channel Chat Widget -->
<div id="multi-chat-widget">
    <!-- Main Chat Button -->
    <div class="main-chat-button" onclick="toggleChatOptions()">
        <i class="fas fa-comments"></i>
    </div>
    
    <!-- Chat Options Popup -->
    <div class="chat-options" id="chatOptions">
        <div class="chat-header">
            <h6>Chọn kênh hỗ trợ</h6>
            <button class="close-btn" onclick="closeChatOptions()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        
        <div class="chat-channels">
            <!-- Facebook Messenger -->
            <div class="chat-channel facebook" onclick="openFacebookChat()">
                <div class="channel-icon">
                    <i class="fab fa-facebook-messenger"></i>
                </div>
                <div class="channel-info">
                    <h6>Facebook Messenger</h6>
                    <p>Chat qua Facebook Page</p>
                </div>
                <div class="channel-status online"></div>
            </div>
            
            <!-- Zalo Chat -->
            <div class="chat-channel zalo" onclick="openZaloOptions()">
                <div class="channel-icon">
                    <i class="fas fa-comment-alt"></i>
                </div>
                <div class="channel-info">
                    <h6>Zalo Chat</h6>
                    <p>Chat với Nhân Viên</p>
                </div>
                <div class="channel-status online"></div>
            </div>
            
            <!-- Phone -->
            <div class="chat-channel phone" onclick="makePhoneCall()">
                <div class="channel-icon">
                    <i class="fas fa-phone"></i>
                </div>
                <div class="channel-info">
                    <h6>Hotline</h6>
                    <p>0917971420</p>
                </div>
                <div class="channel-status online"></div>
            </div>
        </div>
        
        <div class="chat-footer">
            <small>Chúng tôi thường phản hồi trong vài phút</small>
        </div>
    </div>
    
    <!-- Chat Tooltip -->
    <div class="main-tooltip">
        Cần hỗ trợ? Chọn kênh chat!
    </div>
</div>

<!-- Zalo Options Modal (CLEAN - No QR) -->
<div class="zalo-options-modal" id="zaloOptionsModal">
    <div class="modal-overlay" onclick="closeZaloOptions()"></div>
    <div class="modal-content">
        <!-- Modal Header -->
        <div class="modal-header">
            <div class="zalo-info">
                <div class="zalo-avatar">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/9/91/Icon_of_Zalo.svg" alt="Zalo" width="40" height="40">
                </div>
                <div class="zalo-details">
                    <h5>Liên hệ Zalo</h5>
                    <p>GymLife Support Team</p>
                </div>
                <div class="verified-badge">✓</div>
            </div>
            <button class="close-modal-btn" onclick="closeZaloOptions()">
                <i class="fas fa-times"></i>
            </button>
        </div>

        <!-- Zalo Contact Options (Only 2 options) -->
        <div class="zalo-contact-options">
            <!-- Option 1: Chat trực tiếp -->
            <div class="zalo-option" onclick="openZaloDirectChat()">
                <div class="option-icon">
                    <i class="fas fa-comments"></i>
                </div>
                <div class="option-content">
                    <h6>Chat trực tiếp</h6>
                    <p>Mở Zalo để chat ngay</p>
                    <small>Gia Minh • 0815142005</small>
                </div>
                <div class="option-arrow">
                    <i class="fas fa-chevron-right"></i>
                </div>
            </div>

            <!-- Option 2: Sao chép số điện thoại -->
            <div class="zalo-option" onclick="copyZaloPhone()">
                <div class="option-icon">
                    <i class="fas fa-copy"></i>
                </div>
                <div class="option-content">
                    <h6>Sao chép số</h6>
                    <p>Copy để tìm trong Zalo</p>
                    <small id="zaloPhoneNumber">0815142005</small>
                </div>
                <div class="option-arrow">
                    <i class="fas fa-chevron-right"></i>
                </div>
            </div>
        </div>

        <!-- Contact Info -->
        <div class="contact-info">
            <div class="info-item">
                <i class="fas fa-clock text-success"></i>
                <span>Sẵn sàng hỗ trợ • 8:00 - 22:00</span>
            </div>
            <div class="info-item">
                <i class="fas fa-shield-alt text-primary"></i>
                <span>Hỗ trợ chính thức GymLife</span>
            </div>
        </div>
    </div>
</div>

<!-- Success Toast -->
<div class="success-toast" id="successToast">
    <i class="fas fa-check-circle"></i>
    <span id="toastMessage">Đã sao chép số điện thoại!</span>
</div>

<!-- Overlay -->
<div class="chat-overlay" id="chatOverlay" onclick="closeChatOptions()"></div>

<style>
/* Enhanced UTF-8 Font Support */
* {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, 'Arial Unicode MS', sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

/* Multi-Chat Widget Styles */
#multi-chat-widget {
    position: fixed;
    bottom: 20px;
    right: 20px;
    z-index: 9999;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, 'Arial Unicode MS', sans-serif;
}

/* Main Chat Button */
.main-chat-button {
    width: 60px;
    height: 60px;
    background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 24px;
    cursor: pointer;
    box-shadow: 
        0 4px 20px rgba(176, 42, 32, 0.4),
        0 0 0 0 rgba(176, 42, 32, 0.7);
    transition: all 0.3s ease;
    animation: pulse-ring-gymlife 2s infinite, float 3s ease-in-out infinite;
    position: relative;
}

.main-chat-button:hover {
    transform: translateY(-3px) scale(1.05);
    box-shadow: 0 8px 30px rgba(176, 42, 32, 0.5);
    animation: float 3s ease-in-out infinite;
}

.main-chat-button.active {
    background: linear-gradient(135deg, #28a745, #20c997);
    animation: none;
    transform: scale(1.1);
}

/* Main Tooltip */
.main-tooltip {
    position: absolute;
    right: 70px;
    top: 50%;
    transform: translateY(-50%);
    background: rgba(0, 0, 0, 0.8);
    color: white;
    padding: 8px 12px;
    border-radius: 20px;
    font-size: 14px;
    white-space: nowrap;
    opacity: 0;
    visibility: hidden;
    transition: all 0.3s ease;
    backdrop-filter: blur(10px);
}

.main-tooltip::after {
    content: '';
    position: absolute;
    left: 100%;
    top: 50%;
    transform: translateY(-50%);
    border: 6px solid transparent;
    border-left-color: rgba(0, 0, 0, 0.8);
}

#multi-chat-widget:hover .main-tooltip {
    opacity: 1;
    visibility: visible;
    transform: translateY(-50%) translateX(-5px);
}

/* Chat Options Popup */
.chat-options {
    position: absolute;
    bottom: 70px;
    right: 0;
    width: 300px;
    background: white;
    border-radius: 15px;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
    opacity: 0;
    visibility: hidden;
    transform: translateY(20px) scale(0.9);
    transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
    border: 1px solid #e9ecef;
    overflow: hidden;
}

.chat-options.show {
    opacity: 1;
    visibility: visible;
    transform: translateY(0) scale(1);
}

/* Chat Header */
.chat-header {
    background: linear-gradient(135deg, #b02a20 0%, #8b1e16 100%);
    color: white;
    padding: 15px 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.chat-header h6 {
    margin: 0;
    font-size: 16px;
    font-weight: 600;
}

.close-btn {
    background: none;
    border: none;
    color: white;
    font-size: 16px;
    cursor: pointer;
    padding: 0;
    width: 24px;
    height: 24px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    transition: background 0.3s ease;
}

.close-btn:hover {
    background: rgba(255, 255, 255, 0.2);
}

/* Chat Channels */
.chat-channels {
    padding: 10px;
}

.chat-channel {
    display: flex;
    align-items: center;
    padding: 12px;
    border-radius: 10px;
    cursor: pointer;
    transition: all 0.3s ease;
    position: relative;
    margin-bottom: 8px;
}

.chat-channel:hover {
    background: #f8f9fa;
    transform: translateX(5px);
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.chat-channel:last-child {
    margin-bottom: 0;
}

/* Channel Icons */
.channel-icon {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 12px;
    font-size: 18px;
    color: white;
}

.facebook .channel-icon {
    background: linear-gradient(135deg, #1877f2, #42a5f5);
}

.zalo .channel-icon {
    background: linear-gradient(135deg, #0180c7, #04a9f4);
}

.phone .channel-icon {
    background: linear-gradient(135deg, #28a745, #20c997);
}

/* Channel Info */
.channel-info {
    flex: 1;
}

.channel-info h6 {
    margin: 0 0 2px 0;
    font-size: 14px;
    font-weight: 600;
    color: #333;
}

.channel-info p {
    margin: 0;
    font-size: 12px;
    color: #666;
}

/* Channel Status */
.channel-status {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    margin-left: 10px;
}

.channel-status.online {
    background: #28a745;
    box-shadow: 0 0 0 2px rgba(40, 167, 69, 0.3);
    animation: blink 2s infinite;
}

.channel-status.offline {
    background: #6c757d;
}

/* Chat Footer */
.chat-footer {
    padding: 10px 20px 15px;
    text-align: center;
    background: #f8f9fa;
    border-top: 1px solid #e9ecef;
}

.chat-footer small {
    color: #666;
    font-size: 11px;
}

/* Zalo Options Modal */
.zalo-options-modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 10000;
    display: none;
    align-items: center;
    justify-content: center;
    padding: 20px;
    box-sizing: border-box;
}

.zalo-options-modal.show {
    display: flex;
}

.modal-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.7);
    backdrop-filter: blur(5px);
}

.modal-content {
    position: relative;
    background: white;
    border-radius: 20px;
    max-width: 400px;
    width: 100%;
    max-height: 90vh;
    overflow-y: auto;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
    animation: modalSlideIn 0.3s ease-out;
}

/* Modal Header */
.modal-header {
    padding: 20px 20px 15px 20px;
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    border-bottom: 1px solid #f0f0f0;
}

.zalo-info {
    display: flex;
    align-items: center;
    flex: 1;
}

.zalo-avatar {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    background: linear-gradient(135deg, #0180c7, #04a9f4);
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 12px;
}

.zalo-details h5 {
    margin: 0;
    font-size: 18px;
    font-weight: 700;
    color: #333;
}

.zalo-details p {
    margin: 0;
    font-size: 14px;
    color: #666;
}

.verified-badge {
    background: #28a745;
    color: white;
    border-radius: 50%;
    width: 20px;
    height: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 12px;
    font-weight: bold;
    margin-left: 8px;
}

.close-modal-btn {
    background: #f8f9fa;
    border: none;
    border-radius: 50%;
    width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    color: #666;
    transition: all 0.3s ease;
}

.close-modal-btn:hover {
    background: #e9ecef;
    color: #333;
}

/* Zalo Contact Options */
.zalo-contact-options {
    padding: 15px 20px;
}

.zalo-option {
    display: flex;
    align-items: center;
    padding: 15px;
    border-radius: 12px;
    cursor: pointer;
    transition: all 0.3s ease;
    margin-bottom: 10px;
    border: 1px solid #f0f0f0;
    position: relative;
    overflow: hidden;
}

.zalo-option:hover {
    background: #f8f9fa;
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    border-color: #0180c7;
}

.zalo-option:last-child {
    margin-bottom: 0;
}

.option-icon {
    width: 45px;
    height: 45px;
    border-radius: 50%;
    background: linear-gradient(135deg, #0180c7, #04a9f4);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 18px;
    margin-right: 15px;
}

.option-content {
    flex: 1;
}

.option-content h6 {
    margin: 0 0 2px 0;
    font-size: 16px;
    font-weight: 600;
    color: #333;
}

.option-content p {
    margin: 0 0 2px 0;
    font-size: 13px;
    color: #666;
}

.option-content small {
    font-size: 12px;
    color: #0180c7;
    font-weight: 500;
}

.option-arrow {
    color: #ccc;
    font-size: 14px;
}

/* Contact Info */
.contact-info {
    padding: 15px 20px;
    border-top: 1px solid #f0f0f0;
}

.info-item {
    display: flex;
    align-items: center;
    margin-bottom: 12px;
    font-size: 14px;
}

.info-item:last-child {
    margin-bottom: 0;
}

.info-item i {
    width: 20px;
    margin-right: 12px;
}

/* Success Toast */
.success-toast {
    position: fixed;
    top: 20px;
    left: 50%;
    transform: translateX(-50%) translateY(-100px);
    background: #28a745;
    color: white;
    padding: 12px 20px;
    border-radius: 25px;
    display: flex;
    align-items: center;
    z-index: 10001;
    box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
    transition: all 0.3s ease;
    opacity: 0;
}

.success-toast.show {
    transform: translateX(-50%) translateY(0);
    opacity: 1;
}

.success-toast i {
    margin-right: 8px;
    font-size: 16px;
}

/* Overlay */
.chat-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: transparent;
    z-index: 9998;
    opacity: 0;
    visibility: hidden;
    transition: all 0.3s ease;
}

.chat-overlay.show {
    opacity: 1;
    visibility: visible;
}

/* Animations */
@keyframes pulse-ring-gymlife {
    0% {
        box-shadow: 
            0 4px 20px rgba(176, 42, 32, 0.4),
            0 0 0 0 rgba(176, 42, 32, 0.7);
    }
    50% {
        box-shadow: 
            0 4px 20px rgba(176, 42, 32, 0.4),
            0 0 0 15px rgba(176, 42, 32, 0);
    }
    100% {
        box-shadow: 
            0 4px 20px rgba(176, 42, 32, 0.4),
            0 0 0 0 rgba(176, 42, 32, 0);
    }
}

@keyframes float {
    0%, 100% { 
        transform: translateY(0px); 
    }
    50% { 
        transform: translateY(-5px); 
    }
}

@keyframes blink {
    0%, 100% { 
        opacity: 1; 
    }
    50% { 
        opacity: 0.3; 
    }
}

@keyframes modalSlideIn {
    from {
        opacity: 0;
        transform: scale(0.9) translateY(-20px);
    }
    to {
        opacity: 1;
        transform: scale(1) translateY(0);
    }
}

@keyframes ripple {
    to {
        transform: scale(4);
        opacity: 0;
    }
}

/* Responsive */
@media (max-width: 768px) {
    #multi-chat-widget {
        bottom: 15px;
        right: 15px;
    }
    
    .main-chat-button {
        width: 55px;
        height: 55px;
        font-size: 22px;
    }
    
    .chat-options {
        width: 280px;
        right: -10px;
    }
    
    .main-tooltip {
        display: none;
    }
    
    .modal-content {
        margin: 10px;
        max-width: none;
        border-radius: 15px;
    }
}

/* Footer link styles */
footer a.text-light:hover {
    color: #b02a20 !important;
    transition: color 0.3s ease;
}

footer .text-info {
    color: #17a2b8 !important;
}
</style>

<script>
// Global variables
let chatOptionsOpen = false;
let zaloOptionsOpen = false;

// Toggle chat options popup
function toggleChatOptions() {
    const chatOptions = document.getElementById('chatOptions');
    const chatOverlay = document.getElementById('chatOverlay');
    const mainButton = document.querySelector('.main-chat-button');
    
    chatOptionsOpen = !chatOptionsOpen;
    
    if (chatOptionsOpen) {
        chatOptions.classList.add('show');
        chatOverlay.classList.add('show');
        mainButton.classList.add('active');
        document.body.style.overflow = 'hidden';
    } else {
        chatOptions.classList.remove('show');
        chatOverlay.classList.remove('show');
        mainButton.classList.remove('active');
        document.body.style.overflow = '';
    }
    
    console.log('💬 Chat options toggled:', chatOptionsOpen);
}

// Close chat options
function closeChatOptions() {
    const chatOptions = document.getElementById('chatOptions');
    const chatOverlay = document.getElementById('chatOverlay');
    const mainButton = document.querySelector('.main-chat-button');
    
    chatOptions.classList.remove('show');
    chatOverlay.classList.remove('show');
    mainButton.classList.remove('active');
    chatOptionsOpen = false;
    document.body.style.overflow = '';
    
    console.log('💬 Chat options closed');
}

// Open Zalo Options Modal
function openZaloOptions() {
    const modal = document.getElementById('zaloOptionsModal');
    modal.classList.add('show');
    document.body.style.overflow = 'hidden';
    zaloOptionsOpen = true;
    
    // Close main chat options
    closeChatOptions();
    
    console.log('💙 Zalo options modal opened');
}

// Close Zalo Options Modal
function closeZaloOptions() {
    const modal = document.getElementById('zaloOptionsModal');
    modal.classList.remove('show');
    document.body.style.overflow = '';
    zaloOptionsOpen = false;
    
    console.log('💙 Zalo options modal closed');
}

// Open Zalo Direct Chat
function openZaloDirectChat() {
    const phoneNumber = '0815142005';
    const zaloUrl = `https://zalo.me/${phoneNumber}`;
    
    const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
    
    if (isMobile) {
        // Mobile: Try to open Zalo app first
        const zaloAppUrl = `zalo://conversation?phone=${phoneNumber}`;
        
        const iframe = document.createElement('iframe');
        iframe.style.display = 'none';
        iframe.src = zaloAppUrl;
        document.body.appendChild(iframe);
        
        setTimeout(() => {
            window.open(zaloUrl, '_blank');
            document.body.removeChild(iframe);
        }, 1500);
    } else {
        // Desktop: Open web version
        window.open(zaloUrl, '_blank');
    }
    
    closeZaloOptions();
    showSuccessToast('Đang mở Zalo Chat...');
    
    // Analytics tracking
    trackZaloInteraction('click', 'Direct_Chat');
    
    console.log('💙 Opening Zalo direct chat for:', phoneNumber);
}

// Copy Zalo Phone Number - ENHANCED VERSION
function copyZaloPhone() {
    const phoneNumber = '0815142005';
    
    console.log('📋 Attempting to copy Zalo phone number:', phoneNumber);
    
    if (navigator.clipboard && window.isSecureContext) {
        // Modern approach for HTTPS
        navigator.clipboard.writeText(phoneNumber).then(() => {
            showSuccessToast('✅ Đã sao chép số điện thoại!');
            closeZaloOptions();
            trackZaloInteraction('copy', 'Phone_Number_Modern');
            console.log('✅ Successfully copied using modern clipboard API');
        }).catch(err => {
            console.warn('Modern clipboard failed, using fallback:', err);
            fallbackCopyText(phoneNumber);
        });
    } else {
        // Fallback for HTTP or older browsers
        console.log('🔄 Using fallback copy method (HTTP or older browser)');
        fallbackCopyText(phoneNumber);
    }
}

// Enhanced Fallback copy method
function fallbackCopyText(text) {
    console.log('📝 Executing fallback copy for:', text);
    
    const textArea = document.createElement('textarea');
    textArea.value = text;
    textArea.style.position = 'fixed';
    textArea.style.left = '-999999px';
    textArea.style.top = '-999999px';
    textArea.setAttribute('readonly', '');
    document.body.appendChild(textArea);
    
    try {
        textArea.focus();
        textArea.select();
        textArea.setSelectionRange(0, 99999); // For mobile devices
        
        const successful = document.execCommand('copy');
        
        if (successful) {
            showSuccessToast('✅ Đã sao chép số điện thoại!');
            closeZaloOptions();
            trackZaloInteraction('copy', 'Phone_Number_Fallback');
            console.log('✅ Successfully copied using fallback method');
        } else {
            showSuccessToast('⚠️ Không thể sao chép. Số: ' + text);
            console.error('❌ Fallback copy failed - execCommand returned false');
        }
    } catch (err) {
        console.error('❌ Fallback copy exception:', err);
        showSuccessToast('⚠️ Không thể sao chép. Số: ' + text);
    } finally {
        document.body.removeChild(textArea);
    }
}

// Show Success Toast
function showSuccessToast(message) {
    const toast = document.getElementById('successToast');
    const toastMessage = document.getElementById('toastMessage');
    
    toastMessage.textContent = message;
    toast.classList.add('show');
    
    setTimeout(() => {
        toast.classList.remove('show');
    }, 3000);
    
    console.log('🔔 Toast shown:', message);
}

// Open Facebook Chat
function openFacebookChat() {
    const facebookPageId = 'ghetnhatkethu3'; // ✅ Page ID từ link của bạn
    const messengerUrl = `https://m.me/${facebookPageId}`;
    
    const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
    
    if (isMobile) {
        window.open(messengerUrl, '_blank');
    } else {
        window.open(messengerUrl, 'FacebookChat', 'width=800,height=600,scrollbars=yes,resizable=yes');
    }
    
    closeChatOptions();
    
    // Analytics tracking (optional)
    if (typeof gtag !== 'undefined') {
        gtag('event', 'click', {
            event_category: 'Contact',
            event_label: 'Facebook Chat',
            value: 1
        });
    }
    
    console.log('📘 Opening Facebook Messenger...');
}

// Make Phone Call
function makePhoneCall() {
    const phoneNumber = '0917971420'; // ✅ Số hotline từ footer
    const phoneUrl = `tel:${phoneNumber}`;
    
    // Mở app gọi điện
    window.location.href = phoneUrl;
    
    closeChatOptions();
    
    // Analytics tracking (optional)
    if (typeof gtag !== 'undefined') {
        gtag('event', 'click', {
            event_category: 'Contact',
            event_label: 'Phone Call',
            value: 1
        });
    }
    
    console.log('📞 Making phone call to:', phoneNumber);
}

// Analytics tracking helper
function trackZaloInteraction(action, label) {
    if (typeof gtag !== 'undefined') {
        gtag('event', action, {
            event_category: 'Zalo_Chat',
            event_label: label,
            value: 1
        });
    }
    console.log(`📊 Analytics: ${action} - ${label}`);
}

// Initialize widget
document.addEventListener('DOMContentLoaded', function() {
    const chatWidget = document.getElementById('multi-chat-widget');
    
    if (chatWidget) {
        // Delay animation để trang load xong
        setTimeout(() => {
            chatWidget.style.opacity = '0';
            chatWidget.style.transform = 'translateY(100px)';
            chatWidget.style.transition = 'all 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94)';
            
            setTimeout(() => {
                chatWidget.style.opacity = '1';
                chatWidget.style.transform = 'translateY(0)';
            }, 100);
        }, 1500); // Hiện sau 1.5 giây
        
        console.log('💬 GymLife Multi-Channel Chat Widget initialized!');
        console.log('💙 Zalo integration ready (Clean - No QR)!');
    }
    
    // Add ripple effect to Zalo options
    const zaloOptions = document.querySelectorAll('.zalo-option');
    zaloOptions.forEach(option => {
        option.addEventListener('click', function(e) {
            const ripple = document.createElement('div');
            ripple.style.position = 'absolute';
            ripple.style.borderRadius = '50%';
            ripple.style.background = 'rgba(1, 128, 199, 0.3)';
            ripple.style.transform = 'scale(0)';
            ripple.style.animation = 'ripple 0.6s linear';
            ripple.style.left = (e.clientX - this.offsetLeft) + 'px';
            ripple.style.top = (e.clientY - this.offsetTop) + 'px';
            
            this.appendChild(ripple);
            
            setTimeout(() => {
                ripple.remove();
            }, 600);
        });
    });

    // Test copy functionality on page load
    console.log('🧪 Testing copy functionality...');
    if (navigator.clipboard && window.isSecureContext) {
        console.log('✅ Modern clipboard API available (HTTPS)');
    } else if (document.queryCommandSupported && document.queryCommandSupported('copy')) {
        console.log('⚠️ Using fallback copy method (HTTP or older browser)');
    } else {
        console.log('❌ Copy functionality may not work on this browser/protocol');
    }
});

// Close on Escape key
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        if (zaloOptionsOpen) {
            closeZaloOptions();
        } else if (chatOptionsOpen) {
            closeChatOptions();
        }
    }
});

// Hide on admin pages
function hideOnAdminPages() {
    const currentPath = window.location.pathname.toLowerCase();
    const hideOnPages = ['/admin', '/login.jsp', '/register.jsp'];
    
    if (hideOnPages.some(page => currentPath.includes(page))) {
        const chatWidget = document.getElementById('multi-chat-widget');
        if (chatWidget) {
            chatWidget.style.display = 'none';
            console.log('💬 Chat widget hidden on admin page');
        }
    }
}

hideOnAdminPages();

// Performance optimization and error handling
window.addEventListener('load', function() {
    console.log('🚀 Page fully loaded - Chat widget ready');
    
    // Test copy function silently
    setTimeout(() => {
        console.log('🔍 Copy function status check:');
        console.log('- HTTPS:', window.isSecureContext);
        console.log('- Clipboard API:', !!navigator.clipboard);
        console.log('- execCommand support:', document.queryCommandSupported ? document.queryCommandSupported('copy') : 'Unknown');
    }, 2000);
});

// Handle errors gracefully
window.addEventListener('error', function(e) {
    if (e.message && e.message.includes('clipboard')) {
        console.warn('🔄 Clipboard error detected, fallback will be used');
    }
});
</script>

<!-- FontAwesome (nếu chưa có) -->
<!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"> -->