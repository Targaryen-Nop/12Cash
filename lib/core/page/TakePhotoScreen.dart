import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class CameraExample extends StatefulWidget {
  @override
  _CameraExampleState createState() => _CameraExampleState();
}

class _CameraExampleState extends State<CameraExample> {
  late CameraController _cameraController;
  Future<void>? _initializeControllerFuture; // Make it nullable

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Initialize the camera
  Future<void> _initializeCamera() async {
    try {
      // Get the list of available cameras
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      // Initialize the camera controller
      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.high,
      );

      // Initialize the controller
      _initializeControllerFuture = _cameraController.initialize();

      // Trigger rebuild to allow the FutureBuilder to properly handle the future
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController.dispose(); // Dispose the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Example'),
      ),
      body: _initializeControllerFuture == null
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loader until camera is initialized
          : FutureBuilder<void>(
              future: _initializeControllerFuture, // Use the nullable Future
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the camera is initialized, display the camera preview
                  return CameraPreview(_cameraController);
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  // Otherwise, display a loading indicator while waiting for the camera to initialize
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Ensure the camera is initialized
            await _initializeControllerFuture;

            // Take the picture
            final image = await _cameraController.takePicture();

            // If the picture was taken, display it on a new screen
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
    );
  }
}

// A new screen to display the captured image
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Captured Image')),
      body: Image.file(File(imagePath)),
    );
  }
}

Future<void> main() async {
  // Ensure that plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    home: CameraExample(),
  ));
}
