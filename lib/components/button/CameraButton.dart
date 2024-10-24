import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart'; // For file path manipulation

class CameraButtonWidget extends StatefulWidget {
  // final String buttonText;
  // final Color buttonColor;
  // final TextStyle textStyle;

  const CameraButtonWidget({
    Key? key,
    // required this.buttonText,
    // required this.buttonColor,
    // required this.textStyle,
  }) : super(key: key);

  @override
  _CameraButtonWidgetState createState() => _CameraButtonWidgetState();
}

class _CameraButtonWidgetState extends State<CameraButtonWidget> {
  late CameraController _cameraController;
  Future<void>? _initializeControllerFuture;
  String? imagePath; // Path to store the captured image

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
    await _initializeControllerFuture; // Wait for the camera to initialize
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CameraPreviewScreen(
          cameraController: _cameraController,
          onImageCaptured: (String imagePath) {
            setState(() {
              this.imagePath = imagePath; // Store the image path when captured
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => _openCamera(context),
      child: Column(
        children: [
          // Display image if available, otherwise show the camera icon placeholder
          Container(
            // margin: EdgeInsets.all(20),
            height: screenWidth / 2,
            width: double.infinity,
            color:
                Colors.grey[300], // Background color before image is captured
            child: imagePath == null
                ? const Icon(
                    Icons.camera_alt_outlined,
                    size: 50,
                    color: Colors.black54,
                  )
                : Image.file(
                    height: 200,
                    width: 200,
                    File(imagePath!), // Display the captured image here
                    fit: BoxFit.contain,
                  ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () =>
                _openCamera(context), // Open camera when button is pressed
            style: ElevatedButton.styleFrom(
                backgroundColor: GobalStyles.successButtonColor,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                Text(' กล้อง', style: GobalStyles.text3),
              ],
            ),
          ),
        ],
      ),
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
      appBar: AppBar(title: Text('dawd Preview')),
      body: FutureBuilder<void>(
        future: cameraController.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Center(
                  child: CameraPreview(cameraController),
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

                          // Pass the file path back to the previous screen
                          onImageCaptured(image.path);

                          // Pop the current screen after the photo is taken
                          Navigator.pop(context);
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
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
