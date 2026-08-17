import json
import base64
import asyncio
from fastapi import FastAPI, WebSocket
from faster_whisper import WhisperModel
import httpx

# Import services and database connections
from app.services.audio_processor import process_audio_bytes
from app.services.scam_engine import evaluate_transcript_chunk
from app.db.connection import redis_client

app = FastAPI(title="SAS Transcription Server")

# Load model globally on startup
print("Loading Faster-Whisper model...")
model = WhisperModel("base.en", device="cpu", compute_type="int8")
print("Model loaded successfully.")

@app.websocket("/audiostream")
async def twilio_media_stream(websocket: WebSocket):
    await websocket.accept()
    print("Twilio WebSocket connected.")

    call_state = {
        "raw_score": 0.0,
        "total_score": 0.0,
        "matched_tripwires": {},
        "buckets_hit": set(),
        "is_scam": False
    }

    audio_buffer = bytearray()
    
    # 50 chunks * 2.5s = 125 chunks
    BUFFER_THRESHOLD = int(50 * 2.5) 
    chunk_count = 0

    try:
        while True:
            message = await websocket.receive_text()
            packet = json.loads(message)

            if packet['event'] == 'start':
                print("Stream started:", packet['start']['streamSid'])

            elif packet['event'] == 'media':
                # Extract base64 payload and append to buffer
                payload = packet['media']['payload']
                audio_bytes = base64.b64decode(payload)
                audio_buffer.extend(audio_bytes)
                chunk_count += 1

                # Process when buffer is full
                if chunk_count >= BUFFER_THRESHOLD:
                    audio_to_process = bytes(audio_buffer)
                    audio_buffer.clear()
                    chunk_count = 0
                    
                    # DSP Resampling (Sync)
                    audio_array = process_audio_bytes(audio_to_process)
                    
                    # Transcribe (Async thread to prevent blocking WebSocket)
                    segments, info = await asyncio.to_thread(
                        model.transcribe, audio_array, beam_size=1, language="en"
                    )
                    
                    transcript = "".join(segment.text for segment in segments).strip()
                    if transcript:
                        print(f"Caller: {transcript}")

                        # Scam Engine Scoring
                        call_state = await evaluate_transcript_chunk(
                            transcript, call_state, redis_client
                        )

                        if call_state["matched_tripwires"]:
                            print(f"Tripwires Hit: {list(call_state['matched_tripwires'].keys())}")
                            print(f"Score: {call_state['total_score']} / 1.5")

                        if call_state["is_scam"]:
                            print(f" POTENTIAL SCAM ! Threat score: {call_state['total_score']}")

                            try:
                                async with httpx.AsyncClient() as client:
                                    await client.post(
                                        "http://localhost:5000/alert",
                                        json={
                                        "phone_number": "Live Call Stream",
                                        "score": call_state["total_score"],
                                        "tripwires": list(call_state["matched_tripwires"].keys()),
                                        "is_scam": True
                                    },
                                    timeout=2.0
                                )
                            except Exception as err:
                                print(f"Failed to forward alert to Flask: {err}")
                            
            elif packet['event'] == 'stop':
                print("Stream stopped.")
                break

    except Exception as e:
        print(f"WebSocket Error: {e}")