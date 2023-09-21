import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'home_page.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  print(cameras);

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras[0];

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: HomePage(camera: firstCamera),
    ),
  );
}
