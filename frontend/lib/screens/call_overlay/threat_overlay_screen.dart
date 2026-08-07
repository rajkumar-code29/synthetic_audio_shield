import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ThreatOverlayScreen extends StatelessWidget {
  final Map<String, dynamic> threatData;
  final VoidCallback onDismiss;

  const ThreatOverlayScreen({
    super.key,
    required this.threatData,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    // Extracting data from the backend
    final callerNumber = threatData['phone_number'] ?? 'Unknown Caller';
    final rawScore = threatData['score'] ?? 0.0;
    final List<dynamic> tripwires = threatData['tripwires'] ?? [];

    // Check if it's a known database threat
    final isDbMatch = threatData.containsKey('report_count');
    final reports = threatData['report_count'] ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFF0000),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Warning Icon
              const Icon(
                CupertinoIcons.exclamationmark_triangle_fill,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              const Text(
                'ALERT: POTENTIAL SCAM CALL',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 32),

              // Main Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black, // Stark black contrast
                  border: Border.all(color: Colors.yellowAccent, width: 4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Caller Id',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      callerNumber,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Divider(color: Colors.grey, height: 1),
                    ),

                    // Conditional display: DB Reported
                    if (isDbMatch) ...[
                      Text(
                        'Reported $reports times as a scam.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.yellowAccent,
                        ),
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Threat Score: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            '$rawScore',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.yellowAccent,
                            ),
                          ),
                        ],
                      ),
                      if (tripwires.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Issues Identified:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: tripwires
                              .map(
                                (wire) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.3),
                                    border: Border.all(color: Colors.redAccent),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    wire.toString().toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ],
                ),
              ),

              const Spacer(),

              // Actions
              const Text(
                'Don\'t provide any personal information, Seek help if you feel unsafe',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onDismiss,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Dismiss Alert',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
