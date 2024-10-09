import 'package:_12sale_app/components/Button.dart';
import 'package:_12sale_app/components/chart/BarChart.dart';
import 'package:_12sale_app/components/chart/LineChart.dart';
import 'package:_12sale_app/components/chart/TrendingMusicChart.dart';
import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  @override
  Widget build(BuildContext context) {
    GobalStyles.screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(10.0),
      height: GobalStyles.screenWidth / 2.5,
      width: GobalStyles.screenWidth / 1.5,
      child: Column(children: [CustomButton(title: 'adddddd')]),
    );
    // return Container(height: 500, width: 400, child: LineChartSample());
  }
}

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  @override
  Widget build(BuildContext context) {
    GobalStyles.screenWidth = MediaQuery.of(context).size.width;
    return GobalStyles.screenWidth > 600
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Row(
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        color: Colors.red,
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/12TradingLogo.png'),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 6,
                      fit: FlexFit.loose,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              color: Colors.blue,
                              child: Row(
                                children: [
                                  Text(
                                    'นายนพรัตน์ มั่นสุวรรณ',
                                    style: GobalStyles.headline3,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Row(children: [
                                Container(
                                  color: Colors.green,
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  child: RichText(
                                    text: TextSpan(
                                      text: DateTime.now().day.toString(),
                                      style: GobalStyles.headline3,
                                      children: [
                                        TextSpan(
                                          text: DateFormat(' MMMM yyyy')
                                              .format(DateTime.now()),
                                          style: GobalStyles.headline3,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: StreamBuilder(
                                        stream: Stream.periodic(
                                            const Duration(seconds: 1)),
                                        builder: (context, snapshot) {
                                          return Container(
                                            color: Colors.green,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              DateFormat('hh:mm:ss a')
                                                  .format(DateTime.now()),
                                              style: GobalStyles.headline3,
                                            ),
                                          );
                                        }))
                              ])),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Row(
                                children: [
                                  Container(
                                    width: GobalStyles.screenWidth / 9,
                                    // margin: EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 52, 6, 255),
                                        borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(50),
                                            left: Radius.circular(50))),
                                    child: Center(
                                        child: Text(
                                      'SALE',
                                      style: GobalStyles.headline4,
                                    )),
                                  ),
                                  Container(
                                    width: GobalStyles.screenWidth / 10,
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    decoration: const BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 52, 6, 255),
                                        borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(50),
                                            left: Radius.circular(50))),
                                    child: Center(
                                        child: Text(
                                      'BE121',
                                      style: GobalStyles.headline4,
                                    )),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : SizedBox();
  }
}
