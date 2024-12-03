import 'package:_12sale_app/core/page/store/CheckStoreDuplicateScreen.dart';
import 'package:_12sale_app/data/models/DuplicateStore.dart';
import 'package:_12sale_app/data/models/Store.dart';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:toastification/toastification.dart'; // Ensure this package is imported
import 'package:_12sale_app/core/styles/style.dart'; // Adjust the path as needed

void showToast({
  required BuildContext context,
  required String message,
  Icon? icon,
  ToastificationType type = ToastificationType.success,
  ToastificationStyle style = ToastificationStyle.flatColored,
  Color primaryColor = Colors.green,
  Duration autoCloseDuration = const Duration(seconds: 5),
}) {
  toastification.show(
    icon: icon,
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

void showToastDuplicateMenu({
  required BuildContext context,
  required String message,
  required String description,
  required List<DuplicateStore> stores,
  Icon? icon,
  ToastificationType type = ToastificationType.success,
  ToastificationStyle style = ToastificationStyle.flatColored,
  Color primaryColor = Colors.green,
  TextStyle? titleStyle,
  TextStyle? descriptionStyle,
}) {
  toastification.show(
    icon: const Icon(
      Icons.info_outline,
      color: Styles.failTextColor,
      size: 50,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    context: context,
    primaryColor: Colors.red,
    type: type,
    style: style,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: titleStyle, // Adjust your style method as necessary
        ),
        Text(
          description,
          style: descriptionStyle, // Adjust your style method as necessary
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CheckStoreDuplicateScreen(
                stores: stores,
              );
            }));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Styles.failTextColor,
            ),
            width: 110,
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(
                  Icons.visibility,
                  color: Colors.white,
                ),
                Text(
                  "ดูร้านค้า",
                  style: Styles.white18(
                      context), // Adjust your style method as necessary
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}

void showToastDuplicateMenu2({
  required BuildContext context,
  required String message,
  required String description,
  required List<Store> stores,
  Icon? icon,
  ToastificationType type = ToastificationType.success,
  ToastificationStyle style = ToastificationStyle.flatColored,
  Color primaryColor = Colors.green,
  TextStyle? titleStyle,
  TextStyle? descriptionStyle,
}) {
  toastification.show(
    icon: const Icon(
      Icons.info_outline,
      color: Styles.failTextColor,
      size: 50,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    context: context,
    primaryColor: Colors.red,
    type: type,
    style: style,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: titleStyle, // Adjust your style method as necessary
        ),
        Text(
          description,
          style: descriptionStyle, // Adjust your style method as necessary
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CheckStoreDuplicateScreen2(
                stores: stores,
              );
            }));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Styles.failTextColor,
            ),
            width: 110,
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(
                  Icons.visibility,
                  color: Colors.white,
                ),
                Text(
                  "ดูร้านค้า",
                  style: Styles.white18(
                      context), // Adjust your style method as necessary
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
// toastification.show(
// 	  context: context,
// 	  type: ToastificationType.success,
// 	  style: ToastificationStyle.flat,
// 	  title: Text("Component updates available."),
// 	  description: Text("Component updates available."),
// 	  alignment: Alignment.topCenter,
// 	  autoCloseDuration: const Duration(seconds: 4),
// 	  icon: Icon(Iconsax.info_circle),
// 	  boxShadow: highModeShadow,
// 	  showProgressBar: true,
// 	);
