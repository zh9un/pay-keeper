<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>구독 공유 현황 - Pay Keeper</title>

    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Custom Enhanced Styles -->
    <link href="/css/custom-style.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 30px 0;
        }
        .guest-container {
            max-width: 700px;
            margin: 0 auto;
        }
        .guest-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        .header-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px 15px 0 0;
            text-align: center;
        }
        .info-row {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
        }
        .info-row:last-child {
            border-bottom: none;
        }
    </style>
</head>
<body>
    <div class="guest-container">
        <!-- Guest View Card -->
        <div class="guest-card">
            <!-- Header -->
            <div class="header-section">
                <h2 class="mb-2">
                    <i class="bi bi-tv-fill"></i> ${subscription.serviceName}
                </h2>
                <p class="mb-0">
                    <i class="bi bi-info-circle"></i> 구독 공유 현황
                </p>
            </div>

            <!-- Subscription Info -->
            <div class="p-4">
                <h5 class="border-bottom pb-2 mb-3">
                    <i class="bi bi-card-text"></i> 구독 정보
                </h5>

                <div class="info-row">
                    <div class="row">
                        <div class="col-6">
                            <strong><i class="bi bi-currency-dollar"></i> 총 금액:</strong>
                        </div>
                        <div class="col-6 text-end">
                            <span class="text-primary fs-5 fw-bold">${subscription.totalPrice}원</span>
                        </div>
                    </div>
                </div>

                <div class="info-row">
                    <div class="row">
                        <div class="col-6">
                            <strong><i class="bi bi-calendar3"></i> 결제일:</strong>
                        </div>
                        <div class="col-6 text-end">
                            매월 ${subscription.billingDate}일
                        </div>
                    </div>
                </div>

                <c:if test="${not empty subscription.accountNumber}">
                    <div class="info-row">
                        <div class="row">
                            <div class="col-12">
                                <strong><i class="bi bi-bank"></i> 입금 계좌:</strong>
                                <div class="alert alert-success mt-2 mb-0">
                                    <h6 class="mb-0">${subscription.accountNumber}</h6>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Party Members -->
                <h5 class="border-bottom pb-2 mb-3 mt-4">
                    <i class="bi bi-people-fill"></i> 파티원 현황
                    <span class="badge bg-primary">${subscription.memberCount}명</span>
                </h5>

                <c:choose>
                    <c:when test="${empty subscription.members}">
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i>
                            등록된 파티원이 없습니다.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="table table-hover">
                            <thead class="table-light">
                                <tr>
                                    <th>이름</th>
                                    <th>부담 금액</th>
                                    <th class="text-center">입금 상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${subscription.members}" var="member">
                                    <tr>
                                        <td>
                                            <i class="bi bi-person-circle"></i> ${member.memberName}
                                        </td>
                                        <td>
                                            <strong>${member.perPrice}원</strong>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${member.isPaid == 'Y'}">
                                                    <span class="badge bg-success">
                                                        <i class="bi bi-check-circle-fill"></i> 입금 완료
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">
                                                        <i class="bi bi-x-circle-fill"></i> 미입금
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>

                        <!-- Progress Summary -->
                        <div class="alert alert-light border mt-3">
                            <div class="row text-center">
                                <div class="col-6">
                                    <strong>입금 완료:</strong>
                                    <h4 class="text-success mb-0">${subscription.paidMemberCount}명</h4>
                                </div>
                                <div class="col-6">
                                    <strong>미입금:</strong>
                                    <h4 class="text-danger mb-0">${subscription.unpaidMemberCount}명</h4>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Info Message -->
                <div class="alert alert-info mt-4 mb-0">
                    <i class="bi bi-info-circle-fill"></i>
                    <strong>안내:</strong> 이 페이지는 <strong>읽기 전용</strong> 공유 페이지입니다.
                    입금 상태 변경이나 정보 수정은 총무에게 문의하세요.
                </div>
            </div>
        </div>

        <!-- Footer -->
        <div class="text-center mt-4">
            <p class="text-white">
                <i class="bi bi-shield-check"></i> Pay Keeper - OTT 구독 공유 정산 관리
            </p>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
