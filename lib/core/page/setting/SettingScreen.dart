import 'package:_12sale_app/core/components/search/CustomerDropdownSearch.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
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
                    style: GobalStyles.textbBlack3,
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
                          style: GobalStyles.textbBlack3,
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
                          style: GobalStyles.textbBlack3,
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
                    style: GobalStyles.textbBlack3,
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
                          style: GobalStyles.textbBlack3,
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
                    style: GobalStyles.textbBlack3,
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
                          style: GobalStyles.textbBlack3,
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
                          style: GobalStyles.textbBlack3,
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
                          style: GobalStyles.textbBlack3,
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
    );
  }
}

class SettingHeader extends StatefulWidget {
  const SettingHeader({super.key});

  @override
  State<SettingHeader> createState() => _SettingHeaderState();
}

class _SettingHeaderState extends State<SettingHeader> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),

                  // color: Colors.red,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/12TradingLogo.png'),
                        // fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.loose,
                child: Center(
                  // margin: EdgeInsets.only(top: 10),
                  child: Column(
                    // mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          // color: Colors.blue,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'จรัญมนู ศรีอมรเพทนคร',
                                    style: GobalStyles.text2,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                      DateFormat(' d MMMM yyyy').format(DateTime
                                          .now()), // Current date and time
                                      style: Styles.white18),
                                  StreamBuilder(
                                    stream: Stream.periodic(
                                        const Duration(seconds: 1)),
                                    builder: (context, snapshot) {
                                      return Container(
                                        child: Text(
                                            DateFormat(' hh:mm:ss a')
                                                .format(DateTime.now()),
                                            style: Styles.white18),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Container(
                                // color: Colors.amber,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: screenWidth / 10,
                                      // margin: EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                          color: GobalStyles.secondaryColor,
                                          borderRadius: BorderRadius.horizontal(
                                              right: Radius.circular(50),
                                              left: Radius.circular(50))),

                                      child: Center(
                                        child: Text(
                                          'SALE',
                                          style: GobalStyles.headlineblack4,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth / 10,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      decoration: const BoxDecoration(
                                          color: GobalStyles.secondaryColor,
                                          borderRadius: BorderRadius.horizontal(
                                              right: Radius.circular(50),
                                              left: Radius.circular(50))),
                                      child: Center(
                                        child: Text(
                                          'BE121',
                                          style: GobalStyles.headlineblack4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
