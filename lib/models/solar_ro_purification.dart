/// Model representing NDMA & Jal Jeevan Mission Portable Mobile Solar RO Water Treatment Plants.
class SolarRoPurificationUnit {
  final String plantId;
  final String location;
  final double rawWaterTdsPpm;
  final double treatedWaterTdsPpm;
  final double filtrationRateLitersPerHour;
  final double batterySolarChargePercent;
  final bool isUvBacterialDisinfectionActive;

  const SolarRoPurificationUnit({
    required this.plantId,
    required this.location,
    required this.rawWaterTdsPpm,
    required this.treatedWaterTdsPpm,
    required this.filtrationRateLitersPerHour,
    required this.batterySolarChargePercent,
    required this.isUvBacterialDisinfectionActive,
  });

  /// TDS reduction efficiency percentage
  double get tdsRejectionPercent {
    if (rawWaterTdsPpm == 0) return 100.0;
    return ((rawWaterTdsPpm - treatedWaterTdsPpm) / rawWaterTdsPpm) * 100.0;
  }

  /// True if treated water meets BIS IS 10500 drinking water parameters (TDS < 500 ppm and UV active)
  bool get isPotableBisCompliant => treatedWaterTdsPpm <= 500.0 && isUvBacterialDisinfectionActive;

  /// Daily clean drinking water output in Liters (assuming 10 hours of operation)
  double get dailyCleanWaterOutputLiters => filtrationRateLitersPerHour * 10.0;
}
