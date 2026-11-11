-- ============================================
-- HAUI Admissions Sample Data
-- ============================================

SET search_path TO haui_admissions, public;

-- ============================================
-- 1. Programs
-- ============================================
INSERT INTO programs (code, name, description, faculty, department, duration_years, tuition_fee, admission_score_min, admission_score_max, capacity, language_of_instruction, is_active)
VALUES
    ('CNTT', 'Công Nghệ Thông Tin', 
     'Đào tạo về phát triển phần mềm, an toàn mạng, trí tuệ nhân tạo và các công nghệ thông tin hiện đại', 
     'Công Nghệ Thông Tin', 'Information Technology', 4, 2500.00, 15.0, 30.0, 100, 'Vietnamese', TRUE),
    
    ('KTXD', 'Kỹ Thuật Xây Dựng', 
     'Đào tạo về thiết kế, xây dựng công trình dân dụng và công trình giao thông', 
     'Xây Dựng', 'Civil Engineering', 4, 2200.00, 14.0, 28.0, 80, 'Vietnamese', TRUE),
    
    ('KTVT', 'Kỹ Thuật Vận Tải', 
     'Đào tạo về quản lý vận tải, logistics, vận hành tàu biển', 
     'Vận Tải', 'Maritime Engineering', 4, 2000.00, 13.0, 26.0, 60, 'Vietnamese', TRUE),
    
    ('HVTN', 'Hệ Thống Thông Tin', 
     'Đào tạo về quản trị hệ thống thông tin, cơ sở dữ liệu, kiến trúc hệ thống', 
     'Công Nghệ Thông Tin', 'Information Systems', 4, 2400.00, 14.5, 29.0, 70, 'Vietnamese', TRUE),
    
    ('KTHH', 'Kỹ Thuật Hóa Học', 
     'Đào tạo về công nghệ hóa học, xử lý chất thải, công nghệ lọc nước', 
     'Kỹ Thuật', 'Chemical Engineering', 4, 2100.00, 13.5, 27.0, 50, 'Vietnamese', TRUE)
ON CONFLICT (code) DO NOTHING;

-- ============================================
-- 2. Admission Criteria
-- ============================================
INSERT INTO admissions_criteria (program_id, criteria_type, description, min_score, max_score, required, weight)
SELECT id, 'EXAM_SCORE', 'Điểm thi tuyển sinh', 0, 30, TRUE, 100 FROM programs WHERE code = 'CNTT'
UNION ALL
SELECT id, 'IELTS', 'Chứng chỉ IELTS (tuỳ chọn)', 5.5, 9.0, FALSE, 50 FROM programs WHERE code = 'CNTT'
UNION ALL
SELECT id, 'EXAM_SCORE', 'Điểm thi tuyển sinh', 0, 30, TRUE, 100 FROM programs WHERE code = 'KTXD'
UNION ALL
SELECT id, 'HIGH_SCHOOL_GPA', 'GPA trung học (tuỳ chọn)', 7.0, 10.0, FALSE, 30 FROM programs WHERE code = 'KTXD'
ON CONFLICT DO NOTHING;

-- ============================================
-- 3. FAQ
-- ============================================
INSERT INTO faq (category, question, answer, program_id, keyword, is_active)
VALUES
    ('Tuyển Sinh', 'Hạn chót đăng ký tuyển sinh là khi nào?', 
     'Hạn chót đăng ký tuyển sinh năm học 2024-2025 là ngày 30/06/2024. Các hồ sơ nộp sau thời hạn sẽ không được xem xét.', 
     NULL, 'hạn chót, đăng ký, tuyển sinh', TRUE),
    
    ('Tuyển Sinh', 'Điểm chuẩn tuyển sinh năm nay là bao nhiêu?', 
     'Điểm chuẩn tuyển sinh tuỳ thuộc từng chuyên ngành: CNTT: 18-30 điểm, KTXD: 16-28 điểm, KTVT: 15-26 điểm, HVTN: 17-29 điểm.', 
     NULL, 'điểm chuẩn, tuyển sinh, điểm', TRUE),
    
    ('Chương Trình', 'Học phí hàng năm bao nhiêu?', 
     'Học phí theo chuyên ngành từ 2,000 - 2,500 USD mỗi năm học. Chi tiết: CNTT: 2,500 USD, KTXD: 2,200 USD, KTVT: 2,000 USD.', 
     NULL, 'học phí, chi phí, tiền', TRUE),
    
    ('Tuyển Sinh', 'Yêu cầu hồ sơ tuyển sinh gồm những gì?', 
     'Hồ sơ tuyển sinh bao gồm: (1) Giấy chứng minh thư/CCCD, (2) Bằng cấp học vấn, (3) Chứng chỉ ngoại ngữ (nếu có), (4) Chứng chỉ TOEFL/IELTS (nếu chuyên ngành yêu cầu).', 
     NULL, 'hồ sơ, yêu cầu, giấy tờ', TRUE),
    
    ('Chương Trình', 'Thời gian đào tạo của mỗi chương trình là bao lâu?', 
     'Phần lớn chương trình đào tạo cấp bằng cử nhân kéo dài 4 năm học. Một số chương trình đặc thù có thể kéo dài 5 năm.', 
     NULL, 'thời gian, năm, khoá học', TRUE),
    
    ('Hỗ Trợ', 'Có học bổng cho sinh viên không?', 
     'Có. HAUI cung cấp nhiều loại học bổng: (1) Học bổng khuyến khích, (2) Học bổng hoàn cảnh khó khăn, (3) Học bổng từ các nhà tài trợ. Liên hệ phòng Công tác sinh viên để biết chi tiết.', 
     NULL, 'học bổng, tài chính, hỗ trợ', TRUE),
    
    ('Hỗ Trợ', 'Có cơ hội làm việc trong quá trình học không?', 
     'Có. HAUI hợp tác với nhiều doanh nghiệp, cung cấp cơ hội thực tập và làm việc bán thời gian cho sinh viên. Hầu hết các chương trình cũng có môn thực tập doanh nghiệp.', 
     NULL, 'làm việc, thực tập, cơ hội', TRUE),
    
    ('Sinh Viên', 'Có ký túc xá không?', 
     'Có. HAUI cung cấp ký túc xá cho sinh viên. Chi phí ký túc xá từ 500-800 năm mỗi năm học tuỳ loại phòng.', 
     NULL, 'ký túc xá, ở, nhà ở', TRUE),
    
    ('Sinh Viên', 'Cơ sở vật chất của trường như thế nào?', 
     'HAUI có cơ sở vật chất hiện đại bao gồm: phòng học có máy chiếu, phòng thí nghiệm trang thiết bị đầy đủ, thư viện với 200,000+ cuốn sách, trung tâm thể thao, nhà ăn, cửa hàng tiện lợi.', 
     NULL, 'cơ sở, vật chất, trang thiết bị', TRUE),
    
    ('Tuyển Sinh', 'Làm sao để nộp hồ sơ?', 
     'Bạn có thể nộp hồ sơ qua: (1) Trực tiếp tại phòng Tuyển Sinh, (2) Qua bưu điện, (3) Thông qua website HAUI (https://haui.edu.vn). Chi tiết liên hệ: admissions@haui.edu.vn hoặc SĐT: +84-24-XXXX-XXXX', 
     NULL, 'nộp hồ sơ, đăng ký, quy trình', TRUE)
ON CONFLICT DO NOTHING;

-- ============================================
-- 4. Admission Calendar
-- ============================================
INSERT INTO admission_calendar (academic_year, event_name, event_type, event_date, description)
VALUES
    ('2024-2025', 'Mở đơn đăng ký', 'REGISTRATION_OPEN', '2024-05-01', 'Bắt đầu nhận đơn đăng ký tuyển sinh'),
    ('2024-2025', 'Hạn cuối đăng ký', 'DEADLINE', '2024-06-30', 'Ngày hạn cuối nộp hồ sơ'),
    ('2024-2025', 'Kỳ thi tuyển sinh', 'EXAM', '2024-07-15', 'Ngày diễn ra kỳ thi'),
    ('2024-2025', 'Công bố kết quả', 'RESULT', '2024-08-01', 'Công bố danh sách trúng tuyển'),
    ('2024-2025', 'Nhập học', 'ENROLLMENT', '2024-09-01', 'Ngày nhập học chính thức'),
    ('2025-2026', 'Mở đơn đăng ký', 'REGISTRATION_OPEN', '2025-05-01', 'Bắt đầu nhận đơn đăng ký tuyển sinh năm học 2025-2026')
ON CONFLICT DO NOTHING;

-- ============================================
-- 5. User Sessions (sample)
-- ============================================
INSERT INTO user_sessions (session_id, user_agent, device_type, message_count, is_active)
VALUES
    ('session_001', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)', 'desktop', 5, TRUE),
    ('session_002', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0)', 'mobile', 12, TRUE)
ON CONFLICT DO NOTHING;

-- ============================================
-- Commit
-- ============================================
COMMIT;

-- Display summary
SELECT 'Seed data loaded successfully' as status;
SELECT COUNT(*) as total_programs FROM programs;
SELECT COUNT(*) as total_faq FROM faq;
SELECT COUNT(*) as total_calendar_events FROM admission_calendar;
