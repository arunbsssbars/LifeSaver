import 'package:flutter/material.dart';
import '../models/aapda_mitra_responder.dart';
import '../services/emergency_service.dart';

class EvacuationShelterSheet extends StatelessWidget {
  final List<NdmaReliefShelter> shelters;
  final List<AapdaMitraVolunteer> volunteers;

  const EvacuationShelterSheet({
    super.key,
    required this.shelters,
    required this.volunteers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Title
            const Row(
              children: [
                Icon(Icons.shield_moon_rounded, color: Color(0xFF10B981), size: 22),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'NDMA Designated Relief Shelters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            ...shelters.map((shelter) {
              final statusColor = shelter.status.color;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            shelter.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            shelter.status.label,
                            style: TextStyle(color: statusColor, fontSize: 9.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${shelter.district}, ${shelter.state} • Elev: ${shelter.elevationMeters.toStringAsFixed(0)}m',
                      style: const TextStyle(color: Colors.white54, fontSize: 11.5),
                    ),
                    const SizedBox(height: 8),

                    // Amenities + Distance Chip
                    Row(
                      children: [
                        if (shelter.distanceKm != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '📍 ${shelter.distanceKm!.toStringAsFixed(1)} km away',
                              style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 10.5, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (shelter.hasMedicalAid)
                          const Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(Icons.medical_services_rounded, color: Color(0xFFEF4444), size: 15),
                          ),
                        if (shelter.hasWaterPurifier)
                          const Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(Icons.water_drop_rounded, color: Color(0xFF38BDF8), size: 15),
                          ),
                        if (shelter.hasHelipad)
                          const Padding(
                            padding: EdgeInsets.only(right: 6),
                            child: Icon(Icons.flight_land_rounded, color: Color(0xFF10B981), size: 15),
                          ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Occupancy: ${shelter.currentOccupancy}/${shelter.capacityPeople}',
                          style: const TextStyle(color: Colors.white60, fontSize: 11),
                        ),
                        InkWell(
                          onTap: () => EmergencyService.makePhoneCall(shelter.officerPhone),
                          child: Row(
                            children: [
                              const Icon(Icons.call, color: Color(0xFF10B981), size: 13),
                              const SizedBox(width: 4),
                              Text(
                                shelter.officerPhone,
                                style: const TextStyle(
                                  color: Color(0xFF10B981),
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 14),

            // Aapda Mitra Volunteers Section
            const Row(
              children: [
                Icon(Icons.diversity_3_rounded, color: Color(0xFFFBBF24), size: 20),
                SizedBox(width: 8),
                Text(
                  'Aapda Mitra Community First Responders',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ...volunteers.map((vol) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBBF24).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_pin_rounded, color: Color(0xFFFBBF24), size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vol.name,
                            style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            vol.skills.join(' • '),
                            style: const TextStyle(color: Colors.white54, fontSize: 10.5),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: const Size(50, 32),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => EmergencyService.makePhoneCall(vol.phone),
                      child: const Text('CALL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
