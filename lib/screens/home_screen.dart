// screens/home_screen.dart
// Pantalla principal del Brazo Robótico

import 'package:brazo_robotico/services/bluetooth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/robot_state.dart';
import '../widgets/app_theme.dart';
import '../widgets/robot_card.dart';
import '../widgets/robot_slider.dart';
import '../widgets/action_button.dart';
import '../widgets/pinza_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Estado del robot
  final RobotState robot = RobotState();

  // Controladores de animación para el botón de emergencia
  late AnimationController _emergencyController;
  late Animation<double> _emergencyPulse;

  @override
  void initState() {
    super.initState();
    // Animación pulsante para el botón de emergencia activo
    _emergencyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _emergencyPulse = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _emergencyController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _emergencyController.dispose();
    super.dispose();
  }

  // =========================================================
  // BUILD PRINCIPAL
  // =========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,

      // ---- HEADER ----
      appBar: AppBar(
        backgroundColor: AppTheme.bgCard,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.border),
        ),
        title: const Row(
          children: [
            Icon(Icons.precision_manufacturing, color: AppTheme.cyan, size: 20),
            SizedBox(width: 8),
            Text(
              "BRAZO ROBÓTICO",
              style: TextStyle(
                color: AppTheme.cyan,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        actions: [
          // Indicador de conexión Bluetooth
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildStatusDot(),
          ),
        ],
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ---- BANNER DE EMERGENCIA (aparece solo si está activo) ----
            if (robot.emergencyActive) _buildEmergencyBanner(),

            // ---- SECCIÓN: Logo UJCV ----
            _buildUjcvSection(),

            // ---- SECCIÓN: TENAZA ----
            _buildTenazaSection(),

            // ---- SECCIÓN: BASE ----
            _buildBaseSection(),

            // ---- SECCIÓN: CONTROLES ----
            _buildControlsGrid(),

            // ---- SECCIÓN: BLUETOOTH Y MICRÓFONO ----
            _buildConnectionSection(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // WIDGETS DE CADA SECCIÓN
  // =========================================================

  // Punto de estado (verde = conectado, gris = desconectado)
  Widget _buildStatusDot() {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: robot.bluetoothConnected
                ? AppTheme.green
                : AppTheme.textSecondary,
            boxShadow: robot.bluetoothConnected
                ? [
                    BoxShadow(
                      color: AppTheme.green.withOpacity(0.6),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          robot.bluetoothConnected ? "CONECTADO" : "OFFLINE",
          style: TextStyle(
            fontSize: 10,
            color: robot.bluetoothConnected
                ? AppTheme.green
                : AppTheme.textSecondary,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  // Banner rojo de emergencia
  Widget _buildEmergencyBanner() {
    return AnimatedBuilder(
      animation: _emergencyPulse,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          color: AppTheme.red.withOpacity(_emergencyPulse.value * 0.3),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, color: AppTheme.red, size: 16),
              SizedBox(width: 8),
              Text(
                "⚠  MODO EMERGENCIA ACTIVO  ⚠",
                style: TextStyle(
                  color: AppTheme.red,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Logo UJCV con click largo para dialog
  Widget _buildUjcvSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          // Título principal
          const Text(
            "BRAZO ROBÓTICO ARDUINO",
            style: AppTheme.titleStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Imagen UJCV con click largo
          GestureDetector(
            onLongPress: _showAboutDialog,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.bgCardLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  // Aquí va tu imagen - por ahora muestra placeholder
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.bgDark,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.school,
                      color: AppTheme.cyan,
                      size: 48,
                    ),
                    // CUANDO TENGAS LA IMAGEN descomenta esto y borra el Container de arriba:
                    // child: Image.asset("assets/Ujcv.png", height: 80),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Mantén presionado para info",
                    style: TextStyle(
                      fontSize: 10,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Sección de la Tenaza
  Widget _buildTenazaSection() {
    return RobotCard(
      title: "Tenaza",
      isAccented: true,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ✅ PINZA ANIMADA — reemplaza el Container con ícono
              PinzaWidget(angle: robot.tenazaAngle, size: 100),

              // Estado y botón
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    robot.tenazaOpen ? "ABIERTA" : "CERRADA",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: robot.tenazaOpen ? AppTheme.green : AppTheme.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: robot.securityEnabled
                        ? () {
                            HapticFeedback.lightImpact();
                            setState(
                              () => robot.tenazaOpen = !robot.tenazaOpen,
                            );
                          }
                        : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: robot.securityEnabled
                            ? AppTheme.cyan.withOpacity(0.15)
                            : AppTheme.bgCardLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: robot.securityEnabled
                              ? AppTheme.cyan
                              : AppTheme.border,
                        ),
                      ),
                      child: Text(
                        "TENAZA",
                        style: TextStyle(
                          color: robot.securityEnabled
                              ? AppTheme.cyan
                              : AppTheme.textSecondary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Click corto = abrir/cerrar",
                    style: TextStyle(
                      fontSize: 9,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Slider de Tenaza
          RobotSlider(
            label: "Ángulo Tenaza",
            value: robot.tenazaAngle,
            min: 0,
            max: 90,
            enabled: robot.securityEnabled,
            color: AppTheme.cyan,
            onChanged: (value) {
              setState(() {
                robot.tenazaAngle = value;
                robot.tenazaOpen = value < 45;
              });
            },
          ),
        ],
      ),
    );
  }

  // Sección de la Base
  Widget _buildBaseSection() {
    return RobotCard(
      title: "Base",
      accentColor: AppTheme.orange,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Imagen de giro de base
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.bgCardLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.orange.withOpacity(0.5)),
                ),
                child: Transform.rotate(
                  // Rota el ícono según el ángulo
                  angle: (robot.baseAngle / 90) * 3.14159,
                  child: const Icon(
                    Icons.rotate_right,
                    size: 40,
                    color: AppTheme.orange,
                  ),
                ),
                // CUANDO TENGAS IMAGEN:
                // child: Transform.rotate(
                //   angle: (robot.baseAngle / 90) * 3.14159,
                //   child: Image.asset("assets/base_giro.png"),
                // ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${robot.baseAngle.toInt()}°",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.orange,
                    ),
                  ),
                  const Text(
                    "BASE",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          RobotSlider(
            label: "Ángulo Base",
            value: robot.baseAngle,
            min: 0,
            max: 90,
            enabled: robot.securityEnabled,
            color: AppTheme.orange,
            onChanged: (value) {
              setState(() => robot.baseAngle = value);
            },
          ),
        ],
      ),
    );
  }

  // Grid de botones de control
  Widget _buildControlsGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Etiqueta de sección
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 3,
                  height: 16,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: AppTheme.green),
                  ),
                ),
                SizedBox(width: 8),
                Text("CONTROLES", style: AppTheme.labelStyle),
              ],
            ),
          ),

          // Grid 2x2
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              // 1. BOTÓN SEGURIDAD
              ActionButton(
                label: "SEGURIDAD",
                description: "Corto: activar\nLargo: desactivar",
                icon: robot.securityEnabled ? Icons.lock_open : Icons.lock,
                color: robot.securityEnabled
                    ? AppTheme.green
                    : AppTheme.textSecondary,
                enabled: true,
                onTap: () {
                  // Click corto = habilita
                  setState(() => robot.securityEnabled = true);
                  _showSnack("✅ Sistema habilitado");
                },
                onLongPress: () {
                  // Click largo = deshabilita
                  setState(() => robot.securityEnabled = false);
                  _showSnack("🔒 Sistema deshabilitado");
                },
              ),

              // 2. BOTÓN EMERGENCIA
              ActionButton(
                label: "EMERGENCIA",
                description: "Largo: activar\nCorto: desactivar",
                icon: Icons.warning_rounded,
                color: robot.emergencyActive ? AppTheme.red : AppTheme.orange,
                enabled: true,
                onTap: () {
                  // Click corto = desactiva emergencia
                  setState(() => robot.deactivateEmergency());
                  _showSnack("✅ Emergencia desactivada");
                },
                onLongPress: () {
                  // Click largo = activa emergencia
                  setState(() => robot.activateEmergency());
                  _showSnack("🚨 EMERGENCIA ACTIVADA");
                },
              ),

              // 3. BOTÓN BLUETOOTH
              ActionButton(
                label: "BLUETOOTH",
                description: "Largo: conectar\nal Arduino",
                icon: Icons.bluetooth,
                color: robot.bluetoothConnected
                    ? AppTheme.cyan
                    : AppTheme.textSecondary,
                enabled: true,
                onTap: null,
                onLongPress: () {
                  final btService = bluetoothService();
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: AppTheme.bgCard,
                      title: const Text(
                        "Buscando dispositivos...",
                        style: TextStyle(color: AppTheme.cyan),
                      ),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: StreamBuilder<List<ScanResult>>(
                          stream: btService.getDevices(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final devices = snapshot.data!;
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: devices.length,
                              itemBuilder: (context, index) {
                                final device = devices[index].device;
                                return ListTile(
                                  leading: const Icon(
                                    Icons.bluetooth,
                                    color: AppTheme.cyan,
                                  ),
                                  title: Text(
                                    device.platformName.isEmpty
                                        ? "Desconocido"
                                        : device.platformName,
                                    style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  subtitle: Text(
                                    device.remoteId.toString(),
                                    style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    bool ok = await btService.connectToDevice(
                                      device,
                                    );
                                    setState(
                                      () => robot.bluetoothConnected = ok,
                                    );
                                    _showSnack(
                                      ok
                                          ? "✅ Conectado"
                                          : "❌ Error al conectar",
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),

              // 4. BOTÓN MICRÓFONO

              // 4. BOTÓN MICRÓFONO
              ActionButton(
                label: "MICRÓFONO",
                description: "Corto: instrucciones\nLargo: control voz",
                icon: robot.isVoiceActive ? Icons.mic : Icons.mic_none,
                color: robot.isVoiceActive
                    ? AppTheme.green
                    : AppTheme.textSecondary,
                enabled: robot.securityEnabled,
                onTap: () {
                  // Click corto = muestra instrucciones
                  _showVoiceInstructions();
                },
                onLongPress: () {
                  // Click largo = activa control por voz
                  setState(() => robot.isVoiceActive = !robot.isVoiceActive);
                  _showSnack(
                    robot.isVoiceActive
                        ? "🎤 Control por voz activado"
                        : "🎤 Control por voz desactivado",
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Sección inferior con estado de conexión
  Widget _buildConnectionSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          // Ícono Bluetooth grande
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: robot.bluetoothConnected
                  ? AppTheme.cyan.withOpacity(0.1)
                  : AppTheme.bgCardLight,
              shape: BoxShape.circle,
              border: Border.all(
                color: robot.bluetoothConnected
                    ? AppTheme.cyan
                    : AppTheme.border,
              ),
            ),
            child: Icon(
              Icons.bluetooth,
              color: robot.bluetoothConnected
                  ? AppTheme.cyan
                  : AppTheme.textSecondary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  robot.bluetoothConnected
                      ? "Arduino Conectado"
                      : "Sin conexión",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: robot.bluetoothConnected
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                  ),
                ),
                Text(
                  robot.bluetoothConnected
                      ? "Mantén presionado BT para desconectar"
                      : "Mantén presionado BT para conectar",
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // MÉTODOS (funciones)
  // =========================================================

  // Muestra un Snackbar (mensajito abajo de la pantalla)
  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.bgCard,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Dialog de información de la UJCV
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.cyan, width: 1),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo UJCV
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: AppTheme.bgDark,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.school, color: AppTheme.cyan, size: 48),
              // CUANDO TENGAS IMAGEN:
              // child: Image.asset("assets/Ujcv_logo.png", height: 80),
            ),
            const SizedBox(height: 16),
            const Text(
              "Brazo Robótico Arduino",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.cyan,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Creado por",
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 4),
            const Text(
              "Clase Electrónica Digital",
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "UJCV",
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text("2026", style: TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar", style: TextStyle(color: AppTheme.cyan)),
          ),
        ],
      ),
    );
  }

  // Dialog de instrucciones de control por voz
  void _showVoiceInstructions() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.green, width: 1),
        ),
        title: const Row(
          children: [
            Icon(Icons.mic, color: AppTheme.green),
            SizedBox(width: 8),
            Text(
              "Control por Voz",
              style: TextStyle(color: AppTheme.green, fontSize: 16),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Comandos disponibles:",
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
            ),
            SizedBox(height: 12),
            _VoiceCommand(
              command: "\"abrir tenaza\"",
              action: "Abre la tenaza",
            ),
            _VoiceCommand(
              command: "\"cerrar tenaza\"",
              action: "Cierra la tenaza",
            ),
            _VoiceCommand(
              command: "\"base izquierda\"",
              action: "Gira base a 0°",
            ),
            _VoiceCommand(command: "\"base centro\"", action: "Base a 45°"),
            _VoiceCommand(
              command: "\"base derecha\"",
              action: "Gira base a 90°",
            ),
            _VoiceCommand(
              command: "\"emergencia\"",
              action: "Activa emergencia",
            ),
            _VoiceCommand(command: "\"detener\"", action: "Para todo"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Entendido",
              style: TextStyle(color: AppTheme.green),
            ),
          ),
        ],
      ),
    );
  }
}

extension on Future<List<BluetoothDevice>> {
  int? get length => null;
}

// Widget auxiliar para cada comando de voz en el dialog
class _VoiceCommand extends StatelessWidget {
  final String command;
  final String action;

  const _VoiceCommand({required this.command, required this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.arrow_right, color: AppTheme.green, size: 16),
          const SizedBox(width: 4),
          Text(
            command,
            style: const TextStyle(
              color: AppTheme.cyan,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "→ $action",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
