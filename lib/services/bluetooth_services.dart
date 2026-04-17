import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class bluetoothService 
{
 BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;
  // 1 escanear los dispositivos
  
    Stream<List<ScanResult>> getDevices() async* {
      // Pedir permisos primero
      await Permission.bluetoothScan.request();
      await Permission.bluetoothConnect.request();
      await Permission.location.request();

      // Luego escanear
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
      yield* FlutterBluePlus.scanResults;
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
