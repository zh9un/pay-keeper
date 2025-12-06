package com.springboot.paykeeper.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import jakarta.annotation.PostConstruct;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.stream.Collectors;

@Service
public class KakaoApiService {

    @Value("${kakao.rest.api.key}")
    private String kakaoRestApiKey;

    @Value("${kakao.redirect.uri}")
    private String kakaoRedirectUri;
    
    private final String KAKAO_AUTH_URL = "https://kauth.kakao.com";
    private final String KAKAO_API_URL = "https://kapi.kakao.com";

    private final ObjectMapper objectMapper = new ObjectMapper();
    
    // 메모리에 토큰 저장 (운영 환경에서는 DB 권장)
    private String currentAccessToken;

    // 초기화 시 값 확인 (디버깅용)
    @PostConstruct
    public void init() {
        System.out.println("[KakaoApiService] Initialized with:");
        System.out.println("  kakao.rest.api.key = " + (kakaoRestApiKey != null ? kakaoRestApiKey : "NULL"));
        System.out.println("  kakao.redirect.uri = " + (kakaoRedirectUri != null ? kakaoRedirectUri : "NULL"));
    }

    /**
     * 1. 인가 코드로 액세스 토큰 요청
     */
    public String getAccessToken(String code) {
        System.out.println("[KakaoApiService] getAccessToken 호출됨, code: " + code);
        try {
            String reqUrl = KAKAO_AUTH_URL + "/oauth/token";
            String params = "grant_type=authorization_code" +
                    "&client_id=" + kakaoRestApiKey +
                    "&redirect_uri=" + kakaoRedirectUri +
                    "&code=" + code;

            String response = sendPostRequest(reqUrl, params, null);
            
            JsonNode rootNode = objectMapper.readTree(response);
            if (rootNode.has("access_token")) {
                String accessToken = rootNode.get("access_token").asText();
                this.currentAccessToken = accessToken;
                System.out.println("[KakaoApiService] Access Token 발급 성공: " + accessToken);
                return accessToken;
            } else {
                System.err.println("[KakaoApiService] 토큰 발급 실패: " + response);
                return null;
            }

        } catch (Exception e) {
            System.err.println("[KakaoApiService] Error getting access token: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    public String getCurrentAccessToken() {
        return currentAccessToken;
    }

    /**
     * 2. 나에게 메시지 보내기
     */
    public boolean sendTextToMe(String message) {
        if (currentAccessToken == null) {
            System.err.println("[KakaoApiService] 저장된 액세스 토큰이 없습니다.");
            return false;
        }
        
        try {
            String reqUrl = KAKAO_API_URL + "/v2/api/talk/memo/default/send";
            String templateObject = buildTextMessageTemplate(message);
            String params = "template_object=" + java.net.URLEncoder.encode(templateObject, StandardCharsets.UTF_8); // URL 인코딩 필수

            String response = sendPostRequest(reqUrl, params, currentAccessToken);
            
            JsonNode rootNode = objectMapper.readTree(response);
            if (rootNode.has("result_code") && rootNode.get("result_code").asInt() == 0) {
                 System.out.println("[KakaoApiService] 메시지 전송 성공");
                 return true;
            } else {
                 System.err.println("[KakaoApiService] 메시지 전송 실패: " + response);
                 return false;
            }

        } catch (Exception e) {
            System.err.println("[KakaoApiService] Error sending message: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // 헬퍼: POST 요청 전송 (HttpURLConnection 사용)
    private String sendPostRequest(String reqUrl, String params, String accessToken) throws Exception {
        URL url = new URL(reqUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
        
        if (accessToken != null) {
            conn.setRequestProperty("Authorization", "Bearer " + accessToken);
        }

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = params.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        int responseCode = conn.getResponseCode();
        System.out.println("[KakaoApiService] Response Code: " + responseCode);

        try (BufferedReader br = new BufferedReader(new InputStreamReader(
                (responseCode >= 200 && responseCode < 300) ? conn.getInputStream() : conn.getErrorStream(),
                StandardCharsets.UTF_8))) {
            return br.lines().collect(Collectors.joining("\n"));
        }
    }
    
    private String buildTextMessageTemplate(String text) {
        // JSON 문자열 생성 (이스케이프 처리 주의)
        String safeText = text.replace("\n", "\\n").replace("\"", "\\\"");
        return String.format(
            "{\"object_type\": \"text\",\"text\": \"%s\",\"link\": {\"web_url\": \"http://localhost:8080/list\",\"mobile_web_url\": \"http://localhost:8080/list\"},\"button_title\": \"앱에서 확인\"}", safeText);
    }
}
