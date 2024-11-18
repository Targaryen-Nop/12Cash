import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class WaterFilledRectangle extends StatefulWidget {
  final double width;
  final double height;
  final double depth;
  final double fillPercentage;
  final Color borderColor;
  final Color waterColor;
  final TextStyle? textStyle;

  const WaterFilledRectangle({
    Key? key,
    required this.width,
    required this.height,
    required this.depth,
    required this.fillPercentage,
    this.borderColor = Colors.grey,
    this.waterColor = Styles.primaryColor,
    this.textStyle,
  }) : super(key: key);

  @override
  _WaterFilledRectangleState createState() => _WaterFilledRectangleState();
}

class _WaterFilledRectangleState extends State<WaterFilledRectangle> {
  double _rotationAngle = 0.0;

  void _rotateRectangle() {
    setState(() {
      _rotationAngle += pi / 8; // Increment angle by 22.5 degrees
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        CustomPaint(
          size: Size(widget.width * 2, widget.height * 2),
          painter: RectanglePainter(
            width: widget.width,
            height: widget.height,
            depth: widget.depth,
            fillPercentage: widget.fillPercentage,
            rotationAngle: _rotationAngle,
            borderColor: widget.borderColor,
            waterColor: widget.waterColor.withOpacity(0.5),
            textStyle: widget.textStyle,
            context: context,
          ),
        ),
        SizedBox(
            height: screenWidth /
                8), // Add spacing between the rectangle and button
        ElevatedButton(
          onPressed: _rotateRectangle,
          child: const Text("Rotate Rectangle"),
        ),
      ],
    );
  }
}

class RectanglePainter extends CustomPainter {
  final double width;
  final double height;
  final double depth;
  final double fillPercentage;
  final double rotationAngle;
  final Color borderColor;
  final Color waterColor;
  final TextStyle? textStyle;
  final BuildContext context;

  RectanglePainter({
    required this.width,
    required this.height,
    required this.depth,
    required this.fillPercentage,
    required this.rotationAngle,
    required this.borderColor,
    required this.waterColor,
    this.textStyle,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Rectangle vertices in 3D
    final vertices = [
      Offset3D(-width, -height, depth),
      Offset3D(width, -height, depth),
      Offset3D(width, height, depth),
      Offset3D(-width, height, depth),
      Offset3D(-width, -height, -depth),
      Offset3D(width, -height, -depth),
      Offset3D(width, height, -depth),
      Offset3D(-width, height, -depth),
    ];

    // Apply rotation to each vertex
    final rotatedVertices =
        vertices.map((v) => rotateY(v, rotationAngle)).toList();

    // Perspective projection
    final projected = rotatedVertices.map((v) => project3D(v, size)).toList();

    // Draw edges
    void drawEdge(int i, int j, Color color) {
      paint.color = color;
      canvas.drawLine(projected[i], projected[j], paint);
    }

    // Draw rectangle borders
    for (final face in [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [0, 4, 7, 3],
      [1, 5, 6, 2]
    ]) {
      for (int i = 0; i < face.length; i++) {
        drawEdge(face[i], face[(i + 1) % face.length], borderColor);
      }
    }

    // Draw water
    final waterHeight = (height * 2) * fillPercentage;
    final waterVertices = [
      Offset3D(-width, height - waterHeight, depth),
      Offset3D(width, height - waterHeight, depth),
      Offset3D(width, height, depth),
      Offset3D(-width, height, depth),
      Offset3D(-width, height - waterHeight, -depth),
      Offset3D(width, height - waterHeight, -depth),
      Offset3D(width, height, -depth),
      Offset3D(-width, height, -depth),
    ];

    final rotatedWaterVertices =
        waterVertices.map((v) => rotateY(v, rotationAngle)).toList();
    final projectedWater =
        rotatedWaterVertices.map((v) => project3D(v, size)).toList();

    final waterFaces = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [0, 1, 5, 4],
      [3, 2, 6, 7],
      [0, 3, 7, 4],
      [1, 2, 6, 5],
    ];

    for (final face in waterFaces) {
      final path = Path()
        ..moveTo(projectedWater[face[0]].dx, projectedWater[face[0]].dy)
        ..lineTo(projectedWater[face[1]].dx, projectedWater[face[1]].dy)
        ..lineTo(projectedWater[face[2]].dx, projectedWater[face[2]].dy)
        ..lineTo(projectedWater[face[3]].dx, projectedWater[face[3]].dy)
        ..close();

      paint.style = PaintingStyle.fill;
      paint.color = waterColor;
      canvas.drawPath(path, paint);
    }

    // Draw "XX%" text
    final percentageText = "${(fillPercentage * 100).toInt()}%";
    final textPainter = TextPainter(
      text: TextSpan(
        text: percentageText,
        style: fillPercentage > 0.39
            ? Styles.white24(context)
            : Styles.black24(context),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final textX = size.width / 2 - textPainter.width / 2;
    final textY = size.height / 2 + height / 4 - textPainter.height / 2;

    textPainter.paint(
      canvas,
      Offset(textX, textY),
    );
  }

  Offset3D rotateY(Offset3D vertex, double angle) {
    final double cosA = cos(angle);
    final double sinA = sin(angle);
    final double x = vertex.x * cosA - vertex.z * sinA;
    final double z = vertex.x * sinA + vertex.z * cosA;
    return Offset3D(x, vertex.y, z);
  }

  Offset project3D(Offset3D vertex, Size size) {
    final double perspective = 500;
    final double screenX = size.width / 2;
    final double screenY = size.height / 2;
    final scale = perspective / (perspective + vertex.z);
    final x = vertex.x * scale + screenX;
    final y = vertex.y * scale + screenY;
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Offset3D {
  final double x, y, z;

  Offset3D(this.x, this.y, this.z);
}
