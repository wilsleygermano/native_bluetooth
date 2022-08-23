# Native Bluetooth in flutter through MethodChannel **(WIP)**

This repo is not finished yet. My goal is to build a simple app with Flutter to search and to connect bluetooth devices through native plataform code (Swift and Kotlin).

**Be advised that this is not a tutorial. Is just my way of taking notes.**

My flutter doctor:

```Text
[✓] Flutter (Channel stable, 2.10.5, on macOS 12.5.1 21G83 darwin-arm, locale en-BR)
[✓] Android toolchain - develop for Android devices (Android SDK version 32.1.0-rc1)
[✓] Xcode - develop for iOS and macOS (Xcode 13.4.1)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2021.1)
[✓] VS Code (version 1.70.2)
[✓] Connected device (2 available)
[✓] HTTP Host Availability
```

## Getting started

### MethodChannel

Create a channel name with an unique name. Like this:

```Dart
static const platform = MethodChannel('samples.flutter.dev/bluetooth')
```

Then make a method which are going to be called on Swift side. The "invokeMethod" requires a string identifier, which must be equal to the method name you've just created.

```Dart
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
```

### Swift Side

First of all you need to add the following permissions to the "info.plist" (ios/Runner/info.plist) file:

```XML
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Allow Bluetooth for search devices</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>Allow Bluetooth for peripherals search</string>
```

After that open the "ios" folder in Xcode and then navigate to the "AppDelegate.swift" file.

Import the "CoreBluetooth" framework.

Inside the "application" method are declared three constants:

```Swift
let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
let bluetoothChannel = FlutterMethodChannel(name: "samples.flutter.dev/bluetooth", binaryMessenger: controller.binaryMessenger)
// this last one initializes the class below
let bluetoothViewModel = BluetoothViewModel()
```

Notice the "bluetoothChannel" constants initialize the "FlutterMethodChannel", which receives the same channel name declared on Flutter side. Follow the [Fluter documentation](https://docs.flutter.dev/development/platform-integration/platform-channels?tab=android-channel-java-tab) for more details.

Add these class and extension:

```Swift
class BluetoothViewModel: NSObject, ObservableObject {
    private var centralManager: CBCentralManager?
    private var periphals: [CBPeripheral] = []
    @Published var peripheralNames: [String] = []

    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
}

extension BluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.centralManager?.scanForPeripherals(withServices: nil)
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !periphals.contains(peripheral) {
            self.periphals.append(peripheral)
            self.peripheralNames.append(peripheral.name ?? "Unnamed device")
            
        }
    }
}
```

> For more information about CoreBluetooth framework and CBCentralManager, access the [Swift documentation](https://developer.apple.com/documentation/corebluetooth).

Inside the ".setMethodCallHandler" you need to return the "result", which will receive the "peripheralNames".

That's it for now.
