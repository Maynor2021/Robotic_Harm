import 'package:flutter/material.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

    @override
    State<NavBarScreen> createState() => _NavBarScreenState();
  }
  
  class _NavBarScreenState extends State<NavBarScreen> {
    @override
    Widget build(BuildContext context) {
      return const MaterialApp(home: NavigationExample());
    }
}
class NavigationExample extends StatefulWidget 
{
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
 
}
class _NavigationExampleState extends State<NavigationExample> 
{  int currentPageIndex=0;
  @override
  Widget build(BuildContext context){
 final ThemeData theme = Theme.of(context);
 return Scaffold(
  bottomNavigationBar: NavigationBar(
    onDestinationSelected: (int index) {
      setState(() {
        currentPageIndex = index;
      });
    },
    indicatorColor: Colors.amber,
    selectedIndex: currentPageIndex,
    destinations: const <Widget>[
      NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.settings), label: 'Notifications'),
      NavigationDestination(icon: Icon(Icons.account_circle), label: 'Messages'),
    ],
  ),
);
  }
  
}