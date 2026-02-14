import asyncio
from app.services.rag.rag_service import RAGService
from app.services.translation_service import TranslationService


rag_service = RAGService()
translator = TranslationService()


class AIService:

    @staticmethod
    async def get_legal_advice(query: str) -> str:
        # Step 1: Detect language
        source_lang = translator.detect_language(query)

        # Step 2: Translate to English if needed
        if source_lang != "en":
            query_en = translator.translate(query, source_lang, "en")
        else:
            query_en = query

        # Step 3: Run RAG in background thread (blocking call)
        answer_en = await asyncio.to_thread(rag_service.query, query_en)

        # Step 4: Translate answer back to original language
        if source_lang != "en":
            final_answer = translator.translate(answer_en, "en", source_lang)
        else:
            final_answer = answer_en

        return final_answer

    @staticmethod
    async def text_to_speech_placeholder(text: str) -> str:
        return "TTS not implemented yet"

    @staticmethod
    async def speech_to_text_placeholder(audio_data: bytes) -> str:
        return "STT not implemented yet"
