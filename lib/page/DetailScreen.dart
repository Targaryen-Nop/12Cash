import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String day;
  final String route;
  final String status;

  DetailScreen({required this.day, required this.route, required this.status});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Screen'),
        centerTitle: true,
        foregroundColor: Colors.white,
        titleTextStyle: GobalStyles.headline3,
        backgroundColor: GobalStyles.primaryColor,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        color: GobalStyles.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCustomButton(
              context,
              icon: Icons.location_on_outlined,
              label: 'ไม่ขายสินค้า',
              color: Colors.red,
              onPressed: () {
                // Add your onPressed logic here
              },
            ),
            _buildCustomButton(
              context,
              icon: Icons.add,
              label: 'ขายสินค้า',
              color: Colors.teal,
              onPressed: () {
                // Add your onPressed logic here
              },
            ),
            _buildCustomButton(
              context,
              icon: Icons.camera_alt,
              label: 'ถ่ายรูป',
              color: Colors.blue,
              onPressed: () {
                // Add your onPressed logic here
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Day: ${widget.day}', style: TextStyle(fontSize: 20)),
            Text('Route: ${widget.route}', style: TextStyle(fontSize: 20)),
            Text('Status: ${widget.status}', style: TextStyle(fontSize: 20)),

            Spacer(), // Pushes the button to the bottom of the screen
          ],
        ),
      ),
    );
  }

  Widget _buildCustomButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius:
          BorderRadius.circular(16), // Adds ripple effect and rounded corners
      child: Container(
        width: 100, // Fixed width for the button
        height: 100, // Fixed height for the button
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 36,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
