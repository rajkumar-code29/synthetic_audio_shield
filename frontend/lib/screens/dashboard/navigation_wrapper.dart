import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';
import 'help_screen.dart';
import '../../services/socket_service.dart';
import '../call_overlay/threat_overlay_screen.dart';
import '../../services/twilio_service.dart';
import '../../services/call_manager.dart';

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => _NavigationWrapperState();
}

class _NavigationWrapperState extends State<NavigationWrapper> {
  int _currentIndex = 0;

  // socket service and threat management
  final SocketService _socketService = SocketService();
  final TwilioService _twilioService = TwilioService();
  final CallManager _callManager = CallManager();

  Map<String, dynamic>? _activeThreat;

  final List<Widget> _pages = [
    const HomeScreen(),
    const SettingsScreen(),
    const AboutScreen(),
    const HelpScreen(),
  ];

  @override
  void initState() {
    super.initState();

    // initialise socket when dashboard is loaded
    _socketService.initSocket();

    // initialise voice callkit
    _twilioService.initiateAndRegister().then((result) => print(result));

    // initialise call manager
    _callManager.listenForCallEvents();

    // listen for threat
    _socketService.threatAlerts.listen((threatData) {
      setState(() {
        _activeThreat = threatData;
      });
      // override screen
      WakelockPlus.enable();
    });
  }

  @override
  void dispose() {
    _socketService.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  // method to dismiss overlay
  void _clearThreat() {
    setState(() {
      _activeThreat = null;
    });
    WakelockPlus.disable();
  }

  @override
  Widget build(BuildContext context) {
    // if threat is active show overlay screen
    if (_activeThreat != null) {
      return ThreatOverlayScreen(
        threatData: _activeThreat!,
        onDismiss: _clearThreat,
      );
    }

    // Otherwise show the normal interface
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1E40AF),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.info_circle),
            label: 'About',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2),
            label: 'Help',
          ),
        ],
      ),
    );
  }
}
