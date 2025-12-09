<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pay Keeper - OTT 구독 공유 정산 관리</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>

    <link href="/css/custom-style.css" rel="stylesheet">
</head>
<body>
    <div class="container my-5 animate-fade-in-up">
        <header class="d-flex justify-content-between align-items-center mb-5">
            <div style="cursor: pointer;" onclick="location.href='/list'" title="메인으로 이동">
                <h1 class="h2 mb-0">
                    페이키퍼
                    <span class="text-secondary fs-5 ms-1 fw-normal">Pay Keeper</span>
                </h1>
                <p class="text-secondary mb-0">OTT 구독 공유 및 정산 관리 시스템</p>
            </div>
            <div class="d-flex align-items-center">
                <button id="kakao-auth-btn" 
                        class="btn btn-outline-warning me-2" 
                        onclick="startKakaoLogin()" 
                        title="카카오톡 메시지 전송을 위해 인증이 필요합니다"
                        data-client-id="5f7e5fdaa7123c1ede1ed8bb7c9b8967" data-redirect-uri="http://localhost:8080/kakao/callback"> <i class="bi bi-chat-fill me-1"></i> 카카오 인증
                </button>
                <a href="/write" class="btn btn-primary">
                    <i class="bi bi-plus-circle me-1"></i> 새 구독 등록
                </a>
            </div>
        </header>

        <div class="card mb-4">
            <div class="card-header" data-bs-toggle="collapse" data-bs-target="#userGuide" aria-expanded="true" aria-controls="userGuide" style="cursor: pointer;">
                <h5 class="mb-0 d-flex justify-content-between align-items-center">
                    <span><i class="bi bi-question-circle-fill me-2"></i>사용 안내</span>
                    <i class="bi bi-chevron-down" id="guideToggleIcon"></i>
                </h5>
            </div>
            <div id="userGuide" class="collapse">
                <div class="card-body small">
                    <p class="text-secondary mb-3">Pay Keeper를 활용하여 OTT 구독 공유 및 정산을 스마트하게 관리하세요.</p>
                     <div class="row g-3">
                        <div class="col-md-6">
                            <h6 class="fw-bold text-primary"><i class="bi bi-pencil-square me-1"></i>구독 관리</h6>
                            <ul class="list-unstyled text-secondary mb-0">
                                <li>• <b>등록:</b> 우측 상단 '새 구독 등록' 버튼으로 서비스와 파티원을 추가하세요.</li>
                                <li>• <b>수정/삭제:</b> 각 구독 카드의 우측 상단 아이콘을 이용하세요.</li>
                                <li>• <b>공유:</b> 공유 아이콘 <i class="bi bi-share"></i>을 눌러 파티원에게 링크를 보내세요.</li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <h6 class="fw-bold text-success"><i class="bi bi-cash-coin me-1"></i>정산 및 알림</h6>
                            <ul class="list-unstyled text-secondary mb-0">
                                <li>• <b>입금 확인:</b> 파티원 목록의 아이콘을 눌러 '미입금' ↔ '완료' 상태를 변경하세요.</li>
                                <li>• <b>콕 찌르기:</b> 미입금 파티원에게 <i class="bi bi-hand-index-thumb-fill text-warning"></i> 버튼으로 카카오톡 알림을 보내세요.</li>
                                <li>• <b>현황판:</b> 좌측 대시보드에서 이번 달 총 지출과 다음 결제일을 확인하세요.</li>
                            </ul>
                        </div>
                        <div class="col-12 mt-2 border-top pt-2">
                             <p class="mb-0 text-muted"><i class="bi bi-info-circle me-1"></i><b>Tip:</b> 카테고리 버튼으로 원하는 구독만 모아보거나, 달력에서 전체 결제 일정을 한눈에 파악할 수 있습니다.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mb-5 align-items-stretch">
            <div class="col-lg-5 mb-4 mb-lg-0 d-flex flex-column">
                <div class="mb-auto"> 
    <h5 class="mb-3 fw-bold"><i class="bi bi-bar-chart-fill me-2"></i>이번 달 리포트</h5>
    <div class="row g-3">
        <!-- 1. Total Cost (Highlighted) -->
        <div class="col-12">
            <div class="card border-0 shadow-sm text-white" style="background: linear-gradient(135deg, #007aff, #005ecb);">
                <div class="card-body p-4 d-flex justify-content-between align-items-center">
                    <div>
                        <div class="small text-white-50 mb-1">이번 달 총 결제 예정액</div>
                        <div class="fs-2 fw-bold text-white">${String.format("%,d", stats.sumTotalPrice)}원</div>
                        <div class="small text-white-50 mt-1">총 <span class="text-white fw-bold">${stats.countSubscriptions}</span>개의 구독을 관리 중입니다.</div>
                    </div>
                    <div class="bg-white bg-opacity-25 rounded-circle d-flex align-items-center justify-content-center" style="width: 56px; height: 56px;">
                        <i class="bi bi-wallet2 fs-3"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- 2. Next Payment (Dynamic) -->
        <div class="col-6">
            <div class="card border-0 shadow-sm h-100" style="background-color: #fff;">
                <div class="card-body p-3">
                    <div class="d-flex align-items-center mb-2 text-secondary">
                        <i class="bi bi-clock-history me-1"></i>
                        <span class="small fw-bold">곧 결제 예정</span>
                    </div>
                    <div id="next-payment-info">
                        <h6 class="fw-bold mb-1 text-truncate" id="next-service-name">-</h6>
                        <div class="text-danger fw-bold small" id="next-service-dday">일정 없음</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 3. Settlement Status (Progress) -->
        <div class="col-6">
            <div class="card border-0 shadow-sm h-100" style="background-color: #fff;">
                <div class="card-body p-3">
                    <div class="d-flex align-items-center mb-2 text-secondary">
                        <i class="bi bi-check-circle me-1"></i>
                        <span class="small fw-bold">정산 현황</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-end mb-2">
                        <span class="fs-5 fw-bold">${String.format("%.0f", stats.paidPercentage)}%</span>
                        <span class="small text-muted">${stats.countAllPartyMembers}명 중</span>
                    </div>
                    <div class="progress" style="height: 6px; background-color: #f0f0f0;">
                        <div class="progress-bar bg-success" role="progressbar" style="width: ${stats.paidPercentage}%" aria-valuenow="${stats.paidPercentage}" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 4. Average Cost -->
        <div class="col-6">
            <div class="card border-0 shadow-sm h-100" style="background-color: #fff;">
                <div class="card-body p-3">
                    <div class="d-flex align-items-center mb-2 text-secondary">
                        <i class="bi bi-calculator me-1"></i>
                        <span class="small fw-bold">평균 구독료</span>
                    </div>
                    <div class="d-flex flex-column justify-content-center h-50">
                        <div class="fs-5 fw-bold text-dark">
                             ${stats.countSubscriptions > 0 ? String.format("%,.0f", stats.sumTotalPrice / stats.countSubscriptions) : 0}원
                        </div>
                        <div class="small text-secondary">서비스 1개당</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 5. Top Category (Dynamic) -->
        <div class="col-6">
            <div class="card border-0 shadow-sm h-100" style="background-color: #fff;">
                <div class="card-body p-3">
                    <div class="d-flex align-items-center mb-2 text-secondary">
                        <i class="bi bi-pie-chart me-1"></i>
                        <span class="small fw-bold">주 이용 분야</span>
                    </div>
                    <div class="d-flex flex-column justify-content-center h-50">
                        <div class="fs-5 fw-bold text-dark" id="top-category-name">-</div>
                        <div class="small text-secondary" id="top-category-count">데이터 분석 중</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

                <div>
                    <h5 class="mb-3 fw-bold mt-4"><i class="bi bi-search me-2"></i>구독 검색</h5>
                    <div class="card">
                        <div class="card-body d-flex align-items-center p-3">
                            <form action="/list" method="get" class="row g-2 w-100 align-items-end m-0">
                                <div class="col-md-4">
                                    <label class="form-label small text-secondary mb-1">검색 조건</label>
                                    <select class="form-select form-select-sm" name="searchType">
                                        <option value="service" ${searchType != 'member' ? 'selected' : ''}>서비스명</option>
                                        <option value="member" ${searchType == 'member' ? 'selected' : ''}>파티원 이름</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small text-secondary mb-1">검색어</label>
                                    <input type="text" class="form-control form-select-sm" name="keyword" placeholder="검색어 입력" value="${keyword}">
                                </div>
                                <div class="col-md-2">
                                    <button type="submit" class="btn btn-secondary btn-sm w-100"><i class="bi bi-search"></i></button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="d-flex flex-column h-100">
                    <h5 class="mb-3 fw-bold"><i class="bi bi-calendar3 me-2"></i>구독 결제 달력</h5>
                    <div class="card h-100">
                        <div class="card-body p-3 pb-1">
                            <div id="calendar" style="height: 100%;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="category-scroll-wrapper">
            <button class="category-btn active" onclick="filterByCategory('all', this)">전체</button>
            <button class="category-btn" onclick="filterByCategory('video', this)">영상 (OTT)</button>
            <button class="category-btn" onclick="filterByCategory('music', this)">음악</button>
            <button class="category-btn" onclick="filterByCategory('shopping', this)">쇼핑/생활</button>
            <button class="category-btn" onclick="filterByCategory('work', this)">업무/유틸</button>
            <button class="category-btn" onclick="filterByCategory('other', this)">기타</button>
        </div>

        <c:choose>
            <c:when test="${empty subscriptions}">
                <div class="card text-center py-5">
                    <div class="card-body">
                        <i class="bi bi-info-circle fs-2 text-secondary mb-3"></i>
                        <h5 class="card-title">등록된 구독이 없습니다.</h5>
                        <p class="text-secondary">새로운 구독 정보를 등록해주세요.</p>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <c:forEach items="${subscriptions}" var="sub">
                        <div class="col-md-6 mb-4 subscription-item">
                            <div class="card h-100">
                                <div class="card-header d-flex justify-content-between align-items-center" data-billing-date="${sub.billingDate}">
                                    <span class="fw-bold d-flex align-items-center">
                                        <span class="service-logo-wrapper me-2" data-service="${sub.serviceName}">
                                            <i class="bi bi-tv text-secondary"></i>
                                        </span>
                                        ${sub.serviceName}
                                    </span>
                                    <div class="d-flex align-items-center">
                                        <a href="/edit?seq=${sub.seq}" class="btn btn-icon" title="수정"><i class="bi bi-pencil-square"></i></a>
                                        <form id="delete-form-${sub.seq}" action="/delete" method="post" class="ms-2">
                                            <input type="hidden" name="seq" value="${sub.seq}">
                                            <button type="button" class="btn btn-icon" title="삭제" onclick="confirmDelete(${sub.seq})"><i class="bi bi-trash3"></i></button>
                                        </form>
                                    </div>
                                </div>

                                <div class="card-body">
                                    <div class="d-flex justify-content-between text-secondary mb-3">
                                        <span>총 금액: <strong class="text-dark">${String.format("%,d", sub.totalPrice)}원</strong></span>
                                        <span class="payment-date-text">결제일: 매월 ${sub.billingDate}일</span>
                                    </div>

                                    <div class="d-flex justify-content-between align-items-center mb-4 p-3 bg-light rounded-3">
                                        <div class="d-flex align-items-center" style="gap: 10px;">
                                            <c:if test="${not empty sub.accountNumber}">
                                                <div class="icon-circle bg-white shadow-sm text-secondary">
                                                    <i class="bi bi-credit-card"></i>
                                                </div>
                                                <div>
                                                    <div class="small text-muted" style="font-size: 0.75rem;">입금 계좌</div>
                                                    <div class="fw-bold small" onclick="copyToClipboard('${sub.accountNumber}', '계좌번호가')" style="cursor:pointer;" title="클릭하여 복사">
                                                        ${sub.accountNumber} <i class="bi bi-files ms-1 text-secondary"></i>
                                                    </div>
                                                </div>
                                            </c:if>
                                            <c:if test="${empty sub.accountNumber}">
                                                <span class="small text-secondary">계좌 정보 없음</span>
                                            </c:if>
                                        </div>
                                    </div>

                                    <h6 class="fw-bold"><i class="bi bi-people me-2"></i>파티원 목록 (${sub.memberCount}명)</h6>
                                    
                                     <c:choose>
                                        <c:when test="${empty sub.members}">
                                            <p class="text-secondary small mt-3">등록된 파티원이 없습니다.</p>
                                        </c:when>
                                        <c:otherwise>
                                            <table class="table table-borderless table-sm small">
                                                <thead>
                                                    <tr>
                                                        <th>이름</th>
                                                        <th>부담액</th>
                                                        <th>상태</th>
                                                        <th class="text-end">관리</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${sub.members}" var="member">
                                                        <tr>
                                                            <td>${member.memberName}</td>
                                                            <td>${String.format("%,d", member.perPrice)}원</td>
                                                            <td>
                                                                <span id="badge-${member.memberSeq}" class="badge ${member.isPaid == 'Y' ? 'bg-success' : 'bg-danger'}">
                                                                    ${member.isPaid == 'Y' ? '완료' : '미입금'}
                                                                </span>
                                                            </td>
                                                            <td class="text-end">
                                                                <button class="btn btn-icon btn-sm ${member.isPaid == 'Y' ? 'text-success' : 'text-danger'}" 
                                                                        title="${member.isPaid == 'Y' ? '미입금으로 변경' : '입금 완료로 변경'}" 
                                                                        onclick="togglePaidStatus(this, ${member.memberSeq}, '${member.isPaid}')">
                                                                    <i class="bi ${member.isPaid == 'Y' ? 'bi-check-circle-fill' : 'bi-x-circle-fill'}"></i>
                                                                </button>
                                                                
                                                                <span id="poke-container-${member.memberSeq}" style="${member.isPaid == 'Y' ? 'display:none;' : ''}">
                                                                    <button class="btn btn-sm btn-kakao ms-1" 
                                                                            title="카카오톡으로 알림 보내기"
                                                                            onclick="pokeUnpaidMember('${member.memberName}', '${sub.serviceName}', ${member.perPrice}, '${sub.accountNumber}')">
                                                                        <i class="bi bi-chat-fill me-1"></i> 콕 찌르기
                                                                    </button>
                                                                </span>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="card-footer text-end">
                                    <small class="text-secondary"><i class="bi bi-calendar-event me-1"></i>등록일: ${sub.regdate}</small>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/ui-enhancements.js"></script>

    <script>
        // 전역 스코프 함수들 (DOMContentLoaded 외부에 위치)
        function togglePaidStatus(btnElement, memberSeq, currentStatus) {
            // Optimistic UI: 서버 응답 전에 로딩 표시 대신 버튼을 비활성화
            btnElement.disabled = true;
            
            fetch('/togglePaid', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'memberSeq=' + memberSeq + '&currentStatus=' + currentStatus
            })
            .then(res => res.json())
            .then(data => {
                btnElement.disabled = false;
                if (data.success) {
                    const newStatus = data.newStatus;
                    const isPaid = newStatus === 'Y';
                    
                    // 1. Badge Update
                    const badge = document.getElementById('badge-' + memberSeq);
                    if (badge) {
                        badge.className = isPaid ? 'badge bg-success' : 'badge bg-danger';
                        badge.textContent = isPaid ? '완료' : '미입금';
                    }

                    // 2. Button Update (Icon & Color)
                    btnElement.className = 'btn btn-icon btn-sm ' + (isPaid ? 'text-success' : 'text-danger');
                    btnElement.title = isPaid ? '미입금으로 변경' : '입금 완료로 변경';
                    
                    const icon = btnElement.querySelector('i');
                    if (icon) {
                        icon.className = 'bi ' + (isPaid ? 'bi-check-circle-fill' : 'bi-x-circle-fill');
                    }

                    // 3. Update Onclick for next interaction
                    // 주의: setAttribute로 설정해야 다음 클릭 시 새 값이 반영됨
                    btnElement.setAttribute('onclick', "togglePaidStatus(this, " + memberSeq + ", '" + newStatus + "')");

                    // 4. Poke Button Visibility
                    const pokeContainer = document.getElementById('poke-container-' + memberSeq);
                    if (pokeContainer) {
                        pokeContainer.style.display = isPaid ? 'none' : 'inline-block';
                    }

                    Toast.success('입금 상태가 변경되었습니다.');
                } else {
                    Toast.error(data.message || '상태 변경에 실패했습니다.');
                }
            })
            .catch(err => {
                btnElement.disabled = false;
                Toast.error('오류가 발생했습니다.');
                console.error(err);
            });
        }

        function confirmDelete(seq) {
            showConfirmModal('구독 삭제', '정말 삭제하시겠습니까?', () => {
                document.getElementById('delete-form-' + seq).submit();
            });
        }
        
        function copyToClipboard(text, subject) {
            navigator.clipboard.writeText(text).then(() => {
                Toast.success(`${subject} 복사되었습니다!`);
            }).catch(() => {
                Toast.error('복사에 실패했습니다.');
            });
        }



        // 카카오톡 인증 시작
        function startKakaoLogin() {
            const authBtn = document.getElementById('kakao-auth-btn');
            const REST_API_KEY = authBtn.dataset.clientId;
            const REDIRECT_URI = authBtn.dataset.redirectUri;

            if (!REST_API_KEY || !REDIRECT_URI) {
                Toast.error('카카오 인증을 위한 Key 또는 Redirect URI 설정이 누락되었습니다. 버튼의 data-client-id를 확인하세요.');
                return;
            }

            const authUrl = 'https://kauth.kakao.com/oauth/authorize?client_id=' + REST_API_KEY + '&redirect_uri=' + REDIRECT_URI + '&response_type=code&scope=talk_message';
            
            showConfirmModal('카카오톡 인증', '미입금 알림 메시지를 보내기 위해 카카오톡 인증이 필요합니다.<br>로그인 후 <b>[카카오톡 메시지 전송]</b> 항목에 동의해 주세요.', () => {
                window.location.href = authUrl;
            });
        }

        // 카카오톡 메시지 전송 (나에게 보내기)
        // [수정 완료] HTML의 onclick과 인자 수가 일치하도록 함수 시그니처 수정
        function pokeUnpaidMember(memberName, serviceName, perPrice, accountNumber) {
            const month = new Date().getMonth() + 1;

            let message = '[페이키퍼] ' + memberName + '님\n';
            message += '[' + serviceName + '] ' + month + '월 구독료\n';
            message += parseInt(perPrice).toLocaleString() + '원 입금 부탁드려요!';
            if (accountNumber && accountNumber.trim() !== '') {
                message += '\n\n계좌: ' + accountNumber;
            }

            // 1. 인증 상태 확인 (클라이언트 측)
            const authBtn = document.getElementById('kakao-auth-btn');
            // 'btn-success' 클래스로 인증 완료 상태 확인
            if (!authBtn || !authBtn.classList.contains('btn-success')) { 
                if(confirm('카카오톡 인증이 필요합니다. 인증하시겠습니까?\n(취소 시 클립보드에 복사됩니다)')) {
                    startKakaoLogin();
                } else {
                    copyToClipboard(message, '메시지가');
                }
                return;
            }

            // 2. 메시지 전송 요청
            Loading.show();
            fetch('/api/kakao/poke', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'message=' + encodeURIComponent(message)
            })
            .then(res => res.json())
            .then(data => {
                Loading.hide();
                if (data.success) {
                    Toast.success('카카오톡(나에게)으로 메시지가 전송되었습니다.');
                } else {
                    Toast.error('전송 실패: ' + (data.message || '카카오톡 메시지 전송에 실패했습니다.'));
                }
            })
            .catch(err => {
                Loading.hide();
                Toast.error('오류가 발생했습니다.');
            });
        }

        // 토큰 상태 확인
        function checkKakaoTokenStatus() {
            fetch('/api/kakao/status')
                .then(res => res.json())
                .then(data => {
                    const authBtn = document.getElementById('kakao-auth-btn');
                    if (data.isAuthorized) {
                        authBtn.classList.replace('btn-outline-warning', 'btn-success');
                        authBtn.innerHTML = '<i class="bi bi-check-circle-fill me-1"></i> 카카오 연동됨';
                        authBtn.disabled = true;
                        authBtn.title = '이미 인증되었습니다';
                    }
                })
                .catch(console.error);
        }

        // Service Domain Mapping for Favicons
        function getServiceDomain(serviceName) {
            if (!serviceName) return null;
            const name = serviceName.toLowerCase().replace(/\s/g, '');
            
            if (name.includes('netflix') || name.includes('넷플릭스')) return 'netflix.com';
            if (name.includes('youtube') || name.includes('유튜브')) return 'youtube.com';
            if (name.includes('tving') || name.includes('티빙')) return 'tving.com';
            if (name.includes('wavve') || name.includes('웨이브')) return 'wavve.com';
            if (name.includes('disney') || name.includes('디즈니')) return 'disneyplus.com';
            if (name.includes('watcha') || name.includes('왓챠')) return 'watcha.com';
            if (name.includes('melon') || name.includes('멜론')) return 'melon.com';
            // Spotify는 구글 파비콘 서비스에서 간혹 오류가 나서 직접 도메인 대신 구글의 캐시된 이미지 경로를 지정
            if (name.includes('spotify') || name.includes('스포티파이')) return 'spotify.com';
            if (name.includes('genie') || name.includes('지니')) return 'genie.co.kr';
            if (name.includes('bugs') || name.includes('벅스')) return 'bugs.co.kr';
            if (name.includes('naver') || name.includes('네이버')) return 'naver.com';
            if (name.includes('coupang') || name.includes('쿠팡')) return 'coupangplay.com';
            if (name.includes('apple') || name.includes('애플') || name.includes('icloud')) return 'apple.com';
            if (name.includes('laftel') || name.includes('라프텔')) return 'laftel.net';
            if (name.includes('prime') || name.includes('amazon') || name.includes('아마존')) return 'primevideo.com';
            
            // AI & Productivity
            if (name.includes('chatgpt') || name.includes('openai') || name.includes('gpt')) return 'openai.com';
            if (name.includes('claude') || name.includes('클로드')) return 'anthropic.com';
            if (name.includes('gemini') || name.includes('제미나이') || name.includes('바드')) return 'google.com'; // Google service
            if (name.includes('midjourney') || name.includes('미드저니')) return 'midjourney.com';
            if (name.includes('notion') || name.includes('노션')) return 'notion.so';
            if (name.includes('deepl') || name.includes('딥엘')) return 'deepl.com';
            if (name.includes('perplexity') || name.includes('퍼플렉시티')) return 'perplexity.ai';
            
            return null;
        }

        // Brand Color Mapping Helper
        function getBrandColor(serviceName) {
            if (!serviceName) return '#007aff'; // Default Blue
            
            const name = serviceName.toLowerCase().replace(/\s/g, '');
            
            if (name.includes('netflix') || name.includes('넷플릭스')) return '#E50914';
            if (name.includes('youtube') || name.includes('유튜브')) return '#FF0000';
            if (name.includes('tving') || name.includes('티빙')) return '#FF143C';
            if (name.includes('wavve') || name.includes('웨이브')) return '#1EC4E8';
            if (name.includes('disney') || name.includes('디즈니')) return '#061840';
            if (name.includes('watcha') || name.includes('왓챠')) return '#FF2F6E';
            if (name.includes('melon') || name.includes('멜론')) return '#00CD3C';
            if (name.includes('spotify') || name.includes('스포티파이')) return '#1DB954';
            if (name.includes('genie') || name.includes('지니')) return '#2BB6E8';
            if (name.includes('bugs') || name.includes('벅스')) return '#FE3C34';
            if (name.includes('naver') || name.includes('네이버')) return '#03C75A';
            if (name.includes('coupang') || name.includes('쿠팡')) return '#E4312B';
            if (name.includes('apple') || name.includes('애플') || name.includes('icloud')) return '#2c2c2c';
            if (name.includes('laftel') || name.includes('라프텔')) return '#816BFF';
            if (name.includes('prime') || name.includes('amazon') || name.includes('아마존')) return '#00A8E1';

            // AI & Productivity
            if (name.includes('chatgpt') || name.includes('openai') || name.includes('gpt')) return '#10A37F';
            if (name.includes('claude') || name.includes('클로드')) return '#CC785C';
            if (name.includes('gemini') || name.includes('제미나이') || name.includes('바드')) return '#4285F4';
            if (name.includes('midjourney') || name.includes('미드저니')) return '#000000';
            if (name.includes('notion') || name.includes('노션')) return '#000000';
            if (name.includes('deepl') || name.includes('딥엘')) return '#0F2B46';
            if (name.includes('perplexity') || name.includes('퍼플렉시티')) return '#1FB8CD';
            
            return '#007aff'; // Fallback Default
        }

        // Category Logic
        function getCategory(serviceName) {
            if (!serviceName) return 'other';
            const name = serviceName.toLowerCase().replace(/\s/g, '');
            
            // Video / OTT
            if (['netflix','youtube','tving','wavve','disney','watcha','laftel','coupangplay','prime','hbo','paramount'].some(k => name.includes(k))) return 'video';
            // Music
            if (['melon','spotify','genie','bugs','flo','vibe','music'].some(k => name.includes(k))) return 'music';
            // Shopping / Life
            if (['naver','coupang','kurly','smile','delivery','baemin','yogiyo','shinsegae','컬리패스','배민클럽','요기패스'].some(k => name.includes(k))) return 'shopping';
            // Work / Utility / AI
            if (['chatgpt','gpt','claude','gemini','midjourney','notion','deepl','perplexity','adobe','microsoft','office','zoom','slack','figma','dropbox','drive','cloud'].some(k => name.includes(k))) return 'work';
            return 'other';
        }

        function filterByCategory(category, btn) {
            // Update Active Button
            document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            
            const items = document.querySelectorAll('.subscription-item');
            
            items.forEach(item => {
                const itemCategory = item.dataset.category;
                if (category === 'all' || itemCategory === category) {
                    item.style.display = 'block';
                    // Add fade-in animation for better UX
                    item.classList.remove('animate-fade-in-up');
                    void item.offsetWidth; // trigger reflow
                    item.classList.add('animate-fade-in-up');
                } else {
                    item.style.display = 'none';
                }
            });
        }


        document.addEventListener('DOMContentLoaded', function() {
            checkKakaoTokenStatus();
            
            // Initialize Categories for Items & Calculate Top Category
            const categoryCounts = { video: 0, music: 0, shopping: 0, work: 0, other: 0 };
            const categoryNames = { video: '영상 (OTT)', music: '음악', shopping: '쇼핑/생활', work: '업무/유틸', other: '기타' };
            
            document.querySelectorAll('.subscription-item').forEach(item => {
                const serviceNameWrapper = item.querySelector('.service-logo-wrapper');
                const serviceName = serviceNameWrapper ? serviceNameWrapper.dataset.service : '';
                const cat = getCategory(serviceName);
                item.dataset.category = cat;
                
                if (categoryCounts[cat] !== undefined) {
                    categoryCounts[cat]++;
                } else {
                    categoryCounts['other']++;
                }
            });

            // Determine Top Category
            let maxCat = 'other';
            let maxCount = -1;
            for (const [key, value] of Object.entries(categoryCounts)) {
                if (value > maxCount) {
                    maxCount = value;
                    maxCat = key;
                }
            }
            
            const topCatNameEl = document.getElementById('top-category-name');
            const topCatCountEl = document.getElementById('top-category-count');
            if (topCatNameEl && maxCount > 0) {
                topCatNameEl.textContent = categoryNames[maxCat] || '기타';
                topCatCountEl.textContent = maxCount + '개의 구독 중';
            } else if (topCatNameEl) {
                topCatNameEl.textContent = '-';
                topCatCountEl.textContent = '구독 없음';
            }

            // Load Service Logos
            document.querySelectorAll('.service-logo-wrapper').forEach(wrapper => {
                const serviceName = wrapper.dataset.service;
                const domain = getServiceDomain(serviceName); 
                
                if (domain) {
                    const img = document.createElement('img');
                    // Google's service for fetching favicons
                    img.src = 'https://www.google.com/s2/favicons?domain=' + domain + '&sz=64';
                    img.className = 'service-logo-img';
                    img.alt = serviceName;
                    img.style.width = '24px';
                    img.style.height = '24px';
                    img.style.borderRadius = '4px';
                    
                    const defaultIcon = wrapper.querySelector('i');
                    if (defaultIcon) defaultIcon.style.display = 'none';
                    
                    img.onload = function() {
                        wrapper.appendChild(img);
                    };
                    
                    img.onerror = function() {
                        // 이미지 로드 실패 시 기본 아이콘 복원
                        if (defaultIcon) defaultIcon.style.display = 'inline-block';
                        img.remove();
                    };
                    
                    // Note: AppendChild is usually done on onload to prevent flicker, 
                    // but for favicon service, appending immediately is often fine.
                    // However, we wait for onload/onerror to manage the default icon visibility.
                }
            });

            // Add D-Day Badges
            document.querySelectorAll('.card-header[data-billing-date]').forEach(header => {
                console.log('[D-Day Debug] Processing header element:', header); // header 요소 자체 로그
                const billingDateStr = header.getAttribute('data-billing-date'); // .dataset 대신 getAttribute 사용
                const billingDate = parseInt(billingDateStr);
                const serviceName = header.querySelector('.fw-bold').innerText.split('\n')[0].trim(); // 서비스명 추출

                console.log(`[D-Day Debug] Processing service: ${serviceName}, Raw Billing Date Str: '${billingDateStr}', Parsed Billing Date: ${billingDate}`);
                
                if (isNaN(billingDate) || billingDate < 1 || billingDate > 31) {
                    console.warn(`[D-Day Debug] Invalid Billing Date for ${serviceName}: '${billingDateStr}'. Skipping D-Day calculation.`);
                    return; // 유효하지 않으면 건너뜀
                }

                const today = new Date();
                today.setHours(0, 0, 0, 0); // 오늘 날짜의 시간 정보를 초기화

                let paymentDate = new Date(today.getFullYear(), today.getMonth(), billingDate);
                paymentDate.setHours(0, 0, 0, 0); // 결제 예정일의 시간 정보를 초기화

                // 결제 예정일이 오늘보다 과거이면 다음 달로 설정
                if (paymentDate < today) {
                    paymentDate.setMonth(paymentDate.getMonth() + 1);
                    console.log(`[D-Day Debug] Payment date ${billingDate} is in the past. Adjusted to next month: ${paymentDate.toLocaleDateString()}`);
                }
                
                // 오늘 날짜와 결제 예정일의 차이 계산 (미래 날짜에서 오늘 날짜를 뺌)
                const diffTime = paymentDate.getTime() - today.getTime();
                const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); // 올림하여 남은 일수 계산
                
                console.log(`[D-Day Debug] Today: ${today.toLocaleDateString()}, Payment Date: ${paymentDate.toLocaleDateString()}, Diff Days: ${diffDays}`);

                let ddayText = '';
                let badgeClass = '';

                if (diffDays === 0) {
                    ddayText = 'D-Day';
                    badgeClass = 'bg-danger'; // 오늘 결제
                } else if (diffDays > 0 && diffDays <= 7) {
                    ddayText = 'D-' + diffDays;
                    badgeClass = 'bg-warning'; // 7일 이내 (custom css handles color)
                } else if (diffDays > 7) {
                    ddayText = 'D-' + diffDays;
                    badgeClass = 'bg-secondary'; // 7일 이상 남음
                } else {
                    // Should not happen, but safe fallback
                    ddayText = ''; 
                }

                if (ddayText) {
                    const ddayBadge = document.createElement('span');
                    ddayBadge.className = 'badge rounded-pill ms-2 ' + badgeClass;
                    ddayBadge.textContent = ddayText;
                    
                    // 결제일 옆에 배지 추가
                    const billingDateSpan = header.nextElementSibling.querySelector('.payment-date-text');
                    
                    if (billingDateSpan) {
                        billingDateSpan.appendChild(ddayBadge);
                        console.log(`[D-Day Debug] Badge appended to billing date span for ${serviceName}.`);
                    } else {
                        header.querySelector('.fw-bold').appendChild(ddayBadge); // fallback
                        console.warn(`[D-Day Debug] Could not find billing date span for ${serviceName}. Appended to service name (fallback).`);
                    }
                } else {
                    console.log(`[D-Day Debug] No D-Day badge to display for ${serviceName}.`);
                }
            });

            // Calendar & Full Data for Dashboard
            const calendarEl = document.getElementById('calendar');
            const accentColor = getComputedStyle(document.documentElement).getPropertyValue('--accent-color').trim();

            const subscriptions = []; // For Calendar
            const allSubsData = [];   // For Next Payment Calculation (Full Data)

            <c:set var="calendarData" value="${not empty allSubscriptions ? allSubscriptions : subscriptions}" />
            <c:if test="${not empty calendarData}">
                <c:forEach items="${calendarData}" var="sub">
                    // 1. Calendar Event
                    subscriptions.push({
                        title: '${sub.serviceName}',
                        start: new Date(new Date().getFullYear(), new Date().getMonth(), ${sub.billingDate}).toISOString().split('T')[0],
                        backgroundColor: getBrandColor('${sub.serviceName}'),
                        borderColor: getBrandColor('${sub.serviceName}')
                    });

                    // 2. Full Data for Logic
                    allSubsData.push({
                        serviceName: '${sub.serviceName}',
                        billingDate: ${sub.billingDate}
                    });
                </c:forEach>
            </c:if>

            // Find Next Payment Logic (Based on Full Data)
            let minDiff = 999;
            let nextService = null;
            
            allSubsData.forEach(sub => {
                 const billingDate = sub.billingDate;
                 const serviceName = sub.serviceName;
                 
                 if (isNaN(billingDate)) return;

                 const today = new Date();
                 today.setHours(0, 0, 0, 0);
                 
                 let paymentDate = new Date(today.getFullYear(), today.getMonth(), billingDate);
                 paymentDate.setHours(0, 0, 0, 0);
                 
                 if (paymentDate < today) {
                     paymentDate.setMonth(paymentDate.getMonth() + 1);
                 }
                 
                 const diffTime = paymentDate.getTime() - today.getTime();
                 const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
                 
                 if (diffDays >= 0 && diffDays < minDiff) {
                     minDiff = diffDays;
                     nextService = { name: serviceName, dday: diffDays };
                 }
            });

            if (nextService) {
                const nameEl = document.getElementById('next-service-name');
                const ddayEl = document.getElementById('next-service-dday');
                if (nameEl && ddayEl) {
                    nameEl.textContent = nextService.name;
                    nameEl.title = nextService.name; // Tooltip for truncation
                    
                    if (nextService.dday === 0) {
                        ddayEl.textContent = '오늘 결제일!';
                        ddayEl.className = 'text-danger fw-bold small';
                    } else {
                        ddayEl.textContent = 'D-' + nextService.dday;
                        ddayEl.className = 'text-primary fw-bold small';
                    }
                }
            } else {
                 const nameEl = document.getElementById('next-service-name');
                 const ddayEl = document.getElementById('next-service-dday');
                 if (nameEl) nameEl.textContent = '모든 결제 완료';
                 if (ddayEl) {
                     ddayEl.textContent = '다음 달을 기다리세요';
                     ddayEl.className = 'text-success fw-bold small';
                 }
            }

            if (!calendarEl) return;

            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                locale: 'ko',
                height: 'auto',
                expandRows: true,
                headerToolbar: { 
                    left: 'prev,next',
                    center: 'title',
                    right: 'today' 
                },
                buttonText: { today: '오늘' },
                events: subscriptions,
                dayMaxEvents: true,
                eventColor: accentColor,
                moreLinkText: (num) => `+${num}개`
            });
            calendar.render();

            // Guide Toggle
            const guide = document.getElementById('userGuide');
            const icon = document.getElementById('guideToggleIcon');
            guide.addEventListener('show.bs.collapse', () => icon.classList.replace('bi-chevron-down', 'bi-chevron-up'));
            guide.addEventListener('hide.bs.collapse', () => icon.classList.replace('bi-chevron-up', 'bi-chevron-down'));
        });
    </script>
</body>
</html>