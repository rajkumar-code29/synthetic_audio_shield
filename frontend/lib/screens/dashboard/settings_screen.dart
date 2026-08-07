import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State variables for toggle buttons
  bool _scamAlerts = true;
  bool _caregiverUpdates = true;
  bool _weeklySummary = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header section
            Container(
              width: double.infinity,
              color: const Color(0xFF1E40AF),
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Manage your settings',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            // Profile
            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          CupertinoIcons.person,
                          color: Color(0xFF2563EB),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Raj',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '+447777777777',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  CupertinoIcons.lock_shield_fill,
                                  color: Color(0xFF059669),
                                  size: 14,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Protected Account',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _buildEditButton(),
                    ],
                  ),
                ),
              ),
            ),

            // caregiver section
            _buildSectionHeader('Caregiver'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.heart,
                        color: Color(0xFF059669),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shyam',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Brother • +919876543210',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildEditButton(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Notifications
            _buildSectionHeader('Notifications'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildToggleRow(
                      icon: CupertinoIcons.shield,
                      iconColor: const Color(0xFF2563EB),
                      iconBg: const Color(0xFFEFF6FF),
                      title: 'Scam Alerts',
                      subtitle: 'Immediate fraud warnings',
                      value: _scamAlerts,
                      onChanged: (val) => setState(() => _scamAlerts = val),
                    ),
                    const Divider(
                      height: 1,
                      indent: 64,
                      color: Color(0xFFF1F5F9),
                    ),
                    _buildToggleRow(
                      icon: CupertinoIcons.heart,
                      iconColor: const Color(0xFF059669),
                      iconBg: const Color(0xFFECFDF5),
                      title: 'Caregiver Updates',
                      subtitle: 'Notify caregiver of threats',
                      value: _caregiverUpdates,
                      onChanged: (val) =>
                          setState(() => _caregiverUpdates = val),
                    ),
                    const Divider(
                      height: 1,
                      indent: 64,
                      color: Color(0xFFF1F5F9),
                    ),
                    _buildToggleRow(
                      icon: CupertinoIcons.bell,
                      iconColor: const Color(0xFF9333EA),
                      iconBg: const Color(0xFFFAF5FF),
                      title: 'Weekly Summary',
                      subtitle: 'Call protection report',
                      value: _weeklySummary,
                      onChanged: (val) => setState(() => _weeklySummary = val),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Privacy and Security
            _buildSectionHeader('Privacy & Security'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Helper Widget: Section Header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Color(0xFF475569),
        ),
      ),
    );
  }

  // Helper Widget: Edit Circular Button
  Widget _buildEditButton() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Icon(
        CupertinoIcons.pencil,
        color: Color(0xFF64748B),
        size: 18,
      ),
    );
  }

  // Helper Widget: Toggle Row
  Widget _buildToggleRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF2563EB),
          ),
        ],
      ),
    );
  }
}
