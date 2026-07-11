//import 'package:flutter/material.dart';
import 'package:twilio_voice/twilio_voice.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';

class TwilioService {
  //final TwilioVoice _twilioVoice = TwilioVoice();
  final String _herokuTokenUrl =
      "https://synthetic-audio-shield-b20ca7af9711.herokuapp.com/token";

  Future<String> initiateAndRegister() async {
    try {
      final response = await http.get(
        Uri.parse(_herokuTokenUrl),
      ); // fetch token from python server

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String token = data['token'];

        TwilioVoice.instance.setTokens(accessToken: token);

        await TwilioVoice.instance.registerClient(
          "synthetic_audio_shield_ios",
          "synthetic_audio_shield_ios",
        );

        return "Device is Registered and ready for incoming calls!";
      } else {
        return "Error: error status ${response.statusCode}.";
      }
    } catch (e) {
      return "Network Error: Issue with server. Details: $e";
    }
  }
}

class CallManager {
  late WebSocketChannel _channel;

  // secure heroku websockets
  final String _webSocketUrl =
      "wss://synthetic-audio-shield-b20ca7af9711.herokuapp.com/socket.io/?EIO=4&transport=websocket";

  void connectWebSocket() {
    _channel = WebSocketChannel.connect(Uri.parse(_webSocketUrl));

    _channel!.stream.listen(
      (message) {
        try {
          final data = jsonDecode(message);
          if (data['event'] == 'incoming_call_event') {
            showLocalCallKit(data['from'] ?? 'Unknown Caller');
          }
        } catch (e) {
          print("Error in parsing WebSocket message: $e");
        }
      },
      onError: (error) {
        print("WebSocket error: $error");
        Future.delayed(const Duration(seconds: 5), () {
          connectWebSocket(); // try to reconnect after 5 seconds
        });
      },
      onDone: () {
        print("WebSocket connection closed. Reconnecting...");
        Future.delayed(const Duration(seconds: 5), () {
          connectWebSocket();
        });
      },
    );
  }

  Future<void> showLocalCallKit(String callerId) async {
    CallKitParams params = CallKitParams(
      id: 'call_id_${DateTime.now().millisecondsSinceEpoch}',
      nameCaller: callerId,
      appName: 'Synthetic Audio Shield',
      handle: callerId,
      type: 0, // 0 = Audio Call
      ios: IOSParams(
        iconName: 'AppIcon',
        handleType: 'generic',
        supportsVideo: false,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
      ),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  void dispose() {
    _channel?.sink.close();
  }
}
