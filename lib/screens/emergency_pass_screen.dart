import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/emergency_pass.dart';
import '../models/region_preset.dart';

class EmergencyPassScreen extends StatefulWidget {
  final RegionPreset activeRegion;

  const EmergencyPassScreen({
    super.key,
    required this.activeRegion,
  });

  @override
  State<EmergencyPassScreen> createState() => _EmergencyPassScreenState();
}

class _EmergencyPassScreenState extends State<EmergencyPassScreen> {
  late EmergencyFamilyPass _profile;
  late Map<String, bool> _kitState;
  String _selectedLanguageCode = 'en';

  final List<Map<String, String>> _languages = const [
    {'code': 'en', 'label': 'English'},
    {'code': 'hi', 'label': 'हिंदी (Hindi)'},
    {'code': 'bn', 'label': 'বাংলা (Bengali)'},
    {'code': 'ta', 'label': 'தமிழ் (Tamil)'},
    {'code': 'te', 'label': 'తెలుగు (Telugu)'},
    {'code': 'mr', 'label': 'मराठी (Marathi)'},
    {'code': 'ne', 'label': 'नेपाली (Nepali)'},
  ];

  @override
  void initState() {
    super.initState();
    _profile = EmergencyFamilyPass.defaultProfile();
    _kitState = Map<String, bool>.from(_profile.survivalKitChecklist);
  }

  void _copyToClipboard(String text, String successMessage) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📋 $successMessage'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  double get _currentReadinessPercent {
    if (_kitState.isEmpty) return 0.0;
    final packed = _kitState.values.where((v) => v).length;
    return (packed / _kitState.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final readiness = _currentReadinessPercent;
    final readinessColor = readiness >= 80
        ? const Color(0xFF10B981)
        : readiness >= 50
            ? const Color(0xFFF59E0B)
            : const Color(0xFFEF4444);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'NDMA Emergency Survival Pass',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          IconButton(
            tooltip: 'Copy Digital Pass',
            icon: const Icon(Icons.copy_rounded, color: Color(0xFF38BDF8)),
            onPressed: () {
              _copyToClipboard(
                _profile.generateReliefCampManifest(),
                'NDMA Relief Camp Manifest copied to clipboard!',
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Digital ID Badge
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.badge_rounded, color: Color(0xFF38BDF8), size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'NDMA FAMILY DISASTER PASS',
                            style: TextStyle(
                              color: const Color(0xFF38BDF8).withValues(alpha: 0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFEF4444)),
                        ),
                        child: Text(
                          _profile.bloodGroup,
                          style: const TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _profile.familyHeadName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Family Size: ${_profile.familyMemberCount} Persons • ID: XXXX-XXXX-${_profile.govtIdLastFourDigits}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const Divider(color: Colors.white12, height: 24),
                  Row(
                    children: [
                      const Icon(Icons.call_rounded, color: Color(0xFF10B981), size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Primary: ${_profile.primaryContactPhone}',
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.medical_services_rounded, color: Color(0xFFF59E0B), size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Medical Alert: ${_profile.chronicConditionsOrAllergies}',
                          style: const TextStyle(color: Color(0xFFFDE68A), fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.meeting_room_rounded, color: Color(0xFF38BDF8), size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Meeting Point: ${_profile.designatedEvacuationMeetingPoint}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // SOS Broadcast Action Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 4,
              ),
              icon: const Icon(Icons.send_rounded, size: 20),
              label: const Text(
                'Copy Instant GPS SOS Broadcast Text',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              onPressed: () {
                final sosMsg = _profile.generateDistressBroadcast(
                  latitude: widget.activeRegion.latitude,
                  longitude: widget.activeRegion.longitude,
                  regionName: widget.activeRegion.name,
                );
                _copyToClipboard(sosMsg, 'Instant GPS SOS text copied to clipboard!');
              },
            ),

            const SizedBox(height: 24),

            // NDMA 72-Hour Survival Kit Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'NDMA 72-Hour Survival Kit',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Essential items recommended for emergency bags',
                              style: TextStyle(color: Colors.white60, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: readinessColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: readinessColor),
                        ),
                        child: Text(
                          '${readiness.toStringAsFixed(0)}% Ready',
                          style: TextStyle(color: readinessColor, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: readiness / 100,
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation<Color>(readinessColor),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ..._kitState.entries.map((entry) {
                    return CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeColor: const Color(0xFF10B981),
                      title: Text(
                        entry.key,
                        style: TextStyle(
                          color: entry.value ? Colors.white : Colors.white60,
                          fontSize: 13,
                          decoration: entry.value ? null : TextDecoration.none,
                        ),
                      ),
                      value: entry.value,
                      onChanged: (val) {
                        setState(() {
                          _kitState[entry.key] = val ?? false;
                        });
                      },
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Multi-lingual Disaster Triage Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Multi-lingual SOS Phrases',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _selectedLanguageCode,
                  dropdownColor: const Color(0xFF1E293B),
                  style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 13),
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF38BDF8)),
                  items: _languages.map((l) {
                    return DropdownMenuItem<String>(
                      value: l['code'],
                      child: Text(l['label']!),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedLanguageCode = val);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Show these bold phrase cards to local responders (NDRF/SDRF/Aapda Mitra) in high-noise or multilingual rescue zones.',
              style: TextStyle(color: Colors.white60, fontSize: 12),
            ),
            const SizedBox(height: 12),

            ...DisasterPhrase.triagePhrases.map((phrase) {
              final translated = phrase.getForLanguage(_selectedLanguageCode);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            phrase.category.toUpperCase(),
                            style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          iconSize: 18,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.copy_rounded, color: Colors.white54),
                          tooltip: 'Copy phrase',
                          onPressed: () {
                            _copyToClipboard(
                              '$translated\n(${phrase.english})',
                              'Emergency phrase copied!',
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      translated,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    if (_selectedLanguageCode != 'en') ...[
                      const SizedBox(height: 4),
                      Text(
                        phrase.english,
                        style: const TextStyle(color: Colors.white54, fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
