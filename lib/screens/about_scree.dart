import 'package:flutter/material.dart';
import '../widgets/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  final String nombre='Maynor Rodriguez';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgCard,
      appBar: AppBar(title: const Text('Acerca de'), backgroundColor: AppTheme.bgCard,),
      body :Center( 
         child :Text("Brazo Robótico Control App\n\nDesarrollada por $nombre\n\nVersión 1.0.0", 
        style: TextStyle(fontSize: 18, color: Colors.white70)),
      ),
    );
  }
}
