import 'package:flutter/services.dart';

class HomePageController {
  // channel name (must be unique)
  static const platform = MethodChannel('samples.flutter.dev/bluetooth');

  // method specifying the concrete method to call using the String identifier
  // list typecast MUST be <Object?>
  Future<void> searchBluetoothDevices(List<Object?> peripheralNames) async {
    try {
      // the String indentifier is 'searchBluetoothDevices'
      final List<Object?> result =
          await platform.invokeMethod('searchBluetoothDevices');
      peripheralNames.addAll(result);
    } on PlatformException catch (e) {
      peripheralNames.add("No bluetooth device found: ${e.message}.");
    }
  }
}
