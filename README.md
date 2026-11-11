# HAUI Admissions Chatbot

Hệ thống chatbot tuyển sinh thông minh sử dụng **Open WebUI + Ollama + PostgreSQL** cho Trường Đại học Công Nghiệp Hà Nội (HAUI).

## Features

- **Open WebUI** — Giao diện chat trực quan
- **Ollama LLM** — Mô hình ngôn ngữ local
- **PostgreSQL** — Lưu trữ tri thức tuyển sinh
- **RAG Pipeline** — Truy vấn ngữ cảnh thông minh
- **PDF Processing** — Nạp tài liệu HAUI
- **ChromaDB** — Vector store tích hợp

## System Requirements

- **OS**: Windows 10/11, macOS, Linux
- **Python**: 3.9+
- **PostgreSQL**: 14+
- **Ollama**: Latest
- **RAM**: 8GB minimum (16GB recommended)
- **Storage**: 20GB+ (for models and data)

## Quick Start

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
# Create database
createdb -U postgres haui_admissions

# Create schema
psql -U postgres -d haui_admissions -f db\schema.sql

# Load sample data
psql -U postgres -d haui_admissions -f db\seed_data.sql
```

### 4. Configure Environment

```bash
copy .env.example .env
# Edit .env with your credentials
```

### 5. Start Services

**Terminal 1 — Ollama:**
```bash
scripts\start_ollama.bat
```

**Terminal 2 — Open WebUI:**
```bash
scripts\start_webui.bat
```

**Terminal 3 — Backend (optional):**
```bash
# If you have Python backend
python src\main.py
```

### 6. Access

- **Open WebUI**: http://localhost:3000
- **Ollama API**: http://localhost:11434
- **PostgreSQL**: localhost:5432

## Project Structure

```
haui-admissions-chatbot/
├── open-webui/                 # Open WebUI runtime
│   └── data/                   # SQLite DB, ChromaDB, uploads
├── db/
│   ├── schema.sql              # PostgreSQL schema
│   ├── indexes.sql             # Database indices
│   └── seed_data.sql           # Sample data
├── docs/
│   ├── srs_document.md         # Requirements
│   ├── architecture.md         # System design
│   └── progress.md             # Development progress
├── models/
│   └── Modelfile               # Ollama model config
├── scripts/
│   ├── start_ollama.bat
│   └── start_webui.bat
├── src/
│   ├── rag_pipeline/
│   │   ├── pdf_processor.py
│   │   ├── chunker.py
│   │   └── embeddings.py
│   └── requirements.txt
├── .env.example
├── .gitignore
├── LICENSE
└── README.md
```

## Configuration

### PostgreSQL Schema

Key tables:
- `programs` — Academic programs
- `admissions_criteria` — Entry requirements
- `faq` — Frequently asked questions
- `chat_history` — Chat logs
- `embeddings` — Vector embeddings

### Ollama Models

```bash
# Pull models
ollama pull qwen2.5:1.5b       # Lightweight (~1.5GB)
ollama pull nomic-embed-text   # Embedding model

# Or alternatives
ollama pull mistral             # Stronger (~4GB)
ollama pull llama2              # Larger (~4GB)
```

### Open WebUI Configuration

- Data path: `./open-webui/data/`
- Ollama API: `http://localhost:11434`
- Port: 3000
- Database: Built-in SQLite + ChromaDB

## Usage

### Chat Interface

1. Open http://localhost:3000
2. Create account or login
3. Select model (e.g., `haui-admissions-model`)
4. Start chatting

**Example questions:**
- "I want to study IT, what are the requirements?"
- "What is the tuition fee?"
- "When is the application deadline?"

### Upload Documents

#### Method 1: Web UI Upload
1. Open WebUI → Documents → Upload PDF
2. System automatically processes embeddings

#### Method 2: Script Processing
```bash
python src\rag_pipeline\pdf_processor.py --file data/admissions_guide.pdf
```

### Customize Model

Edit `models/Modelfile`:

```dockerfile
FROM mistral:latest

SYSTEM """You are an HAUI admissions assistant...
[Customize system prompt here]
"""

PARAMETER temperature 0.7
PARAMETER top_k 40
```

Then:
```bash
ollama create haui-admissions-model -f models/Modelfile
```

## Troubleshooting

### Ollama not running

```bash
# Check status
ollama list

# Start manually
ollama serve

# Check connection
curl http://localhost:11434/api/tags
```

### PostgreSQL connection error

```bash
# Check PostgreSQL
pg_isready

# Verify credentials in .env
# Ensure:
# DB_HOST=localhost
# DB_USER=postgres
# DB_PASSWORD=[correct password]
```

### Open WebUI data not persisting

Ensure directory exists:
```bash
mkdir open-webui\data
# Contains SQLite DB and ChromaDB
```

### Out of memory

```bash
# Use lighter model
ollama run qwen2.5:1.5b

# Or in Modelfile
PARAMETER num_ctx 2048  # Reduce context window
```

## Security

- **Environment variables**: Use `.env` for credentials
- **Open WebUI**: Protect with username/password
- **PostgreSQL**: Not exposed outside localhost
- **Ollama**: Local only, not public

## System Architecture

```
User Devices (Browser)
         ↓ HTTP/WebSocket
┌────────────────────────┐
│   Open WebUI           │
│  (Chat Interface)      │
└────────┬───────────────┘
         ↓ HTTP
┌────────────────────────┐
│  Ollama API            │
│ (LLM Inference)        │
└────────┬───────────────┘
         ↓
    ┌────┴────┐
    ↓         ↓
┌────────┐ ┌──────┐
│  LLM   │ │ RAG  │
│ Model  │ │Search│
└────────┘ └──┬───┘
              ↓
      ┌───────────────────┐
      │ PostgreSQL +      │
      │ ChromaDB          │
      │ (Knowledge Base)  │
      └───────────────────┘
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/XYZ`)
3. Commit changes (`git commit -m 'Add XYZ'`)
4. Push to branch (`git push origin feature/XYZ`)
5. Open Pull Request

## Contact

- **Email**: admissions@haui.edu.vn
- **Website**: https://haui.edu.vn

## License

MIT License — See LICENSE file for details

## Acknowledgments

- Ollama — LLM inference engine
- Open WebUI — Chat interface
- PostgreSQL — Database
- ChromaDB — Vector store