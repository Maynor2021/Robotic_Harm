import 'package:flutter/material.dart';
import '../widgets/app_theme.dart';



class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {

  // ---- variables de cada switch ----
  bool _bluetoothOn = false;
  bool _voiceOn = false;
  bool _darkModeOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: AppTheme.bgCard,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildSectionTitle("Conexión"),
            _buildSwitchTile(
              title: "Bluetooth",
              subtitle: "Conectar al Arduino",
              icon: Icons.bluetooth,
              value: _bluetoothOn,               // ← lee la variable
              onChanged: (v) {
                setState(() => _bluetoothOn = v); // ← guarda y redibuja
              },
            ),

            const SizedBox(height: 16),

            _buildSectionTitle("Control"),
            _buildSwitchTile(
              title: "Control por voz",
              subtitle: "Activar micrófono",
              icon: Icons.mic,
              value: _voiceOn,
              onChanged: (v) {
                setState(() => _voiceOn = v);
              },
            ),

            const SizedBox(height: 16),

            _buildSectionTitle("Apariencia"),
            _buildSwitchTile(
              title: "Modo oscuro",
              subtitle: "Tema de la aplicación",
              icon: Icons.dark_mode,
              value: _darkModeOn,
              onChanged: (v) {
                setState(() => _darkModeOn = v);
              },
            ),

          ],
        ),
      ),
    );
  }

  // ---- WIDGETS PRIVADOS ----

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(width: 3, height: 16, color: AppTheme.cyan),
          const SizedBox(width: 8),
          Text(title,
            style: const TextStyle(
              color: AppTheme.cyan,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontSize: 12,
            )),
        ],
      ),
    );
  }

  // ← ahora recibe onChanged como parámetro
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged, // ← función que recibe un bool
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value ? AppTheme.cyan : AppTheme.border, // ← borde cambia con el switch
        ),
      ),
      child: Row(
        children: [
          Icon(icon,
            color: value ? AppTheme.cyan : AppTheme.textSecondary, // ← ícono cambia
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                  style: TextStyle(
                    color: value ? AppTheme.textPrimary : AppTheme.textSecondary,
                    fontWeight: FontWeight.bold,
                  )),
                Text(subtitle,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  )),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged, // ← usa la función que recibió
            activeColor: AppTheme.cyan,
          ),
        ],
      ),
    );
  }
}