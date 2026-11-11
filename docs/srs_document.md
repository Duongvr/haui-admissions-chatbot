# Software Requirements Specification (SRS)
## HAUI Admissions Chatbot

**Version**: 1.0  
**Date**: November 2024  
**Status**: Draft

---

## 1. Executive Summary

The HAUI Admissions Chatbot is an AI-powered conversational system designed to assist prospective students with admissions inquiries at Hanoi University of Industry (HAUI). The system integrates Open WebUI for user interface, Ollama for LLM inference, and PostgreSQL for knowledge base storage.

---

## 2. System Overview

### 2.1 Purpose
- Provide instant responses to admission questions
- Reduce workload on admissions staff
- Improve student experience during application process
- Collect analytics on student inquiries

### 2.2 Key Features
- Natural language conversational interface
- Context-aware responses using RAG (Retrieval Augmented Generation)
- PDF document processing and indexing
- Multi-language support (Vietnamese, English)
- Session-based chat history
- Admin dashboard for analytics

### 2.3 Technology Stack
- **Frontend**: Open WebUI + WebSocket
- **Backend**: Ollama (LLM) + ChromaDB (Vector Store)
- **Database**: PostgreSQL
- **Processing**: Python 3.9+
- **Deployment**: Local (No Docker)

---

## 3. Functional Requirements

### FR1: Chat Interface
- **FR1.1**: Accept user messages in Vietnamese and English
- **FR1.2**: Generate contextual responses using Ollama
- **FR1.3**: Maintain conversation history per session
- **FR1.4**: Support follow-up questions with context awareness
- **FR1.5**: Display response time and source attribution

### FR2: Knowledge Management
- **FR2.1**: Store FAQ entries with categorization
- **FR2.2**: Maintain program information database
- **FR2.3**: Support PDF document uploads
- **FR2.4**: Auto-index documents with embeddings
- **FR2.5**: Implement semantic search

### FR3: RAG Pipeline
- **FR3.1**: Retrieve relevant context for queries
- **FR3.2**: Generate embeddings for documents
- **FR3.3**: Perform similarity matching
- **FR3.4**: Return source attribution

### FR4: User Session Management
- **FR4.1**: Generate unique session IDs
- **FR4.2**: Track conversation history
- **FR4.3**: Store user preferences
- **FR4.4**: Implement session timeout

### FR5: Analytics & Reporting
- **FR5.1**: Log all conversations
- **FR5.2**: Track frequently asked questions
- **FR5.3**: Analyze user satisfaction
- **FR5.4**: Generate monthly reports

---

## 4. Non-Functional Requirements

### NFR1: Performance
- Response time < 3 seconds (95th percentile)
- Support 100+ concurrent users
- Database query optimization
- Vector search latency < 1 second

### NFR2: Reliability
- 99.5% uptime SLA
- Graceful error handling
- Connection recovery
- Data backup daily

### NFR3: Security
- HTTPS for all communications
- Input validation and sanitization
- SQL injection prevention
- Secure credential storage in .env

### NFR4: Scalability
- Horizontal scaling capability
- Connection pooling
- Caching layer ready
- Microservice-ready architecture

### NFR5: Usability
- Responsive design (desktop, mobile, tablet)
- Vietnamese-first interface
- Intuitive navigation
- WCAG 2.1 Level AA compliance

---

## 5. Data Requirements

### 5.1 Database Schema
- **programs**: Academic programs (code, name, faculty, fees, scores)
- **admissions_criteria**: Entry requirements per program
- **faq**: Frequently asked questions with categories
- **chat_history**: User conversations and analytics
- **documents**: Uploaded PDF documents
- **embeddings**: Vector embeddings for semantic search
- **admission_calendar**: Important dates and deadlines
- **user_sessions**: Session tracking

### 5.2 Data Quality
- Accurate program information
- Up-to-date admission dates
- Well-organized FAQ entries
- Clean document text extraction

---

## 6. System Architecture

```
┌──────────────┐
│ User Browser │
└──────┬───────┘
       │
┌──────▼────────────────┐
│   Open WebUI           │
│  (Chat Interface)      │
└──────┬────────────────┘
       │ HTTP/WebSocket
       │
┌──────▼────────────┐
│  Ollama API        │
│  (LLM Inference)   │
└──────┬────────────┘
       │
   ┌───┴───┐
   │       │
┌──▼──┐ ┌─▼────┐
│ LLM │ │ RAG  │
│Model│ │Search│
└─────┘ └──┬───┘
            │
┌───────────▼───────────────┐
│ PostgreSQL + ChromaDB      │
│ (Knowledge Base)           │
└────────────────────────────┘
```

---

## 7. Constraints & Assumptions

### 7.1 Constraints
- No Docker deployment (local setup only)
- PostgreSQL required (no other databases)
- Ollama for LLM (no cloud APIs)
- Windows/Mac/Linux support
- 20GB+ storage requirement

### 7.2 Assumptions
- Users have internet connectivity
- Modern web browser available
- HAUI provides accurate data
- PostgreSQL and Ollama pre-installed

---

## 8. Acceptance Criteria

- ✓ Chat responds to admission questions accurately
- ✓ RAG retrieves relevant context from database
- ✓ PDF processing extracts text correctly
- ✓ Open WebUI displays chat interface properly
- ✓ PostgreSQL stores all data persistently
- ✓ Embeddings generated for all documents
- ✓ Response time < 3 seconds on average
- ✓ Web UI responsive on mobile/desktop
- ✓ Error handling prevents crashes
- ✓ Admissions staff can access analytics

---

## 9. Success Metrics

- User satisfaction score > 4.0/5.0
- Chatbot answer accuracy > 85%
- Average response time < 2 seconds
- 80% of questions answered without human escalation
- Monthly active users growth > 20%
- System uptime > 99.5%

---

## Appendix: Glossary

- **RAG**: Retrieval Augmented Generation
- **LLM**: Large Language Model
- **ChromaDB**: Vector database
- **Embedding**: Vector representation of text
- **Session ID**: Unique identifier for conversation
- **FAQ**: Frequently Asked Questions
