import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/components/card/WeightCude.dart';
import 'package:_12sale_app/core/components/switch/example_1.dart';
import 'package:_12sale_app/core/components/switch/example_10.dart';
import 'package:_12sale_app/core/components/switch/example_11.dart';
import 'package:_12sale_app/core/components/switch/example_12.dart';
import 'package:_12sale_app/core/components/switch/example_13.dart';
import 'package:_12sale_app/core/components/switch/example_14.dart';
import 'package:_12sale_app/core/components/switch/example_15.dart';
import 'package:_12sale_app/core/components/switch/example_2.dart';
import 'package:_12sale_app/core/components/switch/example_3.dart';
import 'package:_12sale_app/core/components/switch/example_4.dart';
import 'package:_12sale_app/core/components/switch/example_5.dart';
import 'package:_12sale_app/core/components/switch/example_6.dart';
import 'package:_12sale_app/core/components/switch/example_7.dart';
import 'package:_12sale_app/core/components/switch/example_8.dart';
import 'package:_12sale_app/core/components/switch/example_9.dart';
import 'package:_12sale_app/core/components/switch/second_screen.dart';
import 'package:_12sale_app/core/page/withdraw/ProductWithdrowScreen.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WithDrawScreen extends StatefulWidget {
  const WithDrawScreen({super.key});

  @override
  State<WithDrawScreen> createState() => _WithDrawScreenState();
}

class _WithDrawScreenState extends State<WithDrawScreen> {
  int isSelect = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(
          title: " เบิกสินค้า",
          icon: Icons.store_mall_directory_rounded,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Styles.primaryColor,
        child: const Icon(
          Icons.add,
          color: Styles.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductWithdrowScreen(),
            ),
          );
        },
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const WeightCudeCard(),
                    const SizedBox(height: 10),
                    CustomSlidingSegmentedControl<int>(
                      initialValue: 1,
                      isStretch: true,
                      children: {
                        1: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.clock,
                              color: isSelect == 1
                                  ? Styles.primaryColor
                                  : Styles.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'รอส่ง',
                              style: isSelect == 1
                                  ? Styles.headerPirmary18(context)
                                  : Styles.headerWhite18(context),
                            )
                          ],
                        ),
                        2: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.description,
                              color: isSelect == 2
                                  ? Styles.primaryColor
                                  : Styles.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'ประวัติ',
                              style: isSelect == 2
                                  ? Styles.headerPirmary18(context)
                                  : Styles.headerWhite18(context),
                            ),
                          ],
                        )
                      },
                      onValueChanged: (v) {
                        setState(() {
                          isSelect = v;
                        });
                        print(v);
                      },
                      decoration: BoxDecoration(
                        color: Styles.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      thumbDecoration: BoxDecoration(
                        color: Styles.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      duration: const Duration(milliseconds: 300),
                    ),
                    const SizedBox(height: 10),
                    BoxShadowCustom(
                      child: Container(
                        height: viewportConstraints.maxHeight * 0.4,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Text("dw"),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
