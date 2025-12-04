package com.springboot.paykeeper.controller;

import com.springboot.paykeeper.domain.PartyMemberDO;
import com.springboot.paykeeper.domain.SubscriptionDO;
import com.springboot.paykeeper.mapper.SubscriptionMapper;
import com.springboot.paykeeper.service.SubscriptionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * SubscriptionController
 * Controller -> Service -> Mapper 계층 구조
 */
@Controller
@RequestMapping("/")
public class SubscriptionController {

    @Autowired
    private SubscriptionService subscriptionService;

    @Autowired
    private SubscriptionMapper subscriptionMapper;

    // ===========================
    // READ - 목록 조회 및 검색
    // ===========================

    /**
     * 메인 페이지: 구독 목록 조회 (검색 포함)
     * GET /list
     * GET /list?searchType=service&keyword=넷플릭스
     */
    @GetMapping({"/", "/list"})
    public String listSubscriptions(
            @RequestParam(value = "searchType", required = false) String searchType,
            @RequestParam(value = "keyword", required = false) String keyword,
            Model model) {

        System.out.println("[Controller] GET /list - searchType: " + searchType + ", keyword: " + keyword);

        List<SubscriptionDO> subscriptions;

        // 검색 조건이 있으면 검색, 없으면 전체 목록
        if (searchType != null && !searchType.isEmpty() &&
            keyword != null && !keyword.isEmpty()) {
            subscriptions = subscriptionService.searchSubscriptions(searchType, keyword);
            model.addAttribute("searchType", searchType);
            model.addAttribute("keyword", keyword);
        } else {
            subscriptions = subscriptionService.getAllSubscriptions();
        }

        // 대시보드 통계 데이터 추가
        model.addAttribute("stats", subscriptionService.getDashboardStats());

        model.addAttribute("subscriptions", subscriptions);
        return "list"; // /views/list.jsp
    }

    // ===========================
    // CREATE - 구독 등록
    // ===========================

    /**
     * 등록 폼 화면
     * GET /write
     */
    @GetMapping("/write")
    public String writeForm() {
        System.out.println("[Controller] GET /write - 등록 폼");
        return "write"; // /views/write.jsp
    }

    /**
     * 구독 등록 처리 (Service의 1/N 계산 로직 호출)
     * POST /create
     */
    @PostMapping("/create")
    public String createSubscription(
            @RequestParam("serviceName") String serviceName,
            @RequestParam("totalPrice") Integer totalPrice,
            @RequestParam("billingDate") Integer billingDate,
            @RequestParam("memberNames") String memberNames,
            Model model) {

        System.out.println("[Controller] POST /create - serviceName: " + serviceName +
                ", totalPrice: " + totalPrice + ", billingDate: " + billingDate +
                ", memberNames: " + memberNames);

        try {
            // SubscriptionDO 객체 생성
            SubscriptionDO subscription = new SubscriptionDO();
            subscription.setServiceName(serviceName);
            subscription.setTotalPrice(totalPrice);
            subscription.setBillingDate(billingDate);

            // Service 호출 (1/N 계산 + 트랜잭션 처리)
            subscriptionService.createSubscription(subscription, memberNames);

            // 성공 시 목록 페이지로 리다이렉트
            return "redirect:/list";

        } catch (IllegalArgumentException e) {
            // 유효성 검증 실패 시 에러 메시지와 함께 폼으로 돌아감
            model.addAttribute("error", e.getMessage());
            return "write";

        } catch (Exception e) {
            // 기타 예외 처리
            model.addAttribute("error", "구독 등록 중 오류가 발생했습니다: " + e.getMessage());
            return "write";
        }
    }

    // ===========================
    // UPDATE - 구독 정보 수정
    // ===========================

    /**
     * 수정 폼 화면
     * GET /edit?seq=1
     */
    @GetMapping("/edit")
    public String editForm(@RequestParam("seq") Integer seq, Model model) {
        System.out.println("[Controller] GET /edit - seq: " + seq);

        // 1. 기존 데이터 조회
        SubscriptionDO subscription = subscriptionService.getSubscriptionById(seq);

        // 2. 파티원 리스트를 콤마 문자열로 변환 (View용)
        String memberNamesStr = subscription.getMembers().stream()
                .map(PartyMemberDO::getMemberName)
                .collect(Collectors.joining(","));

        model.addAttribute("subscription", subscription);
        model.addAttribute("memberNamesStr", memberNamesStr);

        return "edit"; // /views/edit.jsp
    }

    /**
     * 구독 수정 처리
     * POST /update
     */
    @PostMapping("/update")
    public String updateSubscription(
            @RequestParam("seq") Integer seq,
            @RequestParam("serviceName") String serviceName,
            @RequestParam("totalPrice") Integer totalPrice,
            @RequestParam("billingDate") Integer billingDate,
            @RequestParam("memberNames") String memberNames,
            Model model) {

        System.out.println("[Controller] POST /update - seq: " + seq +
                ", serviceName: " + serviceName + ", totalPrice: " + totalPrice +
                ", billingDate: " + billingDate + ", memberNames: " + memberNames);

        try {
            SubscriptionDO subscription = new SubscriptionDO();
            subscription.setSeq(seq);
            subscription.setServiceName(serviceName);
            subscription.setTotalPrice(totalPrice);
            subscription.setBillingDate(billingDate);

            subscriptionService.updateSubscription(subscription, memberNames);

            return "redirect:/list";

        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("subscription", subscriptionService.getSubscriptionById(seq));
            return "edit";

        } catch (Exception e) {
            model.addAttribute("error", "구독 수정 중 오류가 발생했습니다: " + e.getMessage());
            model.addAttribute("subscription", subscriptionService.getSubscriptionById(seq));
            return "edit";
        }
    }

    // ===========================
    // UPDATE - 입금 상태 토글 (AJAX)
    // ===========================

    /**
     * 입금 상태 토글 (Y <-> N)
     * POST /togglePaid
     * AJAX 요청으로 JSON 응답 반환
     */
    @PostMapping("/togglePaid")
    @ResponseBody
    public Map<String, Object> togglePaidStatus(@RequestParam("memberSeq") Integer memberSeq,
                                                  @RequestParam("currentStatus") String currentStatus) {

        System.out.println("[Controller] POST /togglePaid - memberSeq: " + memberSeq +
                ", currentStatus: " + currentStatus);

        Map<String, Object> response = new HashMap<>();

        try {
            // 현재 상태의 반대로 변경
            String newStatus = "Y".equals(currentStatus) ? "N" : "Y";

            // Mapper를 직접 호출하여 상태 변경
            subscriptionMapper.updatePaidStatus(memberSeq, newStatus);

            response.put("success", true);
            response.put("newStatus", newStatus);
            response.put("message", "입금 상태가 변경되었습니다.");

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "상태 변경 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    // ===========================
    // DELETE - 구독 삭제
    // ===========================

    /**
     * 구독 삭제 (CASCADE로 파티원도 자동 삭제)
     * POST /delete
     */
    @PostMapping("/delete")
    public String deleteSubscription(@RequestParam("seq") Integer seq) {

        System.out.println("[Controller] POST /delete - seq: " + seq);

        try {
            subscriptionService.deleteSubscription(seq);
            return "redirect:/list";

        } catch (Exception e) {
            System.err.println("삭제 중 오류: " + e.getMessage());
            return "redirect:/list?error=delete_failed";
        }
    }

    // ===========================
    // Detail View (Optional)
    // ===========================

    /**
     * 특정 구독 상세 조회 (선택사항)
     * GET /detail?seq=1
     */
    @GetMapping("/detail")
    public String detailSubscription(@RequestParam("seq") Integer seq, Model model) {

        System.out.println("[Controller] GET /detail - seq: " + seq);

        SubscriptionDO subscription = subscriptionService.getSubscriptionById(seq);
        model.addAttribute("subscription", subscription);

        return "detail"; // /views/detail.jsp (필요 시 생성)
    }
}
