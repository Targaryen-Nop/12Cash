import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:flutter/material.dart';

class BadgeExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      floatingActionButton: Container(
        child: FittedBox(
          child: Stack(
            alignment: Alignment(1.5, -1.5),
            children: [
              SizedBox(
                width: 100, // Set the width of the button
                height: 100, // Set the height of the button
                child: FloatingActionButton(
                  // Your actual Fab
                  onPressed: () {},
                  backgroundColor: GobalStyles.primaryColor,
                  shape: CircleBorder(),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),
              Container(
                width: 50, // Set the width of the button
                height: 50,
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(minHeight: 32, minWidth: 32),
                decoration: BoxDecoration(
                  // This controls the shadow
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 5,
                        color: Colors.black.withAlpha(50))
                  ],
                  borderRadius: BorderRadius.circular(180),
                  color: Colors.red, // This would be color of the Badge
                ),
                // This is your Badge
                child: const Center(
                  // Here you can put whatever content you want inside your Badge
                  child: Text('4',
                      style: TextStyle(color: Colors.white, fontSize: 22)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
