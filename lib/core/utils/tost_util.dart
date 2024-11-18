import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart'; // Ensure this package is imported
import 'package:_12sale_app/core/styles/style.dart'; // Adjust the path as needed

void showToast({
  required BuildContext context,
  required String message,
  ToastificationType type = ToastificationType.success,
  ToastificationStyle style = ToastificationStyle.flatColored,
  Color primaryColor = Colors.green,
  Duration autoCloseDuration = const Duration(seconds: 5),
}) {
  toastification.show(
    context: context,
    primaryColor: primaryColor,
    type: type,
    style: style,
    title: Text(
      message,
      style: Styles.black18(context), // Adjust your style method as necessary
    ),
    autoCloseDuration: autoCloseDuration,
  );
}
