import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/settings_controller.dart';
import 'screens/home_screen.dart';
import 'screens/add_water_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';

/// Main application scaffold with bottom navigation
class AppScaffold extends StatefulWidget {
  const AppScaffold({Key? key}) : super(key: key);

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;

  // List of screens for the bottom navigation
  final List<Widget> _screens = const [
    HomeScreen(),
    AddWaterScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  // List of navigation items
  final List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.water_drop,
      selectedIcon: Icons.water_drop,
      label: 'Today',
    ),
    _NavItem(
      icon: Icons.add_circle_outline,
      selectedIcon: Icons.add_circle,
      label: 'Add',
    ),
    _NavItem(
      icon: Icons.history,
      selectedIcon: Icons.history,
      label: 'History',
    ),
    _NavItem(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final settingsController = context.watch<SettingsController>();
    final isDarkMode = settingsController.isDarkTheme(context);
    
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: _buildNavigationDestinations(isDarkMode),
          height: 65,
          backgroundColor: isDarkMode 
              ? Colors.grey[900] 
              : Colors.white,
        ),
      ),
    );
  }

  /// Build navigation destinations from nav items
  List<NavigationDestination> _buildNavigationDestinations(bool isDarkMode) {
    return _navItems.map((item) {
      return NavigationDestination(
        icon: Icon(item.icon),
        selectedIcon: Icon(
          item.selectedIcon,
          color: Theme.of(context).primaryColor,
        ),
        label: item.label,
      );
    }).toList();
  }
}

/// Helper class for navigation items
class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}