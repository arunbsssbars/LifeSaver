/// Model representing an encrypted, low-power disaster mesh packet
/// for peer-to-peer relay across Bluetooth Low Energy (BLE) and Wi-Fi Direct in zero-cellular zones.
class DisasterMeshPacket {
  final String packetId;
  final String senderAadhaarOrAlias;
  final double latitude;
  final double longitude;
  final String urgencyLevel;
  final String messagePayload;
  final int hopCount;
  final DateTime timestamp;

  const DisasterMeshPacket({
    required this.packetId,
    required this.senderAadhaarOrAlias,
    required this.latitude,
    required this.longitude,
    required this.urgencyLevel,
    required this.messagePayload,
    required this.hopCount,
    required this.timestamp,
  });

  /// Encodes packet into a compact binary-safe string payload for BLE advertising
  String encodeCompactPayload() {
    return 'LSVR|$packetId|$senderAadhaarOrAlias|${latitude.toStringAsFixed(4)}|${longitude.toStringAsFixed(4)}|$urgencyLevel|$hopCount|$messagePayload';
  }

  /// Decodes payload from an incoming BLE/Wi-Fi Direct advertisement
  static DisasterMeshPacket? decodeCompactPayload(String raw) {
    try {
      final parts = raw.split('|');
      if (parts.length < 8 || parts[0] != 'LSVR') return null;
      return DisasterMeshPacket(
        packetId: parts[1],
        senderAadhaarOrAlias: parts[2],
        latitude: double.tryParse(parts[3]) ?? 0.0,
        longitude: double.tryParse(parts[4]) ?? 0.0,
        urgencyLevel: parts[5],
        hopCount: (int.tryParse(parts[6]) ?? 0) + 1, // increment hop
        messagePayload: parts.sublist(7).join('|'),
        timestamp: DateTime.now(),
      );
    } catch (_) {
      return null;
    }
  }
}
