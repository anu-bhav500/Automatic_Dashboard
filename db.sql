-- ============================================================
--  mysql_setup.sql  —  Run this ONCE in MySQL Workbench or terminal
--  Command: mysql -u root -p < mysql_setup.sql
-- ============================================================

-- 1. Create the database
CREATE DATABASE IF NOT EXISTS report
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE report;

-- 2. Uploads log table (one row per file uploaded)
CREATE TABLE IF NOT EXISTS uploads (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  filename    VARCHAR(255)  NOT NULL COMMENT 'Saved filename on disk',
  original    VARCHAR(255)  NOT NULL COMMENT 'Original filename from user',
  rows_count  INT           DEFAULT 0,
  sheets      VARCHAR(255)  COMMENT 'Comma-separated sheet names',
  uploaded_at DATETIME      DEFAULT CURRENT_TIMESTAMP
);

-- 3. Invoice rows table (all rows from uploaded file)
CREATE TABLE IF NOT EXISTS invoice_rows (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  upload_id   INT           NOT NULL,
  party       VARCHAR(255)  DEFAULT '—',
  vr_no       VARCHAR(100)  DEFAULT '—',
  ledger      VARCHAR(255)  DEFAULT '—',
  outstanding DOUBLE        DEFAULT 0,
  collected   DOUBLE        DEFAULT 0,
  gst         DOUBLE        DEFAULT 0,
  agent       VARCHAR(255)  DEFAULT '—',
  due_date    VARCHAR(50)   DEFAULT '—',
  created_at  DATETIME      DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (upload_id) REFERENCES uploads(id) ON DELETE CASCADE,
  INDEX idx_upload (upload_id),
  INDEX idx_agent  (agent),
  INDEX idx_party  (party(100))
);

-- 4. Quick verify
SELECT 'Database setup complete! Tables created.' AS status;
SHOW TABLES;
