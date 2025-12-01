package com.springboot.paykeeper.domain;

/**
 * PartyMemberDO (Data Object)
 * 파티원 정보 및 정산 데이터를 담는 Domain 객체
 *
 * DB Table: party_member
 */
public class PartyMemberDO {

    private Integer memberSeq;    // 파티원 고유 ID (PK, Auto Increment)
    private Integer subSeq;        // 구독 ID (FK -> subscription.seq)
    private String memberName;     // 파티원 이름
    private Integer perPrice;      // 인당 부담 금액 (1/N 계산된 값)
    private String isPaid;         // 입금 여부 ('Y' or 'N')

    // ===========================
    // Constructors
    // ===========================
    public PartyMemberDO() {
    }

    public PartyMemberDO(String memberName, Integer perPrice) {
        this.memberName = memberName;
        this.perPrice = perPrice;
        this.isPaid = "N"; // 기본값: 미입금
    }

    public PartyMemberDO(Integer subSeq, String memberName, Integer perPrice) {
        this.subSeq = subSeq;
        this.memberName = memberName;
        this.perPrice = perPrice;
        this.isPaid = "N";
    }

    // ===========================
    // Getters and Setters
    // ===========================
    public Integer getMemberSeq() {
        return memberSeq;
    }

    public void setMemberSeq(Integer memberSeq) {
        this.memberSeq = memberSeq;
    }

    public Integer getSubSeq() {
        return subSeq;
    }

    public void setSubSeq(Integer subSeq) {
        this.subSeq = subSeq;
    }

    public String getMemberName() {
        return memberName;
    }

    public void setMemberName(String memberName) {
        this.memberName = memberName;
    }

    public Integer getPerPrice() {
        return perPrice;
    }

    public void setPerPrice(Integer perPrice) {
        this.perPrice = perPrice;
    }

    public String getIsPaid() {
        return isPaid;
    }

    public void setIsPaid(String isPaid) {
        this.isPaid = isPaid;
    }

    // ===========================
    // Helper Methods
    // ===========================

    /**
     * 입금 완료 여부 확인
     * @return true if paid, false otherwise
     */
    public boolean isPaidStatus() {
        return "Y".equals(this.isPaid);
    }

    /**
     * 입금 상태를 토글 (Y <-> N)
     */
    public void togglePaidStatus() {
        this.isPaid = "Y".equals(this.isPaid) ? "N" : "Y";
    }

    // ===========================
    // toString (for debugging)
    // ===========================
    @Override
    public String toString() {
        return "PartyMemberDO{" +
                "memberSeq=" + memberSeq +
                ", subSeq=" + subSeq +
                ", memberName='" + memberName + '\'' +
                ", perPrice=" + perPrice +
                ", isPaid='" + isPaid + '\'' +
                '}';
    }
}
