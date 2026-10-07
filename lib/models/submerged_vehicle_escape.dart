/// Loop 142: Submerged Vehicle Escape & Hydrostatic Pressure Equalization Model
/// Aligned with NDMA Tactical Rescue & International Maritime Vehicle Submersion Protocols.

class SubmergedVehicleEscape {
  final double waterDepthMeters;
  final double cabinSubmergedPercentage; // 0 to 100%
  final bool hasSpringLoadedWindowPunch;
  final int occupantCount;
  final bool areSeatbeltsReleased;
  final bool isElectricalPowerFunctional;

  const SubmergedVehicleEscape({
    required this.waterDepthMeters,
    required this.cabinSubmergedPercentage,
    required this.hasSpringLoadedWindowPunch,
    required this.occupantCount,
    required this.areSeatbeltsReleased,
    required this.isElectricalPowerFunctional,
  });

  /// Water density (kg/m3) and gravitational acceleration (m/s2)
  static const double waterDensity = 1000.0;
  static const double gravity = 9.81;

  /// Standard car door surface area ~ 0.85 m2
  static const double doorAreaM2 = 0.85;

  /// Hydrostatic force resisting door opening (Newtons)
  /// Prior to pressure equalization, force can exceed several thousand Newtons (hundreds of kg).
  double get doorResistingForceNewtons {
    if (cabinSubmergedPercentage >= 95.0) {
      return 50.0; // Negligible once cabin is fully equalized
    }
    final headMeters = waterDepthMeters * (1.0 - (cabinSubmergedPercentage / 100.0));
    final deltaP = waterDensity * gravity * headMeters;
    return deltaP * doorAreaM2;
  }

  /// Can door be opened mechanically by human force (~300-400 N max human push)?
  bool get canOpenDoorDirectly => doorResistingForceNewtons < 350.0;

  /// Estimated survival golden escape window in seconds
  int get goldenEscapeWindowSeconds {
    if (cabinSubmergedPercentage < 30.0) {
      return 60; // Floating phase: Immediate exit via side window
    } else if (cabinSubmergedPercentage < 90.0) {
      return 30; // Sinking phase: Window punch mandatory
    } else {
      return 15; // Fully submerged: Equalization breath & push door/kick window
    }
  }

  /// Primary tactical escape instruction
  String get immediateEscapeAction {
    if (!areSeatbeltsReleased) {
      return 'STEP 1: UNBUCKLE SEATBELTS FIRST! Release all children and passengers.';
    }
    if (cabinSubmergedPercentage < 80.0) {
      if (hasSpringLoadedWindowPunch) {
        return 'STEP 2: Strike lower corner of side window with spring-loaded punch, push glass outward and swim up.';
      } else {
        return 'STEP 2: Lower side windows immediately before electronics short, or remove headrest to pry glass corner.';
      }
    } else {
      return 'STEP 3 (EQUALIZED): Take deep breath from remaining roof air pocket, push door firmly or kick windshield out, follow bubbles to surface.';
    }
  }
}
