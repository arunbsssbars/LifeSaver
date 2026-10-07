import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/region_preset.dart';
import '../models/earthquake_event.dart';
import '../services/earthquake_service.dart';
import '../services/evacuation_service.dart';
import '../widgets/evacuation_shelter_sheet.dart';

class InteractiveMapScreen extends StatefulWidget {
  final RegionPreset activeRegion;

  const InteractiveMapScreen({
    super.key,
    required this.activeRegion,
  });

  @override
  State<InteractiveMapScreen> createState() => _InteractiveMapScreenState();
}

class _InteractiveMapScreenState extends State<InteractiveMapScreen> {
  final MapController _mapController = MapController();
  List<EarthquakeEvent> _earthquakes = [];

  @override
  void initState() {
    super.initState();
    _fetchEarthquakes();
  }

  @override
  void didUpdateWidget(covariant InteractiveMapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeRegion.name != widget.activeRegion.name) {
      _mapController.move(
        LatLng(widget.activeRegion.latitude, widget.activeRegion.longitude),
        10.5,
      );
      _fetchEarthquakes();
    }
  }

  Future<void> _fetchEarthquakes() async {
    final list = await EarthquakeService.fetchRecentEarthquakes(
      userLat: widget.activeRegion.latitude,
      userLng: widget.activeRegion.longitude,
    );
    if (mounted) {
      setState(() {
        _earthquakes = list;
      });
    }
  }

  void _showMarkerDetails({
    required String title,
    required String subtitle,
    required String type,
    required Color color,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.info_outline_rounded, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type.toUpperCase(),
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 13.5, height: 1.4),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38BDF8),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final regionCenter = LatLng(widget.activeRegion.latitude, widget.activeRegion.longitude);

    // Simulated safe high-ground relief centers near the basin
    final safeShelter1 = LatLng(
      widget.activeRegion.latitude + 0.035,
      widget.activeRegion.longitude + 0.025,
    );
    final safeShelter2 = LatLng(
      widget.activeRegion.latitude - 0.030,
      widget.activeRegion.longitude - 0.020,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Interactive Basin & Hazard Map',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.activeRegion.name} (${widget.activeRegion.majorRiverBasin})',
                style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11.5),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shield_moon_rounded, color: Color(0xFF10B981)),
            tooltip: 'NDMA Relief Shelters',
            onPressed: () {
              final shelters = EvacuationService.getNearbyShelters(
                widget.activeRegion.latitude,
                widget.activeRegion.longitude,
              );
              final volunteers = EvacuationService.getVolunteersForDistrict(
                widget.activeRegion.name,
              );
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) => EvacuationShelterSheet(
                  shelters: shelters,
                  volunteers: volunteers,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.my_location_rounded, color: Colors.white70),
            tooltip: 'Recenter Map',
            onPressed: () {
              _mapController.move(regionCenter, 11.0);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
            tooltip: 'Refresh Seismic Markers',
            onPressed: _fetchEarthquakes,
          ),
        ],
      ),
      body: Stack(
        children: [
          // OpenStreetMap Layer via FlutterMap
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: regionCenter,
              initialZoom: 10.5,
              minZoom: 3.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.lifesaver.app',
              ),

              // Danger Geofence Circle Overlay
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: regionCenter,
                    radius: 5000, // 5 km danger buffer
                    useRadiusInMeter: true,
                    color: const Color(0xFFEF4444).withValues(alpha: 0.18),
                    borderColor: const Color(0xFFEF4444),
                    borderStrokeWidth: 2,
                  ),
                ],
              ),

              // Markers for User, Shelters, and Earthquakes
              MarkerLayer(
                markers: [
                  // 1. Current Monitored Center Marker
                  Marker(
                    point: regionCenter,
                    width: 50,
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        _showMarkerDetails(
                          title: widget.activeRegion.name,
                          subtitle:
                              'Active flood monitoring point along ${widget.activeRegion.majorRiverBasin}. 5km perimeter monitored for river surges.',
                          type: 'Monitored River Basin',
                          color: const Color(0xFF38BDF8),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.location_pin, color: Color(0xFF38BDF8), size: 34),
                        ),
                      ),
                    ),
                  ),

                  // 2. High Ground Safe Shelters
                  Marker(
                    point: safeShelter1,
                    width: 44,
                    height: 44,
                    child: GestureDetector(
                      onTap: () {
                        _showMarkerDetails(
                          title: 'North Relief & High Ground Camp',
                          subtitle:
                              'Elevated community shelter equipped with first-aid, emergency water filtration, and backup power.',
                          type: 'Designated Safe Zone',
                          color: const Color(0xFF10B981),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.shield_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                  Marker(
                    point: safeShelter2,
                    width: 44,
                    height: 44,
                    child: GestureDetector(
                      onTap: () {
                        _showMarkerDetails(
                          title: 'South Emergency Evacuation Center',
                          subtitle:
                              'Designated high-elevation disaster relief shelter with direct helipad access and medical facilities.',
                          type: 'Designated Safe Zone',
                          color: const Color(0xFF10B981),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.shield_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                  ),

                  // 3. Real-Time Earthquake Epicenters
                  ..._earthquakes.take(15).map((q) {
                    return Marker(
                      point: LatLng(q.latitude, q.longitude),
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () {
                          _showMarkerDetails(
                            title: 'M ${q.magnitude.toStringAsFixed(1)} Earthquake',
                            subtitle:
                                '${q.place}\nDepth: ${q.depthKm} km\nTime: ${q.time.toLocal().toString().substring(0, 16)}'
                                '${q.distanceKm != null ? '\nDistance: ${q.distanceKm!.toStringAsFixed(0)} km from active basin' : ''}',
                            type: 'Seismic Epicenter',
                            color: Colors.orangeAccent,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.85),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              q.magnitude.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          // Map Legend / Layer Pill at bottom
          Positioned(
            bottom: 14,
            left: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
                boxShadow: const [
                  BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: 6,
                children: [
                  _buildLegendItem(const Color(0xFF38BDF8), 'Basin Center'),
                  _buildLegendItem(const Color(0xFFEF4444), '5km Danger Zone'),
                  _buildLegendItem(const Color(0xFF10B981), 'Safe Shelter'),
                  _buildLegendItem(Colors.orangeAccent, 'Earthquake (M)'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
