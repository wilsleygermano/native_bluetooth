import 'package:flutter/material.dart';
import 'package:native_bluetooth/controller/homepage_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  List<Object?> peripheralNames = [];
  final controller = HomePageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Native Bluetooth"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Nearby Bluetooth Devices:',
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                          itemCount: peripheralNames.length,
                          itemBuilder: (context, index) {
                            return Text(peripheralNames[index].toString());
                          }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          setState(() {
            controller.searchBluetoothDevices(peripheralNames);
          });
        },
        tooltip: 'Refresh',
        child: const Icon(
          Icons.refresh,
        ),
      ),
    );
  }
}
