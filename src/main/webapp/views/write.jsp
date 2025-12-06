<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>새 구독 등록 - Pay Keeper</title>

    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Custom Enhanced Styles -->
    <link href="/css/custom-style.css" rel="stylesheet">

    <style>
        .info-box {
            background-color: #e7f3ff;
            border-left: 4px solid #0d6efd;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 10px;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <!-- Global Brand Header -->
        <div class="mb-4">
            <a href="/list" class="text-decoration-none d-inline-flex align-items-center" style="color: var(--text-color-primary);">
                <span class="fw-bold fs-4">페이키퍼 <span class="text-secondary fs-6 ms-1 fw-normal">Pay Keeper</span></span>
            </a>
        </div>

        <!-- Header -->
        <div class="row mb-4">
            <div class="col-md-12">
                <h1><i class="bi bi-plus-circle"></i> 새 구독 등록</h1>
                <p class="text-muted">OTT 구독 정보와 파티원 정보를 입력하세요</p>
            </div>
        </div>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle"></i> <strong>오류:</strong> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Info Box -->
        <div class="info-box">
            <h6><i class="bi bi-info-circle"></i> 안내사항</h6>
            <ul class="mb-0">
                <li>파티원 이름은 <strong>콤마(,)</strong>로 구분하여 입력하세요. (예: 철수,영희,민수)</li>
                <li>인당 부담 금액은 <strong>자동으로 계산</strong>됩니다. (총 금액 ÷ (파티원 수 + 본인 1명))</li>
                <li>입금 상태는 기본적으로 <strong>'미입금'</strong>으로 설정됩니다.</li>
            </ul>
        </div>

        <!-- Registration Form -->
        <div class="card shadow-sm">
            <div class="card-body">
                <form action="/create" method="post" onsubmit="return validateForm()">

                    <!-- 구독 정보 섹션 -->
                    <h5 class="border-bottom pb-2 mb-3">
                        <i class="bi bi-tv"></i> 구독 서비스 정보
                    </h5>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">
                                서비스명 <span class="text-danger">*</span>
                            </label>
                            <div class="d-flex gap-2 mb-2">
                                <!-- 1. 카테고리 선택 -->
                                <select class="form-select" id="categorySelect" onchange="handleCategoryChange(this)" style="flex: 1;">
                                    <option value="" disabled selected>카테고리</option>
                                    <option value="video">영상 (OTT)</option>
                                    <option value="music">음악</option>
                                    <option value="shopping">쇼핑/생활</option>
                                    <option value="ai">AI & 생산성</option>
                                    <option value="custom">직접 입력</option>
                                </select>
                                
                                <!-- 2. 서비스 선택 -->
                                <select class="form-select" id="serviceSelect" onchange="handleServiceChange(this)" style="flex: 1.5;" disabled>
                                    <option value="" disabled selected>서비스 선택</option>
                                </select>
                            </div>
                            
                            <!-- 직접 입력 필드 (숨김 상태) -->
                            <input type="text" class="form-control" id="serviceName"
                                   name="serviceName" placeholder="서비스명 입력"
                                   style="display:none;" maxlength="100">
                                   
                            <div class="form-text">
                                카테고리를 먼저 선택해주세요.
                            </div>
                        </div>

                        <div class="col-md-3">
                            <label for="totalPrice" class="form-label">
                                총 결제 금액 <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="totalPrice"
                                       name="totalPrice" placeholder="17000"
                                       required min="1" max="999999">
                                <span class="input-group-text">원</span>
                            </div>
                            <div class="form-text">
                                매월 결제되는 총 금액
                            </div>
                        </div>

                        <div class="col-md-3">
                            <label for="billingDate" class="form-label">
                                결제일 <span class="text-danger">*</span>
                            </label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="billingDate"
                                       name="billingDate" placeholder="15"
                                       required min="1" max="31">
                                <span class="input-group-text">일</span>
                            </div>
                            <div class="form-text">
                                매월 결제일 (1~31)
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-12">
                            <label for="accountNumber" class="form-label">
                                입금 계좌번호
                            </label>
                            <input type="text" class="form-control" id="accountNumber"
                                   name="accountNumber" placeholder="예: 카카오뱅크 3333-01-1234567"
                                   maxlength="100">
                            <div class="form-text">
                                파티원들에게 안내할 입금 계좌번호를 입력하세요 (선택사항)
                            </div>
                        </div>
                    </div>

                    <!-- 파티원 정보 섹션 -->
                    <h5 class="border-bottom pb-2 mb-3 mt-4">
                        <i class="bi bi-people"></i> 파티원 정보
                    </h5>

                    <div class="mb-3">
                        <label for="memberNames" class="form-label">
                            파티원 이름 <span class="text-danger">*</span>
                        </label>
                        <textarea class="form-control" id="memberNames" name="memberNames"
                                  rows="3" placeholder="철수,영희,민수,본인"
                                  required></textarea>
                        <div class="form-text">
                            파티원 이름을 <strong>콤마(,)</strong>로 구분하여 입력하세요.
                            본인 포함 여부는 자유입니다.
                        </div>
                    </div>

                    <!-- 계산 예시 -->
                    <div class="alert alert-light border">
                        <h6 class="alert-heading">
                            <i class="bi bi-calculator"></i> 정산 계산 예시
                        </h6>
                        <p class="mb-0" id="calculationPreview">
                            총 금액과 파티원 정보를 입력하면 인당 부담 금액이 자동 계산됩니다.
                        </p>
                    </div>

                    <!-- 버튼 -->
                    <div class="d-flex justify-content-between mt-4">
                        <a href="/list" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> 취소
                        </a>
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="bi bi-check-circle"></i> 등록하기
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Custom UI Enhancements -->
    <script src="/js/ui-enhancements.js"></script>

    <!-- Form Validation & Preview -->
    <script>
        // 서비스 데이터 정의 (Global)
        window.serviceData = {
            video: [
                { name: '넷플릭스', value: 'Netflix' },
                { name: '유튜브 프리미엄', value: 'Youtube Premium' },
                { name: '티빙', value: 'Tving' },
                { name: '웨이브', value: 'Wavve' },
                { name: '디즈니+', value: 'Disney+' },
                { name: '쿠팡플레이', value: 'Coupang Play' },
                { name: '왓챠', value: 'Watcha' },
                { name: '라프텔', value: 'Laftel' },
                { name: '아마존 프라임 비디오', value: 'Amazon Prime Video' }
            ],
            music: [
                { name: '멜론', value: 'Melon' },
                { name: '스포티파이', value: 'Spotify' },
                { name: '유튜브 뮤직', value: 'Youtube Music' },
                { name: '애플뮤직', value: 'Apple Music' },
                { name: '지니', value: 'Genie' },
                { name: '벅스', value: 'Bugs' },
                { name: '플로', value: 'Flo' }
            ],
            shopping: [
                { name: '쿠팡 와우 멤버십', value: 'Coupang Wow' },
                { name: '네이버 플러스 멤버십', value: 'Naver Plus' },
                { name: '신세계 유니버스', value: 'Shinsegae Universe' },
                { name: '컬리패스', value: 'Kurly Pass' },
                { name: '배민클럽', value: 'Baemin' },
                { name: '요기패스', value: 'Yogiyo' }
            ],
            ai: [
                { name: 'ChatGPT Plus', value: 'ChatGPT Plus' },
                { name: 'Claude Pro', value: 'Claude Pro' },
                { name: 'Gemini Advanced', value: 'Gemini Advanced' },
                { name: 'Midjourney', value: 'Midjourney' },
                { name: 'DeepL Pro', value: 'DeepL Pro' },
                { name: 'Perplexity Pro', value: 'Perplexity Pro' },
                { name: 'Notion Plus', value: 'Notion Plus' },
                { name: 'Microsoft 365', value: 'Microsoft 365' },
                { name: 'Adobe Creative Cloud', value: 'Adobe Creative Cloud' }
            ]
        };

        // 1. 카테고리 선택 핸들러
        function handleCategoryChange(catSelect) {
            const svcSelect = document.getElementById('serviceSelect');
            const input = document.getElementById('serviceName');
            const category = catSelect.value;

            console.log('Category Selected:', category);

            // 서비스 셀렉트 초기화
            svcSelect.innerHTML = '<option value="" disabled selected>서비스 선택</option>';
            input.value = '';
            
            if (category === 'custom') {
                // 직접 입력 모드
                svcSelect.style.display = 'none';
                svcSelect.disabled = true;
                
                input.style.display = 'block';
                input.disabled = false;
                input.focus();
            } else {
                // 카테고리 모드
                input.style.display = 'none';
                
                svcSelect.style.display = 'block';
                svcSelect.disabled = false;
                
                const data = window.serviceData[category];
                if (data && data.length > 0) {
                    data.forEach(svc => {
                        const option = document.createElement('option');
                        option.value = svc.value;
                        option.textContent = svc.name;
                        svcSelect.appendChild(option);
                    });
                } else {
                    console.warn('No services found for category:', category);
                }
            }
        }

        // 2. 서비스 선택 핸들러
        function handleServiceChange(svcSelect) {
            const input = document.getElementById('serviceName');
            input.value = svcSelect.value;
        }

        // 실시간 계산 미리보기
        document.getElementById('totalPrice').addEventListener('input', updatePreview);
        document.getElementById('memberNames').addEventListener('input', updatePreview);

        function updatePreview() {
            const totalPrice = parseInt(document.getElementById('totalPrice').value) || 0;
            const memberNames = document.getElementById('memberNames').value.trim();

            if (totalPrice > 0 && memberNames) {
                const members = memberNames.split(',').filter(name => name.trim() !== '');
                const totalCount = members.length; // 파티원 수 (본인 포함 가능)
                const perPrice = Math.floor(totalPrice / totalCount);

                document.getElementById('calculationPreview').innerHTML =
                    `총 금액 <strong>${totalPrice.toLocaleString()}원</strong>을 ` +
                    `<strong>${totalCount}명</strong>이 나누면 ` +
                    `인당 <strong class="text-primary">${perPrice.toLocaleString()}원</strong>입니다.`;
            } else {
                document.getElementById('calculationPreview').innerHTML =
                    '총 금액과 파티원 정보를 입력하면 인당 부담 금액이 자동 계산됩니다.';
            }
        }

        // 폼 제출 전 유효성 검증
        function validateForm() {
            const catSelect = document.getElementById('categorySelect');
            const svcSelect = document.getElementById('serviceSelect');
            const input = document.getElementById('serviceName');
            
            let serviceName = input.value.trim();
            
            if (!catSelect.value) {
                Toast.error('카테고리를 선택해주세요.');
                return false;
            }

            if (catSelect.value !== 'custom' && !svcSelect.value) {
                Toast.error('서비스를 선택해주세요.');
                return false;
            }
            
            if (!serviceName) {
                 Toast.error('서비스명을 입력해주세요.');
                 return false;
            }

            const totalPrice = parseInt(document.getElementById('totalPrice').value);
            const billingDate = parseInt(document.getElementById('billingDate').value);
            const memberNames = document.getElementById('memberNames').value.trim();

            if (!totalPrice || totalPrice <= 0) {
                Toast.error('유효한 총 금액을 입력해주세요.');
                return false;
            }

            if (!billingDate || billingDate < 1 || billingDate > 31) {
                Toast.error('결제일은 1~31 사이여야 합니다.');
                return false;
            }

            if (!memberNames) {
                Toast.error('파티원 이름을 입력해주세요.');
                return false;
            }

            const members = memberNames.split(',').filter(name => name.trim() !== '');
            if (members.length === 0) {
                Toast.error('최소 1명 이상의 파티원을 입력해주세요.');
                return false;
            }

            const submitBtn = event.target.querySelector('button[type="submit"]');
            if (typeof setButtonLoading === 'function') {
                setButtonLoading(submitBtn, true);
            }

            return true;
        }
    </script>
</body>
</html>
