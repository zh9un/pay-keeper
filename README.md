# Pay Keeper

OTT 구독 공유 및 정산 관리 시스템

---

## 프로젝트 개요

Pay Keeper는 Netflix, YouTube Premium 등의 OTT 서비스를 여러 명이 공유할 때 발생하는 요금 정산을 효율적으로 관리하기 위한 웹 애플리케이션입니다. 총 구독료를 파티원 수로 자동 분할하여 인당 부담 금액을 계산하고, 각 파티원의 입금 상태를 실시간으로 추적할 수 있습니다.

### 개발 목적

- OTT 구독 공유 시 복잡한 정산 과정 자동화
- 파티원별 입금 현황 시각화 및 관리
- 다수의 구독 서비스를 통합 관리
- 동적 검색을 통한 효율적인 정보 조회

---

## 기술 스택

### Backend
- **Framework**: Spring Boot 3.3.5
- **Language**: Java 21
- **ORM**: MyBatis 3.0.3 (XML Mapper 방식)
- **Build Tool**: Maven
- **Database**: MySQL 8.x
- **Connection Pool**: HikariCP

### Frontend
- **Template Engine**: JSP (Jakarta EE)
- **Tag Library**: JSTL 3.0.0
- **UI Framework**: Bootstrap 5.3.0
- **Calendar Library**: FullCalendar 6.1.8
- **Font**: Pretendard (Korean Web Font)
- **AJAX**: Fetch API
- **Clipboard API**: 공유 링크 복사

### Architecture
- **Design Pattern**: MVC (Model-View-Controller)
- **Layered Architecture**: Controller → Service → Mapper → Database
- **Transaction Management**: Spring @Transactional

---

## 시스템 아키텍처

```
┌─────────────┐
│   Browser   │
└──────┬──────┘
       │ HTTP Request/Response
       │
┌──────▼────────────────────────────┐
│     Presentation Layer             │
│  - SubscriptionController.java    │
│  - list.jsp, write.jsp, edit.jsp  │
└──────┬────────────────────────────┘
       │
┌──────▼────────────────────────────┐
│     Business Logic Layer           │
│  - SubscriptionService.java       │
│  - SubscriptionServiceImpl.java   │
│    (1/N 정산 계산 로직)            │
└──────┬────────────────────────────┘
       │
┌──────▼────────────────────────────┐
│     Data Access Layer              │
│  - SubscriptionMapper.java        │
│  - SubscriptionMapper.xml          │
│    (MyBatis SQL Mapping)           │
└──────┬────────────────────────────┘
       │
┌──────▼────────────────────────────┐
│     Database Layer                 │
│  - MySQL 8.x                       │
│  - paykeeper_db                    │
└───────────────────────────────────┘
```

---

## 주요 기능

### 1. 대시보드 통계
- **실시간 통계 카드**: 총 구독 수, 월 결제액 합계, 전체 파티원 수, 입금 완료율
- **시각적 표현**: 입금 완료율 프로그레스 바, 카드형 레이아웃
- **자동 계산**: 데이터베이스 집계 함수 활용 (COUNT, SUM, COALESCE)
- **DashboardStatsDO**: 통계 전용 도메인 객체

### 2. 구독 관리
- 신규 OTT 구독 서비스 등록
- 서비스명, 총 금액, 결제일, 계좌번호 입력
- 파티원 정보 일괄 등록 (콤마 구분)
- 구독 정보 수정 및 삭제 (CASCADE)

### 3. 자동 정산 계산
- 총 구독료를 파티원 수로 자동 분할
- 계산 공식: `인당 부담금 = 총 금액 ÷ 총 인원 수`
- Service 계층에서 비즈니스 로직 처리
- 트랜잭션 보장 (부모-자식 데이터 원자적 저장)

### 4. 입금 상태 관리
- 파티원별 입금 여부 토글 (Y/N)
- AJAX 비동기 처리로 실시간 상태 변경
- 배지 표시: 미입금(빨강), 완료(초록)
- 토스트 알림으로 상태 변경 피드백
- 페이지 새로고침 없이 UI 업데이트

### 5. 동적 검색
- 서비스명 검색 (예: "넷플릭스")
- 파티원 이름 검색 (예: "철수")
- MyBatis 동적 SQL (`<if>` 태그) 활용
- 검색 조건별 쿼리 최적화

### 6. 구독 캘린더 뷰
- **FullCalendar 6.1.8** 라이브러리 통합
- 구독 서비스의 결제일을 달력에 시각화
- 월별 결제 일정 한눈에 확인
- 31일이 없는 달 자동 처리 (예: 2월 28/29일)
- 서버 사이드 렌더링 (JSTL → JavaScript 데이터 변환)
- 반응형 캘린더 뷰 (모바일 대응)

### 7. 게스트 공유 링크
- UUID 기반 고유 공유 링크 자동 생성
- 로그인 없이 구독 현황 조회 가능
- 읽기 전용 뷰 (수정/삭제 불가)
- Clipboard API를 통한 링크 복사
- 총무는 관리, 파티원은 간편 조회 컨셉

### 8. 계좌번호 관리 및 독촉 기능
- 구독별 입금 계좌번호 등록
- 계좌번호 원클릭 복사
- 미입금 파티원 독촉 메시지 자동 생성
- 메시지에 이름, 금액, 계좌번호 포함
- "콕 찌르기" 버튼으로 간편 독촉

### 9. 카카오톡 연동 기능
- **OAuth 2.0 인증**: 카카오 계정 연동
- **나에게 보내기**: 미입금 알림 메시지를 카카오톡으로 전송
- **자동 메시지 생성**: 파티원 이름, 서비스명, 금액, 계좌번호 자동 포함
- **인증 상태 표시**: 버튼 색상으로 연동 상태 확인 가능
- **토큰 관리**: Access Token 자동 갱신 및 세션 관리
- **Fallback 옵션**: 인증 미완료 시 클립보드 복사로 대체

### 10. 카테고리별 필터링
- **5가지 카테고리**: 영상(OTT), 음악, 쇼핑/생활, 업무/유틸, 기타
- **자동 분류**: 서비스명 기반 카테고리 자동 할당
- **실시간 필터링**: 클릭 한 번으로 카테고리별 구독 필터
- **부드러운 애니메이션**: 페이드 인/아웃 효과
- **스크롤 가능한 버튼**: 모바일 환경에서도 편리한 카테고리 선택

### 11. 서비스별 브랜드 아이덴티티
- **자동 로고 표시**: Google Favicon API를 통한 서비스 로고 자동 로드
- **브랜드 컬러 적용**: 넷플릭스(빨강), 유튜브(빨강), 스포티파이(초록) 등 브랜드 컬러 캘린더 적용
- **25개 이상 서비스 지원**: OTT, 음악, AI, 쇼핑 등 주요 구독 서비스 로고 지원
- **Fallback 처리**: 로고 로드 실패 시 기본 아이콘으로 자동 전환

### 12. Apple 스타일 UI/UX
- **Pretendard 폰트**: 한국어 가독성 최적화
- **모노크롬 디자인**: Apple 스타일의 깔끔한 색상 팔레트
- **카드형 레이아웃**: 그림자 효과와 호버 인터랙션
- **토스트 알림**: 작업 성공/실패 시각적 피드백
- **로딩 스피너**: 비동기 작업 진행 상태 표시
- **확인 모달**: 삭제 등 중요 작업 전 확인 다이얼로그
- **반응형 디자인**: PC, 태블릿, 모바일 대응
- **접을 수 있는 사용자 가이드**: 초보자를 위한 상세 설명

---

## 데이터베이스 설계

### ERD 구조

```
┌─────────────────────────────┐
│      subscription           │
├─────────────────────────────┤
│ seq (PK, INT, AUTO_INCREMENT) │
│ service_name (VARCHAR 100)   │
│ total_price (INT)            │
│ billing_date (INT)           │
│ account_number (VARCHAR 100) │
│ share_uuid (VARCHAR 36)      │
│ regdate (TIMESTAMP)          │
└──────────┬──────────────────┘
           │ 1:N
           │
┌──────────▼──────────────────┐
│      party_member           │
├─────────────────────────────┤
│ member_seq (PK, INT, AI)     │
│ sub_seq (FK, INT)            │
│ member_name (VARCHAR 50)     │
│ per_price (INT)              │
│ is_paid (CHAR 1)             │
└─────────────────────────────┘
```

### 테이블 상세

#### subscription (구독 정보)
| 컬럼명 | 타입 | 제약조건 | 설명 |
|--------|------|----------|------|
| seq | INT | PK, AUTO_INCREMENT | 구독 고유 ID |
| service_name | VARCHAR(100) | NOT NULL | 서비스명 |
| total_price | INT | NOT NULL, CHECK > 0 | 총 결제 금액 |
| billing_date | INT | NOT NULL, CHECK 1-31 | 매월 결제일 |
| account_number | VARCHAR(100) | NULL | 입금 계좌번호 |
| share_uuid | VARCHAR(36) | UNIQUE | 공유 링크용 UUID |
| regdate | TIMESTAMP | DEFAULT NOW() | 등록 일시 |

#### party_member (파티원 정보)
| 컬럼명 | 타입 | 제약조건 | 설명 |
|--------|------|----------|------|
| member_seq | INT | PK, AUTO_INCREMENT | 파티원 고유 ID |
| sub_seq | INT | FK, NOT NULL | 구독 ID (외래키) |
| member_name | VARCHAR(50) | NOT NULL | 파티원 이름 |
| per_price | INT | NOT NULL, CHECK >= 0 | 인당 부담 금액 |
| is_paid | CHAR(1) | DEFAULT 'N', CHECK IN('Y','N') | 입금 여부 |

### 제약 조건
- **Foreign Key**: `sub_seq` → `subscription.seq`
- **ON DELETE CASCADE**: 구독 삭제 시 파티원 자동 삭제
- **ON UPDATE CASCADE**: 구독 ID 변경 시 연쇄 업데이트
- **CHECK Constraints**: 데이터 무결성 보장

### 인덱스
- `idx_service_name`: 서비스명 검색 최적화
- `idx_member_name`: 파티원 이름 검색 최적화
- `idx_sub_seq`: 외래키 조인 성능 향상

---

## 프로젝트 구조

```
paykeeper/
├── src/main/java/com/springboot/paykeeper/
│   ├── PayKeeperApplication.java          # Spring Boot 메인 클래스
│   ├── config/
│   │   └── DataInitializer.java           # 샘플 데이터 자동 생성
│   ├── controller/
│   │   └── SubscriptionController.java    # MVC Controller
│   ├── service/
│   │   ├── SubscriptionService.java       # Service 인터페이스
│   │   ├── SubscriptionServiceImpl.java   # Service 구현체 (1/N 계산)
│   │   └── KakaoApiService.java           # 카카오톡 메시지 전송 서비스
│   ├── mapper/
│   │   └── SubscriptionMapper.java        # MyBatis Mapper 인터페이스
│   └── domain/
│       ├── SubscriptionDO.java            # 구독 도메인 객체
│       ├── PartyMemberDO.java             # 파티원 도메인 객체
│       └── DashboardStatsDO.java          # 대시보드 통계 객체
├── src/main/resources/
│   ├── application.properties             # Spring Boot 설정
│   ├── schema.sql                         # 데이터베이스 스키마
│   ├── migration.sql                      # DB 마이그레이션 1 (계좌번호)
│   ├── migration2.sql                     # DB 마이그레이션 2 (공유 링크)
│   └── mapper/
│       └── SubscriptionMapper.xml         # MyBatis SQL 매핑
├── src/main/webapp/
│   ├── views/
│   │   ├── list.jsp                       # 목록/검색/캘린더 화면
│   │   ├── write.jsp                      # 등록 폼 화면
│   │   ├── edit.jsp                       # 수정 폼 화면
│   │   └── guest_view.jsp                 # 게스트 공유 뷰 (읽기 전용)
│   ├── css/
│   │   └── custom-style.css               # Apple 스타일 커스텀 CSS
│   └── js/
│       └── ui-enhancements.js             # UI 인터랙션 (토스트, 로딩, 모달)
├── pom.xml                                # Maven 빌드 설정
└── README.md
```

---

## 핵심 기술 구현

### 1. MyBatis XML Mapper

#### ResultMap을 통한 1:N 관계 매핑
```xml
<resultMap id="SubscriptionWithMembersResultMap" type="SubscriptionDO">
    <id property="seq" column="seq"/>
    <result property="serviceName" column="service_name"/>
    <result property="totalPrice" column="total_price"/>
    <result property="billingDate" column="billing_date"/>
    <result property="accountNumber" column="account_number"/>
    <result property="shareUuid" column="share_uuid"/>
    <result property="regdate" column="regdate"/>

    <!-- 1:N Collection Mapping using nested select -->
    <collection property="members"
                column="seq"
                ofType="PartyMemberDO"
                select="selectPartyMembersForSubscription"/>
</resultMap>
```

#### 동적 SQL (Dynamic SQL)
```xml
<select id="searchSubscriptions" resultMap="SubscriptionWithMembersResultMap">
    SELECT s.*
    FROM subscription s
    <where>
        <if test="searchType == 'service' and keyword != null and keyword != ''">
            s.service_name LIKE CONCAT('%', #{keyword}, '%')
        </if>
        <if test="searchType == 'member' and keyword != null and keyword != ''">
            s.seq IN (
                SELECT DISTINCT pm.sub_seq
                FROM party_member pm
                WHERE pm.member_name LIKE CONCAT('%', #{keyword}, '%')
            )
        </if>
    </where>
    ORDER BY s.seq DESC
</select>
```

#### 배치 삽입 (Batch Insert)
```xml
<insert id="insertPartyMembers" parameterType="list">
    INSERT INTO party_member (sub_seq, member_name, per_price, is_paid)
    VALUES
    <foreach collection="list" item="member" separator=",">
        (#{member.subSeq}, #{member.memberName}, #{member.perPrice}, #{member.isPaid})
    </foreach>
</insert>
```

#### 통계 쿼리
```xml
<!-- 총 월 결제액 합계 조회 -->
<select id="sumTotalPrice" resultType="int">
    SELECT COALESCE(SUM(total_price), 0) FROM subscription
</select>

<!-- 입금 완료 파티원 수 조회 -->
<select id="countPaidPartyMembers" resultType="int">
    SELECT COUNT(*) FROM party_member WHERE is_paid = 'Y'
</select>
```

### 2. Service 계층 비즈니스 로직

```java
@Service
@Transactional
public class SubscriptionServiceImpl implements SubscriptionService {

    // 1/N 정산 계산 로직
    private int calculatePerPrice(int totalPrice, int memberCount) {
        if (memberCount <= 0) {
            throw new IllegalArgumentException("인원 수는 1명 이상이어야 합니다.");
        }
        return totalPrice / memberCount;
    }

    // 트랜잭션 보장: 부모-자식 원자적 저장
    public void createSubscription(SubscriptionDO subscription, String memberNames) {
        // 1. 파티원 이름 파싱
        List<String> nameList = parseMemberNames(memberNames);

        // 2. 1/N 계산
        int totalCount = nameList.size() + 1; // 파티원 + 본인
        int perPrice = calculatePerPrice(subscription.getTotalPrice(), totalCount);

        // 3. 구독 정보 Insert (useGeneratedKeys로 PK 반환)
        subscriptionMapper.insertSubscription(subscription);
        Integer subSeq = subscription.getSeq();

        // 4. 파티원 정보 배치 Insert
        List<PartyMemberDO> members = createMemberList(subSeq, nameList, perPrice);
        subscriptionMapper.insertPartyMembers(members);
    }

    // 대시보드 통계 조회
    @Override
    public DashboardStatsDO getDashboardStats() {
        DashboardStatsDO stats = new DashboardStatsDO();
        stats.setCountSubscriptions(subscriptionMapper.countSubscriptions());
        stats.setSumTotalPrice(subscriptionMapper.sumTotalPrice());
        stats.setCountAllPartyMembers(subscriptionMapper.countAllPartyMembers());
        stats.setCountPaidPartyMembers(subscriptionMapper.countPaidPartyMembers());
        return stats;
    }
}
```

### 3. AJAX 비동기 처리

```javascript
function togglePaidStatus(memberSeq, currentStatus) {
    Loading.show(); // 로딩 스피너 표시

    fetch('/togglePaid', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `memberSeq=${memberSeq}&currentStatus=${currentStatus}`
    })
    .then(res => res.json())
    .then(data => {
        Loading.hide();
        if (data.success) {
            Toast.success('입금 상태가 변경되었습니다');
            setTimeout(() => location.reload(), 800);
        } else {
            Toast.error(data.message);
        }
    })
    .catch(err => {
        Loading.hide();
        Toast.error('상태 변경 중 오류가 발생했습니다');
    });
}
```

### 4. Jakarta EE 표준 준수

#### JSP Taglib (Spring Boot 3.x 호환)
```jsp
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!-- 대시보드 통계 -->
<div class="row">
    <div class="col-md-3">
        <div class="card stat-card">
            <div class="stat-value">${stats.countSubscriptions}</div>
            <div class="stat-title">총 구독 수</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card stat-card">
            <div class="stat-value">${stats.sumTotalPrice}</div>
            <div class="stat-title">총 월 결제액</div>
        </div>
    </div>
</div>

<!-- 구독 목록 -->
<c:forEach items="${subscriptions}" var="sub">
    <div class="card">
        <h5>${sub.serviceName}</h5>
        <p>총 금액: ${sub.totalPrice}원</p>

        <c:forEach items="${sub.members}" var="member">
            <c:choose>
                <c:when test="${member.isPaid == 'Y'}">
                    <span class="badge bg-success">완료</span>
                </c:when>
                <c:otherwise>
                    <span class="badge bg-danger">미입금</span>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </div>
</c:forEach>
```

### 5. FullCalendar 통합

```javascript
// 서버에서 받은 데이터를 FullCalendar 이벤트로 변환
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
    headerToolbar: { left: 'prev,next today', center: 'title', right: '' },
    events: subscriptions,
    eventColor: accentColor
});
calendar.render();
```

---

## 설치 및 실행

### 사전 요구사항
- JDK 21 이상
- Maven 3.6 이상
- MySQL 8.x
- IDE: Spring Tool Suite 4 (또는 IntelliJ IDEA)

### 1. 저장소 클론
```bash
git clone https://github.com/zh9un/pay-keeper.git
cd pay-keeper
```

### 2. 데이터베이스 설정
```sql
# MySQL 접속
mysql -u root -p

# schema.sql 실행
source /path/to/pay-keeper/src/main/resources/schema.sql

# 마이그레이션 실행 (계좌번호 추가)
source /path/to/pay-keeper/src/main/resources/migration.sql

# 마이그레이션 2 실행 (공유 링크 추가)
source /path/to/pay-keeper/src/main/resources/migration2.sql

# 데이터베이스 확인
USE paykeeper_db;
SHOW TABLES;
```

### 3. 보안 설정 파일 생성
민감한 정보(API 키, DB 비밀번호)는 별도 파일로 관리됩니다.

```bash
# 템플릿 파일을 복사하여 실제 설정 파일 생성
cd src/main/resources
cp application-secret.properties.example application-secret.properties
```

`application-secret.properties` 파일을 열어 실제 값으로 변경:
```properties
# Database Password
spring.datasource.password=YOUR_DATABASE_PASSWORD

# Kakao API Configuration
kakao.rest.api.key=YOUR_KAKAO_REST_API_KEY
kakao.redirect.uri=http://localhost:8080/kakao/callback
```

**카카오 API 키 발급 방법:**
1. [카카오 개발자 콘솔](https://developers.kakao.com/console/app) 접속
2. 애플리케이션 추가 또는 선택
3. 앱 키 > REST API 키 복사
4. 플랫폼 설정 > Web > Redirect URI 등록: `http://localhost:8080/kakao/callback`

### 4. Maven 빌드 및 실행
```bash
# 의존성 설치
mvn clean install

# 애플리케이션 실행
mvn spring-boot:run
```

### 5. 브라우저 접속
```
http://localhost:8080
```

### 6. 샘플 데이터 확인
- 애플리케이션 최초 실행 시 DataInitializer가 샘플 데이터를 자동 생성합니다
- 넷플릭스, 유튜브, 멜론 등 10개의 예시 구독 정보가 등록됩니다

---

## API 엔드포인트

### HTTP Methods 및 URL 매핑

| Method | URL | 설명 | 반환 |
|--------|-----|------|------|
| GET | `/` | 메인 페이지 (목록) | list.jsp |
| GET | `/list` | 전체 구독 목록 조회 | list.jsp |
| GET | `/list?searchType={type}&keyword={word}` | 동적 검색 | list.jsp |
| GET | `/write` | 등록 폼 화면 | write.jsp |
| GET | `/edit?seq={id}` | 수정 폼 화면 | edit.jsp |
| POST | `/create` | 구독 등록 처리 | redirect:/list |
| POST | `/update` | 구독 수정 처리 | redirect:/list |
| POST | `/togglePaid` | 입금 상태 토글 (AJAX) | JSON |
| POST | `/delete` | 구독 삭제 | redirect:/list |
| GET | `/detail?seq={id}` | 구독 상세 조회 | detail.jsp |
| GET | `/share/{uuid}` | 게스트 공유 링크 (읽기 전용) | guest_view.jsp |

### 검색 파라미터
- `searchType`: "service" (서비스명) 또는 "member" (파티원 이름)
- `keyword`: 검색어

### AJAX 응답 형식 (togglePaid)
```json
{
    "success": true,
    "newStatus": "Y",
    "message": "입금 상태가 변경되었습니다."
}
```

---

## 주요 특징

### 1. 계층형 아키텍처
- **Controller**: HTTP 요청/응답 처리, 파라미터 바인딩
- **Service**: 비즈니스 로직 구현, 트랜잭션 관리
- **Mapper**: 데이터 접근 추상화, SQL 매핑
- **Domain**: 데이터 전달 객체, 도메인 로직

### 2. 트랜잭션 관리
- `@Transactional` 어노테이션 기반
- 부모(subscription) + 자식(party_member) 원자적 저장
- 롤백 보장 (예외 발생 시 자동 롤백)

### 3. MyBatis 고급 기능
- **ResultMap**: 1:N 관계 자동 매핑
- **Nested Select**: N+1 문제 고려한 설계
- **Dynamic SQL**: 조건부 쿼리 생성
- **Batch Insert**: 여러 행 동시 삽입
- **useGeneratedKeys**: Auto Increment PK 자동 반환

### 4. 데이터 무결성
- Foreign Key Constraint (CASCADE)
- CHECK Constraint (값 범위 제한)
- NOT NULL Constraint (필수 필드)
- Index (검색 성능 최적화)

### 5. 보안 고려사항
- PreparedStatement (SQL Injection 방지)
- 파라미터 바인딩 (`#{}` 사용)
- 입력값 검증 (Service 계층)

### 6. 사용자 경험 최적화
- 토스트 알림으로 즉각적인 피드백
- 로딩 스피너로 비동기 작업 상태 표시
- 확인 모달로 실수 방지
- 반응형 디자인으로 다양한 기기 지원
- 접을 수 있는 사용자 가이드
- Clipboard API로 간편한 복사 기능

---

## 개발 환경

### IDE 및 도구
- Spring Tool Suite 4
- HeidiSQL (MySQL 클라이언트)
- Git Bash
- Postman (API 테스트)

### 버전 관리
- Git 2.x
- GitHub Repository: [pay-keeper](https://github.com/zh9un/pay-keeper)

### 코딩 컨벤션
- Java Naming Convention
- Camel Case (변수, 메서드)
- Pascal Case (클래스)
- Snake Case (데이터베이스 컬럼)

---

## 향후 개선 계획

### 기능 추가
- 사용자 인증 및 권한 관리 (Spring Security)
- 알림 기능 (결제일 리마인더)
- 월별 지출 분석 및 리포트
- 엑셀 다운로드 (Apache POI)
- 파티원별 입금 이력 관리

### 기술 개선
- RESTful API 전환 (JSON 응답)
- React/Vue.js 프론트엔드 분리
- Redis 캐싱 (조회 성능 향상)
- Docker 컨테이너화
- N+1 쿼리 문제 해결 (Batch Fetching)

### 테스트
- JUnit 5 단위 테스트
- Mockito 모킹
- Spring Boot Test 통합 테스트
- Testcontainers (DB 테스트)

---

## 라이선스

본 프로젝트는 교육 목적으로 개발되었습니다.

---

## 개발자

- GitHub: [@zh9un](https://github.com/zh9un)
- Repository: [pay-keeper](https://github.com/zh9un/pay-keeper)

---

## 참고 자료

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [MyBatis Documentation](https://mybatis.org/mybatis-3/)
- [Bootstrap 5 Documentation](https://getbootstrap.com/docs/5.3/)
- [FullCalendar Documentation](https://fullcalendar.io/docs)
- [Jakarta EE Specification](https://jakarta.ee/)
- [Pretendard Font](https://github.com/orioncactus/pretendard)
