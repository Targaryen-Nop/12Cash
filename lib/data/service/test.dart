import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;

  final _connectivityStreamController = StreamController<bool>.broadcast();
  Stream<bool> get connectivityStream => _connectivityStreamController.stream;

  ConnectivityService._internal() {
    Connectivity().onConnectivityChanged.listen((result) {
      final isConnected = result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi;
      _connectivityStreamController.sink.add(isConnected);
    });
  }

  void dispose() {
    _connectivityStreamController.close();
  }
}
