package com.springboot.paykeeper;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * PayKeeperApplication
 * OTT 구독 공유 및 정산 관리 시스템
 *
 * Spring Boot 3.3.5 + MyBatis + JSP + MySQL
 * Architecture: Controller -> Service -> Mapper(XML) -> DB
 *
 * @author Pay Keeper Team
 * @version 1.0.0
 */
@SpringBootApplication
public class PayKeeperApplication {

    public static void main(String[] args) {
        System.out.println("=========================================");
        System.out.println("  Pay Keeper Application Starting...   ");
        System.out.println("  OTT 구독 공유 및 정산 관리 시스템      ");
        System.out.println("=========================================");

        SpringApplication.run(PayKeeperApplication.class, args);

        System.out.println("=========================================");
        System.out.println("  Application Started Successfully!    ");
        System.out.println("  Access: http://localhost:8080        ");
        System.out.println("=========================================");
    }
}
