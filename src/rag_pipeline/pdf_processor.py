"""
PDF Processing Module for HAUI Admissions Chatbot
Xử lý tài liệu PDF và tạo embeddings cho RAG pipeline
"""

import os
import sys
import logging
from pathlib import Path
from typing import List, Tuple

import PyPDF2
from tqdm import tqdm
import argparse

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


class PDFProcessor:
    """Xử lý tệp PDF"""
    
    @staticmethod
    def extract_text(pdf_path: str) -> str:
        """Trích xuất văn bản từ PDF"""
        try:
            text = []
            with open(pdf_path, 'rb') as file:
                reader = PyPDF2.PdfReader(file)
                for page_num, page in enumerate(reader.pages):
                    page_text = page.extract_text()
                    if page_text:
                        text.append(page_text)
                        logger.info(f"Extracted page {page_num + 1}")
            
            full_text = '\n'.join(text)
            logger.info(f"✓ Successfully extracted {len(reader.pages)} pages from {Path(pdf_path).name}")
            return full_text
        except Exception as e:
            logger.error(f"✗ Error extracting PDF {pdf_path}: {e}")
            return ""
    
    @staticmethod
    def chunk_text(text: str, chunk_size: int = 512, overlap: int = 50) -> List[str]:
        """Chia văn bản thành các chunks"""
        if not text:
            return []
        
        words = text.split()
        chunks = []
        
        for i in range(0, len(words), chunk_size - overlap):
            chunk = ' '.join(words[i:i + chunk_size])
            if chunk.strip():
                chunks.append(chunk)
        
        logger.info(f"Created {len(chunks)} chunks")
        return chunks
    
    @staticmethod
    def process_pdf(pdf_path: str, chunk_size: int = 512, overlap: int = 50) -> Tuple[str, List[str]]:
        """Xử lý PDF hoàn toàn"""
        logger.info(f"Processing PDF: {pdf_path}")
        
        # Extract text
        text = PDFProcessor.extract_text(pdf_path)
        if not text:
            return None, []
        
        # Create chunks
        chunks = PDFProcessor.chunk_text(text, chunk_size, overlap)
        
        return text, chunks


class EmbeddingGenerator:
    """Tạo embeddings cho text chunks"""
    
    @staticmethod
    def generate_embeddings(chunks: List[str]) -> List[List[float]]:
        """Tạo embeddings cho danh sách chunks"""
        try:
            from sentence_transformers import SentenceTransformer
            
            logger.info("Loading embedding model...")
            model = SentenceTransformer('all-MiniLM-L6-v2')
            
            logger.info(f"Generating embeddings for {len(chunks)} chunks...")
            embeddings = []
            for i, chunk in enumerate(tqdm(chunks, desc="Creating embeddings")):
                embedding = model.encode(chunk, convert_to_numpy=True)
                embeddings.append(embedding.tolist())
            
            logger.info(f"✓ Generated {len(embeddings)} embeddings")
            return embeddings
        except Exception as e:
            logger.error(f"✗ Error generating embeddings: {e}")
            return []


def main():
    parser = argparse.ArgumentParser(description='Process PDF documents for HAUI Admissions')
    parser.add_argument('--file', '-f', help='Path to PDF file')
    parser.add_argument('--dir', '-d', help='Directory containing PDFs')
    parser.add_argument('--chunk-size', type=int, default=512, help='Chunk size (default: 512)')
    parser.add_argument('--overlap', type=int, default=50, help='Overlap size (default: 50)')
    parser.add_argument('--output', '-o', help='Output directory for processed files')
    
    args = parser.parse_args()
    
    # Process single file
    if args.file:
        logger.info(f"Processing single file: {args.file}")
        processor = PDFProcessor()
        text, chunks = processor.process_pdf(args.file, args.chunk_size, args.overlap)
        
        if text and chunks:
            logger.info("✓ PDF processed successfully")
            logger.info(f"  - Total text length: {len(text)} characters")
            logger.info(f"  - Chunks created: {len(chunks)}")
    
    # Process directory
    elif args.dir:
        logger.info(f"Processing directory: {args.dir}")
        pdf_dir = Path(args.dir)
        pdf_files = list(pdf_dir.glob('*.pdf'))
        
        if not pdf_files:
            logger.warning(f"No PDF files found in {args.dir}")
            return
        
        logger.info(f"Found {len(pdf_files)} PDF files")
        processor = PDFProcessor()
        
        for pdf_file in tqdm(pdf_files, desc="Processing PDFs"):
            text, chunks = processor.process_pdf(str(pdf_file), args.chunk_size, args.overlap)
    
    else:
        parser.print_help()


if __name__ == '__main__':
    main()
