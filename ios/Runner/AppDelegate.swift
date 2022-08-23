import UIKit
import Flutter
import CoreBluetooth





@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        
        
        
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let bluetoothChannel = FlutterMethodChannel(name: "samples.flutter.dev/bluetooth", binaryMessenger: controller.binaryMessenger)
        let bluetoothViewModel = BluetoothViewModel()
        
        
        bluetoothChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            bluetoothChannel.setMethodCallHandler({
                [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
                // This method is invoked on the UI thread.
                guard call.method == "searchBluetoothDevices" else {
                    result(FlutterMethodNotImplemented)
                    return
                }
                result(bluetoothViewModel.peripheralNames)
            })
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
        
    
}


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



