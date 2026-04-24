import 'package:brazo_robotico/models/robot_state.dart';
import 'package:brazo_robotico/services/bluetooth_services.dart';

class ProcesarComando {
  final BluetoothService _bluetoothService = BluetoothService();
  final RobotState robot;
  final Function(void Function()) onSetState;

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
        _bluetoothService.sendCommand('B90');
        onSetState(() => robot.baseAngle = 90);
        break;

      case 'mover brazo abajo':
        _bluetoothService.sendCommand('B0');
        onSetState(() => robot.baseAngle = 0);
        break;

      case 'mover brazo izquierda':
        _bluetoothService.sendCommand('B0');
        onSetState(() => robot.baseAngle = 0);
        break;

      case 'mover brazo derecha':
        _bluetoothService.sendCommand('B90');
        onSetState(() => robot.baseAngle = 90);
        break;

      case 'abrir pinza':
        _bluetoothService.sendCommand('T0');
        onSetState(() => robot.tenazaAngle = 0);
        break;

      case 'cerrar pinza':
        _bluetoothService.sendCommand('T90');
        onSetState(() => robot.tenazaAngle = 90);
        break;

      case 'emergencia':
        _bluetoothService.sendCommand('E1');
        onSetState(() => robot.activateEmergency());
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
        _bluetoothService.sendCommand('E0');
        onSetState(() => robot.deactivateEmergency());
        break;
    }
  }
}