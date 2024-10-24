import 'package:_12sale_app/components/CustomerDropdownSearch.dart';
import 'package:_12sale_app/components/table/ShopTableAll.dart';
import 'package:_12sale_app/components/table/ShopTableNew.dart';
import 'package:_12sale_app/page/shop/AddShopScreen.dart';
import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isSelected = !_isSelected;
                        });
                      },
                      child: Text(
                        'ร้านค้าทั้งหมด',
                        style: GobalStyles.textbBlack2,
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 16, // Add elevation for shadow
                        shadowColor: Colors.black
                            .withOpacity(0.5), // Shadow color with opacity

                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 10),
                        backgroundColor:
                            _isSelected ? Colors.white : Colors.grey[300],

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isSelected = !_isSelected;
                        });
                      },
                      child: Text(
                        'ร้านค้าใหม่',
                        style: GobalStyles.textbBlack2,
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 16, // Add elevation for shadow
                        shadowColor: Colors.black
                            .withOpacity(0.5), // Shadow color with opacity
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 10),
                        backgroundColor:
                            _isSelected ? Colors.grey[300] : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          _isSelected ? ShopTableNew() : ShopTableAll(),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 100, // Set the width of the button
                height: screenWidth / 8, // Set the height of the button
                child: FloatingActionButton(
                  // Your actual Fab
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddShopScreen(),
                      ),
                    );
                  },
                  backgroundColor: GobalStyles.primaryColor,
                  shape: CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ShopHeader extends StatefulWidget {
  const ShopHeader({super.key});

  @override
  State<ShopHeader> createState() => _ShopHeaderState();
}

class _ShopHeaderState extends State<ShopHeader> {
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
                flex: 5,
                fit: FlexFit.loose,
                child: Center(
                  // margin: EdgeInsets.only(top: 10),

                  child: Column(
                    // mainAxisSize: MainAxisSize.max,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          // color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    child: Icon(Icons.store,
                                        size: screenWidth / 15,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    ' ร้านค้า',
                                    style: GobalStyles.headline3,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              Flexible(
                                  fit: FlexFit.loose,
                                  child: Container(
                                      width: screenWidth / 3,
                                      child: const CustomerDropdownSearch())),
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
