import 'package:flutter/material.dart';
import '../models/earthquake_event.dart';
import '../models/region_preset.dart';
import '../services/earthquake_service.dart';
import '../services/bis_seismic_service.dart';
import '../widgets/seismic_zonation_badge.dart';

class LiveCalamityScreen extends StatefulWidget {
  final RegionPreset activeRegion;

  const LiveCalamityScreen({
    super.key,
    required this.activeRegion,
  });

  @override
  State<LiveCalamityScreen> createState() => _LiveCalamityScreenState();
}

class _LiveCalamityScreenState extends State<LiveCalamityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<EarthquakeEvent> _earthquakes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCalamityFeeds();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCalamityFeeds() async {
    setState(() => _isLoading = true);
    final events = await EarthquakeService.fetchRecentEarthquakes(
      userLat: widget.activeRegion.latitude,
      userLng: widget.activeRegion.longitude,
    );
    if (mounted) {
      setState(() {
        _earthquakes = events;
        _isLoading = false;
      });
    }
  }

  List<EarthquakeEvent> _filterEvents(int tabIndex) {
    if (tabIndex == 1) {
      // Nepal & Himalayas (Lat 26-32, Lon 78-90)
      return _earthquakes.where((e) {
        return (e.latitude >= 26.0 && e.latitude <= 32.0 && e.longitude >= 78.0 && e.longitude <= 90.0) ||
            e.place.toLowerCase().contains('nepal');
      }).toList();
    } else if (tabIndex == 2) {
      // India & Subcontinent
      return _earthquakes.where((e) {
        return (e.latitude >= 6.0 && e.latitude <= 37.0 && e.longitude >= 68.0 && e.longitude <= 98.0) ||
            e.place.toLowerCase().contains('india');
      }).toList();
    }
    // All recent earthquakes
    return _earthquakes;
  }

  Color _getMagnitudeColor(double mag) {
    if (mag >= 6.0) return const Color(0xFFEF4444); // Red
    if (mag >= 4.5) return const Color(0xFFF97316); // Orange
    if (mag >= 3.0) return const Color(0xFFF59E0B); // Amber
    return const Color(0xFF10B981); // Green
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            'Live Calamity Feeds',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF38BDF8)),
            onPressed: _loadCalamityFeeds,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF38BDF8),
          indicatorWeight: 3,
          labelColor: const Color(0xFF38BDF8),
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'All Global (24h)'),
            Tab(text: '🇳🇵 Nepal & Himalayas'),
            Tab(text: '🇮🇳 India Region'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF38BDF8)),
                  SizedBox(height: 12),
                  Text('Fetching USGS & Global Seismic Feeds...', style: TextStyle(color: Colors.white54)),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildEventList(_filterEvents(0), showZonation: false),
                _buildEventList(_filterEvents(1), showZonation: true),
                _buildEventList(_filterEvents(2), showZonation: true),
              ],
            ),
    );
  }

  Widget _buildEventList(List<EarthquakeEvent> events, {required bool showZonation}) {
    if (events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF10B981), size: 48),
              const SizedBox(height: 14),
              const Text(
                'No Severe Seismic Events in Sector',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'No significant earthquakes recorded in this region over the past 24 hours.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length + (showZonation ? 1 : 0),
      itemBuilder: (context, index) {
        if (showZonation && index == 0) {
          final zoneAssessment = BisSeismicService.getZoneAssessment(
            latitude: widget.activeRegion.latitude,
            longitude: widget.activeRegion.longitude,
            regionName: widget.activeRegion.name,
            stateOrDistrict: widget.activeRegion.stateOrDistrict,
          );
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: SeismicZonationBadge(assessment: zoneAssessment),
          );
        }

        final eventIndex = showZonation ? index - 1 : index;
        final event = events[eventIndex];
        final magColor = _getMagnitudeColor(event.magnitude);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: magColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Magnitude Badge
              Container(
                width: 54,
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                decoration: BoxDecoration(
                  color: magColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: magColor),
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          event.magnitude.toStringAsFixed(1),
                          style: TextStyle(
                            color: magColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text(
                          'MAG',
                          style: TextStyle(color: Colors.white54, fontSize: 8, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.place,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Depth: ${event.depthKm.toStringAsFixed(1)} km  •  Coords: ${event.latitude.toStringAsFixed(2)}, ${event.longitude.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white54, fontSize: 11.5),
                    ),
                    const SizedBox(height: 4),
                    if (event.distanceKm != null) ...[
                      Text(
                        '📍 ~${event.distanceKm!.toStringAsFixed(0)} km away from ${widget.activeRegion.name}',
                        style: const TextStyle(
                          color: Color(0xFF38BDF8),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
