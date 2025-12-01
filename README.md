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
- **AJAX**: Fetch API

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
│  - list.jsp, write.jsp             │
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

### 1. 구독 관리
- 신규 OTT 구독 서비스 등록
- 서비스명, 총 금액, 결제일 입력
- 파티원 정보 일괄 등록 (콤마 구분)
- 구독 정보 수정 및 삭제 (CASCADE)

### 2. 자동 정산 계산
- 총 구독료를 파티원 수로 자동 분할
- 계산 공식: `인당 부담금 = 총 금액 ÷ 총 인원 수`
- Service 계층에서 비즈니스 로직 처리
- 트랜잭션 보장 (부모-자식 데이터 원자적 저장)

### 3. 입금 상태 관리
- 파티원별 입금 여부 토글 (Y/N)
- AJAX 비동기 처리로 실시간 상태 변경
- 색상 구분: 미입금(빨강), 완료(파랑)
- 페이지 새로고침 없이 UI 업데이트

### 4. 동적 검색
- 서비스명 검색 (예: "넷플릭스")
- 파티원 이름 검색 (예: "철수")
- MyBatis 동적 SQL (`<if>` 태그) 활용
- 검색 조건별 쿼리 최적화

### 5. 데이터 시각화
- Bootstrap 5 Card 레이아웃
- 반응형 디자인 (모바일 대응)
- 입금 현황 배지 표시
- 구독별 파티원 목록 테이블

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
│   ├── controller/
│   │   └── SubscriptionController.java    # MVC Controller
│   ├── service/
│   │   ├── SubscriptionService.java       # Service 인터페이스
│   │   └── SubscriptionServiceImpl.java   # Service 구현체 (1/N 계산)
│   ├── mapper/
│   │   └── SubscriptionMapper.java        # MyBatis Mapper 인터페이스
│   └── domain/
│       ├── SubscriptionDO.java            # 구독 도메인 객체
│       └── PartyMemberDO.java             # 파티원 도메인 객체
├── src/main/resources/
│   ├── application.properties             # Spring Boot 설정
│   ├── schema.sql                         # 데이터베이스 스키마
│   └── mapper/
│       └── SubscriptionMapper.xml         # MyBatis SQL 매핑
├── src/main/webapp/views/
│   ├── list.jsp                           # 목록/검색 화면
│   └── write.jsp                          # 등록 폼 화면
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
    <result property="regdate" column="regdate"/>

    <!-- 1:N Collection Mapping -->
    <collection property="members" ofType="PartyMemberDO" resultMap="PartyMemberResultMap"/>
</resultMap>
```

#### 동적 SQL (Dynamic SQL)
```xml
<select id="searchSubscriptions" resultMap="SubscriptionWithMembersResultMap">
    SELECT * FROM subscription s
    LEFT JOIN party_member pm ON s.seq = pm.sub_seq
    <where>
        <if test="searchType == 'service' and keyword != null">
            s.service_name LIKE CONCAT('%', #{keyword}, '%')
        </if>
        <if test="searchType == 'member' and keyword != null">
            pm.member_name LIKE CONCAT('%', #{keyword}, '%')
        </if>
    </where>
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
}
```

### 3. AJAX 비동기 처리

```javascript
function togglePaidStatus(memberSeq, currentStatus) {
    fetch('/togglePaid', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'memberSeq=' + memberSeq + '&currentStatus=' + currentStatus
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            location.reload(); // 상태 업데이트 후 새로고침
        } else {
            alert('오류: ' + data.message);
        }
    });
}
```

### 4. Jakarta EE 표준 준수

#### JSP Taglib (Spring Boot 3.x 호환)
```jsp
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:forEach items="${subscriptions}" var="sub">
    <div class="card">
        <h5>${sub.serviceName}</h5>
        <p>총 금액: ${sub.totalPrice}원</p>

        <c:forEach items="${sub.members}" var="member">
            <span class="${member.isPaid == 'Y' ? 'paid-badge' : 'unpaid-badge'}">
                ${member.memberName}: ${member.perPrice}원
            </span>
        </c:forEach>
    </div>
</c:forEach>
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

# 데이터베이스 확인
USE paykeeper_db;
SHOW TABLES;
```

### 3. application.properties 설정
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/paykeeper_db
spring.datasource.username=root
spring.datasource.password=YOUR_PASSWORD
```

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

---

## API 엔드포인트

### HTTP Methods 및 URL 매핑

| Method | URL | 설명 | 반환 |
|--------|-----|------|------|
| GET | `/` | 메인 페이지 (목록) | list.jsp |
| GET | `/list` | 전체 구독 목록 조회 | list.jsp |
| GET | `/list?searchType={type}&keyword={word}` | 동적 검색 | list.jsp |
| GET | `/write` | 등록 폼 화면 | write.jsp |
| POST | `/create` | 구독 등록 처리 | redirect:/list |
| POST | `/togglePaid` | 입금 상태 토글 (AJAX) | JSON |
| POST | `/delete?seq={id}` | 구독 삭제 | redirect:/list |
| GET | `/detail?seq={id}` | 구독 상세 조회 | detail.jsp |

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

---

## 개발 환경

### IDE 및 도구
- Spring Tool Suite 4
- HeidiSQL (MySQL 클라이언트)
- Git Bash
- Postman (API 테스트)

### 버전 관리
- Git 2.x
- GitHub Repository

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
- 통계 및 리포트 (월별 지출 분석)
- 엑셀 다운로드 (Apache POI)

### 기술 개선
- RESTful API 전환 (JSON 응답)
- React/Vue.js 프론트엔드 분리
- Redis 캐싱 (조회 성능 향상)
- Docker 컨테이너화

### 테스트
- JUnit 5 단위 테스트
- Mockito 모킹
- Spring Boot Test 통합 테스트

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
- [Jakarta EE Specification](https://jakarta.ee/)
