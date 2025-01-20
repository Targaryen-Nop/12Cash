import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// Screen to display the camera preview and allow the user to take a picture
class CameraPreviewScreen extends StatefulWidget {
  final CameraController cameraController;
  final Function(String) onImageCaptured;

  const CameraPreviewScreen({
    super.key,
    required this.cameraController,
    required this.onImageCaptured,
  });

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  @override
  void dispose() {
    widget.cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(
            icon: Icons.camera_alt, title: "gobal.camera_button.appbar".tr()),
      ),
      body: FutureBuilder<void>(
        future: widget.cameraController.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Center(
                  child: Transform.rotate(
                    angle: 90 * (3.141592653589793 / 180),
                    child: AspectRatio(
                      aspectRatio:
                          2 * 1 / widget.cameraController.value.aspectRatio,
                      child: CameraPreview(
                        widget.cameraController,
                      ),
                    ),
                  ),
                ),
                // Center(
                //   child: Transform.rotate(
                //     angle: 90 *
                //         (3.141592653589793 /
                //             180), // 0 radians means no rotation (default is portrait)
                //     child: AspectRatio(
                //       aspectRatio:
                //           1 / widget.cameraController.value.aspectRatio,
                //       child: CameraPreview(
                //         widget.cameraController,
                //       ),
                //     ),
                //   ),
                // ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FloatingActionButton(
                      onPressed: () async {
                        try {
                          // Capture the picture
                          final image =
                              await widget.cameraController.takePicture();

                          // Pass the file path back to the previous screen
                          widget.onImageCaptured(image.path);

                          // Pop the current screen after the photo is taken
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
