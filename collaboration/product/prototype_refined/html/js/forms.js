/* GoldQuant - 表单处理脚本 */

// DOM加载完成后执行
document.addEventListener('DOMContentLoaded', function() {
    initLoginForm();
    initPasswordToggle();
    initModalTriggers();
    initFormValidation();
});

// 初始化登录表单
function initLoginForm() {
    const loginForm = document.getElementById('loginForm');
    if (!loginForm) return;
    
    loginForm.addEventListener('submit', function(event) {
        event.preventDefault();
        event.stopPropagation();
        
        if (!this.checkValidity()) {
            this.classList.add('was-validated');
            return;
        }
        
        // 模拟登录过程
        simulateLogin();
    });
}

// 模拟登录过程
function simulateLogin() {
    const submitBtn = document.querySelector('#loginForm button[type="submit"]');
    const originalText = submitBtn.innerHTML;
    
    // 显示加载状态
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>登录中...';
    submitBtn.disabled = true;
    
    // 模拟网络请求延迟
    setTimeout(() => {
        // 获取表单数据
        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;
        const rememberMe = document.getElementById('rememberMe').checked;
        
        // 模拟登录成功
        console.log('登录尝试:', { email, rememberMe });
        
        // 显示成功消息
        showToast('登录成功！正在跳转到仪表盘...', 'success');
        
        // 模拟跳转延迟
        setTimeout(() => {
            // 在实际应用中，这里会跳转到仪表盘页面
            // window.location.href = 'dashboard.html';
            
            // 暂时显示成功状态
            submitBtn.innerHTML = '<i class="fas fa-check me-2"></i>登录成功';
            submitBtn.classList.remove('btn-primary');
            submitBtn.classList.add('btn-success');
            
            // 3秒后重置按钮状态（模拟跳转）
            setTimeout(() => {
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
                submitBtn.classList.remove('btn-success');
                submitBtn.classList.add('btn-primary');
                
                // 在实际应用中，这里会执行页面跳转
                alert('登录成功！在实际应用中，这里会跳转到仪表盘页面。\n\n邮箱: ' + email + '\n记住登录: ' + rememberMe);
            }, 3000);
            
        }, 1000);
        
    }, 1500);
}

// 初始化密码显示/隐藏切换
function initPasswordToggle() {
    const toggleBtn = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('password');
    
    if (!toggleBtn || !passwordInput) return;
    
    toggleBtn.addEventListener('click', function() {
        const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);
        
        // 切换图标
        const icon = this.querySelector('i');
        if (type === 'text') {
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
            this.setAttribute('title', '隐藏密码');
        } else {
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
            this.setAttribute('title', '显示密码');
        }
    });
}

// 初始化模态框触发器
function initModalTriggers() {
    // 注册链接
    const registerLink = document.getElementById('registerLink');
    if (registerLink) {
        registerLink.addEventListener('click', function(e) {
            e.preventDefault();
            const registerModal = new bootstrap.Modal(document.getElementById('registerModal'));
            registerModal.show();
        });
    }
    
    // 忘记密码链接
    const forgotPasswordLink = document.getElementById('forgotPassword');
    if (forgotPasswordLink) {
        forgotPasswordLink.addEventListener('click', function(e) {
            e.preventDefault();
            const forgotModal = new bootstrap.Modal(document.getElementById('forgotPasswordModal'));
            forgotModal.show();
        });
    }
}

// 初始化表单验证
function initFormValidation() {
    // 邮箱验证
    const emailInput = document.getElementById('email');
    if (emailInput) {
        emailInput.addEventListener('input', function() {
            validateEmail(this);
        });
    }
    
    // 密码验证
    const passwordInput = document.getElementById('password');
    if (passwordInput) {
        passwordInput.addEventListener('input', function() {
            validatePassword(this);
        });
    }
}

// 邮箱验证函数
function validateEmail(input) {
    const email = input.value.trim();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    
    if (email === '') {
        setValidationState(input, false, '请输入邮箱地址');
        return false;
    }
    
    if (!emailRegex.test(email)) {
        setValidationState(input, false, '请输入有效的邮箱地址');
        return false;
    }
    
    setValidationState(input, true);
    return true;
}

// 密码验证函数
function validatePassword(input) {
    const password = input.value;
    
    if (password === '') {
        setValidationState(input, false, '请输入密码');
        return false;
    }
    
    if (password.length < 6) {
        setValidationState(input, false, '密码至少需要6个字符');
        return false;
    }
    
    setValidationState(input, true);
    return true;
}

// 设置验证状态
function setValidationState(input, isValid, message = '') {
    if (isValid) {
        input.classList.remove('is-invalid');
        input.classList.add('is-valid');
    } else {
        input.classList.remove('is-valid');
        input.classList.add('is-invalid');
        
        // 更新错误消息
        const feedback = input.nextElementSibling;
        if (feedback && feedback.classList.contains('invalid-feedback')) {
            feedback.textContent = message;
        }
    }
}

// 显示Toast通知
function showToast(message, type = 'info') {
    // 创建Toast容器（如果不存在）
    let toastContainer = document.getElementById('toastContainer');
    if (!toastContainer) {
        toastContainer = document.createElement('div');
        toastContainer.id = 'toastContainer';
        toastContainer.className = 'toast-container position-fixed top-0 end-0 p-3';
        document.body.appendChild(toastContainer);
    }
    
    // 创建Toast元素
    const toastId = 'toast-' + Date.now();
    const toast = document.createElement('div');
    toast.id = toastId;
    toast.className = `toast align-items-center text-bg-${type} border-0`;
    toast.setAttribute('role', 'alert');
    toast.setAttribute('aria-live', 'assertive');
    toast.setAttribute('aria-atomic', 'true');
    
    // Toast内容
    toast.innerHTML = `
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas ${getToastIcon(type)} me-2"></i>
                ${message}
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    `;
    
    // 添加到容器
    toastContainer.appendChild(toast);
    
    // 初始化并显示Toast
    const bsToast = new bootstrap.Toast(toast, {
        autohide: true,
        delay: 3000
    });
    
    bsToast.show();
    
    // Toast隐藏后移除元素
    toast.addEventListener('hidden.bs.toast', function() {
        toast.remove();
    });
}

// 获取Toast图标
function getToastIcon(type) {
    switch(type) {
        case 'success': return 'fa-check-circle';
        case 'warning': return 'fa-exclamation-triangle';
        case 'danger': return 'fa-times-circle';
        case 'info': 
        default: return 'fa-info-circle';
    }
}

// 模拟API调用
function mockApiCall(endpoint, data) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            // 模拟成功响应
            const mockResponses = {
                '/api/login': {
                    success: true,
                    data: {
                        token: 'mock-jwt-token-123456',
                        user: {
                            id: 1,
                            email: data.email,
                            name: '张伟',
                            role: '量化分析师'
                        }
                    },
                    message: '登录成功'
                },
                '/api/register': {
                    success: true,
                    data: {
                        userId: 2,
                        email: data.email
                    },
                    message: '注册成功'
                },
                '/api/forgot-password': {
                    success: true,
                    message: '重置密码链接已发送到您的邮箱'
                }
            };
            
            const response = mockResponses[endpoint] || {
                success: false,
                message: 'API端点不存在'
            };
            
            if (response.success) {
                resolve(response);
            } else {
                reject(new Error(response.message));
            }
        }, 1000);
    });
}

// 导出函数供其他模块使用
window.formUtils = {
    validateEmail,
    validatePassword,
    showToast,
    mockApiCall
};