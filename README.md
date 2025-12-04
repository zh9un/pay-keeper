# 페이키퍼 (Pay Keeper) - OTT 구독 공유 및 정산 관리 시스템

페이키퍼(Pay Keeper)는 넷플릭스, 유튜브 프리미엄, 챗GPT 등 다양한 정기 구독 서비스의 요금을 파티원들과 함께 관리하고, 매월 정산 현황을 한눈에 파악할 수 있는 웹 서비스입니다.

---

## 주요 기능

### 1. 직관적인 대시보드
- 구독 현황: 총 구독 수, 월 예상 지출액, 전체 파티원 수, 입금 완료율을 한눈에 확인
- 결제 달력: 매월 결제일을 캘린더 형태로 시각화 (브랜드 컬러 자동 적용)
- 통합 검색: 서비스명 또는 파티원 이름으로 구독 정보 검색

### 2. 간편한 구독 관리
- 2단계 등록 시스템: 카테고리(영상, 음악, 쇼핑, AI) 선택 후 서비스명 자동 완성
- 자동 로고 매핑: 넷플릭스, 멜론, 쿠팡 등 주요 서비스 로고 자동 표시
- 1/N 정산 자동화: 입력된 파티원 수에 따라 인당 부담 금액 자동 계산 (실시간 미리보기 지원)

### 3. 입금 관리 및 알림
- 입금 상태 토글: 클릭 한 번으로 '미입금' - '완료' 상태 변경
- 콕 찌르기: 미입금 파티원에게 보낼 독촉 메시지("OO님, 넷플릭스 입금일입니다!") 자동 생성 및 복사
- 계좌번호 복사: 등록된 계좌번호를 원클릭으로 복사하여 공유 가능

### 4. 모던한 UI/UX
- Apple 스타일 디자인: 깔끔하고 세련된 카드형 레이아웃과 부드러운 인터랙션
- 반응형 웹: PC 및 모바일 환경 최적화
- 다크 모드 대비: 가독성 높은 폰트와 컬러 팔레트 적용

---

## 기술 스택

- Backend: Java 17, Spring Boot 3.x, MyBatis
- Frontend: JSP, JavaScript (ES6+), Bootstrap 5, FullCalendar v6
- Database: MySQL (or H2/MariaDB for testing)
- Tools: Maven, Git

---

## 시작하기 (Getting Started)

### 1. 요구 사항
- Java JDK 17 이상
- Maven 3.x

### 2. 실행 방법
```bash
# 프로젝트 클론
git clone https://github.com/your-repo/paykeeper.git

# 디렉토리 이동
cd paykeeper

# 애플리케이션 실행
./mvnw spring-boot:run
```

### 3. 초기 데이터 (자동 생성)
- 애플리케이션 최초 실행 시, 데이터가 적다면(5개 미만) 샘플 데이터 10개가 자동으로 생성됩니다.
- 넷플릭스, 유튜브, 멜론, 쿠팡 와우, ChatGPT Plus 등 다양한 예시 데이터를 바로 확인해볼 수 있습니다.

---

## 프로젝트 구조

```
src/main/java/com/springboot/paykeeper
├── config          # 설정 파일 (DataInitializer 등)
├── controller      # 웹 요청 처리 (SubscriptionController)
├── domain          # 도메인 모델 (VO/DTO)
├── mapper          # MyBatis 매퍼 인터페이스
└── service         # 비즈니스 로직 처리
```

---

## 라이선스
This project is licensed under the MIT License.
