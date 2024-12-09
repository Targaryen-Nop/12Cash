import 'dart:convert';

import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/components/dropdown/DropDownStandarad.dart';
import 'package:_12sale_app/core/components/search/CustomerDropdownSearch.dart';

import 'package:_12sale_app/core/styles/style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // ProductType? lange;
  late Map<String, String> languages = {};
  String? selectedLanguageCode;
  @override
  void initState() {
    super.initState();
    // _loadData();
  }

  // Future<void> _loadData() async {
  //   final String jsonString =
  //       await rootBundle.loadString('lang/languages.json');
  //   final Map<String, dynamic> jsonData = json.decode(jsonString);
  //   // languages = Map<String, String>.from(jsonData);
  //   setState(() {
  //     languages = Map<String, String>.from(jsonData);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(title: " การตั้งค่า", icon: Icons.settings_sharp),
      ),
      body: Container(
        // color: Colors.deepOrange,
        padding: EdgeInsets.symmetric(vertical: screenWidth / 15),
        margin: const EdgeInsets.only(top: 30),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    child: Text(
                      "  ข้อมูลส่วนตัว",
                      style: Styles.black18(context),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          SizedBox(width: screenWidth / 10),
                          Text(
                            "ข้อมูลส่วนตัว",
                            style: Styles.black18(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          SizedBox(width: screenWidth / 10),
                          Text(
                            "สรุปการทำงาน",
                            style: Styles.black18(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    child: Text(
                      "  การตั้งค่า",
                      style: Styles.black18(context),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.white,
                      child: Row(
                        children: [
                          SizedBox(width: screenWidth / 10),
                          DropdownButton<String>(
                            icon: const Icon(
                              Icons.chevron_left,
                            ),
                            // isExpanded: true,
                            value: selectedLanguageCode,
                            hint: Text(
                              'เลือกภาษา',
                              style: Styles.black18(context),
                            ),
                            items: languages.entries
                                .map(
                                  (entry) => DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Text(
                                      entry.value,
                                      style: Styles.black18(context),
                                    ),

                                    // Display language name
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              context.setLocale(Locale('en', 'US'));
                              setState(() {
                                selectedLanguageCode = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.white,
                      child: Row(
                        children: [
                          SizedBox(width: screenWidth / 10),
                          Text(
                            "การตั้งค่า",
                            style: Styles.black18(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    child: Text(
                      "  ข้อมูลอื่นๆ",
                      style: Styles.black18(context),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.white,
                      child: Row(
                        children: [
                          SizedBox(width: screenWidth / 10),
                          Text(
                            "ข่าวประกาศ",
                            style: Styles.black18(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.white,
                      child: Row(
                        children: [
                          SizedBox(width: screenWidth / 10),
                          Text(
                            "ออกจากระบบ",
                            style: Styles.black18(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.white,
                      child: Row(
                        children: [
                          SizedBox(width: screenWidth / 10),
                          Text(
                            "เวอร์ชั่นปัจจุบัน : 1.0.0",
                            style: Styles.black18(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class SettingHeader extends StatefulWidget {
//   const SettingHeader({super.key});

//   @override
//   State<SettingHeader> createState() => _SettingHeaderState();
// }

// class _SettingHeaderState extends State<SettingHeader> {
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Flexible(
//           fit: FlexFit.loose,
//           child: Row(
//             children: [
//               Flexible(
//                 flex: 1,
//                 fit: FlexFit.tight,
//                 child: Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 4),

//                   // color: Colors.red,
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage('assets/images/12TradingLogo.png'),
//                         // fit: BoxFit.fitWidth,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Flexible(
//                 flex: 2,
//                 fit: FlexFit.loose,
//                 child: Center(
//                   // margin: EdgeInsets.only(top: 10),
//                   child: Column(
//                     // mainAxisSize: MainAxisSize.max,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Container(
//                           margin: const EdgeInsets.symmetric(horizontal: 4),
//                           // color: Colors.blue,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Row(
//                                 children: [
//                                   Text(
//                                     'จรัญมนู ศรีอมรเพทนคร',
//                                     style: Styles.headerWhite24(context),
//                                     textAlign: TextAlign.start,
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Text(
//                                       DateFormat(' d MMMM yyyy').format(DateTime
//                                           .now()), // Current date and time
//                                       style: Styles.white18(context)),
//                                   StreamBuilder(
//                                     stream: Stream.periodic(
//                                         const Duration(seconds: 1)),
//                                     builder: (context, snapshot) {
//                                       return Container(
//                                         child: Text(
//                                             DateFormat(' hh:mm:ss a')
//                                                 .format(DateTime.now()),
//                                             style: Styles.white18(context)),
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               ),
//                               Container(
//                                 // color: Colors.amber,
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   // mainAxisAlignment:
//                                   //     MainAxisAlignment.spaceAround,
//                                   children: [
//                                     Container(
//                                       width: screenWidth / 10,
//                                       // margin: EdgeInsets.all(4),
//                                       decoration: const BoxDecoration(
//                                           color: Styles.secondaryColor,
//                                           borderRadius: BorderRadius.horizontal(
//                                               right: Radius.circular(50),
//                                               left: Radius.circular(50))),

//                                       child: Center(
//                                         child: Text(
//                                           'SALE',
//                                           style: Styles.headerBlack18(context),
//                                         ),
//                                       ),
//                                     ),
//                                     Container(
//                                       width: screenWidth / 10,
//                                       margin:
//                                           EdgeInsets.symmetric(horizontal: 4),
//                                       decoration: const BoxDecoration(
//                                           color: Styles.secondaryColor,
//                                           borderRadius: BorderRadius.horizontal(
//                                               right: Radius.circular(50),
//                                               left: Radius.circular(50))),
//                                       child: Center(
//                                         child: Text(
//                                           'BE121',
//                                           style: Styles.headerBlack18(context),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
