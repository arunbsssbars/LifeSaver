/// Model representing Archaeological Survey of India (ASI) & UNESCO / NDMA
/// Disaster Risk Management Guidelines for Cultural Heritage Sites and Ancient Monuments.
class HeritageDisasterMitigation {
  final String monumentName;
  final String state;
  final bool isUnescoWorldHeritageSite;
  final bool hasSandbagFloodBarrierDeployed;
  final bool hasLightningArresterRodInstalled;
  final bool hasInertGasFireSuppressionInArchiveVault;

  const HeritageDisasterMitigation({
    required this.monumentName,
    required this.state,
    required this.isUnescoWorldHeritageSite,
    required this.hasSandbagFloodBarrierDeployed,
    required this.hasLightningArresterRodInstalled,
    required this.hasInertGasFireSuppressionInArchiveVault,
  });

  /// Cultural Heritage Vulnerability Score (0 to 100, 100 being fully fortified)
  double get protectionScorePercent {
    int points = 0;
    if (hasSandbagFloodBarrierDeployed) points += 35;
    if (hasLightningArresterRodInstalled) points += 35;
    if (hasInertGasFireSuppressionInArchiveVault) points += 30;
    return points.toDouble();
  }
}
