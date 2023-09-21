
// A screen that allows users to take a picture using a given camera.
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;



  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  double _zoomLevel = 1.0; // Initial zoom level
  int _currentCameraIndex = 0;


  @override
  void initState() {
    //var _camera = await widget.cameras;
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }


  void _zoomIn() {
    setState(() {
      _zoomLevel += 0.1; // Increase zoom level by 0.1
      if (_zoomLevel > 5.0) {
        _zoomLevel = 5.0; // Limit zoom level to 5.0
      }
      _controller.setZoomLevel(_zoomLevel);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel -= 0.1; // Decrease zoom level by 0.1
      if (_zoomLevel < 1.0) {
        _zoomLevel = 1.0; // Limit zoom level to 1.0
      }
      _controller.setZoomLevel(_zoomLevel);
    });
  }

  void _cameraToggle() async{
    final cameras = await availableCameras();
    // setState((){
      if (cameras.length < 2) {
        return; // No need to toggle if there's only one camera available
      }

      _currentCameraIndex = ((_currentCameraIndex + 1) % cameras.length);

      _controller = CameraController(
        cameras[_currentCameraIndex],
        ResolutionPreset.medium,
      );

    _controller.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
    //});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _zoomOut(),
                icon: Icon(Icons.zoom_out_rounded),

              ),
              IconButton(
                  onPressed: () => _zoomIn(),
                  icon: Icon(Icons.zoom_in_rounded),

              ),
            ],
          ),

      Row(

        children: [
          Container(
            margin: EdgeInsets.fromLTRB(170, 0, 110, 0),
            child: FloatingActionButton(
              // Provide an onPressed callback.
              onPressed: () async {
                // Take the Picture in a try / catch block. If anything goes wrong,
                // catch the error.
                try {
                  // Ensure that the camera is initialized.
                  await _initializeControllerFuture;

                  // Attempt to take a picture and get the file `image`
                  // where it was saved.
                  final image = await _controller.takePicture();

                  if (!mounted) return;

                  // If the picture was taken, display it on a new screen.
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DisplayPictureScreen(
                        // Pass the automatically generated path to
                        // the DisplayPictureScreen widget.
                        imagePath: image.path,
                      ),
                    ),
                  );
                } catch (e) {
                  // If an error occurs, log the error to the console.
                  print(e);
                }
              },
              child: const Icon(Icons.camera_alt),
            ),
          ),

          IconButton(
            onPressed: ()=> _cameraToggle(),
            icon: Icon(Icons.flip_camera_android_rounded),

          ),

        ],
      ),
      ],
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}