// for iOS as we need explicit permission for APN

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:twilio_voice/twilio_voice.dart';
import 'api_service.dart';

class TwilioService {
  static final String tokenUrl = '${ApiService.baseUrl}/token';

  Future<String> initiateAndRegister() async {
    try {
      // microphone permission
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return "Microphone permission is required for voice calls.";
      }

      // JWT token from VM Flask server
      final response = await http.get(Uri.parse(tokenUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String token = data['token'];

        TwilioVoicePlatform.instance.setTokens(accessToken: token);

        await TwilioVoicePlatform.instance.registerClient(
          "synthetic_audio_shield_ios",
          "synthetic_audio_shield_ios",
        );

        TwilioVoicePlatform.instance.callEventsListener.listen((event) {
          print("Twilio Call Event: $event");
        });

        return "Device registered with Twilio Voice.";
      } else {
        return "Token Error: ${response.statusCode}";
      }
    } catch (e) {
      return "Network Error connecting to Twilio token endpoint: $e";
    }
  }
}
