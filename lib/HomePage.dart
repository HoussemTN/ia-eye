import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ia_eye/Eye.dart';
import 'package:ia_eye/ObjectBoundaries.dart';
import 'dart:math' as math;
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  HomePage(this.cameras);
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    setRecognitions(recognitions, imageHeight, imageWidth) {
      setState(() {
        _recognitions = recognitions;
        _imageHeight = imageHeight;
        _imageWidth = imageWidth;
      });
    }

    Size screen = MediaQuery.of(context).size;
    return Stack(
        children: [
          Eye(widget.cameras, setRecognitions),
          ObjectBoundaries(
              _recognitions == null ? [] : _recognitions,
              math.max(_imageHeight, _imageWidth),
              math.min(_imageHeight, _imageWidth),
              screen.height,
              screen.width),
        ],
      );

  }

  loadModel() async {
    String? res = await Tflite.loadModel(
      model: "assets/mobilenet.tflite",
      labels: "assets/labels.txt",
    );
    print("Model loading: " + res!);
  }

}
