// services/bluetooth_services.dart
import 'package:flutter_bluetooth_classic_serial/flutter_bluetooth_classic.dart';

class BluetoothService {
  final FlutterBluetoothClassic _bluetooth = FlutterBluetoothClassic();

  // Verifica si Bluetooth está encendido
  Future<bool> isEnabled() async {
    try {
      return await _bluetooth.isBluetoothEnabled();
    } catch (_) {
      return false;
    }
  }

  // Devuelve los dispositivos YA emparejados (ahí debe estar el HC-05)
  Future<List<BluetoothDevice>> getPairedDevices() async {
    try {
      return await _bluetooth.getPairedDevices();
    } catch (e) {
      return [];
    }
  }

  // Conecta al HC-05 por su MAC address
  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      return await _bluetooth.connect(device.address);
    } catch (e) {
      return false;
    }
  }

  // Desconecta
  Future<bool> disconnect() async {
    try {
      return await _bluetooth.disconnect();
    } catch (_) {
      return false;
    }
  }

  // Envía un string al Arduino (ej: "T1", "B45", "E")
  Future<bool> sendCommand(String message) async {
    try {
      return await _bluetooth.sendString(message);
    } catch (_) {
      return false;
    }
  }

  // Stream de datos entrantes desde el Arduino
  Stream<BluetoothData> get onDataReceived => _bluetooth.onDataReceived;

  // Stream de cambios en la conexión
  Stream<BluetoothConnectionState> get onConnectionChanged =>
      _bluetooth.onConnectionChanged;
}

// Instancia global (singleton sencillo) para usar desde cualquier pantalla
final _service = BluetoothService();
BluetoothService bluetoothService() => _service;