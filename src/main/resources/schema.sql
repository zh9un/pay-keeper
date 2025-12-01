-- ===========================
-- Pay Keeper Database Schema
-- ===========================

-- Create Database
CREATE DATABASE IF NOT EXISTS paykeeper_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- Use Database
USE paykeeper_db;

-- Drop tables if exist (for clean setup)
DROP TABLE IF EXISTS party_member;
DROP TABLE IF EXISTS subscription;

-- ===========================
-- 1. Subscription Table (Parent)
-- ===========================
CREATE TABLE subscription (
    seq INT AUTO_INCREMENT PRIMARY KEY COMMENT '구독 고유 ID',
    service_name VARCHAR(100) NOT NULL COMMENT '서비스명 (예: 넷플릭스, 유튜브 프리미엄)',
    total_price INT NOT NULL COMMENT '월 총 결제 금액',
    billing_date INT NOT NULL COMMENT '결제일 (1~31)',
    regdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',

    -- Constraints
    CONSTRAINT chk_billing_date CHECK (billing_date BETWEEN 1 AND 31),
    CONSTRAINT chk_total_price CHECK (total_price > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='OTT 구독 정보';

-- ===========================
-- 2. Party Member Table (Child)
-- ===========================
CREATE TABLE party_member (
    member_seq INT AUTO_INCREMENT PRIMARY KEY COMMENT '파티원 고유 ID',
    sub_seq INT NOT NULL COMMENT '구독 ID (FK)',
    member_name VARCHAR(50) NOT NULL COMMENT '파티원 이름',
    per_price INT NOT NULL COMMENT '인당 부담 금액 (1/N 계산)',
    is_paid CHAR(1) DEFAULT 'N' COMMENT '입금 여부 (Y/N)',

    -- Foreign Key with CASCADE DELETE
    CONSTRAINT fk_party_member_subscription
        FOREIGN KEY (sub_seq)
        REFERENCES subscription(seq)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    -- Constraints
    CONSTRAINT chk_is_paid CHECK (is_paid IN ('Y', 'N')),
    CONSTRAINT chk_per_price CHECK (per_price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='파티원 및 정산 정보';

-- ===========================
-- 3. Sample Data (Optional - for testing)
-- ===========================
-- INSERT INTO subscription (service_name, total_price, billing_date)
-- VALUES ('넷플릭스 프리미엄', 17000, 15);

-- INSERT INTO party_member (sub_seq, member_name, per_price, is_paid)
-- VALUES
-- (1, '김철수', 4250, 'Y'),
-- (1, '이영희', 4250, 'N'),
-- (1, '박민수', 4250, 'Y'),
-- (1, '본인', 4250, 'Y');

-- ===========================
-- 4. Indexes (for performance)
-- ===========================
CREATE INDEX idx_service_name ON subscription(service_name);
CREATE INDEX idx_member_name ON party_member(member_name);
CREATE INDEX idx_sub_seq ON party_member(sub_seq);

-- Show tables
SHOW TABLES;
