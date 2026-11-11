import requests

class OllamaLLM:
    def __init__(self, model_name: str = "haui-chatbot", base_url: str = "http://localhost:11434"):
        self.model_name = model_name
        self.api_url = f"{base_url}/api/generate"

    def generate_response(self, prompt: str, context: str) -> str:
        full_prompt = f"Ngữ cảnh:\n{context}\n\nCâu hỏi:\n{prompt}"
        
        response = requests.post(
            self.api_url,
            json={
                "model": self.model_name,
                "prompt": full_prompt,
                "stream": False
            }
        )
        response.raise_for_status()
        return response.json()["response"]