import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/order/OrderDetail.dart';
import 'package:_12sale_app/data/models/order/Orders.dart';
import 'package:_12sale_app/data/models/withdraw/Withdraw.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WithDrawCard extends StatelessWidget {
  final Withdraw item;
  final VoidCallback onDetailsPressed;
  const WithDrawCard({
    required this.item,
    required this.onDetailsPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onDetailsPressed,
      child: Container(
        height: screenWidth / 4,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: BoxShadowCustom(
          child: Container(
            // color: Colors.cyan,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.fileInvoice,
                              color: Styles.primaryColor,
                              size: 35,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${DateTime.now().year}${DateFormat('dd-MM-yyyy | HH:mm:ss').format(item.created)}",
                                style: Styles.black18(context),
                              ),
                              Skeleton.ignore(
                                child: Container(
                                  width: screenWidth / 7,
                                  // padding: EdgeInsets.all(4),
                                  margin: EdgeInsets.only(right: 8),
                                  // height: screenWidth / ,
                                  decoration: BoxDecoration(
                                    color: item.status == 'Agree'
                                        ? Styles.successTextColor
                                        : item.status == 'Reject'
                                            ? Styles.failTextColor
                                            : Styles.warningTextColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    item.status == 'Agree'
                                        ? 'store.store_card_new.agree'.tr()
                                        : item.status == 'Reject'
                                            ? 'store.store_card_new.reject'.tr()
                                            : '${item.status}',
                                    style: Styles.white18(context),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "${item.orderId}",
                            style: Styles.black18(context),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "วันที่รับ ${DateFormat("dd/MM/yyyy").format(DateTime.parse(item.sendDate))}",
                                  style: Styles.black18(context),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "ประเภท ${item.orderTypeName}",
                                style: Styles.black18(context),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "จำนวน ${item.total.toStringAsFixed(0)} หีบ",
                                style: Styles.black18(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
