

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'coordinates_translator.dart'; // Import the coordinate translator functions
import 'detector_view.dart';
import 'pose_painter.dart';

class PoseDetectorView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;
  ArCoreController? _arCoreController;
  ArCoreNode? _clothingNode;
  String? _selectedModel = 'assets/AndroidRobot.gif'; // Default selected model path

  @override
  void dispose() {
    _canProcess = false;
    _poseDetector.close();
    _arCoreController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  // Callback for ARCore view creation
  void _onArCoreViewCreated(ArCoreController controller) {
    _arCoreController = controller;
    print('ARCore view created successfully.');
  }

  // Load and place the 3D clothing model in AR
  Future<void> _loadClothingModel(Vector3 position) async {
  try {
    print('Attempting to load 3D model from path: $_selectedModel');
    final modelFileName = 'flutter_assets/assets/AndroidRobot.gif';
    print('Final model file path: $modelFileName');

    final clothingNode = ArCoreReferenceNode(
      name: 'clothing',
      object3DFileName: modelFileName,
      position: position,
      scale: Vector3(0.1, 0.1, 0.1),
    );

    await _arCoreController?.addArCoreNode(clothingNode);
    _clothingNode = clothingNode;
    print('3D clothing model successfully loaded and added to ARCore.');
  } catch (e) {
    print('Error loading 3D clothing model: $e');
  }
}


  // UI for clothing selection and displaying AR model
  Widget buildClothingSelection() {
    final List<Map<String, String>> clothingItems = [
      {'name': 'Jacket', 'model': 'assets/AndroidRobot.gif'},
      {'name': 'Pants', 'model': 'assets/heavy.glb'},
      {'name': 'Shirt', 'model': 'assets/heavy.glb'},
    ];

    return Container(
      color: Colors.white,
      height: 150,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: clothingItems.length,
              itemBuilder: (context, index) {
                final item = clothingItems[index];
                return GestureDetector(
                  onTap: () {
                    // Update selected model on item tap and print
                    setState(() {
                      _selectedModel = item['model'];
                    });
                    print(
                        'Selected model: ${item['name']} with path ${item['model']}');
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Icon(Icons.checkroom,
                            size: 50), // Placeholder icon for clothing item
                        SizedBox(height: 5),
                        Text(item['name']!), // Display item name
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle showing AR model on button click
              print('View in AR button pressed for model $_selectedModel');
              _showARModel();
            },
            child: Text('View in AR'),
          ),
        ],
      ),
    );
  }

  // Trigger AR model display based on the selected model and print statements for debugging
  void _showARModel() async {
    print('Preparing to render the selected model $_selectedModel in AR.');
    // Use a fixed position for demo purposes; integrate pose-based position if needed
    final arPosition = Vector3(0.0, 0.0, -1.0);
    _loadClothingModel(arPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pose Detector with AR Clothing')),
      body: Stack(
        children: [
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
          ),
          Column(
            children: [
              Expanded(
                flex: 6,
                child: DetectorView(
                  title: 'Pose Detector',
                  customPaint: _customPaint,
                  text: _text,
                  onImage: _processImage,
                  initialCameraLensDirection: _cameraLensDirection,
                  onCameraLensDirectionChanged: (value) =>
                      _cameraLensDirection = value,
                ),
              ),
              Expanded(
                flex: 4,
                child:
                    buildClothingSelection(), // Show clothing selection at the bottom
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess || _isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });

    print('Processing image for pose detection...');
    final poses = await _poseDetector.processImage(inputImage);
    print('Number of poses detected: ${poses.length}');

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = PosePainter(
        poses,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);

      if (_clothingNode == null && poses.isNotEmpty) {
        final leftShoulder =
            _getLandmarkPosition(poses, PoseLandmarkType.leftShoulder);
        final rightShoulder =
            _getLandmarkPosition(poses, PoseLandmarkType.rightShoulder);

        if (leftShoulder != null && rightShoulder != null) {
          print(
              'Detected left and right shoulders at positions: $leftShoulder and $rightShoulder.');

          // Compute the center position between the shoulders
          final centerX = (leftShoulder.dx + rightShoulder.dx) / 2;
          final centerY = (leftShoulder.dy + rightShoulder.dy) / 2;

          print('Center position between shoulders: ($centerX, $centerY)');

          // Translate coordinates to canvas space
          final double translatedX = translateX(
            centerX,
            Size(context.size!.width, context.size!.height),
            inputImage.metadata!.size,
            inputImage.metadata!.rotation,
            _cameraLensDirection,
          );

          final double translatedY = translateY(
            centerY,
            Size(context.size!.width, context.size!.height),
            inputImage.metadata!.size,
            inputImage.metadata!.rotation,
            _cameraLensDirection,
          );
          print('Translated canvas position: ($translatedX, $translatedY)');

          // Convert 2D canvas position to a 3D position in AR space
          final Vector3 arPosition = Vector3(translatedX, translatedY, -1.0);
          print('Converted 3D AR position: $arPosition');

          // Load clothing model at the computed AR position
          _loadClothingModel(arPosition);
        }
      }
    } else {
      _text = 'Poses found: ${poses.length}\n\n';
      _customPaint = null;
    }

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  // Helper method to get the position of a pose landmark and print debugging info
  Offset? _getLandmarkPosition(List<Pose> poses, PoseLandmarkType type) {
    for (final pose in poses) {
      final landmark = pose.landmarks[type];
      if (landmark != null) {
        print(
            'Landmark of type $type detected at (${landmark.x}, ${landmark.y})');
        return Offset(landmark.x, landmark.y);
      }
    }
    print('Landmark of type $type not detected.');
    return null;
  }
}
