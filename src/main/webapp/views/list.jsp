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

    <style>
        .paid-badge { color: #0d6efd; font-weight: bold; }
        .unpaid-badge { color: #dc3545; font-weight: bold; }
        .card-header { background-color: #f8f9fa; font-weight: bold; }
        .member-row:hover { background-color: #f8f9fa; }
    </style>
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
                                    <form action="/delete" method="post" style="display:inline;"
                                          onsubmit="return confirm('정말 삭제하시겠습니까?');">
                                        <input type="hidden" name="seq" value="${sub.seq}">
                                        <button type="submit" class="btn btn-sm btn-danger">
                                            <i class="bi bi-trash"></i> 삭제
                                        </button>
                                    </form>
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
                                                        <th>입금 확인</th>
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
                                                                <button class="btn btn-sm btn-outline-primary"
                                                                        onclick="togglePaidStatus(${member.memberSeq}, '${member.isPaid}')">
                                                                    <i class="bi bi-arrow-repeat"></i> 토글
                                                                </button>
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

    <!-- AJAX: 입금 상태 토글 -->
    <script>
        function togglePaidStatus(memberSeq, currentStatus) {
            console.log('Toggle 요청:', memberSeq, currentStatus);

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

                if (data.success) {
                    // 페이지 새로고침으로 상태 업데이트
                    location.reload();
                } else {
                    alert('오류: ' + data.message);
                }
            })
            .catch(error => {
                console.error('AJAX 오류:', error);
                alert('상태 변경 중 오류가 발생했습니다.');
            });
        }
    </script>
</body>
</html>
