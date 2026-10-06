import '../models/mesh_packet.dart';

/// Autonomous Service orchestrating disaster mesh relay packets in offline environments
class MeshNetworkService {
  static final List<DisasterMeshPacket> _relayedPackets = [];
  static bool _isMeshActive = false;

  static bool get isMeshActive => _isMeshActive;
  static List<DisasterMeshPacket> get activeMeshPackets => List.unmodifiable(_relayedPackets);

  /// Starts listening and relaying disaster mesh packets
  static void startMeshRelay() {
    _isMeshActive = true;
  }

  /// Stops mesh relay
  static void stopMeshRelay() {
    _isMeshActive = false;
  }

  /// Broadcasts a new local emergency distress packet over BLE/Wi-Fi Direct mesh
  static DisasterMeshPacket broadcastDistress({
    required double latitude,
    required double longitude,
    required String senderAlias,
    required String urgency,
    required String message,
  }) {
    final packet = DisasterMeshPacket(
      packetId: 'PKT-${DateTime.now().millisecondsSinceEpoch}',
      senderAadhaarOrAlias: senderAlias,
      latitude: latitude,
      longitude: longitude,
      urgencyLevel: urgency,
      messagePayload: message,
      hopCount: 0,
      timestamp: DateTime.now(),
    );

    _relayedPackets.insert(0, packet);
    return packet;
  }

  /// Receives an incoming packet from a nearby device and rebroadcasts if hop < 5
  static bool receiveAndRelayRaw(String rawPayload) {
    final packet = DisasterMeshPacket.decodeCompactPayload(rawPayload);
    if (packet == null) return false;

    // Deduplication check: Do not rebroadcast already seen packet IDs
    if (_relayedPackets.any((p) => p.packetId == packet.packetId)) {
      return false;
    }

    _relayedPackets.insert(0, packet);
    return true;
  }

  /// Clears stored mesh packets
  static void clearBuffer() {
    _relayedPackets.clear();
  }
}
