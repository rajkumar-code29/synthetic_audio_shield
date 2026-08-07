import 'package:flutter_callkit_incoming/entities/entities.dart' as ck;
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:twilio_voice/twilio_voice.dart';
import 'package:uuid/uuid.dart';

class CallManager {
  void listenForCallEvents() {
    FlutterCallkitIncoming.onEvent.listen((event) async {
      if (event != null) {
        switch (event.event) {
          case ck.Event.actionCallAccept:
            print("CallKit: Call Accepted");
            await FlutterCallkitIncoming.endAllCalls();

            Future.delayed(const Duration(milliseconds: 1500), () {
              print("Connecting Twilio stream...");
              TwilioVoicePlatform.instance.call.place(
                to: "SecureCall",
                from: "synthetic_audio_shield_ios",
              );
            });
            break;

          case ck.Event.actionCallDecline:
            print("CallKit: Call Declined");
            TwilioVoicePlatform.instance.call.hangUp();
            break;

          default:
            break;
        }
      }
    });
  }

  Future<void> showIncomingCallKit(String callerId) async {
    final String callId = const Uuid().v4();

    ck.CallKitParams params = ck.CallKitParams(
      id: callId,
      nameCaller: callerId,
      appName: 'Synthetic Audio Shield',
      handle: callerId,
      type: 0,
      ios: ck.IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: false,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
      ),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }
}
