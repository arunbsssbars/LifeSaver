import 'package:flutter/material.dart';
import '../models/hazard_status.dart';
import '../models/region_preset.dart';
import '../services/flood_service.dart';
import '../services/location_service.dart';
import '../services/imd_alert_service.dart';
import '../services/cwc_telemetry_service.dart';
import '../widgets/threat_gauge_card.dart';
import '../widgets/basin_telemetry_card.dart';
import '../widgets/imd_alert_banner.dart';
import '../widgets/cwc_gauge_card.dart';
import 'emergency_pass_screen.dart';
import 'statutory_audit_screen.dart';

class DashboardScreen extends StatefulWidget {
  final RegionPreset activeRegion;
  final Function(RegionPreset) onRegionChanged;
  final VoidCallback onNavigateToSos;

  const DashboardScreen({
    super.key,
    required this.activeRegion,
    required this.onRegionChanged,
    required this.onNavigateToSos,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  HazardAssessment? _assessment;
  bool _isLoading = true;
  bool _isGpsLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTelemetry();
  }

  @override
  void didUpdateWidget(covariant DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeRegion.name != widget.activeRegion.name) {
      _loadTelemetry();
    }
  }

  Future<void> _loadTelemetry() async {
    setState(() => _isLoading = true);
    final assessment = await FloodService.evaluateLocationRisk(
      latitude: widget.activeRegion.latitude,
      longitude: widget.activeRegion.longitude,
      basinName: widget.activeRegion.majorRiverBasin,
    );
    if (mounted) {
      setState(() {
        _assessment = assessment;
        _isLoading = false;
      });
    }
  }

  Future<void> _detectGpsLocation() async {
    setState(() => _isGpsLoading = true);
    final position = await LocationService.getCurrentPosition();
    if (position != null) {
      final closest = LocationService.findClosestPreset(
        position.latitude,
        position.longitude,
      );
      widget.onRegionChanged(closest);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📍 Located nearest basin: ${closest.name} (${closest.country})'),
            backgroundColor: const Color(0xFF1E293B),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not access GPS. Please select region manually.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
    if (mounted) {
      setState(() => _isGpsLoading = false);
    }
  }

  void _showRegionPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text(
                      'Select Monitored River Basin',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: RegionPreset.presets.length,
                  itemBuilder: (context, index) {
                    final preset = RegionPreset.presets[index];
                    final isSelected = preset.name == widget.activeRegion.name;
                    final flag = preset.countryCode == 'NP' ? '🇳🇵' : '🇮🇳';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF38BDF8).withValues(alpha: 0.15)
                            : const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF38BDF8) : Colors.white10,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: ListTile(
                          leading: Text(flag, style: const TextStyle(fontSize: 24)),
                          title: Text(
                            preset.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '${preset.stateOrDistrict} • ${preset.majorRiverBasin}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle_rounded, color: Color(0xFF38BDF8))
                              : null,
                          onTap: () {
                            widget.onRegionChanged(preset);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _simulateDrill() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.tune_rounded, color: Color(0xFF38BDF8)),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Simulate Disaster Drill',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
          content: const Text(
            'Test how the LifeSaver early warning system alerts users during critical flash floods and river surges.',
            style: TextStyle(color: Colors.white70, fontSize: 13.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _assessment = HazardAssessment(
                    threatLevel: ThreatLevel.criticalEmergency,
                    estimatedResponseTime: const Duration(minutes: 45),
                    primaryRecommendation:
                        'TEST DRILL: Flash flood water level surging in 45 minutes! Evacuate to higher ground immediately.',
                    floodStatus: FloodStatus(
                      currentDischarge: 1450.0,
                      meanDischarge: 210.0,
                      maxForecastDischarge: 1980.0,
                      surgeRatio: 4.8,
                      forecastDischarges: [1450.0, 1980.0, 1200.0],
                      forecastDates: ['Now', 'Peak', 'Tomorrow'],
                    ),
                    weatherStatus: WeatherStatus(
                      currentRainfall: 42.0,
                      rainSumToday: 135.0,
                      precipitationProbability: 95.0,
                      windSpeed: 28.0,
                      temperature: 21.0,
                    ),
                    evaluatedAt: DateTime.now(),
                    nearestBasinName: widget.activeRegion.majorRiverBasin,
                  );
                });
                Navigator.pop(context);
              },
              child: const Text('Simulate Critical Alarm', style: TextStyle(color: Colors.redAccent)),
            ),
            TextButton(
              onPressed: () {
                _loadTelemetry();
                Navigator.pop(context);
              },
              child: const Text('Reset to Live Data', style: TextStyle(color: Colors.white70)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final flag = widget.activeRegion.countryCode == 'NP' ? '🇳🇵' : '🇮🇳';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shield_rounded, color: Color(0xFFEF4444), size: 20),
              const SizedBox(width: 8),
              const Text(
                'LifeSaver',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'EARLY WARNING',
                  style: TextStyle(
                    color: Color(0xFF38BDF8),
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.assessment_rounded, color: Color(0xFF10B981)),
            tooltip: 'DDMA Statutory Disaster Audit',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatutoryAuditScreen(
                    activeRegion: widget.activeRegion,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.badge_rounded, color: Color(0xFF38BDF8)),
            tooltip: 'NDMA Emergency Family Pass',
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
          IconButton(
            icon: _isGpsLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.my_location_rounded, color: Color(0xFF38BDF8)),
            tooltip: 'Locate Nearest Basin via GPS',
            onPressed: _detectGpsLocation,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadTelemetry,
        color: const Color(0xFF38BDF8),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Region Selector Button
              GestureDetector(
                onTap: _showRegionPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    children: [
                      Text(flag, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.activeRegion.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '${widget.activeRegion.stateOrDistrict}, ${widget.activeRegion.country}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down_rounded, color: Colors.white70, size: 28),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Threat Gauge & Response Time
              if (_isLoading || _assessment == null) ...[
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF38BDF8)),
                        SizedBox(height: 14),
                        Text(
                          'Connecting to GloFAS & Open-Meteo Telemetry...',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                if (widget.activeRegion.countryCode == 'IN') ...[
                  ImdAlertBanner(
                    alert: ImdAlertService.evaluateDistrictAlert(
                      districtName: widget.activeRegion.name,
                      stateName: widget.activeRegion.stateOrDistrict,
                      weather: _assessment!.weatherStatus,
                      flood: _assessment!.floodStatus,
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
                ThreatGaugeCard(
                  assessment: _assessment!,
                  onRefresh: _loadTelemetry,
                  onSimulateDrill: _simulateDrill,
                ),
                const SizedBox(height: 18),
                BasinTelemetryCard(assessment: _assessment!),
                if (widget.activeRegion.countryCode == 'IN') ...[
                  const SizedBox(height: 18),
                  CwcGaugeCard(
                    station: CwcTelemetryService.getCwcStationForLocation(
                      latitude: widget.activeRegion.latitude,
                      longitude: widget.activeRegion.longitude,
                      floodStatus: _assessment!.floodStatus,
                    ),
                  ),
                ],
              ],

              const SizedBox(height: 20),

              // Quick SOS Panic Banner
              GestureDetector(
                onTap: widget.onNavigateToSos,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDC2626), Color(0xFF991B1B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.emergency_share_rounded, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'EMERGENCY SOS & SIREN',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.activeRegion.countryCode == 'NP'
                                  ? 'Hotlines: 1155 (Flood) • 1114 (APF)'
                                  : 'Hotlines: 112 (National) • 1078 (NDRF)',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFDC2626),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          onPressed: widget.onNavigateToSos,
                          child: const Text('ACTIVATE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
