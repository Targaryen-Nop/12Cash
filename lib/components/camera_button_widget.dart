import 'package:_12sale_app/page/HomeScreen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart'; // To get file name from path

class CameraButtonWidget extends StatefulWidget {
  final String buttonText;
  final Color buttonColor;
  final TextStyle textStyle;

  const CameraButtonWidget({
    Key? key,
    required this.buttonText,
    required this.buttonColor,
    required this.textStyle,
  }) : super(key: key);

  @override
  _CameraButtonWidgetState createState() => _CameraButtonWidgetState();
}

class _CameraButtonWidgetState extends State<CameraButtonWidget> {
  late CameraController _cameraController;
  Future<void>? _initializeControllerFuture;
  String? imageName;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Initialize the camera
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController
        .dispose(); // Dispose of the camera controller to free resources
    super.dispose();
  }

  Future<void> _openCamera(BuildContext context) async {
    // Wait for the camera to initialize
    await _initializeControllerFuture;

    // Navigate to the camera preview screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CameraPreviewScreen(
          cameraController: _cameraController,
          onImageCaptured: (String imageName) {
            setState(() {
              this.imageName = imageName; // Store the image name
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () =>
              _openCamera(context), // Open camera when button is pressed
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            backgroundColor: widget.buttonColor,
          ),
          child: Text(widget.buttonText, style: widget.textStyle),
        ),
        if (imageName != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Image captured: $imageName'),
          ), // Display the captured image name
      ],
    );
  }
}

// Screen to display the camera preview and allow the user to take a picture
class CameraPreviewScreen extends StatelessWidget {
  final CameraController cameraController;
  final Function(String) onImageCaptured;

  const CameraPreviewScreen({
    Key? key,
    required this.cameraController,
    required this.onImageCaptured,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera Preview')),
      body: FutureBuilder<void>(
        future: cameraController.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the camera is initialized, display the camera preview
            return Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: 9 / 16, // Force portrait aspect ratio (9:16)
                    child: CameraPreview(cameraController),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FloatingActionButton(
                      onPressed: () async {
                        try {
                          // Capture the picture
                          final image = await cameraController.takePicture();

                          // Get the file name from the image path
                          final fileName =
                              basename(image.path); // Extract file name
                          onImageCaptured(
                              fileName); // Pass the file name back to the button widget

                          // Navigate to the screen that shows the captured image
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  DisplayPictureScreen(imagePath: image.path),
                            ),
                          );
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Icon(Icons.camera_alt),
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Otherwise, display a loading indicator
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

// Screen to display the captured picture
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomeScreen(index: 0),
        ),
      ); // Pop the screen right after the frame is built
    });
    return Scaffold(
      appBar: AppBar(title: Text('Captured Image')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Image.file(File(imagePath)),
          ),
        ],
      ),
    );
  }
}
