import 'dart:io';

import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/order/Product.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderMenuListCard extends StatefulWidget {
  Product product;
  OrderMenuListCard({required this.product, super.key});

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
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${widget.product.name}',
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
                        children: [
                          Text(
                            '${widget.product.group} | ${widget.product.brand}',
                            style: Styles.grey18(context),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '${widget.product.flavour} | ${widget.product.size}',
                            style: Styles.grey18(context),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Net ${widget.product.weightNet} | Gross ${widget.product.weightGross}',
                            style: Styles.grey18(context),
                          ),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: ListView.builder(
                      //         itemCount: widget.product.listUnit.length,
                      //         scrollDirection: Axis.horizontal,
                      //         itemBuilder: (context, index) {
                      //           final unit = widget.product.listUnit[index];
                      //           return Padding(
                      //             padding: const EdgeInsets.symmetric(
                      //                 horizontal: 8.0), // Adds spacing
                      //             child: Text(
                      //               '${unit.name} (${unit.factor}) - ฿${unit.price}', // Shows name, factor, and price
                      //               style: Styles.grey18(context),
                      //             ),
                      //           );
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       '${widget.product.flavour} ${widget.product.size}',
                      //       style: Styles.grey18(context),
                      //     ),
                      //   ],
                      // ),
                      Row(
                        children: [
                          Text(
                            '${widget.product.type}',
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
