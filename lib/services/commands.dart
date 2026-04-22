import 'package:brazo_robotico/models/robot_state.dart';
import 'package:brazo_robotico/services/bluetooth_services.dart';

class ProcesarComando {
  final BluetoothService _bluetoothService = BluetoothService();
  final RobotState robot;
  final Function(void Function()) onSetState;

  // Lista solo para comparar
  final List<String> comandos = [
    'mover brazo arriba',
    'mover brazo abajo',
    'mover brazo izquierda',
    'mover brazo derecha',
    'abrir pinza',
    'cerrar pinza',
    'emergencia',
    'activar seguridad',
    'desactivar seguridad',
    'desactivar emergencia',
  ];

  ProcesarComando({required this.robot, required this.onSetState});

  void ejecutarComando(String p1) {
    String texto = p1.toLowerCase().trim();

    if (!comandos.contains(texto)) {
      print('Comando no reconocido: $p1');
      return;
    }

    switch (texto) {
      case 'mover brazo arriba':
        _bluetoothService.sendCommand('T1');
        onSetState(() => robot.baseAngle = 90);
        break;
      case 'mover brazo abajo':
        _bluetoothService.sendCommand('B1');
        onSetState(() => robot.baseAngle = 0);
        break;
      case 'mover brazo izquierda':
        _bluetoothService.sendCommand('L1');
        break;
      case 'mover brazo derecha':
        _bluetoothService.sendCommand('R1');
        break;
      case 'abrir pinza':
        _bluetoothService.sendCommand('O1');
        onSetState(() => robot.tenazaAngle = 0);
        break;
      case 'cerrar pinza':
        _bluetoothService.sendCommand('C1');
        onSetState(() => robot.tenazaAngle = 90);
        break;
      case 'emergencia':
        _bluetoothService.sendCommand('E');
        onSetState(() => robot.emergencyActive = true);
        break;
      case 'activar seguridad':
        _bluetoothService.sendCommand('S1');
        onSetState(() => robot.securityEnabled = true);
        break;
      case 'desactivar seguridad':
        _bluetoothService.sendCommand('S0');
        onSetState(() => robot.securityEnabled = false);
        break;
      case 'desactivar emergencia':
        _bluetoothService.sendCommand('D0');
        onSetState(() => robot.emergencyActive = false);
        break;
    }
  }
}