import 'dart:async';
import 'package:flutter/material.dart';
import '../models/region_preset.dart';
import '../services/emergency_service.dart';
import '../services/siren_service.dart';
import 'emergency_pass_screen.dart';

class SosActionScreen extends StatefulWidget {
  final RegionPreset activeRegion;

  const SosActionScreen({
    super.key,
    required this.activeRegion,
  });

  @override
  State<SosActionScreen> createState() => _SosActionScreenState();
}

class _SosActionScreenState extends State<SosActionScreen> {
  bool _isSirenActive = false;
  bool _isStrobeOn = false;
  Timer? _strobeTimer;

  @override
  void initState() {
    super.initState();
    _isSirenActive = SirenService.isPlaying;
  }

  @override
  void dispose() {
    _strobeTimer?.cancel();
    super.dispose();
  }

  void _toggleSiren() {
    setState(() {
      _isSirenActive = !_isSirenActive;
      if (_isSirenActive) {
        SirenService.startSiren();
        _startStrobe();
      } else {
        SirenService.stopSiren();
        _stopStrobe();
      }
    });
  }

  void _startStrobe() {
    _strobeTimer?.cancel();
    _strobeTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() => _isStrobeOn = !_isStrobeOn);
      }
    });
  }

  void _stopStrobe() {
    _strobeTimer?.cancel();
    if (mounted) {
      setState(() => _isStrobeOn = false);
    }
  }

  Future<void> _sendDistressSms() async {
    final success = await EmergencyService.sendDistressSms(
      latitude: widget.activeRegion.latitude,
      longitude: widget.activeRegion.longitude,
      regionName: widget.activeRegion.name,
      threatLevel: 'Flooding / Calamity Risk',
    );

    if (mounted && !success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open SMS application.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contacts = EmergencyService.getContactsForCountry(widget.activeRegion.countryCode);
    final countryName = widget.activeRegion.countryCode == 'NP' ? 'Nepal 🇳🇵' : 'India 🇮🇳';

    return Scaffold(
      backgroundColor: _isStrobeOn ? const Color(0xFF7F1D1D) : const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Emergency SOS & Dispatch',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // Country Badge & Location
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on_rounded, color: Color(0xFF38BDF8), size: 16),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Active Sector: ${widget.activeRegion.name} • $countryName',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Giant Panic Siren Button
            GestureDetector(
              onTap: _toggleSiren,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: _isSirenActive
                        ? [const Color(0xFFEF4444), const Color(0xFF991B1B)]
                        : [const Color(0xFFDC2626), const Color(0xFF7F1D1D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isSirenActive
                          ? Colors.red.withValues(alpha: 0.7)
                          : Colors.redAccent.withValues(alpha: 0.35),
                      blurRadius: _isSirenActive ? 40 : 20,
                      spreadRadius: _isSirenActive ? 10 : 4,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withValues(alpha: _isSirenActive ? 0.9 : 0.4),
                    width: 4,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isSirenActive ? Icons.volume_up_rounded : Icons.campaign_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _isSirenActive ? 'STOP SIREN' : 'LOUD SIREN',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),
            Text(
              _isSirenActive
                  ? '🚨 SIREN IS ACTIVE & SOUNDING'
                  : 'Tap to blast acoustic alarm & strobe warning',
              style: TextStyle(
                color: _isSirenActive ? Colors.redAccent : Colors.white60,
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
              ),
            ),

            const SizedBox(height: 24),

            // One-Tap GPS Distress SMS Broadcast Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: const Color(0xFF38BDF8),
                  side: const BorderSide(color: Color(0xFF38BDF8), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.sms_rounded),
                label: const Text(
                  'BROADCAST GPS SOS SMS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                onPressed: _sendDistressSms,
              ),
            ),

            const SizedBox(height: 12),

            // NDMA Digital Pass & Multilingual SOS Toolkit Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: const Color(0xFF38BDF8),
                  side: const BorderSide(color: Color(0xFF38BDF8), width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.badge_rounded, color: Color(0xFF38BDF8)),
                label: const Text(
                  'NDMA DIGITAL SURVIVAL PASS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, letterSpacing: 0.5),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmergencyPassScreen(
                        activeRegion: widget.activeRegion,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Emergency Helplines Section
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$countryName Emergency Hotlines',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Tap to Call',
                  style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 14),

            ...contacts.map((contact) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(contact.icon, color: const Color(0xFFEF4444), size: 22),
                    ),
                    title: Text(
                      contact.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                      ),
                    ),
                    subtitle: Text(
                      contact.subtitle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(color: Colors.white54, fontSize: 11.5),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.phone, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            contact.number,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => EmergencyService.makePhoneCall(contact.number),
                  ),
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
