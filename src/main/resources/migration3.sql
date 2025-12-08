-- Migration 3: UUID 자동 생성 (기존 데이터 복구)
-- 실행 방법: mysql -u root -p paykeeper_db < migration3.sql

USE paykeeper_db;

-- share_uuid가 NULL이거나 빈 문자열인 경우 UUID 자동 생성
UPDATE subscription
SET share_uuid = UUID()
WHERE share_uuid IS NULL OR share_uuid = '';

-- 결과 확인
SELECT seq, service_name, share_uuid
FROM subscription
ORDER BY seq;
