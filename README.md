# LegalTech Super-App

A modern LegalTech Super-App connecting users with legal resources and lawyers. It features an AI-powered legal chatbot, secure file processing, and a professional social network for legal professionals.

## 🚀 Tech Stack

- **Frontend:** Flutter (Material 3), Riverpod (State Management), GoRouter (Routing).
- **Backend:** Python, FastAPI (Asynchronous & WebSocket support).
- **Database:** SQLModel (PostgreSQL logic Ready).
- **Localization:** 6 Languages supported (English, Tamil, Hindi, Malayalam, Kannada, Telugu).
- **Communication:** REST APIs & WebSockets for real-time chat.

## ✨ Core Features

### 1. Multilingual Support

- Dynamic language switching in the UI.
- Supported: English, Tamil (தமிழ்), Hindi (हिन्दी), Malayalam (മലയാളം), Kannada (ಕನ್ನಡ), Telugu (తెలుగు).

### 2. Dual-Dashboard Architecture

- **Client Dashboard:** AI Legal Chat, Document Upload/Parsing (OCR Ready), Lawyer Discovery.
- **Lawyer Dashboard:** Professional Feed (LinkedIn style), Client Inbox, Advanced AI legal tools.

### 3. Legal AI Chat

- Interactive chat interface for case details.
- Voice query support (Microphone integration placeholder).
- Placeholder LLM and Speech-to-Text services for future integration.

### 4. Professional Social Network

- Ability for lawyers to create posts and view professional updates.
- Real-time client-lawyer messaging via WebSockets.

---

## 🛠️ Setup and Installation

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Python 3.10+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/)

### Backend Setup (FastAPI)

1. **Navigate to the backend directory:**

   ```bash
   cd backend
   ```
2. **Create a virtual environment:**

   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```
3. **Install dependencies:**

   ```bash
   pip install -r requirements.txt
   ```
4. **Create a .env file:**
   A template has been created at `backend/.env`. Update the `SECRET_KEY` and other variables as needed.
5. **Start the FastAPI server:**

   ```bash
   python app/main.py
   ```

   The API will be available at `http://localhost:8000`. You can view the Interactive Docs at `http://localhost:8000/docs`.

### Frontend Setup (Flutter)

1. **Install Flutter dependencies:**

   ```bash
   flutter pub get
   ```
2. **Generate localization files:**

   ```bash
   flutter gen-l10n
   ```
3. **Run the application:**

   ```bash
   flutter emulators --launch Medium_Phone_API_35

   flutter run
   ```

---

## 🧪 Testing

### Backend Tests

The backend includes a `pytest` suite for verifying Auth, AI Chat, and Discovery APIs.

1. **Run tests from the root directory:**
   ```bash
   # Set PYTHONPATH to include the backend folder
   set PYTHONPATH=%PYTHONPATH%;%cd%\backend
   pytest tests/test_backend.py
   ```

---

## 📂 Project Structure

```text
legal_ai_app/
├── backend/                # FastAPI Application
│   ├── app/
│   │   ├── api/            # API Routes (Auth, Legal, Chat WS)
│   │   ├── core/           # Security and Auth utilities
│   │   ├── models/         # SQLModel Schemas
│   │   ├── services/       # AI and File Processing Placeholders
│   │   └── main.py         # Entry Point
│   └── requirements.txt    # Python Dependencies
├── lib/                    # Flutter Application
│   ├── l10n/               # Multilingual Arb files
│   ├── providers/          # Riverpod State Management
│   ├── screens/            # UI Screens (Auth, Dashboards, AI Chat)
│   └── main.dart           # App Entry Point
├── tests/                  # Backend Pytest Suite
└── README.md
```

## 🔐 Security Standards

- **JWT Authentication:** Secure token-based auth flow.
- **Bcrypt Hashing:** Industry-standard password security.
- **Input Sanitization:** Protects against injection and common attacks.
- **Thread Safety:** Efficient async handling in FastAPI.
