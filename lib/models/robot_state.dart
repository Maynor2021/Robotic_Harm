// models/robot_state.dart
// Aquí viven todas las variables del brazo robótico
// Es como una "fuente de verdad" centralizada

class RobotState {
  double tenazaAngle;     // 0 a 90 grados
  double baseAngle;       // 0 a 90 grados
  bool tenazaOpen;        // true = abierta, false = cerrada
  bool securityEnabled;   // true = sistema activo
  bool emergencyActive;   // true = emergencia activada
  bool bluetoothConnected; // true = conectado al Arduino
  bool isVoiceActive;     // true = control por voz activo

  RobotState({
    this.tenazaAngle = 0,
    this.baseAngle = 45,
    this.tenazaOpen = true,
    this.securityEnabled = false,
    this.emergencyActive = false,
    this.bluetoothConnected = false,
    this.isVoiceActive = false,
  });

  // Activa el modo emergencia
  void activateEmergency() {
    tenazaOpen = true;
    tenazaAngle = 0;
    securityEnabled = false;
    baseAngle = 45;
    emergencyActive = true;
  }

  // Desactiva el modo emergencia
  void deactivateEmergency() {
    emergencyActive = false;
  }
}