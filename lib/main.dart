import 'package:flutter/material.dart';
import 'models/region_preset.dart';
import 'screens/dashboard_screen.dart';
import 'screens/interactive_map_screen.dart';
import 'screens/live_calamity_screen.dart';
import 'screens/sos_action_screen.dart';
import 'screens/survival_playbook_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LifeSaver());
}

class LifeSaver extends StatelessWidget {
  const LifeSaver({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeSaver - Disaster Early Warning',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF38BDF8),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          secondary: Color(0xFFEF4444),
          surface: Color(0xFF1E293B),
        ),
        fontFamily: 'Roboto',
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;
  // Default to Kathmandu Valley (Bagmati River Basin)
  RegionPreset _activeRegion = RegionPreset.presets.first;

  void _onRegionChanged(RegionPreset newRegion) {
    setState(() {
      _activeRegion = newRegion;
    });
  }

  void _navigateToSos() {
    setState(() {
      _currentIndex = 3; // SOS tab index
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(
        activeRegion: _activeRegion,
        onRegionChanged: _onRegionChanged,
        onNavigateToSos: _navigateToSos,
      ),
      InteractiveMapScreen(
        activeRegion: _activeRegion,
      ),
      LiveCalamityScreen(
        activeRegion: _activeRegion,
      ),
      SosActionScreen(
        activeRegion: _activeRegion,
      ),
      const SurvivalPlaybookScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          border: Border(
            top: BorderSide(color: Colors.white10, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: const Color(0xFF0F172A),
          selectedItemColor: const Color(0xFF38BDF8),
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              activeIcon: Icon(Icons.dashboard_rounded, color: Color(0xFF38BDF8)),
              label: 'Threat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_rounded),
              activeIcon: Icon(Icons.map_rounded, color: Color(0xFF38BDF8)),
              label: 'Basin Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dynamic_feed_rounded),
              activeIcon: Icon(Icons.dynamic_feed_rounded, color: Color(0xFF38BDF8)),
              label: 'Live Feeds',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emergency_rounded),
              activeIcon: Icon(Icons.emergency_rounded, color: Color(0xFFEF4444)),
              label: 'SOS Alert',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              activeIcon: Icon(Icons.menu_book_rounded, color: Color(0xFF10B981)),
              label: 'Playbooks',
            ),
          ],
        ),
      ),
    );
  }
}
