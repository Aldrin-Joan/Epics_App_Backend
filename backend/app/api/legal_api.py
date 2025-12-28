from fastapi import APIRouter, UploadFile, File, HTTPException
from app.services.ai_service import AIService
from app.services.file_service import FileService
from pydantic import BaseModel

router = APIRouter(prefix="/legal", tags=["legal"])


class ChatQuery(BaseModel):
    message: str


@router.post("/ai-chat")
async def ai_chat(query: ChatQuery):
    response = await AIService.get_legal_advice(query.message)
    return {"response": response, "type": "text"}


@router.post("/upload-document")
async def upload_document(file: UploadFile = File(...)):
    allowed_extensions = ["pdf", "docx", "jpg", "jpeg", "png"]
    ext = file.filename.split(".")[-1].lower()

    if ext not in allowed_extensions:
        raise HTTPException(status_code=400, detail="File type not supported")

    content = await file.read()
    result = await FileService.process_document(content, file.filename)
    return result


@router.get("/lawyers")
async def get_lawyers():
    # Placeholder for lawyer discovery
    return [
        {
            "id": 1,
            "name": "Adv. Rajesh Kumar",
            "specialization": "Criminal Law",
            "rating": 4.8,
        },
        {
            "id": 2,
            "name": "Adv. Sneha Sharma",
            "specialization": "Corporate Law",
            "rating": 4.9,
        },
        {
            "id": 3,
            "name": "Adv. Anjali Menon",
            "specialization": "Family Law",
            "rating": 4.7,
        },
    ]
