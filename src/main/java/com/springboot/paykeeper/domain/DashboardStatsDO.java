package com.springboot.paykeeper.domain;

/**
 * DashboardStatsDO (Dashboard Statistics Data Object)
 * 통계 대시보드용 데이터 전송 객체
 */
public class DashboardStatsDO {

    // 총 구독 수
    private Integer countSubscriptions;

    // 총 월 결제액 (모든 구독의 총 금액 합계)
    private Integer sumTotalPrice;

    // 총 파티원 수 (전체 등록된 파티원 수)
    private Integer countAllPartyMembers;

    // 입금 완료 파티원 수 (is_paid = 'Y'인 파티원 수)
    private Integer countPaidPartyMembers;

    // ===========================
    // Constructors
    // ===========================

    public DashboardStatsDO() {
    }

    public DashboardStatsDO(Integer countSubscriptions, Integer sumTotalPrice,
                            Integer countAllPartyMembers, Integer countPaidPartyMembers) {
        this.countSubscriptions = countSubscriptions;
        this.sumTotalPrice = sumTotalPrice;
        this.countAllPartyMembers = countAllPartyMembers;
        this.countPaidPartyMembers = countPaidPartyMembers;
    }

    // ===========================
    // Getters and Setters
    // ===========================

    public Integer getCountSubscriptions() {
        return countSubscriptions;
    }

    public void setCountSubscriptions(Integer countSubscriptions) {
        this.countSubscriptions = countSubscriptions;
    }

    public Integer getSumTotalPrice() {
        return sumTotalPrice;
    }

    public void setSumTotalPrice(Integer sumTotalPrice) {
        this.sumTotalPrice = sumTotalPrice;
    }

    public Integer getCountAllPartyMembers() {
        return countAllPartyMembers;
    }

    public void setCountAllPartyMembers(Integer countAllPartyMembers) {
        this.countAllPartyMembers = countAllPartyMembers;
    }

    public Integer getCountPaidPartyMembers() {
        return countPaidPartyMembers;
    }

    public void setCountPaidPartyMembers(Integer countPaidPartyMembers) {
        this.countPaidPartyMembers = countPaidPartyMembers;
    }

    // ===========================
    // Helper Methods
    // ===========================

    /**
     * 미입금 파티원 수 계산
     * @return 미입금 파티원 수
     */
    public int getCountUnpaidPartyMembers() {
        if (countAllPartyMembers == null || countPaidPartyMembers == null) {
            return 0;
        }
        return countAllPartyMembers - countPaidPartyMembers;
    }

    /**
     * 입금 완료율 계산 (백분율)
     * @return 입금 완료율 (0~100)
     */
    public double getPaidPercentage() {
        if (countAllPartyMembers == null || countAllPartyMembers == 0) {
            return 0.0;
        }
        if (countPaidPartyMembers == null) {
            return 0.0;
        }
        return ((double) countPaidPartyMembers / countAllPartyMembers) * 100;
    }

    // ===========================
    // toString
    // ===========================

    @Override
    public String toString() {
        return "DashboardStatsDO{" +
                "countSubscriptions=" + countSubscriptions +
                ", sumTotalPrice=" + sumTotalPrice +
                ", countAllPartyMembers=" + countAllPartyMembers +
                ", countPaidPartyMembers=" + countPaidPartyMembers +
                ", unpaidMembers=" + getCountUnpaidPartyMembers() +
                ", paidPercentage=" + String.format("%.1f", getPaidPercentage()) + "%" +
                '}';
    }
}
