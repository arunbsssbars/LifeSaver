/// Model representing the India Disaster Resource Network (IDRN - idrn.nidm.gov.in)
/// equipment and material inventory standard for emergency response logistics.
enum IdrnEquipmentCategory {
  waterRescue('Swift Water & Inundation Rescue Equipment'),
  heavySearchRescue('Collapsed Structure Search & Rescue (CSSR)'),
  medicalLifeSupport('Disaster Mobile Health & Trauma Support'),
  communicationPower('Emergency Comms & Backup Auxiliary Power'),
  shelterSanitation('Relief Camp Infrastructure & Sanitation');

  final String description;
  const IdrnEquipmentCategory(this.description);
}

class IdrnEquipmentItem {
  final String itemId;
  final String itemName;
  final IdrnEquipmentCategory category;
  final int totalQuantityAvailable;
  final int operationalQuantity;
  final String storageDepotLocation;
  final String nodalOfficerContact;

  const IdrnEquipmentItem({
    required this.itemId,
    required this.itemName,
    required this.category,
    required this.totalQuantityAvailable,
    required this.operationalQuantity,
    required this.storageDepotLocation,
    required this.nodalOfficerContact,
  });

  /// Computes equipment operational readiness percentage
  double get operationalReadinessPercent {
    if (totalQuantityAvailable == 0) return 0.0;
    return (operationalQuantity / totalQuantityAvailable) * 100;
  }

  static List<IdrnEquipmentItem> getMockDistrictInventory(String districtName) {
    return [
      IdrnEquipmentItem(
        itemId: 'IDRN-B01',
        itemName: 'Inflatable Motorized Rescue Boats (IRB) with 40HP OBM',
        category: IdrnEquipmentCategory.waterRescue,
        totalQuantityAvailable: 12,
        operationalQuantity: 11,
        storageDepotLocation: '$districtName SDRF Warehouse',
        nodalOfficerContact: '+91 98765 01001',
      ),
      const IdrnEquipmentItem(
        itemId: 'IDRN-P01',
        itemName: 'High-Discharge Dewatering Mud Pumps (100 HP)',
        category: IdrnEquipmentCategory.waterRescue,
        totalQuantityAvailable: 25,
        operationalQuantity: 24,
        storageDepotLocation: 'Irrigation & Flood Control Dept',
        nodalOfficerContact: '+91 98765 01002',
      ),
      const IdrnEquipmentItem(
        itemId: 'IDRN-C01',
        itemName: 'Hydraulic Spreader & Diamond Core Cutters (CSSR)',
        category: IdrnEquipmentCategory.heavySearchRescue,
        totalQuantityAvailable: 8,
        operationalQuantity: 8,
        storageDepotLocation: 'District Fire Station Depot',
        nodalOfficerContact: '+91 98765 01003',
      ),
      const IdrnEquipmentItem(
        itemId: 'IDRN-L01',
        itemName: 'High-Mast Inflatable LED Lighting Towers (4.5 kVA)',
        category: IdrnEquipmentCategory.communicationPower,
        totalQuantityAvailable: 16,
        operationalQuantity: 15,
        storageDepotLocation: 'DEOC Central Relief Yard',
        nodalOfficerContact: '+91 98765 01004',
      ),
    ];
  }
}
