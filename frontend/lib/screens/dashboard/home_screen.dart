import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //hero container
            Container(
              color: const Color(0xFF1E40AF),
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting & Profile Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello,',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Raj',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          CupertinoIcons.person_fill,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Active Shield Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981), // Emerald Green
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            CupertinoIcons.shield_fill,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF34D399),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'Shield Active',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'SAS is actively protecting you from scam calls',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Active',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // main content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stat Cards
                  Row(
                    children: [
                      _buildStatCard(
                        icon: CupertinoIcons.phone,
                        iconColor: const Color(0xFF2563EB),
                        value: '47',
                        label: 'Calls Today',
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        icon: CupertinoIcons.shield_slash,
                        iconColor: const Color(0xFF059669),
                        value: '12',
                        label: 'Scams Blocked',
                        bgColor: const Color(0xFFECFDF5),
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        icon: CupertinoIcons.graph_square,
                        iconColor: const Color(0xFFEA580C),
                        value: '26%',
                        label: 'Threat Rate',
                        bgColor: const Color(0xFFFFF7ED),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Quick Call Caregiver Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            CupertinoIcons.phone_arrow_up_right,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quick Call Caregiver',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Shyam • Brother',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          CupertinoIcons.phone_fill,
                          color: Colors.white,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Recent Calls Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Calls',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Row(
                          children: [
                            Text(
                              'View all',
                              style: TextStyle(
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(
                              CupertinoIcons.chevron_right,
                              size: 14,
                              color: Color(0xFF2563EB),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Recent Calls List
                  _buildCallTile(
                    title: 'HMRS Tax Refund Dept.',
                    phoneNumber: '+441234567890',
                    timestamp: '2 hours ago',
                    duration: '0:23',
                    isScam: true,
                  ),
                  _buildCallTile(
                    title: 'Robert Johnson',
                    phoneNumber: '+442345678901',
                    timestamp: 'Yesterday',
                    duration: '4:12',
                    isScam: false,
                  ),
                  _buildCallTile(
                    title: 'NHS Helpdesk',
                    phoneNumber: '+443456789012',
                    timestamp: '2 days ago',
                    duration: '2:07',
                    isScam: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget: Stat Card
  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    Color bgColor = const Color(0xFFEFF6FF),
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget: Call Item Tile
  Widget _buildCallTile({
    required String title,
    required String phoneNumber,
    required String timestamp,
    required String duration,
    required bool isScam,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isScam ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isScam
                  ? CupertinoIcons.exclamationmark_triangle_fill
                  : CupertinoIcons.phone_down_fill,
              color: isScam ? const Color(0xFFDC2626) : const Color(0xFF059669),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      phoneNumber,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('•', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 6),
                    Text(
                      timestamp,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isScam
                      ? const Color(0xFFFEE2E2)
                      : const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isScam ? 'Scam' : 'Safe',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isScam
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF059669),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                duration,
                style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
