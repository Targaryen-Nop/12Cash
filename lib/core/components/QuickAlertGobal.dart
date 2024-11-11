import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class ConfirmationAlert extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String message;
  final String confirmBtnText;
  final String cancelBtnText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Color confirmBtnColor;

  const ConfirmationAlert({
    Key? key,
    required this.context,
    this.title = "ยืนยันข้อมูล",
    this.message = "กรุณาตรวจเช็คความถูกต้องก่อนกดยืนยันการบันทึกข้อมูล",
    this.confirmBtnText = "ยืนยัน",
    this.cancelBtnText = "ไม่ยืนยัน",
    required this.onConfirm,
    this.onCancel,
    this.confirmBtnColor = Styles.successButtonColor,
  }) : super(key: key);

  void show() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: "",
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Styles.headerWhite32(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: Styles.headerBlack24(context),
          ),
        ],
      ),
      confirmBtnText: confirmBtnText,
      onConfirmBtnTap: onConfirm,
      confirmBtnTextStyle: Styles.white18(context),
      cancelBtnTextStyle: Styles.grey18(context),
      cancelBtnText: cancelBtnText,
      confirmBtnColor: confirmBtnColor,
      onCancelBtnTap: onCancel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// class ConfirmationAlert extends StatelessWidget {
//   final BuildContext context;
//   final String title;
//   final String message;
//   final String confirmBtnText;
//   final String cancelBtnText;
//   final VoidCallback onConfirm;
//   final VoidCallback? onCancel;
//   final Color confirmBtnColor;

//   const ConfirmationAlert({
//     Key? key,
//     required this.context,
//     this.title = "ยืนยันข้อมูล",
//     this.message = "กรุณาตรวจเช็คความถูกต้องก่อนกดยืนยันการบันทึกข้อมูล",
//     this.confirmBtnText = "ยืนยัน",
//     this.cancelBtnText = "ไม่ยืนยัน",
//     required this.onConfirm,
//     this.onCancel,
//     this.confirmBtnColor = Styles.successButtonColor,
//   }) : super(key: key);

//   void show() {
//     QuickAlert.show(
//       context: context,
//       type: QuickAlertType.confirm,
//       title: "",
//       widget: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 title,
//                 style: Styles.headerWhite32(context),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Text(
//             message,
//             style: Styles.headerBlack24(context),
//           ),
//         ],
//       ),
//       confirmBtnText: confirmBtnText,
//       onConfirmBtnTap: onConfirm,
//       confirmBtnTextStyle: Styles.white18(context),
//       cancelBtnTextStyle: Styles.grey18(context),
//       cancelBtnText: cancelBtnText,
//       confirmBtnColor: confirmBtnColor,
//       onCancelBtnTap: onCancel,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

