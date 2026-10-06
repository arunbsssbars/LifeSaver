/// Model representing Disaster Field Volunteer Skill Badges & Mission Task Dispatch
enum VolunteerSkillBadge {
  deepDiving('Swift Water & Deep Diving Rescue', 'dive'),
  paramedic('Emergency Trauma Paramedic / CPR', 'med'),
  hamRadio('Licensed HAM Radio Operator (VHF/HF)', 'radio'),
  heavyMachinery('JCB / Earthmover Operator', 'excavator'),
  ropeRescue('High-Angle Mountain & Rope Rescue', 'rope'),
  boatOperator('Inflatable Motorized Boat (IRB) Pilot', 'boat');

  final String title;
  final String iconCode;

  const VolunteerSkillBadge(this.title, this.iconCode);
}

enum MissionStatus {
  pendingDispatch,
  enRoute,
  onSceneActive,
  missionAccomplished,
}

class VolunteerMission {
  final String missionId;
  final String missionTitle;
  final String targetLocation;
  final VolunteerSkillBadge requiredSkill;
  final int volunteerCountRequired;
  final List<String> assignedVolunteerNames;
  final MissionStatus status;
  final DateTime assignedAt;

  const VolunteerMission({
    required this.missionId,
    required this.missionTitle,
    required this.targetLocation,
    required this.requiredSkill,
    required this.volunteerCountRequired,
    required this.assignedVolunteerNames,
    required this.status,
    required this.assignedAt,
  });
}
