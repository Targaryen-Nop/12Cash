import 'package:_12sale_app/core/components/Gird.dart';
import 'package:_12sale_app/core/page/CustomBottomBar.dart';
import 'package:_12sale_app/core/page/NotificationScreen.dart';
import 'package:_12sale_app/core/page/Ractangle3D.dart';
import 'package:_12sale_app/core/page/Square3D.dart';
import 'package:_12sale_app/core/page/printer/BluetoothPrinterScreen.dart';
import 'package:_12sale_app/core/page/printer/PrinterBluetoothScreen.dart';
import 'package:_12sale_app/core/page/printer/TestPrint.dart';
import 'package:_12sale_app/core/page/printer/TestPrinterScreen.dart';
import 'package:_12sale_app/core/page/dashboard/DashboardScreen.dart';
import 'package:_12sale_app/core/page/HomeScreen.dart';
import 'package:_12sale_app/core/page/LoginScreen.dart';
import 'package:_12sale_app/core/page/HomeScreen.dart';
import 'package:_12sale_app/core/page/dashboard/DashboardScreen.dart';
import 'package:_12sale_app/core/page/route/TossAddToCartScreen.dart';
import 'package:_12sale_app/core/page/testOffline.dart';
import 'package:_12sale_app/data/service/localNotification.dart';
import 'package:_12sale_app/data/service/requestPremission.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // For date localization
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

late List<CameraDescription> _cameras;

void main() async {
  // Initialize the locale data for Thai language

  // Ensure the app is always in portrait mode
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the notifications
  await initializeNotifications();

  await requestAllPermissions();
  await initializeDateFormatting('th', null);
  await dotenv.load(fileName: ".env");
  await ScreenUtil.ensureScreenSize();
  // Initialize the background service
  // final hasPermissions = await FlutterBackground.initialize(
  //   androidConfig: const FlutterBackgroundAndroidConfig(
  //     notificationTitle: "Background Service",
  //     notificationText: "This app is running in the background.",
  //     notificationImportance: AndroidNotificationImportance.high,
  //     enableWifiLock: true,
  //   ),
  // );
  // if (!hasPermissions) {
  //   print("Background permissions not granted");
  // }

  // _cameras = await availableCameras();
  // final cameras = await availableCameras();

  // Get the first camera from the list
  // final firstCamera = cameras.first;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      const KeyboardVisibilityProvider(
        child: MyApp(),
      ),
    );
  });
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Base screen size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorObservers: [routeObserver], // Register RouteObserver here
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          // home: const LoginScreen(),
          home: const HomeScreen(
            index: 0,
          ),
          // home: NotificationScreen(),
          // home: HomeScreen2(),
          // home: CustomBottomNavBar(),
          // home: BluetoothPrinterScreen4(),
          // home: AddToCartAnimationPage(),
        );
      },
    );
  }
}
