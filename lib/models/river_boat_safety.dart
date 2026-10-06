/// Model representing NDMA & Inland Waterways Authority of India (IWAI)
/// River Ghat Safety, Overcrowding Index & Boat Capsize Prevention Guidelines.
class RiverBoatSafetyAssessment {
  final int registeredBoatPassengerCapacity;
  final int actualBoardedPassengers;
  final int lifejacketsAvailableOnboard;
  final double riverCurrentVelocityMetersPerSec;
  final bool isTurbulentHydraulicJumpNearGhat;

  const RiverBoatSafetyAssessment({
    required this.registeredBoatPassengerCapacity,
    required this.actualBoardedPassengers,
    required this.lifejacketsAvailableOnboard,
    required this.riverCurrentVelocityMetersPerSec,
    required this.isTurbulentHydraulicJumpNearGhat,
  });

  /// Overcrowding ratio (actual / capacity)
  double get overloadRatio => actualBoardedPassengers / registeredBoatPassengerCapacity;

  /// True if boat is dangerously overloaded
  bool get isDangerousOverload => overloadRatio > 1.15;

  /// True if there are insufficient life jackets for all souls onboard
  bool get hasLifejacketDeficit => lifejacketsAvailableOnboard < actualBoardedPassengers;

  /// Overall river safety advisory
  List<String> get safetyDirectives {
    final directives = <String>[];
    if (isDangerousOverload) {
      directives.add('🚨 CRITICAL OVERLOAD: Boat exceeds statutory safety capacity by ${((overloadRatio - 1.0) * 100).toStringAsFixed(0)}%. DO NOT BOARD.');
    }
    if (hasLifejacketDeficit) {
      directives.add('⚠️ LIFEJACKET DEFICIT: ${actualBoardedPassengers - lifejacketsAvailableOnboard} passengers lack ISO/BIS certified life vests.');
    }
    if (riverCurrentVelocityMetersPerSec >= 2.5) {
      directives.add('Swift water current ($riverCurrentVelocityMetersPerSec m/s) exceeds safe ferry operation limits. High risk of eddy capsizing.');
    }
    if (isTurbulentHydraulicJumpNearGhat) {
      directives.add('Hydraulic boil / whirlpool turbulence detected near pier. Maintain upstream standoff distance.');
    }
    if (directives.isEmpty) {
      directives.add('Vessel load and river hydrology compliant with IWAI statutory safety limits.');
    }
    return directives;
  }
}
