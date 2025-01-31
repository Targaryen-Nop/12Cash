import 'dart:io';

import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderMenuListCard extends StatefulWidget {
  const OrderMenuListCard({super.key});

  @override
  State<OrderMenuListCard> createState() => _OrderMenuListCardState();
}

class _OrderMenuListCardState extends State<OrderMenuListCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      // height: screenWidth / 5,
      child: Column(
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(8), // Optional: Add rounded corners
                  child: Image.network(
                    'https://images.unsplash.com/photo-1735632629408-30233b7455c9?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    width: screenWidth / 4,
                    height: screenWidth / 4,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'ผงปรุงรสหมู ฟ้าไทย 1200g x6',
                            style: Styles.headerBlack24(context),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'ผงปรุงรส',
                            style: Styles.grey18(context),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'ฟ้าไทย',
                            style: Styles.grey18(context),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '1.2 KG',
                            style: Styles.grey18(context),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'หมู',
                            style: Styles.grey18(context),
                          ),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     Text(
                      //       'ส่วนลด 20%',
                      //       style: Styles.grey18(context),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey[200], // Color of the divider line
            thickness: 1, // Thickness of the line
            indent: 16, // Left padding for the divider line
            endIndent: 16, // Right padding for the divider line
          ),
        ],
      ),
    );
  }
}
