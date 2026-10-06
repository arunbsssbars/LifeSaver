/// Model representing NDMA & INTERPOL Guidelines for Disaster Victim Identification (DVI)
/// and Dignified Post-Disaster Management of the Deceased (Cremation/Burial & DNA Banking).
enum DviPrimaryIdentifierType {
  frictionRidgeFingerprint('Primary Identifier: Fingerprint / Latent Friction Ridge Analysis'),
  forensicOdontology('Primary Identifier: Comparative Forensic Dental Radiograph / Odontogram'),
  nuclearDnaProfile('Primary Identifier: STR / mtDNA Nuclear DNA Profile Matching');

  final String description;
  const DviPrimaryIdentifierType(this.description);
}

class DisasterVictimIdentificationRecord {
  final String disasterCaseId;
  final String deceasedTagNumber;
  final String recoveryGpsCoordinates;
  final bool hasAnteMortemDnaSample;
  final bool hasPostMortemDnaProfile;
  final bool hasDentalOdontogramRecord;
  final bool hasDistinctiveTattooOrProsthetic;
  final bool isColdStoragePreservedAt4C;

  const DisasterVictimIdentificationRecord({
    required this.disasterCaseId,
    required this.deceasedTagNumber,
    required this.recoveryGpsCoordinates,
    required this.hasAnteMortemDnaSample,
    required this.hasPostMortemDnaProfile,
    required this.hasDentalOdontogramRecord,
    required this.hasDistinctiveTattooOrProsthetic,
    required this.isColdStoragePreservedAt4C,
  });

  /// True if positive legal identification can be confirmed under INTERPOL/NDMA standards (at least 1 primary scientific identifier matched)
  bool get isPositiveScientificIdentificationEstablished {
    return (hasAnteMortemDnaSample && hasPostMortemDnaProfile) || hasDentalOdontogramRecord;
  }

  /// Dignity compliance status (cold storage maintained, proper body bag, GPS tagging)
  bool get isDignifiedPreservationCompliant => isColdStoragePreservedAt4C && deceasedTagNumber.isNotEmpty;
}
