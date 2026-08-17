Synthetic Audio Shield

1. Summary
   This project aims for the development of a "Digital Guardian", a comprehensive software ecosystem designed to protect vulnerable demographics, particularly the elderly, individuals with early-stage cognitive decline, and visually impaired users, from telecommunications fraud.
   The rise of AI-generated synthetic voices (voice cloning) and highly targeted social engineering scripts presents a critical security and loss of finances to populations least equipped to identify them.
   Paired with a highly accessible, assistive mobile application, this project addresses the critical intersection of cybersecurity, mental health support, and digital accessibility.
   Features:
1. SAS - synthetic audio shield
1. Warn Spam calls - Identify and store numbers reported by users and warn users if its likely a spam
1. Identify Scam Script using keywords used in scam calls - warn users to not divulge sensitive information

Two backend processes
Flask -> answers Twilio's sync webhook and talks to phone
FastAPI -> captures audio websocket and runs transcription

HOW TO RUN?

1. Install Python 3.11 or 3.12
2. cd backend && python -m venv .venv && source .venv/bin/activate
3. pip install -r requirements.txt
4. install Postgres 16 + Redis 7 -> createdb synthetic_audio_shield
   psql -c "CREATE USER sas_user WITH PASSWORD 'sas_password';"
   psql -c "GRANT ALL PRIVILEGES ON DATABASE synthetic_audio_shield TO sas_user;"
   AND seed db
   From backend/: python data/seed_db.py
5. python -c "import nltk; nltk.download('vader_lexicon)
6. python data/seed_db.py -> which will load the ngram data
7. pytest
8. starting servers
   python -m app.main_flask (port 5000)
   From backend/: uvicorn app.main_fastapi:app --host 0.0.0.0 --port 9000
   ngrok tunnel

For Front end
Requirements : macOS + Xcode + CocoaPods & Apple developer account with APN push credential for Twilio VOIP push notifications
-- This features have been tested and demonstration is done on presentation video uploaded along with the project.
