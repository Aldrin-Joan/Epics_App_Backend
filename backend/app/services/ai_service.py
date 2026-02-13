import asyncio
from app.services.rag.rag_service import RAGService

rag_service = RAGService()


class AIService:

    @staticmethod
    async def get_legal_advice(query: str) -> str:
        # Run blocking RAG in thread pool to avoid blocking event loop
        response = await asyncio.to_thread(rag_service.query, query)
        return response

    @staticmethod
    async def text_to_speech_placeholder(text: str) -> str:
        return "TTS not implemented yet"

    @staticmethod
    async def speech_to_text_placeholder(audio_data: bytes) -> str:
        return "STT not implemented yet"
