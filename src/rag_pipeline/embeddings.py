"""
Embeddings Module for RAG Pipeline
Tạo và lưu trữ embeddings cho semantic search
"""

import logging
from typing import List, Optional
import numpy as np

logger = logging.getLogger(__name__)


class EmbeddingService:
    """Dịch vụ tạo embeddings"""
    
    def __init__(self, model_name: str = 'all-MiniLM-L6-v2'):
        self.model_name = model_name
        self.model = None
        self.load_model()
    
    def load_model(self):
        """Tải mô hình embedding"""
        try:
            from sentence_transformers import SentenceTransformer
            logger.info(f"Loading embedding model: {self.model_name}")
            self.model = SentenceTransformer(self.model_name)
            logger.info(f"✓ Model loaded successfully")
        except Exception as e:
            logger.error(f"✗ Error loading model: {e}")
            raise
    
    def embed_text(self, text: str) -> Optional[List[float]]:
        """Tạo embedding cho một đoạn text"""
        try:
            embedding = self.model.encode(text, convert_to_numpy=True)
            return embedding.tolist()
        except Exception as e:
            logger.error(f"✗ Error embedding text: {e}")
            return None
    
    def embed_texts(self, texts: List[str]) -> List[List[float]]:
        """Tạo embeddings cho danh sách texts"""
        try:
            embeddings = self.model.encode(texts, convert_to_numpy=True)
            return embeddings.tolist()
        except Exception as e:
            logger.error(f"✗ Error embedding texts: {e}")
            return []
    
    def similarity(self, embedding1: List[float], embedding2: List[float]) -> float:
        """Tính độ tương đồng giữa hai embeddings"""
        arr1 = np.array(embedding1)
        arr2 = np.array(embedding2)
        
        # Cosine similarity
        dot_product = np.dot(arr1, arr2)
        norm1 = np.linalg.norm(arr1)
        norm2 = np.linalg.norm(arr2)
        
        similarity = dot_product / (norm1 * norm2)
        return float(similarity)
    
    def top_k_similar(self, query_embedding: List[float], 
                     embeddings: List[List[float]], 
                     k: int = 5) -> List[tuple]:
        """Tìm k embeddings gần nhất"""
        similarities = []
        for i, emb in enumerate(embeddings):
            sim = self.similarity(query_embedding, emb)
            similarities.append((i, sim))
        
        # Sort by similarity descending
        similarities.sort(key=lambda x: x[1], reverse=True)
        
        return similarities[:k]


class VectorStore:
    """Lưu trữ vectors cho semantic search"""
    
    def __init__(self, embedding_service: Optional[EmbeddingService] = None):
        self.embedding_service = embedding_service or EmbeddingService()
        self.vectors = {}
        self.texts = {}
        self.metadata = {}
    
    def add(self, text_id: str, text: str, metadata: dict = None):
        """Thêm text vào vector store"""
        embedding = self.embedding_service.embed_text(text)
        if embedding:
            self.vectors[text_id] = embedding
            self.texts[text_id] = text
            self.metadata[text_id] = metadata or {}
            logger.info(f"Added vector: {text_id}")
    
    def search(self, query: str, k: int = 5) -> List[dict]:
        """Tìm kiếm semantic"""
        query_embedding = self.embedding_service.embed_text(query)
        if not query_embedding:
            return []
        
        embeddings_list = list(self.vectors.values())
        if not embeddings_list:
            return []
        
        similar = self.embedding_service.top_k_similar(query_embedding, embeddings_list, k)
        
        results = []
        text_ids = list(self.vectors.keys())
        for idx, similarity in similar:
            text_id = text_ids[idx]
            results.append({
                'id': text_id,
                'text': self.texts[text_id],
                'similarity': similarity,
                'metadata': self.metadata.get(text_id, {})
            })
        
        return results
    
    def size(self) -> int:
        """Kích thước vector store"""
        return len(self.vectors)


# Example usage
if __name__ == '__main__':
    # Test embedding service
    service = EmbeddingService()
    
    # Create embeddings
    texts = [
        "Tôi muốn học Công Nghệ Thông Tin",
        "Điểm chuẩn tuyển sinh là bao nhiêu?",
        "Học phí bao nhiêu tiền một năm?"
    ]
    
    embeddings = service.embed_texts(texts)
    print(f"Created {len(embeddings)} embeddings")
    print(f"Embedding dimension: {len(embeddings[0])}")
    
    # Test similarity
    sim = service.similarity(embeddings[0], embeddings[1])
    print(f"Similarity between texts 1 and 2: {sim:.4f}")
    
    # Test vector store
    store = VectorStore(service)
    for i, text in enumerate(texts):
        store.add(f"text_{i}", text)
    
    # Search
    results = store.search("CNTT admission", k=2)
    print("\nSearch results:")
    for result in results:
        print(f"- {result['id']}: {result['similarity']:.4f}")
