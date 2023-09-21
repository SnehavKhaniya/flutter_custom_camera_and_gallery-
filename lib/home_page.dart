import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'camera_controller.dart';

class HomePage extends StatefulWidget {


  const HomePage({
    super.key,
    required this.camera
  });

  final CameraDescription camera;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Demo'),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder:(_) => TakePictureScreen(camera: widget.camera)));
              },
              icon: Icon(Icons.camera),
          ),
        ],
      ),
      body: Center(
        child: Text('Hello ....'),
      ),
    );
  }
}
