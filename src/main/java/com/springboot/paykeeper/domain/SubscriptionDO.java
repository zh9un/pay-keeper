package com.springboot.paykeeper.domain;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * SubscriptionDO (Data Object)
 * OTT 구독 정보를 담는 Domain 객체
 *
 * DB Table: subscription
 * Relationship: 1:N with PartyMemberDO
 */
public class SubscriptionDO {

    private Integer seq;              // 구독 고유 ID (PK, Auto Increment)
    private String serviceName;       // 서비스명 (예: 넷플릭스, 유튜브)
    private Integer totalPrice;       // 월 총 결제 금액
    private Integer billingDate;      // 결제일 (1~31)
    private String accountNumber;     // 입금 계좌번호 (예: 카카오뱅크 3333-xx-xxxx)
    private String shareUuid;         // 공유 링크용 UUID
    private Timestamp regdate;        // 등록일시

    // 1:N Relationship - 파티원 목록
    private List<PartyMemberDO> members;

    // ===========================
    // Constructors
    // ===========================
    public SubscriptionDO() {
        this.members = new ArrayList<>();
    }

    public SubscriptionDO(String serviceName, Integer totalPrice, Integer billingDate) {
        this.serviceName = serviceName;
        this.totalPrice = totalPrice;
        this.billingDate = billingDate;
        this.members = new ArrayList<>();
    }

    // ===========================
    // Getters and Setters
    // ===========================
    public Integer getSeq() {
        return seq;
    }

    public void setSeq(Integer seq) {
        this.seq = seq;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public Integer getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(Integer totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Integer getBillingDate() {
        return billingDate;
    }

    public void setBillingDate(Integer billingDate) {
        this.billingDate = billingDate;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    public String getShareUuid() {
        return shareUuid;
    }

    public void setShareUuid(String shareUuid) {
        this.shareUuid = shareUuid;
    }

    public Timestamp getRegdate() {
        return regdate;
    }

    public void setRegdate(Timestamp regdate) {
        this.regdate = regdate;
    }

    public List<PartyMemberDO> getMembers() {
        return members;
    }

    public void setMembers(List<PartyMemberDO> members) {
        this.members = members;
    }

    // ===========================
    // Helper Methods
    // ===========================

    /**
     * 파티원 추가
     * @param member 파티원 객체
     */
    public void addMember(PartyMemberDO member) {
        if (this.members == null) {
            this.members = new ArrayList<>();
        }
        this.members.add(member);
    }

    /**
     * 파티원 수 반환 (본인 제외)
     * @return 파티원 수
     */
    public int getMemberCount() {
        return this.members != null ? this.members.size() : 0;
    }

    /**
     * 총 인원 수 반환 (본인 포함)
     * @return 총 인원 수
     */
    public int getTotalMemberCount() {
        return getMemberCount() + 1; // 본인 포함
    }

    /**
     * 입금 완료한 파티원 수
     * @return 입금 완료 파티원 수
     */
    public long getPaidMemberCount() {
        if (this.members == null) return 0;
        return this.members.stream()
                .filter(member -> "Y".equals(member.getIsPaid()))
                .count();
    }

    /**
     * 미입금 파티원 수
     * @return 미입금 파티원 수
     */
    public long getUnpaidMemberCount() {
        if (this.members == null) return 0;
        return this.members.stream()
                .filter(member -> "N".equals(member.getIsPaid()))
                .count();
    }

    /**
     * 전체 입금 완료 여부
     * @return true if all paid, false otherwise
     */
    public boolean isAllPaid() {
        if (this.members == null || this.members.isEmpty()) return false;
        return this.members.stream()
                .allMatch(member -> "Y".equals(member.getIsPaid()));
    }

    // ===========================
    // toString (for debugging)
    // ===========================
    @Override
    public String toString() {
        return "SubscriptionDO{" +
                "seq=" + seq +
                ", serviceName='" + serviceName + '\'' +
                ", totalPrice=" + totalPrice +
                ", billingDate=" + billingDate +
                ", accountNumber='" + accountNumber + '\'' +
                ", shareUuid='" + shareUuid + '\'' +
                ", regdate=" + regdate +
                ", membersCount=" + getMemberCount() +
                '}';
    }
}
