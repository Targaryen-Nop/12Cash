import 'dart:io';

import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderMenuListVerticalCard extends StatefulWidget {
  final VoidCallback onDetailsPressed;
  const OrderMenuListVerticalCard({
    super.key,
    required this.onDetailsPressed,
  });

  @override
  State<OrderMenuListVerticalCard> createState() =>
      _OrderMenuListVerticalCardState();
}

class _OrderMenuListVerticalCardState extends State<OrderMenuListVerticalCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onDetailsPressed,
      child: Container(
        height: 295,
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(8), // Optional: Add rounded corners
              child: Image.network(
                'https://jobbkk.com/upload/employer/0D/53D/03153D/images/202045.webp',
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
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'ผงปรุงรสหมู ฟ้าไทย 1200g x6',
                          style: Styles.headerBlack24(context),
                          overflow:
                              TextOverflow.ellipsis, // Truncate if too long
                          maxLines: 1, // Restrict to 1 line
                          softWrap: false, // Avoid wrapping
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ผงปรุงรส',
                        style: Styles.grey18(context),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ฟ้าไทย',
                        style: Styles.grey18(context),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '1.2 KG',
                        style: Styles.grey18(context),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'หมู',
                        style: Styles.grey18(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
