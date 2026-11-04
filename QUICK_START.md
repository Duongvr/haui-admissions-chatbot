# Quick Start Guide - HAUI Admissions Chatbot

## 🚀 5-Minute Setup (Windows)

### Prerequisites
- Windows 10/11
- Python 3.9+
- PostgreSQL 14+
- Ollama installed
- Git (optional)

---

### Step 1: Prepare Python Environment

```bash
# Navigate to project
cd haui-admissions-chatbot

# Create virtual environment
python -m venv venv

# Activate
venv\Scripts\activate

# Install dependencies
pip install -r src\requirements.txt
```

**Expected time**: 3-5 minutes

---

### Step 2: Setup PostgreSQL

**Windows - Using pgAdmin or Command Line:**

```bash
# Create database
createdb -U postgres haui_admissions

# Login and run schema
psql -U postgres -d haui_admissions -f db\schema.sql

# Load sample data
psql -U postgres -d haui_admissions -f db\seed_data.sql
```

**Verify:**
```bash
psql -U postgres -d haui_admissions -c "SELECT COUNT(*) FROM haui_admissions.programs;"
```

Should return: 5 programs

---

### Step 3: Configure Environment

```bash
# Copy template
copy .env.example .env

# Edit .env - Change these lines:
DB_PASSWORD=your_postgres_password
```

**Important**: Make sure `DB_NAME=haui_admissions`

---

### Step 4: Start Services

**Terminal 1 - Start Ollama:**
```bash
scripts\start_ollama.bat
```

This will:
- Check if Ollama is running
- Pull `qwen2.5:1.5b` model (~1.5GB)
- Pull `nomic-embed-text` (embeddings)
- Display available models

⏱️ Wait until you see: `[OK] Ollama started successfully!`

---

**Terminal 2 - Start Open WebUI:**
```bash
scripts\start_webui.bat
```

This will:
- Create `open-webui/data` directory
- Start Open WebUI on port 3000
- Connect to Ollama

---

### Step 5: Access the Chatbot

**Open browser:**
```
http://localhost:3000
```

**First time setup:**
1. Create an account (username/password)
2. Login
3. Select model: `qwen2.5:1.5b` or `mistral`
4. Start chatting!

---

## 💬 Try These Prompts

```
1. "Tôi muốn học chuyên ngành CNTT, có điều kiện gì?"
2. "Học phí chương trình KTXD bao nhiêu?"
3. "Hạn chót đăng ký tuyển sinh là khi nào?"
4. "Có học bổng cho sinh viên không?"
5. "Cơ sở vật chất của trường như thế nào?"
```

---

## 🔍 Verify Installation

### Check Components

**1. PostgreSQL:**
```bash
psql -U postgres -d haui_admissions -c "SELECT name FROM haui_admissions.programs LIMIT 3;"
```

Expected: 3 program names

**2. Ollama:**
```bash
curl http://localhost:11434/api/tags
```

Expected: JSON with available models

**3. Open WebUI:**
```
http://localhost:3000
```

Expected: Chatbot interface loads

---

## 📁 Project Structure Reference

```
open-webui/data/           ← Runtime data (auto-created)
db/
  ├── schema.sql           ← PostgreSQL tables
  └── seed_data.sql        ← Sample data
docs/
  ├── srs_document.md      ← Requirements
  └── architecture.md      ← System design
models/
  └── Modelfile            ← Custom model config
scripts/
  ├── start_ollama.bat     ← Start Ollama
  └── start_webui.bat      ← Start WebUI
src/
  ├── requirements.txt     ← Python packages
  └── rag_pipeline/        ← PDF processing
.env.example               ← Config template
.gitignore                 ← Git ignore
README.md                  ← Full documentation
```

---

## 🐛 Troubleshooting

### Issue: "Ollama not found"
```bash
# Install from https://ollama.ai
# Or check PATH: where ollama
```

### Issue: "psql command not found"
```bash
# Add PostgreSQL to PATH
# Control Panel → System → Environment Variables
# Add: C:\Program Files\PostgreSQL\16\bin
```

### Issue: "Port 3000 already in use"
```bash
# Change port in start_webui.bat:
# SET WEBUI_PORT=3001
```

### Issue: "Database connection failed"
```bash
# Check PostgreSQL is running:
pg_isready

# Check credentials in .env match your setup:
DB_USER=postgres
DB_PASSWORD=your_actual_password
```

### Issue: "Out of memory"
```bash
# Use lighter model in Ollama:
ollama run qwen2.5:1.5b

# Or reduce context window in models/Modelfile:
PARAMETER num_ctx 2048
```

---

## 📚 Next Steps

1. **Add Custom Data**
   - Place PDF files in `data/pdfs/`
   - Upload via Open WebUI Documents
   - System will auto-process

2. **Customize Model**
   - Edit `models/Modelfile`
   - Change system prompt
   - Run: `ollama create haui-admissions-model -f models/Modelfile`

3. **Connect to Real Ollama Model**
   - Create better custom model with your own prompt
   - Train on HAUI-specific documents

4. **Setup Admissions Staff Dashboard**
   - Access chat analytics
   - Review FAQs performance
   - Monitor system health

---

## 📞 Support

- **Ollama Issues**: https://github.com/ollama/ollama
- **Open WebUI Issues**: https://github.com/open-webui/open-webui
- **PostgreSQL Issues**: https://www.postgresql.org/docs/
- **HAUI Admissions**: admissions@haui.edu.vn

---

## ✅ Success Checklist

- [ ] Python 3.9+ installed
- [ ] PostgreSQL running with haui_admissions database
- [ ] .env configured with correct credentials
- [ ] Ollama serving on port 11434
- [ ] Open WebUI running on port 3000
- [ ] Can login to http://localhost:3000
- [ ] Can see chat interface
- [ ] Can chat with model
- [ ] Responses appear within 3 seconds

**All checked?** 🎉 Your chatbot is ready!

---

**Happy chatting! 💬**
