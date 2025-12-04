/**
 * Pay Keeper - UI Enhancement JavaScript
 * Toast notifications, Loading spinners, Animations
 */

// ============ Toast Notification System ============
const Toast = {
    container: null,

    init() {
        if (!this.container) {
            this.container = document.createElement('div');
            this.container.className = 'toast-container';
            document.body.appendChild(this.container);
        }
    },

    show(message, type = 'info', duration = 3000) {
        this.init();

        const toast = document.createElement('div');
        toast.className = `toast-notification ${type}`;

        const icons = {
            success: 'bi-check-circle-fill',
            error: 'bi-x-circle-fill',
            info: 'bi-info-circle-fill'
        };

        const titles = {
            success: '성공',
            error: '오류',
            info: '알림'
        };

        toast.innerHTML = `
            <i class="bi ${icons[type]} toast-icon" style="color: ${type === 'success' ? '#10b981' : type === 'error' ? '#ef4444' : '#2563eb'}"></i>
            <div class="toast-content">
                <div class="toast-title">${titles[type]}</div>
                <div class="toast-message">${message}</div>
            </div>
            <span class="toast-close">&times;</span>
        `;

        this.container.appendChild(toast);

        // Close button
        const closeBtn = toast.querySelector('.toast-close');
        closeBtn.addEventListener('click', () => {
            this.remove(toast);
        });

        // Auto remove
        setTimeout(() => {
            this.remove(toast);
        }, duration);
    },

    remove(toast) {
        toast.style.opacity = '0';
        toast.style.transform = 'translateX(400px)';
        setTimeout(() => {
            toast.remove();
        }, 300);
    },

    success(message, duration = 3000) {
        this.show(message, 'success', duration);
    },

    error(message, duration = 4000) {
        this.show(message, 'error', duration);
    },

    info(message, duration = 3000) {
        this.show(message, 'info', duration);
    }
};

// ============ Loading Spinner ============
const Loading = {
    overlay: null,

    show() {
        if (!this.overlay) {
            this.overlay = document.createElement('div');
            this.overlay.className = 'loading-overlay';
            this.overlay.innerHTML = '<div class="spinner"></div>';
            document.body.appendChild(this.overlay);
        }
        this.overlay.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    },

    hide() {
        if (this.overlay) {
            this.overlay.style.display = 'none';
            document.body.style.overflow = '';
        }
    }
};

// ============ Counter Animation ============
function animateCounter(element, target, duration = 1000) {
    const start = 0;
    const increment = target / (duration / 16);
    let current = start;

    const timer = setInterval(() => {
        current += increment;
        if (current >= target) {
            element.textContent = Math.round(target);
            clearInterval(timer);
        } else {
            element.textContent = Math.round(current);
        }
    }, 16);
}

// ============ Smooth Fade In Elements ============
function fadeInElements() {
    const cards = document.querySelectorAll('.card');
    cards.forEach((card, index) => {
        setTimeout(() => {
            card.classList.add('animate-fade-in-up');
        }, index * 100);
    });
}

// ============ Confirmation Modal ============
function showConfirmModal(title, message, onConfirm) {
    const modal = document.createElement('div');
    modal.className = 'modal fade';
    modal.innerHTML = `
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">${title}</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>${message}</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-danger" id="confirm-btn">확인</button>
                </div>
            </div>
        </div>
    `;

    document.body.appendChild(modal);
    const bsModal = new bootstrap.Modal(modal);
    bsModal.show();

    document.getElementById('confirm-btn').addEventListener('click', () => {
        onConfirm();
        bsModal.hide();
    });

    modal.addEventListener('hidden.bs.modal', () => {
        modal.remove();
    });
}

// ============ Button Loading State ============
function setButtonLoading(button, isLoading) {
    if (isLoading) {
        button.classList.add('btn-loading');
        button.disabled = true;
        button.dataset.originalText = button.innerHTML;
    } else {
        button.classList.remove('btn-loading');
        button.disabled = false;
        if (button.dataset.originalText) {
            button.innerHTML = button.dataset.originalText;
        }
    }
}

// ============ Form Validation Enhancement ============
function enhanceFormValidation(formElement) {
    const inputs = formElement.querySelectorAll('input, textarea, select');

    inputs.forEach(input => {
        input.addEventListener('invalid', (e) => {
            e.preventDefault();
            input.classList.add('is-invalid');

            let feedback = input.nextElementSibling;
            if (!feedback || !feedback.classList.contains('invalid-feedback')) {
                feedback = document.createElement('div');
                feedback.className = 'invalid-feedback';
                input.parentNode.appendChild(feedback);
            }
            feedback.textContent = input.validationMessage;
        });

        input.addEventListener('input', () => {
            if (input.validity.valid) {
                input.classList.remove('is-invalid');
                input.classList.add('is-valid');
            }
        });
    });
}

// ============ Smooth Scroll to Element ============
function smoothScrollTo(elementId) {
    const element = document.getElementById(elementId);
    if (element) {
        element.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
}

// ============ Initialize on Page Load ============
document.addEventListener('DOMContentLoaded', function() {
    // Fade in animations
    fadeInElements();

    // Enhance all forms
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        enhanceFormValidation(form);
    });

    // Animate statistics counters if they exist
    const statNumbers = document.querySelectorAll('.stat-number');
    statNumbers.forEach(stat => {
        const target = parseInt(stat.textContent.replace(/,/g, ''));
        if (!isNaN(target)) {
            stat.textContent = '0';
            animateCounter(stat, target, 1500);
        }
    });
});

// ============ Export for Global Use ============
window.Toast = Toast;
window.Loading = Loading;
window.showConfirmModal = showConfirmModal;
window.setButtonLoading = setButtonLoading;
window.animateCounter = animateCounter;
