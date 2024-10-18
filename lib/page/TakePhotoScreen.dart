import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );

    // Initialize the controller
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the camera preview
            return GestureDetector(
              onTap: () async {
                try {
                  // Ensure that the camera is initialized
                  await _initializeControllerFuture;

                  // Take the picture and save it
                  final image = await _controller.takePicture();

                  // If the picture is taken, display it in a new screen or process the image
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DisplayPictureScreen(imagePath: image.path),
                    ),
                  );
                } catch (e) {
                  print(e);
                }
              },
              child: Container(
                height: 438,
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: CameraPreview(_controller),
              ),
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

// A widget that displays the captured picture
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the picture')),
      body: Image.file(File(imagePath)),
    );
  }
}

Future<void> main() async {
  // Ensure that plugin services are initialized so we can fetch the available cameras
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of available cameras
  final cameras = await availableCameras();

  // Get the first camera from the list
  final firstCamera = cameras.first;

  runApp(MaterialApp(
    theme: ThemeData.dark(),
    home: TakePictureScreen(camera: firstCamera),
  ));
}
