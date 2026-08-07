import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static const String serverUrl = 'http://54.175.77.125:5000';
  late IO.Socket _socket;

  int _failedAttempts = 0;
  final int _maxAutoRetries = 5;
  bool requireManualConnection = false;

  // Stream controllers to broadcast state to the user
  final _connectionStateController = StreamController<bool>.broadcast();
  final _threatAlertController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<bool> get connectionState => _connectionStateController.stream;
  Stream<Map<String, dynamic>> get threatAlerts =>
      _threatAlertController.stream;

  void initSocket() {
    _socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.onConnect((_) {
      _failedAttempts = 0;
      requireManualConnection = false;
      _connectionStateController.add(true);
    });

    _socket.onDisconnect((_) {
      _connectionStateController.add(false);
    });

    _socket.onConnectError((err) {
      _failedAttempts++;
      if (_failedAttempts >= _maxAutoRetries) {
        requireManualConnection = true;
        // Stop auto-retrying
        _socket.disconnect();
      }
      _connectionStateController.add(false);
    });

    // Listen for Flask webhook
    _socket.on('scam_alert', (data) {
      _threatAlertController.add(data as Map<String, dynamic>);
    });

    autoConnect();
  }

  void autoConnect() {
    if (!requireManualConnection) {
      _socket.connect();
    }
  }

  void manualConnect() {
    _failedAttempts = 0;
    requireManualConnection = false;
    _socket.connect();
  }

  void dispose() {
    _socket.dispose();
    _connectionStateController.close();
    _threatAlertController.close();
  }
}
