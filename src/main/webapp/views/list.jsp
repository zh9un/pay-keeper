<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pay Keeper - OTT 구독 공유 정산 관리</title>

    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

    <!-- FullCalendar CDN -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>

    <!-- Custom Enhanced Styles -->
    <link href="/css/custom-style.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <!-- Header -->
        <div class="row mb-4">
            <div class="col-md-8">
                <h1><i class="bi bi-cash-coin"></i> Pay Keeper</h1>
                <p class="text-muted">OTT 구독 공유 및 정산 관리 시스템</p>
            </div>
            <div class="col-md-4 text-end">
                <a href="/write" class="btn btn-primary btn-lg">
                    <i class="bi bi-plus-circle"></i> 새 구독 등록
                </a>
            </div>
        </div>

        <!-- User Guide (Collapsible) -->
        <div class="card mb-4 border-info">
            <div class="card-header" data-bs-toggle="collapse" data-bs-target="#userGuide" aria-expanded="true" aria-controls="userGuide">
                <h5 class="mb-0 d-flex justify-content-between align-items-center">
                    <span>
                        <i class="bi bi-question-circle-fill"></i> 사용 안내
                    </span>
                    <i class="bi bi-chevron-down" id="guideToggleIcon"></i>
                </h5>
            </div>
            <div id="userGuide" class="collapse show">
                <div class="card-body">
                    <h6 class="text-info"><i class="bi bi-info-circle"></i> Pay Keeper 사용 방법</h6>
                    <p class="text-muted">OTT 구독 공유 및 정산을 쉽게 관리할 수 있는 시스템입니다.</p>

                    <div class="row">
                        <div class="col-md-6">
                            <h6 class="border-bottom pb-2"><i class="bi bi-1-circle-fill text-primary"></i> 구독 등록하기</h6>
                            <ol class="small">
                                <li>우측 상단 <span class="badge bg-primary">새 구독 등록</span> 버튼 클릭</li>
                                <li>서비스명, 총 금액, 결제일 입력</li>
                                <li>파티원 이름을 <strong>콤마(,)</strong>로 구분하여 입력 (예: 철수,영희,민수)</li>
                                <li>인당 부담 금액이 <strong>자동 계산</strong>됩니다</li>
                                <li>"등록하기" 버튼으로 저장</li>
                            </ol>

                            <h6 class="border-bottom pb-2 mt-3"><i class="bi bi-2-circle-fill text-success"></i> 입금 상태 관리</h6>
                            <ul class="small">
                                <li>각 파티원 옆의 <span class="badge bg-primary">변경</span> 버튼 클릭</li>
                                <li><span class="text-danger">미입금</span> ↔ <span class="text-primary">완료</span> 상태 전환</li>
                                <li>실시간으로 상태가 변경됩니다</li>
                            </ul>
                        </div>

                        <div class="col-md-6">
                            <h6 class="border-bottom pb-2"><i class="bi bi-3-circle-fill text-warning"></i> 구독 수정하기</h6>
                            <ul class="small">
                                <li>구독 카드 우측 상단 <span class="badge bg-warning">수정</span> 버튼 클릭</li>
                                <li>서비스명, 금액, 파티원 정보 수정 가능</li>
                                <li><strong>주의:</strong> 파티원 수정 시 입금 상태 초기화됨</li>
                            </ul>

                            <h6 class="border-bottom pb-2 mt-3"><i class="bi bi-4-circle-fill text-danger"></i> 구독 삭제하기</h6>
                            <ul class="small">
                                <li>구독 카드 우측 상단 <span class="badge bg-danger">삭제</span> 버튼 클릭</li>
                                <li>확인 창에서 "확인" 선택</li>
                                <li>파티원 정보도 함께 삭제됩니다</li>
                            </ul>

                            <h6 class="border-bottom pb-2 mt-3"><i class="bi bi-5-circle-fill text-secondary"></i> 검색 기능</h6>
                            <ul class="small">
                                <li><strong>서비스명</strong> 또는 <strong>파티원 이름</strong>으로 검색 가능</li>
                                <li>검색 조건 선택 후 키워드 입력</li>
                                <li><span class="badge bg-success">검색</span> 버튼 클릭</li>
                            </ul>
                        </div>
                    </div>

                    <div class="alert alert-light border mt-3 mb-0">
                        <i class="bi bi-lightbulb-fill text-warning"></i>
                        <strong>Tip:</strong> 상단 통계 대시보드에서 전체 구독 현황을 한눈에 확인할 수 있습니다.
                    </div>
                </div>
            </div>
        </div>

        <!-- Dashboard Statistics -->
        <div class="row mb-4">
            <div class="col-md-3 mb-3">
                <div class="card border-primary">
                    <div class="card-body text-center">
                        <div class="text-primary mb-2">
                            <i class="bi bi-tv-fill" style="font-size: 2rem;"></i>
                        </div>
                        <h5 class="card-title">총 구독 수</h5>
                        <h2 class="text-primary mb-0"><span class="stat-number">${stats.countSubscriptions}</span>개</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card border-success">
                    <div class="card-body text-center">
                        <div class="text-success mb-2">
                            <i class="bi bi-currency-dollar" style="font-size: 2rem;"></i>
                        </div>
                        <h5 class="card-title">총 월 결제액</h5>
                        <h2 class="text-success mb-0"><span class="stat-number">${stats.sumTotalPrice}</span>원</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card border-info">
                    <div class="card-body text-center">
                        <div class="text-info mb-2">
                            <i class="bi bi-people-fill" style="font-size: 2rem;"></i>
                        </div>
                        <h5 class="card-title">전체 파티원</h5>
                        <h2 class="text-info mb-0"><span class="stat-number">${stats.countAllPartyMembers}</span>명</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3 mb-3">
                <div class="card border-warning">
                    <div class="card-body text-center">
                        <div class="text-warning mb-2">
                            <i class="bi bi-check-circle-fill" style="font-size: 2rem;"></i>
                        </div>
                        <h5 class="card-title">입금 완료</h5>
                        <h2 class="text-warning mb-0"><span class="stat-number">${stats.countPaidPartyMembers}</span>명</h2>
                        <small class="text-muted d-block mb-2">
                            (${String.format("%.1f", stats.paidPercentage)}%)
                        </small>
                        <div class="progress" style="height: 6px;">
                            <div class="progress-bar" role="progressbar"
                                 style="width: ${stats.paidPercentage}%;"
                                 aria-valuenow="${stats.paidPercentage}"
                                 aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Calendar View (결제일 달력) -->
        <div class="card mb-4">
            <div class="card-header bg-white">
                <h5 class="mb-0">
                    <i class="bi bi-calendar3"></i> 구독 결제 달력
                </h5>
            </div>
            <div class="card-body">
                <div id="calendar"></div>
            </div>
        </div>

        <!-- Search Form -->
        <div class="card mb-4">
            <div class="card-body">
                <form action="/list" method="get" class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">검색 조건</label>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="searchType"
                                   value="service" id="searchService"
                                   ${searchType == 'service' ? 'checked' : ''}>
                            <label class="form-check-label" for="searchService">
                                서비스명
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="searchType"
                                   value="member" id="searchMember"
                                   ${searchType == 'member' ? 'checked' : ''}>
                            <label class="form-check-label" for="searchMember">
                                파티원 이름
                            </label>
                        </div>
                    </div>
                    <div class="col-md-7">
                        <label class="form-label">검색어</label>
                        <input type="text" class="form-control" name="keyword"
                               placeholder="검색어를 입력하세요" value="${keyword}">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">&nbsp;</label>
                        <button type="submit" class="btn btn-success w-100">
                            <i class="bi bi-search"></i> 검색
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Subscription List -->
        <c:choose>
            <c:when test="${empty subscriptions}">
                <div class="alert alert-info text-center">
                    <i class="bi bi-info-circle"></i>
                    등록된 구독이 없습니다. 새 구독을 등록해주세요.
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <c:forEach items="${subscriptions}" var="sub">
                        <div class="col-md-6 mb-4">
                            <div class="card shadow-sm">
                                <!-- Card Header: 서비스 정보 -->
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <span>
                                        <i class="bi bi-tv"></i> ${sub.serviceName}
                                    </span>
                                    <div>
                                        <a href="/edit?seq=${sub.seq}" class="btn btn-sm btn-outline-primary me-1">
                                            <i class="bi bi-pencil-square"></i> 수정
                                        </a>
                                        <form id="delete-form-${sub.seq}" action="/delete" method="post" style="display:inline;">
                                            <input type="hidden" name="seq" value="${sub.seq}">
                                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="confirmDelete(${sub.seq})">
                                                <i class="bi bi-trash3"></i> 삭제
                                            </button>
                                        </form>
                                    </div>
                                </div>

                                <!-- Card Body: 가격 및 결제일 -->
                                <div class="card-body">
                                    <div class="row mb-3">
                                        <div class="col-6">
                                            <strong>총 금액:</strong>
                                            <span class="text-primary">${sub.totalPrice}원</span>
                                        </div>
                                        <div class="col-6">
                                            <strong>결제일:</strong> 매월 ${sub.billingDate}일
                                        </div>
                                    </div>

                                    <c:if test="${not empty sub.accountNumber}">
                                        <div class="row mb-3">
                                            <div class="col-12">
                                                <strong><i class="bi bi-bank"></i> 입금 계좌:</strong>
                                                <span class="text-success">${sub.accountNumber}</span>
                                                <button class="btn btn-sm btn-outline-success ms-2"
                                                        onclick="copyAccountNumber('${sub.accountNumber}')">
                                                    <i class="bi bi-clipboard"></i> 복사
                                                </button>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- 공유 링크 -->
                                    <div class="row mb-3">
                                        <div class="col-12">
                                            <strong><i class="bi bi-link-45deg"></i> 공유 링크:</strong>
                                            <button class="btn btn-sm btn-outline-info ms-2"
                                                    onclick="copyShareLink('${sub.shareUuid}')">
                                                <i class="bi bi-share"></i> 링크 복사
                                            </button>
                                            <small class="text-muted d-block mt-1">
                                                파티원과 공유하여 입금 현황을 확인하게 하세요
                                            </small>
                                        </div>
                                    </div>

                                    <!-- 파티원 목록 -->
                                    <h6 class="border-bottom pb-2">
                                        <i class="bi bi-people"></i> 파티원 목록
                                        (${sub.memberCount}명)
                                    </h6>

                                    <c:choose>
                                        <c:when test="${empty sub.members}">
                                            <p class="text-muted">등록된 파티원이 없습니다.</p>
                                        </c:when>
                                        <c:otherwise>
                                            <table class="table table-sm table-hover">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>이름</th>
                                                        <th>부담 금액</th>
                                                        <th>입금 상태</th>
                                                        <th>관리</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${sub.members}" var="member">
                                                        <tr class="member-row">
                                                            <td>${member.memberName}</td>
                                                            <td>${member.perPrice}원</td>
                                                            <td id="status-${member.memberSeq}">
                                                                <c:choose>
                                                                    <c:when test="${member.isPaid == 'Y'}">
                                                                        <span class="paid-badge">
                                                                            <i class="bi bi-check-circle-fill"></i> 완료
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="unpaid-badge">
                                                                            <i class="bi bi-x-circle-fill"></i> 미입금
                                                                        </span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <button class="btn btn-sm btn-outline-primary me-1"
                                                                        onclick="togglePaidStatus(${member.memberSeq}, '${member.isPaid}')">
                                                                    <i class="bi bi-arrow-repeat"></i> 변경
                                                                </button>
                                                                <c:if test="${member.isPaid == 'N'}">
                                                                    <button class="btn btn-sm btn-outline-warning"
                                                                            onclick="pokeUnpaidMember('${member.memberName}', '${sub.serviceName}', ${member.perPrice}, '${sub.accountNumber}')">
                                                                        <i class="bi bi-bell-fill"></i> 콕 찌르기
                                                                    </button>
                                                                </c:if>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Card Footer: 등록일 -->
                                <div class="card-footer text-muted">
                                    <small>
                                        <i class="bi bi-calendar"></i>
                                        등록일: ${sub.regdate}
                                    </small>
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

    <!-- AJAX: 입금 상태 토글 -->
    <script>
        function togglePaidStatus(memberSeq, currentStatus) {
            console.log('Toggle 요청:', memberSeq, currentStatus);

            // 로딩 스피너 표시
            Loading.show();

            // Fetch API로 AJAX 요청
            fetch('/togglePaid', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'memberSeq=' + memberSeq + '&currentStatus=' + currentStatus
            })
            .then(response => response.json())
            .then(data => {
                console.log('서버 응답:', data);
                Loading.hide();

                if (data.success) {
                    // 성공 토스트 표시
                    Toast.success('입금 상태가 변경되었습니다');
                    // 페이지 새로고침으로 상태 업데이트
                    setTimeout(() => location.reload(), 800);
                } else {
                    // 에러 토스트 표시
                    Toast.error(data.message);
                }
            })
            .catch(error => {
                console.error('AJAX 오류:', error);
                Loading.hide();
                Toast.error('상태 변경 중 오류가 발생했습니다');
            });
        }

        // 삭제 확인 모달
        function confirmDelete(seq) {
            showConfirmModal(
                '구독 삭제',
                '정말 삭제하시겠습니까? 파티원 정보도 함께 삭제됩니다.',
                function() {
                    document.getElementById('delete-form-' + seq).submit();
                }
            );
        }

        // 계좌번호 복사 기능
        function copyAccountNumber(accountNumber) {
            navigator.clipboard.writeText(accountNumber).then(function() {
                Toast.success('계좌번호가 복사되었습니다!');
            }).catch(function(err) {
                Toast.error('복사에 실패했습니다');
                console.error('복사 실패:', err);
            });
        }

        // 콕 찌르기 (미입금자 독촉 메시지 복사)
        function pokeUnpaidMember(memberName, serviceName, perPrice, accountNumber) {
            const currentMonth = new Date().getMonth() + 1;
            let message = `${memberName}님, [${serviceName}] ${currentMonth}월 구독료 ${perPrice.toLocaleString()}원 입금 부탁드려요!`;

            if (accountNumber && accountNumber.trim() !== '') {
                message += `\n계좌: ${accountNumber}`;
            }

            navigator.clipboard.writeText(message).then(function() {
                Toast.success('독촉 메시지가 복사되었습니다! 카톡에 붙여넣기 하세요');
            }).catch(function(err) {
                Toast.error('복사에 실패했습니다');
                console.error('복사 실패:', err);
            });
        }

        // 공유 링크 복사 기능
        function copyShareLink(uuid) {
            const shareUrl = window.location.origin + '/share/' + uuid;
            navigator.clipboard.writeText(shareUrl).then(function() {
                Toast.success('공유 링크가 복사되었습니다! 파티원에게 전달하세요');
            }).catch(function(err) {
                Toast.error('복사에 실패했습니다');
                console.error('복사 실패:', err);
            });
        }

        // ===========================
        // FullCalendar 초기화
        // ===========================
        document.addEventListener('DOMContentLoaded', function() {
            const calendarEl = document.getElementById('calendar');

            // JSTL 데이터를 JavaScript 배열로 변환
            const subscriptions = [
                <c:forEach items="${subscriptions}" var="sub" varStatus="status">
                {
                    serviceName: '${sub.serviceName}',
                    billingDate: ${sub.billingDate},
                    totalPrice: ${sub.totalPrice}
                }<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ];

            // 현재 월의 이벤트 생성
            const currentDate = new Date();
            const currentYear = currentDate.getFullYear();
            const currentMonth = currentDate.getMonth(); // 0-based (0 = January)

            const events = [];
            subscriptions.forEach(function(sub) {
                let billingDay = sub.billingDate;

                // 해당 월의 마지막 날짜 확인 (예: 2월은 28/29일, 4월은 30일)
                const lastDayOfMonth = new Date(currentYear, currentMonth + 1, 0).getDate();

                // billingDate가 해당 월의 마지막 날을 초과하면 마지막 날로 조정
                if (billingDay > lastDayOfMonth) {
                    billingDay = lastDayOfMonth;
                }

                // 이벤트 날짜 생성 (YYYY-MM-DD 형식)
                const eventDate = currentYear + '-' +
                                  String(currentMonth + 1).padStart(2, '0') + '-' +
                                  String(billingDay).padStart(2, '0');

                events.push({
                    title: sub.serviceName + ' (' + sub.totalPrice.toLocaleString() + '원)',
                    start: eventDate,
                    backgroundColor: '#0d6efd',
                    borderColor: '#0d6efd',
                    textColor: '#ffffff'
                });
            });

            // FullCalendar 초기화
            const calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                locale: 'ko',
                height: 'auto',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth'
                },
                buttonText: {
                    today: '오늘',
                    month: '월'
                },
                events: events,
                eventTimeFormat: {
                    hour: '2-digit',
                    minute: '2-digit',
                    meridiem: false
                },
                dayMaxEvents: true,
                moreLinkText: function(num) {
                    return '+' + num + '개';
                }
            });

            calendar.render();
        });

        // 사용 안내 펼치기/접기 아이콘 회전
        document.getElementById('userGuide').addEventListener('show.bs.collapse', function () {
            document.getElementById('guideToggleIcon').classList.remove('bi-chevron-down');
            document.getElementById('guideToggleIcon').classList.add('bi-chevron-up');
        });

        document.getElementById('userGuide').addEventListener('hide.bs.collapse', function () {
            document.getElementById('guideToggleIcon').classList.remove('bi-chevron-up');
            document.getElementById('guideToggleIcon').classList.add('bi-chevron-down');
        });
    </script>
</body>
</html>
