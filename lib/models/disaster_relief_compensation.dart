/// Model representing Ministry of Home Affairs (MHA) SDRF / NDRF Norms of Financial Assistance.
class DisasterCompensationCalculator {
  /// Computes statutory ex-gratia disaster assistance under SDRF guidelines
  static double calculateTotalReliefAmountInr({
    required int fatalitiesCount, // Rs 4,00,000 per deceased
    required int severeDisabilityCount, // Rs 2,50,000 per person
    required int fullyDamagedPuccaHouses, // Rs 1,20,000 per house
    required int partiallyDamagedHouses, // Rs 6,500 per house
    required int milchCattleLostCount, // Rs 37,500 per cow/buffalo
    required double cropLossAreaHectares, // Rs 17,000 per hectare for irrigated land
  }) {
    return (fatalitiesCount * 400000.0) +
        (severeDisabilityCount * 250000.0) +
        (fullyDamagedPuccaHouses * 120000.0) +
        (partiallyDamagedHouses * 6500.0) +
        (milchCattleLostCount * 37500.0) +
        (cropLossAreaHectares * 17000.0);
  }
}
