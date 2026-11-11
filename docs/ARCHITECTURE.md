# System Architecture
## HAUI Admissions Chatbot

---

## 1. Overall Architecture

```
User Devices (Browser, Mobile)
            ↓
┌─────────────────────────────┐
│      Open WebUI              │
│  - Chat Interface           │
│  - Document Upload          │
│  - Session Management       │
└──────────┬──────────────────┘
           │ WebSocket/HTTP
           │
┌──────────▼──────────────────┐
│   Ollama LLM Service         │
│  - Model Inference           │
│  - Embedding Generation      │
│  - Response Streaming        │
└──────────┬──────────────────┘
           │ HTTP API
           │
    ┌──────┴──────┐
    ↓             ↓
┌────────────┐ ┌──────────────┐
│ChromaDB    │ │ PostgreSQL    │
│(Vectors)   │ │(Relational)   │
└────────────┘ └──────────────┘
```

---

## 2. Component Details

### 2.1 Open WebUI
**Purpose**: User interface layer
**Features**:
- Real-time chat interface
- File upload and processing
- Session management
- Admin dashboard
- Settings configuration

**Database**: SQLite (embedded in Open WebUI)
**Port**: 3000

### 2.2 Ollama LLM Service
**Purpose**: Natural language processing and generation
**Features**:
- LLM inference (Mistral, Qwen, etc.)
**URL**: http://localhost:11434
**Models Available**:
- `qwen2.5:1.5b` - Lightweight (1.5GB)
- `mistral:latest` - Balanced (4GB)
- `nomic-embed-text` - Embeddings

### 2.3 PostgreSQL Database
**Purpose**: Persistent data storage
**Tables**:
- programs
- admissions_criteria
- faq
- chat_history
- documents
- admission_calendar
- user_sessions
**Port**: 5432

### 2.4 ChromaDB Vector Store
**Purpose**: Semantic search via embeddings
**Features**:
- Vector storage
- Similarity search
- Metadata filtering
**Integration**: Open WebUI integrates ChromaDB

### 2.5 RAG Pipeline (Python)
**Purpose**: Context retrieval and generation
**Components**:
- PDF processor (pdf_processor.py)
- Text chunker (chunker.py)
- Embedding generator (embeddings.py)

---

## 3. Data Flow

### 3.1 Chat Query Flow
```
1. User types message in Open WebUI
   ↓
2. Message sent to Ollama API
   ↓
3. RAG Pipeline triggered:
   - Query embedding generated
   - Similar documents retrieved from ChromaDB
   - FAQ search on PostgreSQL
   - Program info lookup
   ↓
4. Context assembled with retrieval results
   ↓
5. Ollama generates response with context
   ↓
6. Response stored in PostgreSQL chat_history
   ↓
7. Response displayed in Open WebUI
```

### 3.2 Document Ingestion Flow
```
1. Admin uploads PDF via Open WebUI
   ↓
2. PDF processor extracts text
   ↓
3. Text split into chunks
   ↓
4. Embeddings generated for each chunk
   ↓
5. Vectors stored in ChromaDB
   ↓
6. Document metadata saved to PostgreSQL
   ↓
7. Ready for RAG retrieval
```

---

## 4. Database Schema

### 4.1 Core Tables

**programs**
```sql
- id (PK)
- code (UNIQUE)
- name
- description
- faculty
- tuition_fee
- admission_score_min
- admission_score_max
- capacity
- is_active
```

**faq**
```sql
- id (PK)
- category
- question
- answer
- program_id (FK)
- keyword
- is_active
```

**chat_history**
```sql
- id (PK)
- session_id
- user_message
- bot_response
- model_used
- response_time_ms
- created_at
```

**documents**
```sql
- id (PK)
- title
- content (TEXT)
- document_type
- source_file
- created_by
- is_active
```

**embeddings**
```sql
- id (PK)
- document_id (FK)
- chunk_text
- embedding (FLOAT8[])
- chunk_index
```

---

## 5. Deployment Architecture

### 5.1 Single-Machine Deployment
```
Local Machine (Windows/Mac/Linux)
│
├── PostgreSQL (port 5432)
├── Ollama (port 11434)
└── Open WebUI (port 3000)
    ├── ChromaDB
    └── SQLite DB
```

### 5.2 Directory Structure
```
haui-admissions-chatbot/
├── open-webui/data/          # Runtime data (ChromaDB, SQLite)
├── db/                       # Database scripts
├── src/rag_pipeline/         # RAG implementation
├── models/Modelfile          # Custom Ollama config
└── scripts/                  # Startup scripts
```

---

## 6. RAG Pipeline Details

### 6.1 Retrieval Process
```
Query Input
    ↓
1. Embedding Generation
   - Convert query to vector using nomic-embed-text
   ↓
2. Semantic Search (ChromaDB)
   - Find similar documents by vector similarity
   - Top-5 most similar chunks
   ↓
3. Database Lookup (PostgreSQL)
   - FAQ keyword search
   - Program information matching
   ↓
4. Context Assembly
   - Combine all retrieved results
   - Format with metadata
   ↓
5. Augmented Prompt to LLM
   - Include context in system prompt
   - Generate response
```

### 6.2 Generation Process
```
Augmented Prompt (with context)
    ↓
1. Ollama LLM Processing
   - Temperature: 0.6 (balanced)
   - Top-k: 40
   - Top-p: 0.9
   ↓
2. Token Generation
   - Streaming response
   - Max tokens: 1024
   ↓
3. Response Formatting
   - Clean markdown
   - Add source attribution
   ↓
4. User Display
```

---

## 7. Security Architecture

### 7.1 Data Protection
- PostgreSQL on localhost only
- Environment variables for credentials (.env)
- SQL parameterized queries
- Input validation and sanitization

### 7.2 Access Control
- Open WebUI authentication
- Session tokens
- HTTPS ready (can be proxied)

### 7.3 Data Privacy
- Chat history stored encrypted
- No PII logging
- Optional data retention policies

---

## 8. Scalability Considerations

### 8.1 Horizontal Scaling
- Multiple Ollama instances (load balancer needed)
- PostgreSQL replication (future)
- ChromaDB clustering (future)

### 8.2 Vertical Scaling
- GPU support for Ollama
- PostgreSQL optimization (indexing)
- Caching layer (Redis optional)

### 8.3 Performance Optimization
- Vector index optimization
- Query caching
- Batch processing
- Connection pooling

---

## 9. Monitoring & Logging

### 9.1 Metrics to Track
- Chat response time
- LLM inference latency
- Vector search latency
- Database query time
- User session count
- Error rates

### 9.2 Logging Strategy
- Application logs (INFO, WARNING, ERROR)
- Audit logs (user actions)
- Database query logs
- LLM API logs

---

## 10. Technology Decisions

| Component | Choice | Reasoning |
|-----------|--------|-----------|
| Frontend | Open WebUI | Pre-built UI, ChromaDB integration |
| LLM | Ollama | Local, privacy, no API costs |
| Database | PostgreSQL | Mature, reliable, good RAG support |
| Vector DB | ChromaDB | Integrated with Open WebUI |
| Language | Python | Rich ML ecosystem, easy deployment |
| OS | Windows/Mac/Linux | Broad compatibility |

---

## 11. Future Enhancements

- Multi-language support
- Advanced NLP (intent classification, NER)
- User feedback system
- A/B testing framework
- Admin analytics dashboard
- Email notification system
- SMS integration
- Telegram/Discord bots
- Mobile app
