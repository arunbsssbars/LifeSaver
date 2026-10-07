import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifesaver_app/models/region_preset.dart';
import 'package:lifesaver_app/screens/dashboard_screen.dart';
import 'package:lifesaver_app/screens/live_calamity_screen.dart';
import 'package:lifesaver_app/screens/sos_action_screen.dart';
import 'package:lifesaver_app/screens/interactive_map_screen.dart';
import 'package:lifesaver_app/screens/emergency_pass_screen.dart';
import 'package:lifesaver_app/screens/statutory_audit_screen.dart';
import 'package:lifesaver_app/screens/survival_playbook_screen.dart';

const List<int> _kTransparentPng = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
];

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _MockHttpClient();
}

class _MockHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpClientRequest();

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _MockHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => _kTransparentPng.length;

  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;

  @override
  HttpHeaders get headers => _MockHttpHeaders();

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(_kTransparentPng).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });
  const viewports = <String, Size>{
    'Compact Mobile (320px)': Size(320, 640),
    'Standard Mobile (393px)': Size(393, 852),
    'Large Mobile (412px)': Size(412, 915),
    'Tablet Portrait (800px)': Size(800, 1280),
    'Tablet Landscape (1280px)': Size(1280, 800),
  };

  const textScales = <double>[1.0, 1.3, 1.5];

  final testPreset = RegionPreset.presets.first;

  Widget buildTestScaffold(Widget child, Size size, double textScale) {
    return MediaQuery(
      data: MediaQueryData(
        size: size,
        textScaler: TextScaler.linear(textScale),
      ),
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0F172A),
        ),
        home: child,
      ),
    );
  }

  group('AQIL Universal Multi-Viewport & Accessibility Matrix', () {
    for (final entry in viewports.entries) {
      final viewportName = entry.key;
      final size = entry.value;

      for (final textScale in textScales) {
        testWidgets('DashboardScreen renders without overflow on $viewportName @ ${textScale}x font', (tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            buildTestScaffold(
              DashboardScreen(
                activeRegion: testPreset,
                onRegionChanged: (_) {},
                onNavigateToSos: () {},
              ),
              size,
              textScale,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });

        testWidgets('LiveCalamityScreen renders without overflow on $viewportName @ ${textScale}x font', (tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            buildTestScaffold(
              LiveCalamityScreen(activeRegion: testPreset),
              size,
              textScale,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });

        testWidgets('SosActionScreen renders without overflow on $viewportName @ ${textScale}x font', (tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            buildTestScaffold(
              SosActionScreen(activeRegion: testPreset),
              size,
              textScale,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });

        testWidgets('InteractiveMapScreen renders without overflow on $viewportName @ ${textScale}x font', (tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            buildTestScaffold(
              InteractiveMapScreen(activeRegion: testPreset),
              size,
              textScale,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });

        testWidgets('EmergencyPassScreen renders without overflow on $viewportName @ ${textScale}x font', (tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            buildTestScaffold(
              EmergencyPassScreen(activeRegion: testPreset),
              size,
              textScale,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });

        testWidgets('StatutoryAuditScreen renders without overflow on $viewportName @ ${textScale}x font', (tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            buildTestScaffold(
              StatutoryAuditScreen(activeRegion: testPreset),
              size,
              textScale,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });

        testWidgets('SurvivalPlaybookScreen renders without overflow on $viewportName @ ${textScale}x font', (tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);

          await tester.pumpWidget(
            buildTestScaffold(
              const SurvivalPlaybookScreen(),
              size,
              textScale,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });
      }
    }
  });
}
