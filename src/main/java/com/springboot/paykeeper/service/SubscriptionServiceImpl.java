package com.springboot.paykeeper.service;

import com.springboot.paykeeper.domain.DashboardStatsDO;
import com.springboot.paykeeper.domain.PartyMemberDO;
import com.springboot.paykeeper.domain.SubscriptionDO;
import com.springboot.paykeeper.mapper.SubscriptionMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

/**
 * SubscriptionServiceImpl
 * 비즈니스 로직 구현 (1/N 정산 계산, 트랜잭션 관리)
 */
@Service
public class SubscriptionServiceImpl implements SubscriptionService {

    @Autowired
    private SubscriptionMapper subscriptionMapper;

    // ===========================
    // CREATE Operation (핵심 비즈니스 로직)
    // ===========================

    /**
     * 구독 등록 - 1/N 정산 계산 로직 포함
     * @Transactional: 부모(subscription) + 자식(party_member) 원자적 저장
     */
    @Override
    @Transactional
    public void createSubscription(SubscriptionDO subscription, String memberNames) {
        // 1. 입력값 검증
        validateSubscriptionInput(subscription, memberNames);

        // 2. 파티원 이름 파싱 (콤마로 구분: "철수,영희,민수" -> List)
        List<String> nameList = parseMemberNames(memberNames);

        // 3. 1/N 정산 계산 (핵심 비즈니스 로직)
        // totalPrice를 (파티원 수 + 본인 1명)으로 나눔
        int totalMemberCount = nameList.size() + 1; // 파티원 + 본인
        int perPrice = calculatePerPrice(subscription.getTotalPrice(), totalMemberCount);

        System.out.println("[Service] 1/N 계산: " + subscription.getTotalPrice() +
                " ÷ " + totalMemberCount + " = " + perPrice + "원");

        // 4. 구독 정보 Insert (useGeneratedKeys로 seq 자동 반환)
        subscriptionMapper.insertSubscription(subscription);
        Integer subSeq = subscription.getSeq(); // 생성된 PK 가져오기
        System.out.println("[Service] 구독 등록 완료 - seq: " + subSeq);

        // 5. 파티원 정보 생성 (1/N 계산된 perPrice 적용)
        List<PartyMemberDO> members = new ArrayList<>();
        for (String name : nameList) {
            PartyMemberDO member = new PartyMemberDO();
            member.setSubSeq(subSeq);
            member.setMemberName(name.trim());
            member.setPerPrice(perPrice);
            member.setIsPaid("N"); // 기본값: 미입금
            members.add(member);
        }

        // 6. 파티원 일괄 Insert (배치 삽입)
        if (!members.isEmpty()) {
            subscriptionMapper.insertPartyMembers(members);
            System.out.println("[Service] 파티원 " + members.size() + "명 등록 완료");
        }
    }

    // ===========================
    // READ Operations
    // ===========================

    @Override
    public List<SubscriptionDO> getAllSubscriptions() {
        return subscriptionMapper.selectAll();
    }

    @Override
    public SubscriptionDO getSubscriptionById(Integer seq) {
        return subscriptionMapper.selectOne(seq);
    }

    @Override
    public SubscriptionDO getSubscriptionByUuid(String uuid) {
        return subscriptionMapper.selectByUuid(uuid);
    }

    @Override
    public List<SubscriptionDO> searchSubscriptions(String searchType, String keyword) {
        // 검색 타입이 비어있거나 키워드가 없으면 전체 목록 반환
        if (searchType == null || searchType.isEmpty() ||
            keyword == null || keyword.trim().isEmpty()) {
            return getAllSubscriptions();
        }
        return subscriptionMapper.searchSubscriptions(searchType, keyword.trim());
    }

    // ===========================
    // UPDATE Operations
    // ===========================

    @Override
    @Transactional
    public void togglePaidStatus(Integer memberSeq) {
        // 현재 상태를 조회하여 반대로 변경
        // 간단하게 처리: SQL에서 직접 토글 가능하지만, 여기서는 명시적으로 처리
        // 실제로는 현재 상태를 조회 후 반전시키는 로직이 필요하지만,
        // 여기서는 클라이언트(Controller)에서 새 상태를 전달받도록 수정 가능

        // 임시 구현: Y -> N, N -> Y 토글
        // (실제 구현 시 현재 값을 조회 후 변경)
        subscriptionMapper.updatePaidStatus(memberSeq, "TOGGLE");
    }

    @Override
    @Transactional
    public void updateSubscription(SubscriptionDO subscription, String memberNames) {
        // 1. 입력값 검증 (기존 로직 활용)
        validateSubscriptionInput(subscription, memberNames);

        // 2. 구독 정보(부모) 수정
        subscriptionMapper.updateSubscription(subscription);

        // 3. 기존 파티원 전체 삭제 (초기화)
        subscriptionMapper.deletePartyMembersBySubSeq(subscription.getSeq());
        System.out.println("[Service] 기존 파티원 전체 삭제 완료 - subSeq: " + subscription.getSeq());

        // 4. 새 파티원 목록 생성 및 1/N 계산
        List<String> nameList = parseMemberNames(memberNames);
        int totalMemberCount = nameList.size() + 1; // 본인 포함
        int perPrice = calculatePerPrice(subscription.getTotalPrice(), totalMemberCount);

        System.out.println("[Service] 수정 - 1/N 계산: " + subscription.getTotalPrice() +
                " ÷ " + totalMemberCount + " = " + perPrice + "원");

        // 5. 파티원 객체 생성
        List<PartyMemberDO> members = new ArrayList<>();
        for (String name : nameList) {
            PartyMemberDO member = new PartyMemberDO();
            member.setSubSeq(subscription.getSeq());
            member.setMemberName(name.trim());
            member.setPerPrice(perPrice);
            member.setIsPaid("N"); // 초기화
            members.add(member);
        }

        // 6. 파티원 재등록 (배치 Insert)
        if (!members.isEmpty()) {
            subscriptionMapper.insertPartyMembers(members);
            System.out.println("[Service] 파티원 " + members.size() + "명 재등록 완료");
        }

        System.out.println("[Service] 구독 수정 완료 - seq: " + subscription.getSeq());
    }

    // ===========================
    // DELETE Operations
    // ===========================

    @Override
    @Transactional
    public void deleteSubscription(Integer seq) {
        subscriptionMapper.deleteSubscription(seq);
        System.out.println("[Service] 구독 삭제 완료 - seq: " + seq);
    }

    // ===========================
    // Private Helper Methods
    // ===========================

    /**
     * 1/N 정산 계산 (핵심 비즈니스 로직)
     * @param totalPrice 총 금액
     * @param memberCount 총 인원 수 (본인 포함)
     * @return 인당 부담 금액
     */
    private int calculatePerPrice(int totalPrice, int memberCount) {
        if (memberCount <= 0) {
            throw new IllegalArgumentException("인원 수는 1명 이상이어야 합니다.");
        }
        return totalPrice / memberCount;
    }

    /**
     * 파티원 이름 파싱 (콤마로 구분된 문자열 -> List)
     * @param memberNames "철수,영희,민수"
     * @return ["철수", "영희", "민수"]
     */
    private List<String> parseMemberNames(String memberNames) {
        List<String> nameList = new ArrayList<>();
        if (memberNames != null && !memberNames.trim().isEmpty()) {
            String[] names = memberNames.split(",");
            for (String name : names) {
                if (!name.trim().isEmpty()) {
                    nameList.add(name.trim());
                }
            }
        }
        return nameList;
    }

    /**
     * 입력값 검증
     * @param subscription 구독 정보
     * @param memberNames 파티원 이름들
     */
    private void validateSubscriptionInput(SubscriptionDO subscription, String memberNames) {
        if (subscription == null) {
            throw new IllegalArgumentException("구독 정보가 비어있습니다.");
        }
        if (subscription.getServiceName() == null || subscription.getServiceName().trim().isEmpty()) {
            throw new IllegalArgumentException("서비스명을 입력해주세요.");
        }
        if (subscription.getTotalPrice() == null || subscription.getTotalPrice() <= 0) {
            throw new IllegalArgumentException("총 금액은 0원보다 커야 합니다.");
        }
        if (subscription.getBillingDate() == null ||
            subscription.getBillingDate() < 1 || subscription.getBillingDate() > 31) {
            throw new IllegalArgumentException("결제일은 1~31 사이여야 합니다.");
        }
        if (memberNames == null || memberNames.trim().isEmpty()) {
            throw new IllegalArgumentException("파티원 이름을 입력해주세요.");
        }
    }

    // ===========================
    // STATISTICS Operations
    // ===========================

    /**
     * 대시보드 통계 조회
     * @return 통계 데이터 객체
     */
    @Override
    public DashboardStatsDO getDashboardStats() {
        DashboardStatsDO stats = new DashboardStatsDO();

        // 1. 총 구독 수
        stats.setCountSubscriptions(subscriptionMapper.countSubscriptions());

        // 2. 총 월 결제액
        stats.setSumTotalPrice(subscriptionMapper.sumTotalPrice());

        // 3. 전체 파티원 수
        stats.setCountAllPartyMembers(subscriptionMapper.countAllPartyMembers());

        // 4. 입금 완료 파티원 수
        stats.setCountPaidPartyMembers(subscriptionMapper.countPaidPartyMembers());

        System.out.println("[Service] 통계 조회 완료 - " + stats);

        return stats;
    }
}
