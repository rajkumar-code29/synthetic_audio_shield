import 'package:flutter/material.dart';
import '../backend/twilioService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TwilioService _twilioService = TwilioService();

  String _statusMessage = "Disconnected Please try again";
  bool _isLoading = false;

  Future<void> _connectToTwilio() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "registering...";
    });

    String result = await _twilioService
        .initiateAndRegister(); // call method from twilioService

    setState(() {
      _isLoading = false;
      _statusMessage = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Synthetic Audio Shield'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.security_rounded,
                size: 100,
                color: _statusMessage.contains("Success")
                    ? Colors.green
                    : Colors.blueGrey,
              ),
              const SizedBox(height: 30),
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _connectToTwilio,
                      icon: const Icon(Icons.power_settings_new),
                      label: const Text("Initialize Secure Line"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
