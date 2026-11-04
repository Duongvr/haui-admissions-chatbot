# HAUI Admissions Chatbot - Integrated Setup

Hệ thống chatbot tuyển sinh thông minh sử dụng **Open WebUI + Ollama + PostgreSQL** cho Trường Đại học Công Nghiệp Hà Nội (HAUI).

## 🎯 Tính Năng Chính

✨ **Open WebUI** - Giao diện chat trực quan  
🧠 **Ollama LLM** - Mô hình ngôn ngữ local  
🗄️ **PostgreSQL** - Lưu trữ tri thức tuyển sinh  
📚 **RAG Pipeline** - Truy vấn ngữ cảnh thông minh  
📄 **PDF Processing** - Nạp tài liệu HAUI  
💾 **ChromaDB** - Vector store tích hợp  

## 📋 Yêu Cầu Hệ Thống

- **OS**: Windows 10/11, macOS, Linux
- **Python**: 3.9+
- **PostgreSQL**: 14+
- **Ollama**: Mới nhất
- **RAM**: 8GB tối thiểu (16GB khuyến nghị)
- **Storage**: 20GB+ (cho mô hình + dữ liệu)

## 🚀 Cài Đặt Nhanh (Windows)

### 1. Clone Repository

```bash
git clone <repo-url>
cd haui-admissions-chatbot
```

### 2. Setup Python Environment

```bash
python -m venv venv
venv\Scripts\activate
pip install -r src\requirements.txt
```

### 3. Setup PostgreSQL

```bash
# Tạo database
createdb -U postgres haui_admissions

# Tạo schema
psql -U postgres -d haui_admissions -f db\schema.sql

# Nạp dữ liệu mẫu
psql -U postgres -d haui_admissions -f db\seed_data.sql
```

### 4. Cấu Hình Environment

```bash
copy .env.example .env
# Chỉnh sửa .env với credentials của bạn
```

### 5. Khởi Động Services

**Terminal 1 - Ollama:**
```bash
scripts\start_ollama.bat
```

**Terminal 2 - Open WebUI:**
```bash
scripts\start_webui.bat
```

**Terminal 3 - Backend (tuỳ chọn):**
```bash
# Nếu có Python backend
python src\main.py
```

### 6. Truy Cập

- **Open WebUI**: http://localhost:3000
- **Ollama API**: http://localhost:11434
- **PostgreSQL**: localhost:5432

## 📁 Cấu Trúc Dự Án

```
haui-admissions-chatbot/
│
├── 📂 open-webui/              # Open WebUI runtime
│   └── data/                   # SQLite DB, ChromaDB, uploads (git ignored)
│
├── 📂 db/                      # Database scripts
│   ├── schema.sql              # Tạo bảng PostgreSQL
│   └── seed_data.sql           # Dữ liệu mẫu ban đầu
│
├── 📂 docs/                    # Documentation
│   ├── srs_document.md         # Yêu cầu phần mềm
│   └── architecture.md         # Kiến trúc hệ thống
│
├── 📂 models/                  # AI Models
│   └── Modelfile               # Ollama custom model
│
├── 📂 scripts/                 # Windows scripts
│   ├── start_ollama.bat        # Khởi động Ollama
│   └── start_webui.bat         # Khởi động Open WebUI
│
├── 📂 src/                     # Source code
│   ├── rag_pipeline/           # PDF processing
│   │   ├── pdf_processor.py
│   │   ├── chunker.py
│   │   └── embeddings.py
│   ├── main.py                 # Backend entry point (nếu cần)
│   └── requirements.txt        # Python dependencies
│
├── .env.example                # Config template
├── .gitignore                  # Git ignore rules
└── README.md                   # This file
```

## 🔧 Cấu Hình Chi Tiết

### PostgreSQL Schema

**Bảng chính:**
- `programs` - Chương trình học
- `admissions_criteria` - Điều kiện tuyển sinh
- `faq` - Câu hỏi thường gặp
- `chat_history` - Lịch sử chat
- `embeddings` - Vector embeddings

### Ollama Models

```bash
# Tải models
ollama pull qwen2.5:1.5b       # Model nhẹ (~1.5GB)
ollama pull nomic-embed-text   # Embedding model

# Hoặc models khác
ollama pull mistral             # Mạnh hơn (~4GB)
ollama pull llama2              # Lớn (~4GB)
```

### Open WebUI Configuration

- Đường dẫn dữ liệu: `./open-webui/data/`
- API Ollama: `http://localhost:11434`
- Port: 3000
- Database: SQLite tích hợp + ChromaDB

## 📚 Sử Dụng

### Chat Interface

1. Mở http://localhost:3000
2. Tạo tài khoản hoặc đăng nhập
3. Chọn model (ví dụ: `haui-admissions-model`)
4. Bắt đầu chat

**Ví dụ câu hỏi:**
- "Tôi muốn học CNTT, có điều kiện gì?"
- "Học phí bao nhiêu?"
- "Hạn nộp hồ sơ là khi nào?"

### Nạp Tài Liệu

#### Phương pháp 1: Upload qua Web UI
1. Open WebUI → Documents → Upload PDF
2. System tự động xử lý embedding

#### Phương pháp 2: Xử lý từ script
```bash
python src\rag_pipeline\pdf_processor.py --file data/admissions_guide.pdf
```

### Tùy Chỉnh Model

Chỉnh sửa `models/Modelfile`:

```dockerfile
FROM mistral:latest

SYSTEM """Bạn là trợ lý tuyển sinh HAUI...
[Chỉnh sửa system prompt tại đây]
"""

PARAMETER temperature 0.7
PARAMETER top_k 40
```

Sau đó:
```bash
ollama create haui-admissions-model -f models/Modelfile
```

## 🐛 Troubleshooting

### Ollama không chạy

```bash
# Kiểm tra status
ollama list

# Khởi động thủ công
ollama serve

# Kiểm tra kết nối
curl http://localhost:11434/api/tags
```

### PostgreSQL connection error

```bash
# Kiểm tra PostgreSQL
pg_isready

# Kiểm tra credentials trong .env
# Chắc chắn rằng:
# DB_HOST=localhost
# DB_USER=postgres
# DB_PASSWORD=[correct password]
```

### Open WebUI không lưu dữ liệu

Đảm bảo thư mục tồn tại:
```bash
mkdir open-webui\data
# Thư mục này sẽ chứa SQLite DB và ChromaDB
```

### Out of memory

```bash
# Sử dụng model nhẹ hơn
ollama run qwen2.5:1.5b

# Hoặc trong Modelfile
PARAMETER num_ctx 2048  # Giảm context window
```

## 🔐 Security

- **Environment variables**: Sử dụng `.env` cho credentials
- **Open WebUI**: Bảo vệ bằng username/password
- **PostgreSQL**: Không expose ra ngoài localhost
- **Ollama**: Chạy local, không công khai

## 📊 Kiến Trúc Hệ Thống

```
┌─────────────────┐
│ User Browser    │
└────────┬────────┘
         │ HTTP/WebSocket
┌────────▼──────────────┐
│   Open WebUI          │
│ (Chat Interface)      │
└────────┬──────────────┘
         │
┌────────▼──────────────┐
│  Ollama API           │
│ (Inference Engine)    │
└────────┬──────────────┘
         │ HTTP
         │
    ┌────┴────┐
    │          │
┌───▼──┐  ┌──▼───┐
│ LLM  │  │ RAG  │
│Model │  │Emb.  │
└──────┘  └──┬───┘
             │
┌────────────▼──────────────┐
│   PostgreSQL + ChromaDB   │
│  (Knowledge Base)         │
└───────────────────────────┘
```

## 🤝 Đóng Góp

1. Fork repository
2. Tạo feature branch (`git checkout -b feature/XYZ`)
3. Commit changes (`git commit -m 'Add XYZ'`)
4. Push to branch (`git push origin feature/XYZ`)
5. Open Pull Request

## 📞 Liên Hệ

- **Email**: admissions@haui.edu.vn
- **Website**: https://haui.edu.vn
- **Phone**: +84-24-XXXX-XXXX

## 📝 License

MIT License - Xem LICENSE file

## 🙏 Acknowledgments

- Ollama - LLM inference engine
- Open WebUI - Chat interface
- PostgreSQL - Database
- ChromaDB - Vector store
- LangChain - RAG pipeline
