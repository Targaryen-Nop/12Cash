import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class BluetoothPrinterScreen extends StatefulWidget {
  @override
  _BluetoothPrinterScreenState createState() => _BluetoothPrinterScreenState();
}

class _BluetoothPrinterScreenState extends State<BluetoothPrinterScreen> {
  String _info = "";
  bool connected = false;
  List<BluetoothInfo> devices = [];
  String printSize = "58 mm";
  List<String> sizeOptions = ["58 mm", "80 mm"];
  String _selectSize = "2";
  final _txtText = TextEditingController(text: "Hello developer");
  bool _progress = false;
  String _msj = "Status message";

  @override
  void initState() {
    super.initState();
    initBluetooth();
  }

  Future<void> initBluetooth() async {
    try {
      final bool isBluetoothEnabled =
          await PrintBluetoothThermal.bluetoothEnabled;
      if (isBluetoothEnabled) {
        _msj = "Bluetooth enabled, please search and connect";
      } else {
        _msj = "Bluetooth not enabled";
      }

      final platformVersion = await PrintBluetoothThermal.platformVersion;
      final batteryLevel = await PrintBluetoothThermal.batteryLevel;

      setState(() {
        _info = "$platformVersion ($batteryLevel% battery)";
      });
    } on PlatformException {
      setState(() {
        _info = "Failed to get platform version.";
      });
    }
  }

  Future<void> scanDevices() async {
    setState(() {
      _progress = true;
      devices = [];
    });

    final List<BluetoothInfo> result =
        await PrintBluetoothThermal.pairedBluetooths;
    setState(() {
      _progress = false;
      devices = result;
      _msj = result.isEmpty
          ? "No Bluetooth devices found"
          : "Select a device to connect";
    });
  }

  Future<void> connectToDevice(String macAddress) async {
    setState(() {
      _progress = true;
      _msj = "Connecting...";
    });

    final bool isConnected =
        await PrintBluetoothThermal.connect(macPrinterAddress: macAddress);
    setState(() {
      connected = isConnected;
      _progress = false;
      _msj = isConnected ? "Connected to $macAddress" : "Failed to connect";
    });
  }

  Future<void> disconnect() async {
    final bool status = await PrintBluetoothThermal.disconnect;
    setState(() {
      connected = !status;
      _msj = "Disconnected";
    });
  }

  Future<void> printTest() async {
    bool isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected) {
      // List<int> bytes = await generatePrintData();
      // await PrintBluetoothThermal.writeBytes(bytes);
    } else {
      setState(() {
        _msj = "No device connected";
      });
    }
  }

  // Future<List<int>> generatePrintData() async {
  //   List<int> bytes = [];
  //   final profile = await CapabilityProfile.load();
  //   final generator = Generator(printSize == "58 mm" ? PaperSize.mm58 : PaperSize.mm80, profile);

  //   bytes += generator.reset();
  //   bytes += generator.text("Hello Developer", styles: PosStyles(bold: true, align: PosAlign.center));

  //   // You can add more content here as needed.
  //   bytes += generator.feed(2);
  //   return bytes;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bluetooth Printer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Info: $_info"),
            Text("Message: $_msj"),
            SizedBox(height: 10),

            // Dropdown for print size selection
            Row(
              children: [
                Text("Print Size:"),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: printSize,
                  items: sizeOptions.map((size) {
                    return DropdownMenuItem(
                      value: size,
                      child: Text(size),
                    );
                  }).toList(),
                  onChanged: (newSize) {
                    setState(() {
                      printSize = newSize!;
                    });
                  },
                ),
              ],
            ),

            // Buttons for scanning, connecting, and printing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: scanDevices,
                  child:
                      _progress ? CircularProgressIndicator() : Text("Search"),
                ),
                ElevatedButton(
                  onPressed: connected ? disconnect : null,
                  child: Text("Disconnect"),
                ),
                ElevatedButton(
                  onPressed: connected ? printTest : null,
                  child: Text("Print Test"),
                ),
              ],
            ),

            // Device list for connection
            Expanded(
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return ListTile(
                    title: Text(device.name),
                    subtitle: Text(device.macAdress),
                    onTap: () => connectToDevice(device.macAdress),
                  );
                },
              ),
            ),

            // Input for custom text printing
            TextField(
              controller: _txtText,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Text to print",
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed:
                  connected ? () => printCustomText(_txtText.text) : null,
              child: Text("Print Custom Text"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> printCustomText(String text) async {
    bool isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected) {
      await PrintBluetoothThermal.writeString(
        printText: PrintTextSize(size: int.parse(_selectSize), text: "$text\n"),
      );
      setState(() {
        _msj = "Printed custom text: $text";
      });
    } else {
      setState(() {
        _msj = "No connected device";
      });
    }
  }
}
