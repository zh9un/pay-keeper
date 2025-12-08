package com.springboot.paykeeper.mapper;

import com.springboot.paykeeper.domain.PartyMemberDO;
import com.springboot.paykeeper.domain.SubscriptionDO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * SubscriptionMapper Interface
 * MyBatis Mapper for Subscription and PartyMember operations
 *
 * XML Mapper: resources/mapper/SubscriptionMapper.xml
 */
@Mapper
public interface SubscriptionMapper {

    // ===========================
    // CREATE Operations
    // ===========================

    /**
     * 구독 정보 등록
     * @param subscription 구독 정보 객체
     * @return 삽입된 행 수
     */
    int insertSubscription(SubscriptionDO subscription);

    /**
     * 파티원 일괄 등록 (배치 삽입)
     * @param members 파티원 리스트
     * @return 삽입된 행 수
     */
    int insertPartyMembers(List<PartyMemberDO> members);

    // ===========================
    // READ Operations
    // ===========================

    /**
     * 전체 구독 목록 조회 (파티원 포함)
     * @return 구독 리스트 (1:N 관계 매핑)
     */
    List<SubscriptionDO> selectAll();

    /**
     * 특정 구독 조회 (파티원 포함)
     * @param seq 구독 ID
     * @return 구독 정보
     */
    SubscriptionDO selectOne(Integer seq);

    /**
     * 동적 SQL 검색 (서비스명 or 파티원 이름)
     * @param searchType 검색 타입 ("service" or "member")
     * @param keyword 검색 키워드
     * @return 검색된 구독 리스트
     */
    List<SubscriptionDO> searchSubscriptions(@Param("searchType") String searchType,
                                               @Param("keyword") String keyword);

    /**
     * UUID로 구독 조회 (게스트 공유 링크용)
     * @param uuid 공유 링크 UUID
     * @return 구독 정보 (파티원 포함)
     */
    SubscriptionDO selectByUuid(String uuid);

    // ===========================
    // UPDATE Operations
    // ===========================

    /**
     * 입금 상태 토글 (Y <-> N)
     * @param memberSeq 파티원 ID
     * @param newStatus 새로운 상태 ('Y' or 'N')
     * @return 수정된 행 수
     */
    int updatePaidStatus(@Param("memberSeq") Integer memberSeq,
                         @Param("newStatus") String newStatus);

    /**
     * 파티원 정보 수정
     * @param member 파티원 객체
     * @return 수정된 행 수
     */
    int updatePartyMember(PartyMemberDO member);

    /**
     * 구독 정보 수정
     * @param subscription 구독 객체
     * @return 수정된 행 수
     */
    int updateSubscription(SubscriptionDO subscription);

    /**
     * UUID 업데이트 (기존 데이터 마이그레이션용)
     * @param seq 구독 ID
     * @param uuid 새로운 UUID
     * @return 수정된 행 수
     */
    int updateShareUuid(@Param("seq") Integer seq, @Param("uuid") String uuid);

    // ===========================
    // DELETE Operations
    // ===========================

    /**
     * 구독 삭제 (CASCADE로 파티원도 자동 삭제)
     * @param seq 구독 ID
     * @return 삭제된 행 수
     */
    int deleteSubscription(Integer seq);

    /**
     * 파티원 삭제
     * @param memberSeq 파티원 ID
     * @return 삭제된 행 수
     */
    int deletePartyMember(Integer memberSeq);

    /**
     * 특정 구독의 모든 파티원 삭제 (Update 시 사용)
     * @param subSeq 구독 ID
     * @return 삭제된 행 수
     */
    int deletePartyMembersBySubSeq(Integer subSeq);

    // ===========================
    // UTILITY Operations
    // ===========================

    /**
     * 전체 구독 수 조회
     * @return 구독 수
     */
    int countSubscriptions();

    /**
     * 특정 구독의 파티원 수 조회
     * @param subSeq 구독 ID
     * @return 파티원 수
     */
    int countPartyMembers(Integer subSeq);

    /**
     * 총 월 결제액 합계 조회 (모든 구독의 total_price 합산)
     * @return 총 월 결제액
     */
    int sumTotalPrice();

    /**
     * 전체 파티원 수 조회
     * @return 전체 파티원 수
     */
    int countAllPartyMembers();

    /**
     * 입금 완료 파티원 수 조회 (is_paid = 'Y')
     * @return 입금 완료 파티원 수
     */
    int countPaidPartyMembers();
}
