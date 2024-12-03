import 'dart:ui';

import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/components/BuildTextRowDetailShop.dart';
import 'package:_12sale_app/core/page/Ractangle3D.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';

class WeightCudeCard extends StatefulWidget {
  const WeightCudeCard({super.key});

  @override
  State<WeightCudeCard> createState() => _WeightCudeCardState();
}

class _WeightCudeCardState extends State<WeightCudeCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: BoxShadowCustom(
        child: Container(
          height: screenWidth / 1.4,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Weight Cude",
                    style: Styles.black24(context),
                  ),
                ],
              ),
              SizedBox(
                height: screenWidth / 15,
              ),
              WaterFilledRectangle(
                width: screenWidth / 6,
                height: screenWidth / 9,
                depth: screenWidth / 6,
                fillPercentage: 0.40,
              ),
              // Row(
              //   children: [
              //     Text(
              //       "Net Weight",
              //       style: Styles.black18(context),
              //     )
              //   ],
              // )
              BuildTextRowBetween(
                  text: "Net Weight",
                  text2: "0.94 kg",
                  style: Styles.black24(context)),
              BuildTextRowBetween(
                  text: "Gross Weight",
                  text2: "0.94 kg",
                  style: Styles.black24(context)),
              BuildTextRowBetween(
                  text: "Utilized Weight",
                  text2: "0.94 t",
                  style: Styles.black24(context)),
              // SizedBox(
              //   height: screenWidth / 15,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
