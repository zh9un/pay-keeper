-- ===========================
-- Pay Keeper - Database Migration
-- 계좌번호 관리 기능 추가
-- ===========================

USE paykeeper_db;

-- subscription 테이블에 account_number 컬럼 추가
ALTER TABLE subscription
ADD COLUMN account_number VARCHAR(100) COMMENT '입금 계좌번호 (예: 카카오뱅크 3333-xx-xxxx)'
AFTER billing_date;

-- 변경 사항 확인
DESCRIBE subscription;
