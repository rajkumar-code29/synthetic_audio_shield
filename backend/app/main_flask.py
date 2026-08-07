import os
import asyncio
import traceback
from flask import Flask, request, jsonify
from flask_socketio import SocketIO, emit
from twilio.twiml.voice_response import VoiceResponse, Dial, Start
from twilio.jwt.access_token import AccessToken
from twilio.jwt.access_token.grants import VoiceGrant
from app.services.lookup_service import check_number_reputation
from dotenv import load_dotenv
load_dotenv()  # Load environment variables from .env file

app = Flask(__name__)
socketio = SocketIO(app, cors_allowed_origins="*")

# Twilio Credentials
TWILIO_ACCOUNT_SID = os.environ.get('TWILIO_ACCOUNT_SID')
TWILIO_API_KEY = os.environ.get('TWILIO_API_KEY')
TWILIO_API_SECRET = os.environ.get('TWILIO_API_SECRET')
TWILIO_TWIML_APP_SID = os.environ.get('TWILIO_TWIML_APP_SID')
TWILIO_PUSH_CREDENTIAL_SID = os.environ.get('TWILIO_PUSH_CREDENTIAL_SID')

WEB_SOCKET_URL = os.environ.get('WEB_SOCKET_URL', 'ws://54.175.77.125:9000/audiostream')
IDENTITY = 'synthetic_audio_shield_ios'
connected_sessions = {}

@socketio.on('connect')
def handle_connect():
    print("SAS app linked successfully.")
    connected_sessions[IDENTITY] = request.sid #type: ignore because sid is not in the type of request

@app.route("/voice", methods=['POST'])
def voice():
    try:
        response = VoiceResponse()
        caller = request.form.get('From', '')
        
        print(f"\n=== Incoming twilio webhook ===")
        print(f"Caller (From): {caller}")

        threat_data = None
        # execute the async lookup without crashing Flask's event loop
        try:
            loop = asyncio.new_event_loop()
            asyncio.set_event_loop(loop)
            threat_data = loop.run_until_complete(check_number_reputation(caller))
            loop.close()
        except Exception as async_err:
            print(f"Failed to look up number reputation: {async_err}")

        # Mandatory warning message GDPR compliance
        response.say("Please note that this call is being monitored for security purposes.")

        if threat_data:
            print(f"ALERT: Potential scam number detected! Reports: {threat_data.get('report_count', 0)}")
            
            # Push notification to the app with details
            app_sid = connected_sessions.get(IDENTITY)
            if app_sid:
                socketio.emit('scam_alert', threat_data, to=app_sid)
            else:
                print("Frontend app is not currently connected to SocketIO.")

        # Forking the audio to FastAPI on port 9000
        start = Start()
        start.stream(url=WEB_SOCKET_URL)
        response.append(start)

        dial = Dial(timeout=30)
        dial.client(IDENTITY)
        response.append(dial)

        return str(response), 200, {'Content-Type': 'text/xml'}

    except Exception as e:
        
        print("\n Flask Error in /voice:")
        traceback.print_exc()
        
        # Return a valid 50-byte TwiML response
        fallback_twiml = "<Response><Say>A system error occurred. Hanging up.</Say></Response>"
        return fallback_twiml, 200, {'Content-Type': 'text/xml'}

@app.route("/token", methods=['GET'])
def token():
    token = AccessToken(
        TWILIO_ACCOUNT_SID,
        TWILIO_API_KEY,
        TWILIO_API_SECRET,
        identity=IDENTITY
    )

    voice_grant = VoiceGrant(
        outgoing_application_sid=TWILIO_TWIML_APP_SID,
        incoming_allow=True,
        push_credential_sid=TWILIO_PUSH_CREDENTIAL_SID
    )
    token.add_grant(voice_grant)

    return jsonify(token=token.to_jwt())


@app.route("/alert", methods=['POST'])
def trigger_alert():
    """Endpoint for FastAPI to send real-time scam alerts to Flutter."""
    data = request.get_json()
    app_sid = connected_sessions.get(IDENTITY)
    
    if app_sid and data:
        print(f"Sending scam alert to Flutter app: {data}")
        socketio.emit('scam_alert', data, to=app_sid)
        return jsonify({"status": "alert_sent"}), 200
    
    print("Flutter app not connected via SocketIO.")
    return jsonify({"status": "app_not_connected"}), 404

if __name__ == "__main__":
    # Running Flask on 5000 and FastAPI on 9000
    socketio.run(app, host="0.0.0.0", port=5000, debug=True)