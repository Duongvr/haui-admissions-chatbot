import requests

class OllamaEmbedder:
    def __init__(self, model_name: str = "nomic-embed-text", base_url: str = "http://localhost:11434"):
        self.model_name = model_name
        self.api_url = f"{base_url}/api/embeddings"

    def get_embedding(self, text: str) -> list[float]:
        response = requests.post(
            self.api_url,
            json={"model": self.model_name, "prompt": text}
        )
        response.raise_for_status()
        return response.json()["embedding"]