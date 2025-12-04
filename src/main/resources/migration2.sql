-- ===========================
-- Pay Keeper - Database Migration 2
-- 공유 링크 기능 추가 (share_uuid)
-- ===========================

USE paykeeper_db;

-- subscription 테이블에 share_uuid 컬럼 추가
ALTER TABLE subscription
ADD COLUMN share_uuid VARCHAR(36) UNIQUE COMMENT '공유 링크용 UUID'
AFTER account_number;

-- 기존 데이터에 UUID 생성 (기존 구독이 있는 경우)
UPDATE subscription
SET share_uuid = UUID()
WHERE share_uuid IS NULL;

-- 변경 사항 확인
DESCRIBE subscription;

-- 데이터 확인
SELECT seq, service_name, share_uuid FROM subscription;
