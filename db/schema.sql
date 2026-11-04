-- ============================================
-- HAUI Admissions Database Schema
-- PostgreSQL
-- ============================================

-- Create schema
CREATE SCHEMA IF NOT EXISTS haui_admissions;
SET search_path TO haui_admissions, public;

-- ============================================
-- 1. Programs Table
-- ============================================
CREATE TABLE IF NOT EXISTS programs (
    id SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    faculty VARCHAR(255),
    department VARCHAR(255),
    duration_years INT DEFAULT 4,
    tuition_fee DECIMAL(12, 2),
    admission_score_min DECIMAL(5, 2),
    admission_score_max DECIMAL(5, 2),
    capacity INT,
    language_of_instruction VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- ============================================
-- 2. Admission Criteria Table
-- ============================================
CREATE TABLE IF NOT EXISTS admissions_criteria (
    id SERIAL PRIMARY KEY,
    program_id INT NOT NULL REFERENCES programs(id) ON DELETE CASCADE,
    criteria_type VARCHAR(100), -- 'EXAM', 'GPA', 'IELTS', 'TOEFL', etc.
    description TEXT,
    min_score DECIMAL(5, 2),
    max_score DECIMAL(5, 2),
    required BOOLEAN DEFAULT TRUE,
    weight DECIMAL(5, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(program_id, criteria_type)
);

-- ============================================
-- 3. FAQ Table (Knowledge Base)
-- ============================================
CREATE TABLE IF NOT EXISTS faq (
    id SERIAL PRIMARY KEY,
    category VARCHAR(100),
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    program_id INT REFERENCES programs(id) ON DELETE SET NULL,
    keyword VARCHAR(500),
    views INT DEFAULT 0,
    helpful_yes INT DEFAULT 0,
    helpful_no INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- ============================================
-- 4. Chat History Table
-- ============================================
CREATE TABLE IF NOT EXISTS chat_history (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(255) NOT NULL,
    user_message TEXT NOT NULL,
    bot_response TEXT,
    program_id INT REFERENCES programs(id) ON DELETE SET NULL,
    model_used VARCHAR(100),
    response_time_ms INT,
    sentiment VARCHAR(50),
    was_helpful BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 5. Documents Table (uploaded via Open WebUI)
-- ============================================
CREATE TABLE IF NOT EXISTS documents (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    document_type VARCHAR(100), -- 'ADMISSION_GUIDELINE', 'REGULATION', 'PROGRAM_INFO'
    source_file VARCHAR(500),
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE
);

-- ============================================
-- 6. Embeddings Table (for RAG)
-- ============================================
CREATE TABLE IF NOT EXISTS embeddings (
    id SERIAL PRIMARY KEY,
    document_id INT REFERENCES documents(id) ON DELETE CASCADE,
    chunk_text TEXT NOT NULL,
    embedding FLOAT8[] NOT NULL,
    chunk_index INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 7. Admission Calendar
-- ============================================
CREATE TABLE IF NOT EXISTS admission_calendar (
    id SERIAL PRIMARY KEY,
    academic_year VARCHAR(20), -- e.g., "2024-2025"
    event_name VARCHAR(255) NOT NULL,
    event_type VARCHAR(100), -- 'REGISTRATION_OPEN', 'DEADLINE', 'EXAM', 'RESULT'
    event_date DATE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 8. User Sessions (for tracking interactions)
-- ============================================
CREATE TABLE IF NOT EXISTS user_sessions (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(255) UNIQUE NOT NULL,
    user_agent VARCHAR(500),
    ip_address VARCHAR(50),
    device_type VARCHAR(50), -- 'desktop', 'mobile', 'tablet'
    first_interaction TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_interaction TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    message_count INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE
);

-- ============================================
-- Indexes for Performance
-- ============================================
CREATE INDEX idx_programs_code ON programs(code);
CREATE INDEX idx_programs_active ON programs(is_active);
CREATE INDEX idx_admissions_criteria_program ON admissions_criteria(program_id);
CREATE INDEX idx_faq_category ON faq(category);
CREATE INDEX idx_faq_program_id ON faq(program_id);
CREATE INDEX idx_faq_active ON faq(is_active);
CREATE INDEX idx_chat_history_session ON chat_history(session_id);
CREATE INDEX idx_chat_history_created ON chat_history(created_at);
CREATE INDEX idx_documents_type ON documents(document_type);
CREATE INDEX idx_documents_active ON documents(is_active);
CREATE INDEX idx_embeddings_document ON embeddings(document_id);
CREATE INDEX idx_admission_calendar_year ON admission_calendar(academic_year);
CREATE INDEX idx_user_sessions_id ON user_sessions(session_id);

-- ============================================
-- Views for Common Queries
-- ============================================

-- View: Programs with criteria
CREATE OR REPLACE VIEW v_programs_full AS
SELECT 
    p.id,
    p.code,
    p.name,
    p.faculty,
    p.tuition_fee,
    p.admission_score_min,
    p.admission_score_max,
    p.capacity,
    COUNT(ac.id) as criteria_count,
    p.is_active
FROM programs p
LEFT JOIN admissions_criteria ac ON p.id = ac.program_id
WHERE p.is_active = TRUE
GROUP BY p.id;

-- View: Chat statistics
CREATE OR REPLACE VIEW v_chat_statistics AS
SELECT 
    DATE(created_at) as chat_date,
    COUNT(*) as total_messages,
    COUNT(DISTINCT session_id) as unique_users,
    AVG(response_time_ms) as avg_response_time_ms
FROM chat_history
GROUP BY DATE(created_at)
ORDER BY chat_date DESC;

-- ============================================
-- Functions for Common Operations
-- ============================================

-- Function: Update FAQ views
CREATE OR REPLACE FUNCTION update_faq_views(faq_id INT)
RETURNS void AS $$
BEGIN
    UPDATE faq SET views = views + 1 WHERE id = faq_id;
END;
$$ LANGUAGE plpgsql;

-- Function: Mark session as last active
CREATE OR REPLACE FUNCTION update_session_activity(session_id_param VARCHAR)
RETURNS void AS $$
BEGIN
    UPDATE user_sessions 
    SET last_interaction = CURRENT_TIMESTAMP,
        message_count = message_count + 1
    WHERE session_id = session_id_param;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- Permissions
-- ============================================
GRANT USAGE ON SCHEMA haui_admissions TO postgres;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA haui_admissions TO postgres;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA haui_admissions TO postgres;
