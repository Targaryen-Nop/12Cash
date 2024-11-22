import 'dart:io';
import 'package:_12sale_app/core/components/button/CameraButton.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class IconButtonWithLabel extends StatefulWidget {
  String? imagePath;
  final IconData icon;
  final String label;
  final TextStyle? labelStyle;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Function(String imagePath)? onImageSelected; // Callback for image path

  IconButtonWithLabel({
    super.key,
    required this.icon,
    this.imagePath,
    required this.label,
    this.labelStyle,
    this.backgroundColor = Colors.blue,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.onImageSelected, // Optional parameter for callback
  });

  @override
  _IconButtonWithLabelState createState() => _IconButtonWithLabelState();
}

class _IconButtonWithLabelState extends State<IconButtonWithLabel> {
  late CameraController _cameraController;
  Future<void>? _initializeControllerFuture;
  // String? imagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final firstCamera = cameras.first;
        _cameraController = CameraController(
          firstCamera,
          ResolutionPreset.high,
        );
        _initializeControllerFuture = _cameraController.initialize();
        await _initializeControllerFuture;
      } else {
        print("No cameras available");
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> openCamera(BuildContext context) async {
    await _initializeControllerFuture;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CameraPreviewScreen(
          cameraController: _cameraController,
          onImageCaptured: (String imagePath) {
            setState(() {
              widget.imagePath = imagePath;
            });
            // Notify parent widget via callback
            if (widget.onImageSelected != null) {
              widget.onImageSelected!(imagePath);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          width: screenWidth / 4,
          height: screenWidth / 4,
          child: ElevatedButton(
            onPressed: () => openCamera(context),
            style: ElevatedButton.styleFrom(
              padding: widget.padding,
              backgroundColor:
                  widget.imagePath == null ? Styles.primaryColor : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ),
            child: widget.imagePath == null
                ? Icon(widget.icon, color: Colors.white, size: 50)
                : ClipRRect(
                    child: Image.file(
                      File(widget.imagePath!),
                      width: screenWidth / 4,
                      height: screenWidth / 4,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        Text(
          widget.label,
          style: Styles.black18(context),
        ),
      ],
    );
  }
}
