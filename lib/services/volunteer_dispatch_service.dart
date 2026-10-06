import '../models/volunteer_dispatch.dart';

/// Autonomous Service managing Aapda Mitra & Civil Defence field volunteer tasks
class VolunteerDispatchService {
  static final List<VolunteerMission> _missions = [
    VolunteerMission(
      missionId: 'MSN-301',
      missionTitle: 'Riparian Cattle Herd Evacuation',
      targetLocation: 'Yamuna Floodplain Sector 135',
      requiredSkill: VolunteerSkillBadge.boatOperator,
      volunteerCountRequired: 4,
      assignedVolunteerNames: ['Rajesh Sharma', 'Amit Verma', 'Sunil Yadav'],
      status: MissionStatus.onSceneActive,
      assignedAt: DateTime.now().subtract(const Duration(minutes: 40)),
    ),
    VolunteerMission(
      missionId: 'MSN-302',
      missionTitle: 'Emergency Satellite Comms & HAM Relay Setup',
      targetLocation: 'District Emergency Operations Centre (DEOC)',
      requiredSkill: VolunteerSkillBadge.hamRadio,
      volunteerCountRequired: 2,
      assignedVolunteerNames: ['Devendra Rao (VU2XYZ)'],
      status: MissionStatus.enRoute,
      assignedAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
  ];

  static List<VolunteerMission> get activeMissions => List.unmodifiable(_missions);

  /// Dispatches a new emergency mission
  static VolunteerMission dispatchMission({
    required String title,
    required String targetLocation,
    required VolunteerSkillBadge requiredSkill,
    required int volunteerCount,
  }) {
    final mission = VolunteerMission(
      missionId: 'MSN-${DateTime.now().millisecondsSinceEpoch}',
      missionTitle: title,
      targetLocation: targetLocation,
      requiredSkill: requiredSkill,
      volunteerCountRequired: volunteerCount,
      assignedVolunteerNames: [],
      status: MissionStatus.pendingDispatch,
      assignedAt: DateTime.now(),
    );
    _missions.insert(0, mission);
    return mission;
  }
}
