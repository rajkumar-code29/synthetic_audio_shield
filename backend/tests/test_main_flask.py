import pytest
from app.main_flask import app
from unittest.mock import patch

@pytest.fixture
def client():
    # built-in test client of flask
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

@patch("app.main_flask.check_number_reputation")
def test_voice_webhook_genuine_routing(mock_check, client):
    # Mock async DB check to return a genuine number
    mock_check.return_value = None 
    
    # Simulate Twilio hitting the webhook
    response = client.post("/voice", data={"From": "+1234567890"})
    
    assert response.status_code == 200
    
    # Assert standard TwiML tags are present
    assert b"monitored for security purposes" in response.data
    assert b"<Stream" in response.data
    assert b"<Dial" in response.data

@patch("app.main_flask.check_number_reputation")
@patch("app.main_flask.socketio.emit")
def test_voice_webhook_scam_alert_emission(mock_emit, mock_check, client):
    # Mock a reported scam number
    mock_check.return_value = {"report_count": 10, "phone_number": "+1999999999"}
    
    # Temporarily inject a dummy frontend session ID 
    with patch.dict("app.main_flask.connected_sessions", {"synthetic_audio_shield_ios": "dummy_sid"}):
        response = client.post("/voice", data={"From": "+1999999999"})
        
        assert response.status_code == 200
        
        # Assert SocketIO alert sent to the app
        mock_emit.assert_called_once_with(
            'scam_alert', 
            {"report_count": 10, "phone_number": "+1999999999"}, 
            to="dummy_sid"
        )