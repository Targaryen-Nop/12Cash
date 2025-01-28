import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/CalendarPicker%20copy.dart';
import 'package:_12sale_app/core/components/CalendarPicker.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:month_year_picker/month_year_picker.dart';

class AjustRoute extends StatefulWidget {
  const AjustRoute({super.key});

  @override
  State<AjustRoute> createState() => _AjustRouteState();
}

class _AjustRouteState extends State<AjustRoute> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppbarCustom(
          title: "ปรับรูท ",
          icon: Icons.route_outlined,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final DateTime? dateTime = await showOmniDateTimePicker(
                  isShowSeconds: false,
                  is24HourMode: false,
                  isForce2Digits: false,
                  context: context,
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  // firstDate:
                  //     DateTime(2025).subtract(const Duration(days: 3652)),
                  // lastDate: DateTime.now().add(
                  //   const Duration(days: 3652),
                  // ),
                  constraints: const BoxConstraints(
                    maxWidth: 350,
                    maxHeight: 650,
                  ),
                  barrierDismissible: true,
                  // transitionBuilder: (context, anim1, anim2, child) {
                  //   return FadeTransition(
                  //     opacity: anim1.drive(
                  //       Tween(
                  //         begin: 0,
                  //         end: 1,
                  //       ),
                  //     ),
                  //     child: child,
                  //   );
                  // },
                );

                // Use dateTime here
                debugPrint('dateTime: $dateTime');
              },
              child: const Text('Show DateTime Picker1'),
            ),
            ElevatedButton(
              onPressed: () async {
                final List<DateTime>? dateTime =
                    await showOmniDateTimeRangePicker(
                  context: context,
                  is24HourMode: false,
                  isForce2Digits: false,
                  isShowSeconds: false,
                  isForceEndDateAfterStartDate: false,
                );

                // Use dateTime here
                debugPrint('dateTime: $dateTime');
              },
              child: const Text('Show DateTime Picker'),
            ),
            ElevatedButton(
              onPressed: () async {
                showMonthPicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2010),
                  lastDate: DateTime(2100),
                  // headerTitle: Text(
                  //   'กรุณาเลือกวันที่',
                  //   style: Styles.white24(context),
                  // ),
                  monthStylePredicate: (p0) {},
                  monthPickerDialogSettings: MonthPickerDialogSettings(
                    headerSettings: PickerHeaderSettings(
                      headerBackgroundColor: Styles.primaryColor,
                      headerCurrentPageTextStyle: Styles.white24(context),
                      headerSelectedIntervalTextStyle: Styles.white18(context),
                    ),
                    dateButtonsSettings: PickerDateButtonsSettings(
                      selectedDateRadius: 10,
                      selectedMonthBackgroundColor: Styles.primaryColor,
                      // selectedMonthTextColor: Styles.primaryColor,
                      // buttonBorder: CircleBorder(side: BorderSide(width: 10)),
                      monthTextStyle: Styles.black18(context),
                      yearTextStyle: Styles.black18(context),
                    ),
                    dialogSettings: PickerDialogSettings(
                        // customHeight: screenWidth * 0.6,
                        // customWidth: 10,

                        insetPadding: EdgeInsets.all(8),
                        dialogRoundedCornersRadius: 16,
                        dialogBackgroundColor: Colors.white,
                        locale: Locale('th', 'TH'),
                        dialogBorderSide: BorderSide()
                        // dialogBackgroundColor: Styles.primaryColor,
                        ),
                    actionBarSettings: PickerActionBarSettings(
                      confirmWidget: Text(
                        'ยืนยัน',
                        style: Styles.black18(context),
                      ),
                      cancelWidget: Text(
                        'ยกเลิก',
                        style: Styles.black18(context),
                      ),
                    ),
                  ),
                );

                // Use dateTime here
              },
              child: const Text('Show DateTime Picker'),
            ),

            // EasyDateTimeLinePicker(
            //   firstDate: DateTime(2025, 1, 1),
            //   lastDate: DateTime(2030, 3, 18),
            //   focusedDate: DateTime(2025, 6, 15),
            //   selectionMode: SelectionMode.autoCenter(),
            //   onDateChange: (date) {
            //     // Handle the selected date.
            //   },
            // ),
            // SfDateRangePicker(
            //   selectionMode: DateRangePickerSelectionMode.single,
            //   view: DateRangePickerView.month,
            //   initialSelectedRange: PickerDateRange(
            //       DateTime.now().subtract(const Duration(days: 4)),
            //       DateTime.now().add(const Duration(days: 3))),
            // ),
            // Expanded(
            //   child: dp.MonthPicker.single(
            //     datePickerStyles: DatePickerStyles(),
            //     selectedDate: DateTime(2025, 6, 15),
            //     onChanged: (value) {},
            //     firstDate: DateTime(2025, 1, 1),
            //     lastDate: DateTime(2026, 3, 18),
            //     // datePickerStyles: style,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
