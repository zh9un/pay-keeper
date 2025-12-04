<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pay Keeper - OTT 구독 공유 정산 관리</title>

    <!-- Bootstrap 5 CDN (for grid system & basic utilities) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

    <!-- FullCalendar CDN -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>

    <!-- Custom Redesigned Styles -->
    <link href="/css/custom-style.css" rel="stylesheet">
</head>
<body>
    <div class="container my-5 animate-fade-in-up">
        <!-- Header -->
        <header class="d-flex justify-content-between align-items-center mb-5">
            <div>
                <h1 class="h2 mb-0"><i class="bi bi-cash-coin me-2"></i>Pay Keeper</h1>
                <p class="text-secondary mb-0">OTT 구독 공유 및 정산 관리 시스템</p>
            </div>
            <a href="/write" class="btn btn-primary">
                <i class="bi bi-plus-circle me-1"></i> 새 구독 등록
            </a>
        </header>

        <!-- User Guide (Collapsible) -->
        <div class="card mb-4">
            <div class="card-header" data-bs-toggle="collapse" data-bs-target="#userGuide" aria-expanded="true" aria-controls="userGuide" style="cursor: pointer;">
                <h5 class="mb-0 d-flex justify-content-between align-items-center">
                    <span><i class="bi bi-question-circle-fill me-2"></i>사용 안내</span>
                    <i class="bi bi-chevron-down" id="guideToggleIcon"></i>
                </h5>
            </div>
            <div id="userGuide" class="collapse">
                <div class="card-body small">
                    <p class="text-secondary">Pay Keeper를 활용하여 OTT 구독 공유 및 정산을 쉽게 관리하세요.</p>
                     <div class="row">
                        <div class="col-md-6">
                            <h6 class="fw-bold mt-2">구독 등록</h6>
                            <p>우측 상단 '새 구독 등록' 버튼을 눌러 서비스명, 금액, 파티원(콤마로 구분)을 입력하세요.</p>
                            <h6 class="fw-bold mt-3">입금 관리</h6>
                            <p>파티원 목록에서 아이콘 버튼을 눌러 '미입금' ↔ '완료' 상태를 변경할 수 있습니다.</p>
                        </div>
                        <div class="col-md-6">
                             <h6 class="fw-bold mt-2">수정 및 삭제</h6>
                            <p>각 구독 카드의 우측 상단 아이콘을 통해 정보를 수정하거나 삭제할 수 있습니다.</p>
                            <h6 class="fw-bold mt-3">공유 링크</h6>
                            <p>공유 아이콘을 눌러 링크를 복사하고, 파티원에게 전달하여 입금 현황을 공유하세요 (읽기 전용).</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Dashboard Statistics -->
        <div class="row mb-4 g-4">
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="stat-icon"><i class="bi bi-tv-fill"></i></div>
                        <div class="stat-title">총 구독 수</div>
                        <div class="stat-value">${stats.countSubscriptions}</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="stat-icon"><i class="bi bi-currency-dollar"></i></div>
                        <div class="stat-title">총 월 결제액</div>
                        <div class="stat-value">${stats.sumTotalPrice}</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="stat-icon"><i class="bi bi-people-fill"></i></div>
                        <div class="stat-title">전체 파티원</div>
                        <div class="stat-value">${stats.countAllPartyMembers}</div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="stat-icon"><i class="bi bi-check-circle-fill"></i></div>
                        <div class="stat-title">입금 완료율</div>
                        <div class="stat-value">${String.format("%.0f", stats.paidPercentage)}%</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Calendar View (결제일 달력) -->
        <div class="card mb-4">
            <div class="card-header">
                <h5 class="mb-0"><i class="bi bi-calendar3 me-2"></i>구독 결제 달력</h5>
            </div>
            <div class="card-body">
                <div id="calendar"></div>
            </div>
        </div>

        <!-- Search Form -->
        <div class="card mb-4">
            <div class="card-body">
                <form action="/list" method="get" class="row g-3 align-items-end">
                    <div class="col-md-4">
                        <label class="form-label">검색 조건</label>
                        <div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="searchType" value="service" id="searchService" ${searchType != 'member' ? 'checked' : ''}>
                                <label class="form-check-label" for="searchService">서비스명</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="searchType" value="member" id="searchMember" ${searchType == 'member' ? 'checked' : ''}>
                                <label class="form-check-label" for="searchMember">파티원 이름</label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">검색어</label>
                        <input type="text" class="form-control" name="keyword" placeholder="검색어를 입력하세요" value="${keyword}">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-secondary w-100"><i class="bi bi-search"></i> 검색</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Subscription List -->
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
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <span class="fw-bold"><i class="bi bi-tv me-2"></i>${sub.serviceName}</span>
                                    <div class="btn-group">
                                        <a href="/edit?seq=${sub.seq}" class="btn btn-icon" title="수정"><i class="bi bi-pencil-square"></i></a>
                                        <form id="delete-form-${sub.seq}" action="/delete" method="post" style="display:inline;">
                                            <input type="hidden" name="seq" value="${sub.seq}">
                                            <button type="button" class="btn btn-icon" title="삭제" onclick="confirmDelete(${sub.seq})"><i class="bi bi-trash3"></i></button>
                                        </form>
                                    </div>
                                </div>

                                <div class="card-body">
                                    <div class="d-flex justify-content-between text-secondary mb-3">
                                        <span>총 금액: <strong class="text-dark">${sub.totalPrice}원</strong></span>
                                        <span>결제일: 매월 ${sub.billingDate}일</span>
                                    </div>

                                    <div class="d-flex justify-content-between align-items-center mb-4 p-3 bg-light rounded-3">
                                        <div class="text-nowrap">
                                            <c:if test="${not empty sub.accountNumber}">
                                                 <strong class="small"><i class="bi bi-bank me-1"></i>입금 계좌:</strong> 
                                                 <span class="small text-secondary me-2">${sub.accountNumber}</span>
                                                 <button class="btn btn-icon btn-sm" title="계좌번호 복사" onclick="copyToClipboard('${sub.accountNumber}', '계좌번호가')"><i class="bi bi-clipboard"></i></button>
                                            </c:if>
                                        </div>
                                         <div class="text-nowrap">
                                            <strong class="small"><i class="bi bi-link-45deg me-1"></i>공유 링크:</strong>
                                            <button class="btn btn-icon btn-sm" title="공유 링크 복사" onclick="copyShareLink('${sub.shareUuid}')"><i class="bi bi-share"></i></button>
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
                                                            <td>${member.perPrice}원</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${member.isPaid == 'Y'}">
                                                                        <span class="badge bg-success">완료</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-danger">미입금</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="text-end">
                                                                <button class="btn btn-icon btn-sm" title="상태 변경" onclick="togglePaidStatus(${member.memberSeq}, '${member.isPaid}')"><i class="bi bi-arrow-repeat"></i></button>
                                                                <c:if test="${member.isPaid == 'N'}">
                                                                    <button class="btn btn-icon btn-sm" title="콕 찌르기" onclick="pokeUnpaidMember('${member.memberName}', '${sub.serviceName}', ${member.perPrice}, '${sub.accountNumber}')"><i class="bi bi-bell-fill"></i></button>
                                                                </c:if>
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

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom UI Enhancements -->
    <script src="/js/ui-enhancements.js"></script>

    <script>
        function togglePaidStatus(memberSeq, currentStatus) {
            Loading.show();
            fetch('/togglePaid', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `memberSeq=${memberSeq}&currentStatus=${currentStatus}`
            })
            .then(res => res.json())
            .then(data => {
                Loading.hide();
                if (data.success) {
                    Toast.success('입금 상태가 변경되었습니다.');
                    setTimeout(() => location.reload(), 800);
                } else {
                    Toast.error(data.message || '상태 변경에 실패했습니다.');
                }
            })
            .catch(err => {
                Loading.hide();
                Toast.error('오류가 발생했습니다.');
            });
        }

        function confirmDelete(seq) {
            showConfirmModal('구독 삭제', '정말 삭제하시겠습니까?', () => {
                document.getElementById(`delete-form-${seq}`).submit();
            });
        }
        
        function copyToClipboard(text, subject) {
            navigator.clipboard.writeText(text).then(() => {
                Toast.success(`${subject} 복사되었습니다!`);
            }).catch(() => {
                Toast.error('복사에 실패했습니다.');
            });
        }

        function pokeUnpaidMember(memberName, serviceName, perPrice, accountNumber) {
            const month = new Date().getMonth() + 1;
            let message = `${memberName}님, [${serviceName}] ${month}월 구독료 ${perPrice.toLocaleString()}원 입금 부탁드려요!`;
            if (accountNumber && accountNumber.trim() !== '') {
                message += `\n계좌: ${accountNumber}`;
            }
            copyToClipboard(message, '독촉 메시지가');
        }

        function copyShareLink(uuid) {
            const shareUrl = `${window.location.origin}/share/${uuid}`;
            copyToClipboard(shareUrl, '공유 링크가');
        }

        document.addEventListener('DOMContentLoaded', function() {
            // Calendar
            const calendarEl = document.getElementById('calendar');
            const accentColor = getComputedStyle(document.documentElement).getPropertyValue('--accent-color').trim();
            const subscriptions = [
                <c:forEach items="${subscriptions}" var="sub" varStatus="status">
                {
                    title: '${sub.serviceName}',
                    start: new Date(new Date().getFullYear(), new Date().getMonth(), ${sub.billingDate}).toISOString().split('T')[0]
                }<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];

            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                locale: 'ko',
                height: 'auto',
                headerToolbar: { left: 'prev,next today', center: 'title', right: '' },
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
