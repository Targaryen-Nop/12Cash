import 'dart:async';
import 'package:flutter/material.dart';

class Throttler {
  final Duration delay;
  Timer? _timer;

  Throttler({required this.delay});

  void run(VoidCallback action) {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer(delay, action);
    }
  }
}
