package com.springboot.paykeeper.config;

import com.springboot.paykeeper.domain.SubscriptionDO;
import com.springboot.paykeeper.service.SubscriptionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
// @Profile("dev") // 개발 환경에서만 실행하고 싶다면 주석 해제
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private SubscriptionService subscriptionService;

    @Override
    public void run(String... args) throws Exception {
        // 데이터가 적을 때만 추가 (5개 미만이면 샘플 추가)
        if (subscriptionService.getAllSubscriptions().size() >= 5) {
            System.out.println("[DataInitializer] 데이터가 충분하여 샘플 데이터 생성을 건너뜁니다.");
            return;
        }

        System.out.println("[DataInitializer] 샘플 데이터 10개 생성 시작...");

        // 1. 넷플릭스 (영상)
        createSample("Netflix", 17000, 1, "3333-01-1234567", "철수,영희,민수");

        // 2. 유튜브 프리미엄 (영상)
        createSample("Youtube Premium", 14900, 15, "110-123-456789", "지수,현우");

        // 3. 멜론 (음악)
        createSample("Melon", 10900, 5, "1002-123-456789", "나연");

        // 4. 쿠팡 와우 (쇼핑)
        createSample("Coupang Wow", 7890, 10, "3333-09-888777", "어머니,동생");

        // 5. ChatGPT Plus (AI)
        createSample("ChatGPT Plus", 29000, 20, "3333-02-9876543", "팀장님,박대리,최사원");

        // 6. 티빙 (영상)
        createSample("Tving", 13900, 25, "123-456-789012", "준호,세정,민지");

        // 7. 디즈니+ (영상)
        createSample("Disney+", 9900, 12, "110-222-333444", "친구1,친구2");

        // 8. 스포티파이 (음악)
        createSample("Spotify", 11990, 3, "356-1234-5678-90", "밴드멤버1,밴드멤버2,밴드멤버3");

        // 9. 네이버 플러스 (쇼핑)
        createSample("Naver Plus", 4900, 1, "1002-555-666777", "가족공유");

        // 10. 노션 (업무/AI)
        createSample("Notion Plus", 15000, 1, "3333-05-1112223", "스터디원1,스터디원2,스터디원3");

        System.out.println("[DataInitializer] 샘플 데이터 생성 완료!");
    }

    private void createSample(String name, int price, int day, String account, String members) {
        try {
            SubscriptionDO sub = new SubscriptionDO();
            sub.setServiceName(name);
            sub.setTotalPrice(price);
            sub.setBillingDate(day);
            sub.setAccountNumber(account);
            
            subscriptionService.createSubscription(sub, members);
        } catch (Exception e) {
            System.err.println("샘플 데이터 생성 실패 (" + name + "): " + e.getMessage());
        }
    }
}
