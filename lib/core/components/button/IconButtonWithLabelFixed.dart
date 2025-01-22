import 'dart:io';
import 'package:_12sale_app/core/components/button/CameraButton%20copy.dart';
import 'package:_12sale_app/core/components/button/CameraPreviewScreen.dart';
import 'package:_12sale_app/core/page/HomeScreen.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IconButtonWithLabelFixed extends StatefulWidget {
  String? imagePath;
  final IconData icon;
  final String label;
  final TextStyle? labelStyle;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Function(String imagePath)? onImageSelected; // Callback for image path
  bool checkNetwork;
  IconButtonWithLabelFixed({
    super.key,
    required this.icon,
    this.imagePath,
    required this.label,
    this.labelStyle,
    this.backgroundColor = Colors.blue,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.onImageSelected, // Optional parameter for callback
    this.checkNetwork = false,
  });

  @override
  _IconButtonWithLabelFixedState createState() =>
      _IconButtonWithLabelFixedState();
}

class _IconButtonWithLabelFixedState extends State<IconButtonWithLabelFixed>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  // late CameraController _cameraController;
  // String? imagePath;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    // _initializeCamera();
  }

  // Future<void> _initializeCamera() async {
  //   try {
  //     final cameras = await availableCameras();
  //     if (cameras.isNotEmpty) {
  //       final firstCamera = cameras.first;
  //       _cameraController = CameraController(
  //         firstCamera,
  //         ResolutionPreset.max,
  //         fps: 30,
  //         enableAudio: false,
  //         imageFormatGroup: ImageFormatGroup.jpeg,
  //       );
  //       _initializeControllerFuture = _cameraController.initialize();
  //       await _initializeControllerFuture;
  //     } else {
  //       print("No cameras available");
  //     }
  //   } catch (e) {
  //     print("Error initializing camera: $e");
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   final CameraController? cameraController = controller;

  //   // App state changed before we got the chance to initialize.
  //   if (cameraController == null || !cameraController.value.isInitialized) {
  //     return;
  //   }

  //   if (state == AppLifecycleState.inactive) {
  //     cameraController.dispose();
  //   } else if (state == AppLifecycleState.resumed) {
  //     _initializeCameraController(cameraController.description);
  //   }
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller == null) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (!controller!.value.isInitialized) {
        _initializeCameraController(controller!.description);
      }
    }
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.max,
      // enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
      // fps: 60,
    );
    controller = cameraController;
    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      // await cameraController
      //     .lockCaptureOrientation(DeviceOrientation.portraitUp);
      // Lock the camera orientation to portrait
      // await cameraController
      //     .lockCaptureOrientation(DeviceOrientation.portraitUp);
      // await cameraController.lockCaptureOrientation(DeviceOrientation.)
      // Ensure portrait orientation
      // await cameraController
      //     .lockCaptureOrientation(DeviceOrientation.landscapeRight);
      // await Future.wait(<Future<Object?>>[
      //   // The exposure mode is currently not supported on the web.
      //   ...!kIsWeb
      //       ? <Future<Object?>>[
      //           cameraController.getMinExposureOffset().then(
      //               (double value) => _minAvailableExposureOffset = value),
      //           cameraController
      //               .getMaxExposureOffset()
      //               .then((double value) => _maxAvailableExposureOffset = value)
      //         ]
      //       : <Future<Object?>>[],
      //   cameraController
      //       .getMaxZoomLevel()
      //       .then((double value) => _maxAvailableZoom = value),
      //   cameraController
      //       .getMinZoomLevel()
      //       .then((double value) => _minAvailableZoom = value),
      // ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable camera access.');
        case 'CameraAccessRestricted':
          // iOS only
          showInSnackBar('Camera access is restricted.');
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          showInSnackBar('Please go to Settings app to enable audio access.');
        case 'AudioAccessRestricted':
          // iOS only
          showInSnackBar('Audio access is restricted.');
        default:
          _showCameraException(e);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _logError(String code, String? message) {
    // ignore: avoid_print
    print('Error: $code${message == null ? '' : '\nError Message: $message'}');
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      return controller!.setDescription(cameraDescription);
    } else {
      return _initializeCameraController(cameraDescription);
    }
  }

  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          controller!,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              onTapDown: (TapDownDetails details) =>
                  onViewFinderTap(details, constraints),
            );
          }),
        ),
      );
    }
  }

  // Future<void> openCamera(BuildContext context) async {
  //   final cameras = await availableCameras();
  //   await onNewCameraSelected(cameras.first);
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) => CameraPreviewScreen(
  //         cameraController: controller!,
  //         onImageCaptured: (
  //           String imagePath,
  //         ) {
  //           setState(() {
  //             widget.imagePath = imagePath;
  //           });
  //           // Notify parent widget via callback
  //           if (widget.onImageSelected != null) {
  //             widget.onImageSelected!(imagePath);
  //           }
  //         },
  //       ),
  //     ),
  //   );
  // }

  Future<void> openCamera(BuildContext context) async {
    try {
      // Dispose of the existing controller if it's already initialized
      if (controller != null && controller!.value.isInitialized) {
        await controller!.dispose();
      }

      // Get the available cameras
      var cameras = await availableCameras();
      // cameras.first.sensorOrientation = 270;

      final camera = cameras.first;
      print('Camera sensor orientation: ${camera.sensorOrientation}');
      print('Lens facing: ${camera.lensDirection}');
      if (cameras.isEmpty) {
        showInSnackBar('No cameras available');
        return;
      }

      // Initialize the camera with the first available camera

      final firstCamera = cameras.first;

      cameras.clear();

      await _initializeCameraController(firstCamera);

      // Navigate to the camera preview screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CameraPreviewScreen(
            cameraController: controller!,
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
    } catch (e) {
      showInSnackBar('Error opening camera: $e');
    }
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
              backgroundColor: widget.imagePath == null
                  ? Colors.grey[400]
                  : Styles.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ),
            child: widget.imagePath == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(widget.icon, color: Colors.white, size: 50),
                      Text(
                        "gobal.camera_button.button".tr(),
                        style: Styles.white18(context),
                      )
                    ],
                  )
                : ClipRRect(
                    child: widget.checkNetwork == false
                        ? Image.file(
                            File(widget.imagePath!),
                            width: screenWidth / 4,
                            height: screenWidth / 4,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            widget.imagePath!,
                            width: screenWidth / 4,
                            height: screenWidth / 4,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 50,
                                ),
                              );
                            },
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
