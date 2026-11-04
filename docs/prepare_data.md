# 📊 Hướng dẫn chuẩn bị dữ liệu

**Mục tiêu:** Chuẩn bị thư mục `data/input/` với 3 file dữ liệu gốc mà agent sẽ xử lý trong Giai đoạn 3-5.

---

## 📂 Cấu trúc thư mục dữ liệu

Tạo thư mục như sau (tất cả vào thư mục gốc dự án):

```
haui-admissions-chatbot/
└── data/
    └── input/                          ← Đặt dữ liệu gốc ở đây
        ├── haui_markdown.zip           (268 file .md)
        ├── haui_2020_nay_sach.jsonl    (dữ liệu cấu trúc)
        └── haui_bi_loai.csv            (danh sách bài bỏ)
```

---

## 📥 File 1: `haui_markdown.zip`

**Nội dung:** 268 file Markdown (`.md`), mỗi bài một file, đã làm sạch.

**Cấu trúc mỗi file `.md`:**
```markdown
---
title: Tiêu đề bài viết
date: 2024-11-15
year: 2024
category: Thông báo / Danh sách / Quy chế...
url: https://tuyensinh.haui.edu.vn/article/...
---

# Nội dung bài viết

Văn bản, bảng, links...
```

**Cách chuẩn bị:**
1. Lấy file `haui_markdown.zip` từ máy tính đã cào dữ liệu
2. Đặt trực tiếp vào `data/input/`
3. **Không giải nén** — agent sẽ làm ở Giai đoạn 5

**Dùng để:** Xây dựng RAG knowledge base (Giai đoạn 5)

---

## 📥 File 2: `haui_2020_nay_sach.jsonl`

**Nội dung:** Mỗi dòng một bài viết (JSON Lines format), gồm:

```json
{
  "article_id": "article_001",
  "year": 2024,
  "date": "2024-11-15",
  "title": "Thông báo tuyển sinh năm 2024",
  "category": "Thông báo",
  "url": "https://tuyensinh.haui.edu.vn/article/001",
  "body": "Nội dung bài viết...",
  "tables": [
    {
      "table_title": "Điểm chuẩn ngành CNTT",
      "content": "Mã ngành,Tên ngành,Điểm\nCNTT,Công Nghệ Thông Tin,25.5"
    }
  ],
  "attachments": [],
  "images": []
}
```

**Cách chuẩn bị:**
1. Tạo file mới `data/input/haui_2020_nay_sach.jsonl`
2. Dùng Python script để trích từ dữ liệu gốc (nếu có), hoặc tạo từ `haui_markdown.zip` bằng script agent cung cấp

**Dùng để:** Trích bảng số liệu và nạp vào PostgreSQL (Giai đoạn 3-4)

---

## 📥 File 3: `haui_bi_loai.csv`

**Nội dung:** Danh sách các bài bỏ (94 bài), cột `article_id, tieu_de, ly_do`.

**Ví dụ:**
```csv
article_id,tieu_de,ly_do
article_050,Thông báo số 15 năm 2020,Mất nội dung (ảnh/file nhúng)
article_067,Quyết định tuyển dụng,Trước năm 2020
article_089,Bản sửa lỗi,Nội dung trùng lặp
```

**Cách chuẩn bị:**
1. Tạo file `data/input/haui_bi_loai.csv` nếu muốn đối chiếu
2. Hoặc tạo sau khi agent phát hiện (Giai đoạn 3)

**Dùng để:** Ghi nhận giới hạn dữ liệu, không lạc lối

---

## 🛠️ Cách tạo file nếu chưa có

### Tùy chọn A: Dùng script agent cung cấp (Giai đoạn 3)
Agent sẽ viết script tạo `haui_2020_nay_sach.jsonl` từ `haui_markdown.zip`.

### Tùy chọn B: Tạo tay (cho dữ liệu mẫu thử)

**Tạo `data/input/haui_2020_nay_sach.jsonl` mẫu:**

```bash
# Mở Notepad hoặc editor, viết nội dung:
```

```json
{"article_id":"sample_001","year":2024,"date":"2024-11-15","title":"Danh sách ngành tuyển sinh 2024","category":"Danh sách","url":"https://tuyensinh.haui.edu.vn/sample","body":"Năm 2024 HAUI tuyển sinh 5 ngành chính","tables":[{"table_title":"Ngành và chỉ tiêu","content":"Mã ngành,Tên ngành,Chỉ tiêu,Điểm chuẩn\nCNTT,Công Nghệ Thông Tin,100,25.5\nKTXD,Kỹ Thuật Xây Dựng,80,23.0\nKTVT,Kỹ Thuật Vận Tải,60,20.0"}],"attachments":[],"images":[]}
```

```bash
# Lưu vào: data/input/haui_2020_nay_sach.jsonl
```

---

## ✅ Checklist chuẩn bị dữ liệu

- [ ] Thư mục `data/input/` tồn tại
- [ ] File `haui_markdown.zip` đặt sẵn (hoặc để trống, agent sẽ hỏi)
- [ ] File `haui_2020_nay_sach.jsonl` đặt sẵn (hoặc để trống, agent sẽ tạo)
- [ ] File `haui_bi_loai.csv` tùy chọn
- [ ] Các file này **không commit lên GitHub** (đã có `.gitignore`)

---

## 🚀 Tiếp theo

Khi dữ liệu sẵn sàng, agent sẽ:
1. **Giai đoạn 3:** Trích bảng từ `haui_2020_nay_sach.jsonl` → CSV chuẩn hóa
2. **Giai đoạn 4:** Nạp CSV vào PostgreSQL
3. **Giai đoạn 5:** Xử lý `.md` → embeddings → RAG

---

## 📞 Câu hỏi thường gặp

**Q: Nếu chưa có dữ liệu gốc từ máy cào?**
A: Agent sẽ tạo dữ liệu mẫu để test luồng; bạn thay sau khi có dữ liệu thật.

**Q: File `.zip` bao lớn, có hỏi trước khi giải nén?**
A: Có, agent sẽ kiểm tra dung lượng và hỏi xác nhận.

**Q: Có giải nén `.zip` bằng tay rồi thôi được không?**
A: Được. Nhưng agent sẽ kiểm tra và chuẩn hóa tự động (ví dụ tên file, encoding).

**Q: Nếu file `.jsonl` format sai sao?**
A: Agent sẽ báo lỗi từng dòng, bạn sửa hoặc agent hỗ trợ sửa.
