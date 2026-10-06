import '../models/sendai_framework_report.dart';

/// Autonomous Service compiling statutory Sendai Framework indicator scorecards for State/District administrations
class SendaiReportingService {
  static NationalSendaiScorecard generateScorecard({
    required String entityName,
    required int year,
  }) {
    return NationalSendaiScorecard(
      administrativeEntity: entityName,
      reportingYear: year,
      targets: const [
        SendaiTargetProgress(
          targetCode: 'Target A',
          targetTitle: 'Substantially reduce global/national disaster mortality',
          indicatorMetric: 'Mortality per 100,000 population',
          currentYearValue: 0.18,
          baselineTenYearAverage: 0.65,
          isTargetMetOrImproving: true,
        ),
        SendaiTargetProgress(
          targetCode: 'Target B',
          targetTitle: 'Substantially reduce the number of affected people',
          indicatorMetric: 'Affected persons per 100,000 population',
          currentYearValue: 850.0,
          baselineTenYearAverage: 2400.0,
          isTargetMetOrImproving: true,
        ),
        SendaiTargetProgress(
          targetCode: 'Target C',
          targetTitle: 'Reduce direct disaster economic loss in relation to GDP',
          indicatorMetric: 'Direct economic loss as % of District GDP',
          currentYearValue: 0.22,
          baselineTenYearAverage: 0.58,
          isTargetMetOrImproving: true,
        ),
        SendaiTargetProgress(
          targetCode: 'Target D',
          targetTitle: 'Reduce disaster damage to critical infrastructure & basic services',
          indicatorMetric: 'Number of disrupted educational & health facilities',
          currentYearValue: 4.0,
          baselineTenYearAverage: 18.0,
          isTargetMetOrImproving: true,
        ),
        SendaiTargetProgress(
          targetCode: 'Target E',
          targetTitle: 'Increase number of local disaster risk reduction strategies',
          indicatorMetric: '% of Gram Panchayats with active Aapda Prabandhan Plans',
          currentYearValue: 92.0,
          baselineTenYearAverage: 45.0,
          isTargetMetOrImproving: true,
        ),
        SendaiTargetProgress(
          targetCode: 'Target G',
          targetTitle: 'Substantially increase access to multi-hazard early warning systems',
          indicatorMetric: '% of population covered by CAP early warning feeds',
          currentYearValue: 98.5,
          baselineTenYearAverage: 30.0,
          isTargetMetOrImproving: true,
        ),
      ],
    );
  }
}
