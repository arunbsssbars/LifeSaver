/// Model representing Petroleum and Natural Gas Regulatory Board (PNGRB) & ASME B31.8
/// Natural Gas Transmission Pipeline Rupture Automatic Line Break Valve (LBV) Slam-Shut Telemetry.
enum LineBreakValveState {
  normalFlowOpen('Normal Transmission - LBV Open', 0xFF10B981),
  rateOfDropWarning('Transient Pressure Drop Rate Warning (Monitoring)', 0xFFFBBF24),
  automaticSlamShutClosed('CRITICAL PIPELINE RUPTURE - LBV SLAM-SHUT ACTUATED', 0xFFEF4444);

  final String statusDescription;
  final int colorValue;
  const LineBreakValveState(this.statusDescription, this.colorValue);
}

class PipelineLineBreakValveTelemetry {
  final String pipelineSectionTag;
  final String valveStationId;
  final double operatingPressureBar;
  final double rateOfPressureDropBarPerMinute; // Critical trigger: >= 5.0 bar/min
  final double lowPressureTripThresholdBar;
  final double currentMeasuredPressureBar;
  final bool isEmergencyActuatorChargedWithGas;

  const PipelineLineBreakValveTelemetry({
    required this.pipelineSectionTag,
    required this.valveStationId,
    required this.operatingPressureBar,
    required this.rateOfPressureDropBarPerMinute,
    required this.lowPressureTripThresholdBar,
    required this.currentMeasuredPressureBar,
    required this.isEmergencyActuatorChargedWithGas,
  });

  /// Evaluates automated Line Break Valve actuation state
  LineBreakValveState get valveState {
    if (rateOfPressureDropBarPerMinute >= 5.0 || currentMeasuredPressureBar <= lowPressureTripThresholdBar) {
      return LineBreakValveState.automaticSlamShutClosed;
    } else if (rateOfPressureDropBarPerMinute >= 2.5) {
      return LineBreakValveState.rateOfDropWarning;
    }
    return LineBreakValveState.normalFlowOpen;
  }

  /// True if pipeline segment has ruptured and sectional block valves are isolating the hydrocarbon mass
  bool get isPipelineRuptureIsolating => valveState == LineBreakValveState.automaticSlamShutClosed;

  /// True if LBV pneumatic gas-over-oil actuator is ready for autonomous slam-shut (< 30 seconds closure)
  bool get isActuatorArmedAndReady => isEmergencyActuatorChargedWithGas;
}
