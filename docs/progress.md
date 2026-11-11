# Nhật ký tiến độ dự án HAUI Admissions Chatbot

**Ngày bắt đầu:** Tháng 11, 2024  
**Trạng thái hiện tại:** Giai đoạn 0 - Khảo sát môi trường

---

## Giai đoạn 0: Khảo sát môi trường

### Kết quả kiểm tra (Phần A)

| Thành phần | Kết quả | Chi tiết | Ghi chú |
|-----------|--------|---------|--------|
| **Python** | ✓ Có | 3.14.3 | Hiện tại có thể dùng |
| **Conda** | ✗ Không trong PATH | - | Cần thêm vào PATH hoặc dùng venv |
| **Ollama** | ✗ Chưa cài | - | Cần cài (https://ollama.ai) |
| **PostgreSQL** | ✗ Chưa cài | - | Cần cài |
| **RAM** | ✓ OK | 7.34 GB | Đủ cho model 1.5B-7B |
| **GPU** | ~ Chưa kiểm tra | - | Sẽ kiểm tra khi cài Ollama |
| **Port 8080** | ~ CHIẾM | Có service đang chạy | Cần kiểm tra hoặc đổi port Open WebUI |
| **Port 11434** | ✓ TRỐNG | Ollama sẽ dùng | OK |
| **Port 5432** | ✓ TRỐNG | PostgreSQL sẽ dùng | OK |

### Hành động cần làm ngay

#### 1️⃣ **Port 8080 - Cần xác nhận**
Port 8080 hiện đang bị chiếm. Trước khi cài Open WebUI:
- [ ] **Bạn hỏi**: Bạn có muốn kiểm tra ứng dụng nào chiếm port 8080 không, hay đổi port Open WebUI sang 8081/8888?

#### 2️⃣ **Cài đặt Ollama** (bắt buộc)
```bash
# Tải từ https://ollama.ai
# Chọn "Download for Windows"
# Cài và khởi động

# Sau cài, chạy để kiểm tra
ollama --version
ollama list
```

#### 3️⃣ **Cài đặt PostgreSQL** (bắt buộc)
Tôi sẽ viết hướng dẫn cài riêng (`docs/install_postgresql.md`).

#### 4️⃣ **Thêm Conda vào PATH** (tùy chọn, nếu muốn dùng Conda)
Hoặc dùng Python venv trực tiếp (đơn giản hơn).

---

## Đề xuất phương án kiến trúc

### Phương án V1: PostgreSQL + pgvector
- **Ưu điểm:** Tất cả dữ liệu trong một CSDL, truy vấn tích hợp RAG, bảo mật tập trung
- **Nhược điểm:** Cài pgvector trên Windows native khó; cần Docker hoặc bản precompiled
- **Đề xuất khi:** Bạn có Docker Desktop hoặc sẵn sàng biên dịch pgvector

### Phương án V2: PostgreSQL + ChromaDB (mặc định)
- **Ưu điểm:** Đơn giản, Open WebUI tích hợp ChromaDB sẵn, không cần cài thêm
- **Nhược điểm:** Số liệu và vector ở 2 chỗ
- **Đề xuất khi:** Muốn setup nhanh, không rắc rối

### 🔴 **Quyết định cần bạn:**
**Bạn chọn V1 hay V2?** (mặc định: V2 nếu bạn không chắc)

---

## Các file hướng dẫn sẽ tạo

- [ ] docs/install_postgresql_windows.md — Cài PG trên Windows step-by-step
- [ ] `docs/prepare_data.md` — Chuẩn bị thư mục `data/input/`
- [ ] `docs/architecture.md` — Cập nhật theo phương án chọn
- [ ] `scripts/setup_env.bat` — Script tự động setup Conda/venv

---

## Checklist Giai đoạn 0

- [ ] Xác nhận port 8080 (đổi port hay dùng tiếp?)
- [ ] Chọn phương án V1/V2
- [ ] Cài Ollama (hoặc xác nhận đã cài)
- [ ] Cài PostgreSQL
- [ ] Chuẩn bị dữ liệu (sẽ làm ở Giai đoạn chuẩn bị)

---

## Tiếp theo

Sau khi bạn trả lời 3 câu hỏi trên, tôi sẽ:
1. Viết hướng dẫn cài Ollama và PostgreSQL chi tiết
2. Tạo template thư mục `data/input/`
3. Chuẩn bị các script setup tự động
4. Bắt đầu Giai đoạn 1 (chuẩn bị khung dự án)
