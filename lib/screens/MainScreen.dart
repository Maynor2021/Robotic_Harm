// screens/main_screen.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../widgets/app_theme.dart';
import 'ConfigScreen.dart';
import 'about_scree.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> 
{
  int _currentIndex = 0;

  // Lista de pantallas — HomeScreen ya existe, las demás las creas tú
  final List<Widget> _screens = const [
    HomeScreen(),
    ConfigScreen(),
    AboutScreen(),
    
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // La pantalla activa ocupa todo el body
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: NavigationBar(
        backgroundColor: AppTheme.bgCard,    
        indicatorColor: AppTheme.cyan.withOpacity(0.2),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.precision_manufacturing_outlined),
            selectedIcon: Icon(Icons.precision_manufacturing, color: AppTheme.cyan),
            label: 'Control',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: AppTheme.cyan),
            label: 'Config',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle, color: AppTheme.cyan),
            label: 'Acerca de',
          ),
        ],
      ),
    );
  }
}
