import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/core/utils/tost_util.dart';
import 'package:_12sale_app/data/service/connectivityService.dart';
import 'package:flutter/material.dart';

import 'package:toastification/toastification.dart';

class Header extends StatefulWidget {
  final String? title;
  final Widget? leading;
  final Widget? leading2;

  const Header({
    Key? key,
    this.title,
    this.leading,
    this.leading2,
  }) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool? lastConnectedState; // Tracks the last connectivity state

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: StreamBuilder<bool>(
                stream: ConnectivityService().connectivityStream,
                builder: (context, snapshot) {
                  bool isConnected = snapshot.data ?? true;

                  // Trigger toast only when the `isConnected` state changes
                  if (lastConnectedState != isConnected) {
                    lastConnectedState = isConnected;

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showToast(
                        context: context,
                        message:
                            isConnected ? 'คุณกำลังออนไลน์' : 'คุณกำลังออฟไลน์',
                        type: isConnected
                            ? ToastificationType.success
                            : ToastificationType.error,
                        primaryColor: isConnected ? Colors.green : Colors.red,
                      );
                    });
                  }
                  return Container(
                    color: Styles.primaryColor,
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            // color: Colors.amber,
                            height: screenWidth / 4,
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: screenWidth / 1.3, // Specify a width
                                    height: screenWidth / 4, // Specify a height
                                    child: widget.leading2),
                                Container(
                                  height: screenWidth / 20,
                                  width: screenWidth / 20,
                                  decoration: BoxDecoration(
                                    color:
                                        isConnected ? Colors.green : Colors.red,
                                    border: Border.all(
                                      width: screenWidth / 200,
                                      color: isConnected
                                          ? Styles.successButtonColor
                                          : Styles.failTextColor,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(360)),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                        offset: Offset(0, -3),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            fit: FlexFit.loose,
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 5),
                                    blurRadius: 100,
                                    spreadRadius: 10,
                                  ),
                                ],
                                color: Colors.grey[100],
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(46),
                                ),
                              ),
                              child: widget.leading!,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
