"""
Text Chunking Module for RAG Pipeline
Chia nhỏ văn bản thành các chunks tối ưu cho embedding
"""

import logging
from typing import List

logger = logging.getLogger(__name__)


class TextChunker:
    """Chia văn bản thành các chunks"""
    
    @staticmethod
    def chunk_by_tokens(text: str, chunk_size: int = 512, overlap: int = 50) -> List[str]:
        """Chia văn bản dựa vào số từ (tokens xấp xỉ)"""
        words = text.split()
        chunks = []
        
        for i in range(0, len(words), chunk_size - overlap):
            chunk = ' '.join(words[i:i + chunk_size])
            if len(chunk.strip()) > 10:
                chunks.append(chunk)
        
        return chunks
    
    @staticmethod
    def chunk_by_sentences(text: str, sentences_per_chunk: int = 5, overlap: int = 1) -> List[str]:
        """Chia văn bản dựa vào câu"""
        import re
        
        # Split by sentences
        sentences = re.split(r'(?<=[.!?])\s+', text)
        chunks = []
        
        for i in range(0, len(sentences), sentences_per_chunk - overlap):
            chunk = ' '.join(sentences[i:i + sentences_per_chunk])
            if chunk.strip():
                chunks.append(chunk)
        
        return chunks
    
    @staticmethod
    def chunk_by_paragraphs(text: str, overlap: int = 1) -> List[str]:
        """Chia văn bản dựa vào đoạn văn"""
        paragraphs = text.split('\n\n')
        chunks = []
        
        for i, para in enumerate(paragraphs):
            if para.strip():
                chunks.append(para)
        
        return chunks
    
    @staticmethod
    def smart_chunk(text: str, target_size: int = 512, overlap: int = 50) -> List[str]:
        """Smart chunking: cố gắng giữ câu nguyên vẹn"""
        import re
        
        # Split into sentences
        sentences = re.split(r'(?<=[.!?])\s+', text)
        
        chunks = []
        current_chunk = []
        current_size = 0
        
        for sentence in sentences:
            sentence_size = len(sentence.split())
            
            if current_size + sentence_size > target_size and current_chunk:
                # Save current chunk
                chunk_text = ' '.join(current_chunk)
                chunks.append(chunk_text)
                
                # Start new chunk with overlap
                overlap_sentences = []
                overlap_size = 0
                for s in reversed(current_chunk):
                    s_size = len(s.split())
                    if overlap_size + s_size <= overlap:
                        overlap_sentences.insert(0, s)
                        overlap_size += s_size
                    else:
                        break
                
                current_chunk = overlap_sentences + [sentence]
                current_size = overlap_size + sentence_size
            else:
                current_chunk.append(sentence)
                current_size += sentence_size
        
        # Add remaining chunk
        if current_chunk:
            chunks.append(' '.join(current_chunk))
        
        return chunks


def test_chunking():
    """Test different chunking strategies"""
    sample_text = """
    Trường Đại học Công Nghiệp Hà Nội (HAUI) là một trường đại học hàng đầu về đào tạo kỹ thuật.
    Chúng tôi cung cấp nhiều chương trình học bao gồm Công Nghệ Thông Tin, Kỹ Thuật Xây Dựng, 
    và Kỹ Thuật Vận Tải. Sinh viên của chúng tôi luôn đạt được thành tích cao trong cuộc thi 
    quốc tế và được các công ty hàng đầu tuyển dụng.
    """
    
    chunker = TextChunker()
    
    print("=== Token-based chunking ===")
    chunks = chunker.chunk_by_tokens(sample_text, chunk_size=20, overlap=5)
    for i, chunk in enumerate(chunks):
        print(f"Chunk {i+1}: {chunk[:50]}...")
    
    print("\n=== Sentence-based chunking ===")
    chunks = chunker.chunk_by_sentences(sample_text)
    for i, chunk in enumerate(chunks):
        print(f"Chunk {i+1}: {chunk[:50]}...")
    
    print("\n=== Smart chunking ===")
    chunks = chunker.smart_chunk(sample_text, target_size=30)
    for i, chunk in enumerate(chunks):
        print(f"Chunk {i+1}: {chunk[:50]}...")


if __name__ == '__main__':
    test_chunking()
