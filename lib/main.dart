import 'package:_12sale_app/core/components/Gird.dart';
import 'package:_12sale_app/core/page/BluetoothPrinterScreen.dart';
import 'package:_12sale_app/core/page/PrinterScreen.dart';
import 'package:_12sale_app/core/page/TestPrint.dart';
import 'package:_12sale_app/core/page/TestPrinterScreen.dart';
import 'package:_12sale_app/core/page/dashboard/DashboardScreen.dart';
import 'package:_12sale_app/core/page/HomeScreen.dart';
import 'package:_12sale_app/core/page/LoginScreen.dart';
import 'package:_12sale_app/core/page/HomeScreen.dart';
import 'package:_12sale_app/core/page/dashboard/DashboardScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // For date localization
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

late List<CameraDescription> _cameras;

void main() async {
  // Initialize the locale data for Thai language
  await initializeDateFormatting('th', null);
  await dotenv.load(fileName: ".env");
  // Ensure the app is always in portrait mode
  WidgetsFlutterBinding.ensureInitialized();
  // _cameras = await availableCameras();
  // final cameras = await availableCameras();

  // Get the first camera from the list
  // final firstCamera = cameras.first;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Portrait orientation
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return HomeScreen(
      index: 1,
    );
  }
}
