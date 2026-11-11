# Hướng dẫn cài PostgreSQL trên Windows

**Mục tiêu:** Cài PostgreSQL 16+ (khuyến nghị 16 hoặc 17) trên Windows 10/11, tạo user và database cho HAUI Admissions.

---

## Bước 1: Tải PostgreSQL

1. Vào https://www.postgresql.org/download/windows/
2. Chọn **"Interactive installer"** phiên bản mới nhất (ưu tiên 16.x hoặc 17.x)
3. Tải file `.exe`

---

## Bước 2: Cài đặt PostgreSQL

1. **Mở file `.exe`** (ví dụ `postgresql-16.4-1-windows-x64.exe`)
2. **Màn hình chào mừng:** Bấm **Next**
3. **Installation Directory:** Giữ mặc định `C:\Program Files\PostgreSQL\16` → **Next**
4. **Select Components:** Chọn:
   - PostgreSQL Server
   - pgAdmin 4
   - Stack Builder (tùy chọn, để sau)
   - Command Line Tools (tùy chọn, bạn có thể bỏ)
   → **Next**
5. **Data Directory:** Giữ mặc định `C:\Program Files\PostgreSQL\16\data` → **Next**
6. **Password:** 
   - Nhập mật khẩu cho user `postgres` (ví dụ: `HauiPostgres2024!`)
   - **Lưu lại mật khẩu này**, sẽ dùng trong `.env`
   - → **Next**
7. **Port:** Giữ mặc định `5432` → **Next**
8. **Locale:** Chọn `[Default locale]` → **Next**
9. **Bắt đầu cài:** Bấm **Next**, chờ hoàn thành
10. **Stack Builder:** Bỏ qua (bấm **Finish** không chọn gì)

PostgreSQL đã cài xong

---

## Bước 3: Kiểm tra cài đặt

Mở **Command Prompt** (Win + R → `cmd`) chạy:

```cmd
psql --version
```

Nếu hiện `psql (PostgreSQL) 16.x` → Cài thành công

Nếu lỗi `psql: The term 'psql' is not recognized`:
- Thêm PostgreSQL vào PATH:
  1. Win + R → `SystemPropertiesAdvanced`
  2. **Environment Variables**
  3. **System variables** → **Path** → **Edit**
  4. **New** → thêm: `C:\Program Files\PostgreSQL\16\bin`
  5. OK → Restart Command Prompt

---

## Bước 4: Tạo Database `haui_admissions`

Mở **Command Prompt** chạy:

```cmd
psql -U postgres
```

Nhập mật khẩu `postgres` vừa đặt ở bước 2.

Khi vào shell PostgreSQL, chạy:

```sql
CREATE DATABASE haui_admissions;
```

Kết quả:
```
CREATE DATABASE
```

Database tạo xong. Kiểm tra:

```sql
\l
```

Phải thấy `haui_admissions | postgres` trong danh sách.

Thoát shell:
```sql
\q
```

---

## Bước 5: Tạo user chỉ đọc `haui_readonly`

Mở **Command Prompt** chạy:

```cmd
psql -U postgres -d haui_admissions
```

Rồi chạy các lệnh SQL sau:

```sql
-- Tạo user chỉ đọc
CREATE USER haui_readonly WITH PASSWORD 'readonly_pass_2024';

-- Cấp quyền CONNECT trên database
GRANT CONNECT ON DATABASE haui_admissions TO haui_readonly;

-- Cấp quyền SELECT trên tất cả bảng trong schema public (khi có)
GRANT USAGE ON SCHEMA public TO haui_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO haui_readonly;

-- Tương tự cho schema haui (khi tạo schema riêng)
-- GRANT USAGE ON SCHEMA haui TO haui_readonly;
-- GRANT SELECT ON ALL TABLES IN SCHEMA haui TO haui_readonly;
```

Kết quả phải không lỗi.

Thoát:
```sql
\q
```

---

## Bước 6: Cập nhật `.env`

Mở file `.env.example`, sao chép nội dung, tạo file `.env` cùng thư mục gốc dự án:

```env
# PostgreSQL
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=HauiPostgres2024!
DB_NAME=haui_admissions

# User chỉ đọc (cho Tool)
DB_READONLY_USER=haui_readonly
DB_READONLY_PASSWORD=readonly_pass_2024
```

LƯU Ý: File .env sẽ không commit lên GitHub (đã có trong .gitignore).

---

## Kiểm tra kết nối

Mở **Command Prompt** chạy:

```cmd
psql -U postgres -h localhost -d haui_admissions -c "SELECT version();"
```

Nếu hiện thông tin phiên bản PostgreSQL → Kết nối OK

---

## Cài pgvector (nếu chọn V1)

**Chỉ làm khi:**
- Bạn chọn **phương án V1** (PostgreSQL + pgvector)
- Bạn có **Docker Desktop** cài sẵn

### Cách 1: Dùng Docker (khuyến nghị, dễ nhất)

Tạo file `docker-compose.yml` trong thư mục gốc dự án:

```yaml
version: '3.8'
services:
  postgres_pgvector:
    image: pgvector/pgvector:pg16
    container_name: haui_postgres_pgvector
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: HauiPostgres2024!
      POSTGRES_DB: haui_admissions
    ports:
      - "5433:5432"  # Dùng port 5433 để không xung đột với PG đã cài
    volumes:
      - pgvector_data:/var/lib/postgresql/data

volumes:
  pgvector_data:
```

Mở **Command Prompt** (ở thư mục gốc dự án), chạy:

```cmd
docker-compose up -d
```

Kết quả:
```
Creating haui_postgres_pgvector ... done
```

Kiểm tra:
```cmd
docker-compose ps
```

Phải thấy container `haui_postgres_pgvector` với trạng thái `Up`.

**Lưu ý:** Sửa `DB_PORT=5433` trong `.env` khi dùng Docker.

### Cách 2: Biên dịch pgvector (nâng cao, không khuyến nghị)

Yêu cầu Visual Studio Build Tools, Git, và khá phức tạp. **Bỏ qua nếu không am hiểu**.

---

## Troubleshooting

### Lỗi: "psql: FATAL: Ident authentication failed"
**Nguyên nhân:** Phương pháp xác thực không khớp
**Sửa:** 
1. Mở `C:\Program Files\PostgreSQL\16\data\pg_hba.conf`
2. Tìm dòng `local   all             all                                 ident`
3. Sửa thành `local   all             all                                 md5`
4. Restart PostgreSQL (Services → PostgreSQL → Restart)

### Lỗi: "Port 5432 already in use"
**Sửa:** 
1. Kiểm tra process nào dùng port 5432: `netstat -ano | findstr :5432`
2. Hoặc dùng port khác (ví dụ 5433) trong PostgreSQL setup

### Lỗi: "Cannot connect to server"
**Sửa:**
1. Kiểm tra PostgreSQL service chạy: `services.msc` → tìm `postgresql-x64-16` → chọn **Start**
2. Kiểm tra firewall: Allow `postgresql.exe` hoặc port 5432

---

## Tài liệu tham khảo

- PostgreSQL Download: https://www.postgresql.org/download/windows/
- pgvector GitHub: https://github.com/pgvector/pgvector
- Docker Compose: https://docs.docker.com/compose/

---

Hoàn thành khi: Bạn chạy lệnh kiểm tra trên và nhận được kết quả OK.

Tiếp theo: Báo cho agent hoàn thành Bước 3 (Cài PostgreSQL).
