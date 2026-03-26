import requests

class Generator:
    def __init__(self, model="mistral"):
        self.model = model

    def generate(self, query, context):
        prompt = f"""
You are a legal assistant.
Use ONLY the provided context to answer.

Context:
{context}

Question:
{query}

Answer:
"""

        response = requests.post(
            "http://localhost:11434/api/generate",
            json={
                "model": self.model,
                "prompt": prompt,
                "stream": False
            }
        )

        return response.json()["response"]
