import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class bluetoothService 
{
 BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;

   // 1. OBTENER dispositivos escaneados
  Stream<List<ScanResult>> getDevices() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
    return FlutterBluePlus.scanResults;
  }

  // 2. CONECTAR
  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      _device = device;

      // Buscar característica para escribir
      List<BluetoothService> services = await device.discoverServices();
      for (var service in services) {
        for (var c in service.characteristics) {
          if (c.properties.write) {
            _characteristic = c;
          }
        }
      }
      return true;
    } catch (e) {
      print('Error al conectar: $e');
      return false;
    }
  }

  // 3. ENVIAR datos al Arduino
  Future<void> sendData(String data) async {
    if (_characteristic != null) {
      await _characteristic!.write(utf8.encode(data));
    }
  }

  // 4. VERIFICAR conexión
  bool get isConnected => _device != null;

  // 5. DESCONECTAR
  Future<void> disconnect() async {
    await _device?.disconnect();
    _device = null;
    _characteristic = null;
  }
}
