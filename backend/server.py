import os
from flask import Flask, request, jsonify
from flask_socketio import SocketIO, emit
from twilio.twiml.voice_response import VoiceResponse, Dial, Say, Connect, Stream
from twilio.jwt.access_token import AccessToken
from twilio.jwt.access_token.grants import VoiceGrant

app = Flask(__name__)

# SocketIO for mobile app to receive real-time audio stream
socketio = SocketIO(app, cors_allowed_origins="*")
## Twilio Credentials 
## Update by Heroku config vars using os.environ.get('TWILIO_ACCOUNT_SID')

TWILIO_ACCOUNT_SID = os.environ.get('TWILIO_ACCOUNT_SID')
TWILIO_API_KEY = os.environ.get('TWILIO_API_KEY')
TWILIO_API_SECRET = os.environ.get('TWILIO_API_SECRET')
TWILIO_TWIML_APP_SID = os.environ.get('TWILIO_TWIML_APP_SID')
 
# identity for ios Flutter app
IDENTITY = 'synthetic_audio_shield_ios'

# Track connected app sessions
connected_sessions = {}

@socketio.on('connect')
def handle_connect():
    print("SAS app linked successfully.")
    connected_sessions['synthetic_audio_shield_ios'] = request.sid

@app.route("/voice", methods=['POST'])
def voice():
    response = VoiceResponse()
    
    # automated voice notification to the caller
    response.say("Please note that this call is being monitored for security purposes")
    
    # app connection via websocket to tell call is coming in
    socketio.emit('incoming_call_event', {'from': request.form.get('From', 'Unknown')})

    # Dial the app 
    dial = Dial(timeout=20)
    dial.client(IDENTITY)
    response.append(dial)
    
    return str(response), 200, {'Content-Type': 'text/xml'}


@app.route("/token", methods=['GET'])
def token():

    # acess token container
    token = AccessToken(
        TWILIO_ACCOUNT_SID,
        TWILIO_API_KEY,
        TWILIO_API_SECRET,
        identity=IDENTITY
    )

    # Create a Voice Grant & enable incoming calls
    voice_grant = VoiceGrant(
        outgoing_application_sid=TWILIO_TWIML_APP_SID,
        incoming_allow=True
    )
    token.add_grant(voice_grant)

    # Return token to Flutter app as JSON
    return jsonify(token=token.to_jwt())


if __name__ == "__main__":
    socketio.run(app, debug=True, port=5000)