import 'dart:typed_data';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Print Invoice'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BluetoothDevice> _devices = [];
  final BlueThermalPrinter _printer = BlueThermalPrinter.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findDevices();
  }

  void findDevices() async {
    _devices = await _printer.getBondedDevices();
    print("Devices-> ${_devices.length}");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _devices.isNotEmpty
          ? ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: _devices.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () async {
                    _printer.connect(_devices[index]);
                    if ((await _printer.isConnected)!) {
                      print("printing...");
                      _printer.printNewLine();
                      _printer.printCustom(
                          "Hi, Greeting form supply line", 0, 1);
                      _printer.printQRcode(
                          "Hi, Greeting form supply line", 200, 200, 1);
                     /* http.Response response = await http.get(Uri.parse(
                          'https://panel.supplyline.network/sr/generate-invoice/11469/'));*/
                    }
                  },
                  child: Container(
                    height: 50,
                    color: Colors.amber[200],
                    child: Center(child: Text(_devices[index].name!)),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            )
          : const Center(child: Text("No device found!")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //http.Response response = await http.get(Uri.parse('https://panel.supplyline.network/sr/generate-invoice/11469/'));
          //findDevices();
        },
        tooltip: 'print',
        child: const Text("Print"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
