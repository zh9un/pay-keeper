package com.springboot.paykeeper.service;

import com.springboot.paykeeper.domain.DashboardStatsDO;
import com.springboot.paykeeper.domain.SubscriptionDO;

import java.util.List;

/**
 * SubscriptionService Interface
 * 비즈니스 로직 처리를 위한 Service 계층 인터페이스
 */
public interface SubscriptionService {

    /**
     * 구독 등록 (1/N 계산 로직 포함, 트랜잭션)
     * @param subscription 구독 정보
     * @param memberNames 파티원 이름들 (콤마로 구분된 문자열: "철수,영희,민수")
     * @throws IllegalArgumentException 유효하지 않은 입력값
     */
    void createSubscription(SubscriptionDO subscription, String memberNames);

    /**
     * 전체 구독 목록 조회
     * @return 구독 리스트 (파티원 포함)
     */
    List<SubscriptionDO> getAllSubscriptions();

    /**
     * 특정 구독 조회
     * @param seq 구독 ID
     * @return 구독 정보
     */
    SubscriptionDO getSubscriptionById(Integer seq);

    /**
     * 동적 검색 (서비스명 or 파티원 이름)
     * @param searchType 검색 타입 ("service" or "member")
     * @param keyword 검색 키워드
     * @return 검색된 구독 리스트
     */
    List<SubscriptionDO> searchSubscriptions(String searchType, String keyword);

    /**
     * 입금 상태 토글 (Y <-> N)
     * @param memberSeq 파티원 ID
     */
    void togglePaidStatus(Integer memberSeq);

    /**
     * 구독 삭제 (CASCADE로 파티원도 자동 삭제)
     * @param seq 구독 ID
     */
    void deleteSubscription(Integer seq);

    /**
     * 구독 정보 수정
     * @param subscription 수정할 구독 정보
     * @param memberNames 수정할 파티원 이름들
     */
    void updateSubscription(SubscriptionDO subscription, String memberNames);

    /**
     * 대시보드 통계 조회
     * @return 통계 데이터 (구독 수, 총 결제액, 파티원 수, 입금 완료 수)
     */
    DashboardStatsDO getDashboardStats();
}
