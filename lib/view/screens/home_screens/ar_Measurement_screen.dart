import 'dart:async';
import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

// Main Measurement Screen
class AddMeasurementScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String price;

  AddMeasurementScreen({
    required this.imageUrl,
    required this.price,
    required this.title,
  });

  @override
  _AddMeasurementScreenState createState() => _AddMeasurementScreenState();
}

class _AddMeasurementScreenState extends State<AddMeasurementScreen> {
  final GlobalKey<FormState> _form = GlobalKey();
  List<TextEditingController> controllers = [];
  bool isCapturing = false;

  // List of predefined body parts for measurement
  final List<String> bodyParts = [
    "Chest",
    "Waist",
    "Hip",
    "Arm Length",
    "Shoulder Width",
    "Neck",
    "Thigh",
    "Inseam",
    "Leg Length"
  ];

  @override
  void initState() {
    for (int i = 0; i < bodyParts.length; i++) {
      controllers.add(TextEditingController());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuerySize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(
            Icons.arrow_forward_ios,
            color: Colors.amber,
          ),
          onPressed: () {
            if (_form.currentState!.validate()) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewSummaryScreen(
                    measurementList: controllers,
                    title: widget.title,
                    price: widget.price,
                    imageUrl: widget.imageUrl,
                  ),
                ),
              );
            }
          },
        ),
        body: Container(
          color: Colors.blue,
          height: mediaQuerySize.height,
          width: mediaQuerySize.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _form,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(),
                    SizedBox(height: 20),
                    Text(
                      "Measurements in Inches",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    _buildMeasurementFields(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildBackButton()),
        Expanded(
          flex: 6,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 40),
              child: Text(
                "Add Measurement",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildMeasurementFields(BuildContext context) {
    return Column(
      children: List.generate(bodyParts.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () =>
                    _showMeasurementGuide(index), // Show the measurement guide
                child: Text(
                  "${bodyParts[index]} Measurement Guide",
                  style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 16),
                ),
              ),
              _buildMeasurementField(index),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _navigateToARMeasurement(context, index),
                child: Text("Get AR Measurement"),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMeasurementField(int index) {
    return TextFormField(
      controller: controllers[index],
      decoration: InputDecoration(
        hintText: bodyParts[index], // Display body part name as hint text
        hintStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Field can't be empty";
        }
        return null;
      },
    );
  }

  void _showMeasurementGuide(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("How to Measure ${bodyParts[index]}"),
        content: SizedBox(
          width: 200,
          height: 200,
          child: Image.asset(
            "assets/gifs/${bodyParts[index].toLowerCase()}.gif",
            fit: BoxFit.contain, // Ensure the image fits within the dialog box
            errorBuilder: (context, error, stackTrace) {
              return Text("Image not found or failed to load.");
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _navigateToARMeasurement(BuildContext context, int index) async {
    if (isCapturing) return;
    isCapturing = true;

    // Open AR screen and capture measurement
    double? measurementValue = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArMeasurementScreen(bodyPart: bodyParts[index]),
      ),
    );

    // If measurement is successfully captured, fill the corresponding text field
    if (measurementValue != null) {
      setState(() {
        controllers[index].text = measurementValue.toStringAsFixed(2);
      });
    }

    isCapturing = false;
  }
}

// AR Measurement Screen using ARCore for capturing distances
class ArMeasurementScreen extends StatefulWidget {
  final String bodyPart;

  ArMeasurementScreen({required this.bodyPart});

  @override
  _ArMeasurementScreenState createState() => _ArMeasurementScreenState();
}

class _ArMeasurementScreenState extends State<ArMeasurementScreen> {
  ArCoreController? arCoreController;
  vector.Vector3? startPosition;
  vector.Vector3? endPosition;
  double? distance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Capture ${widget.bodyPart} Measurement"),
      ),
      body: Stack(
        children: [
          ArCoreView(
            onArCoreViewCreated: _onArCoreViewCreated,
            enableTapRecognizer: true,
          ),
          if (distance != null)
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.white,
                child: Text(
                  "Distance: ${distance?.toStringAsFixed(2)} cm",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                if (distance != null) {
                  Navigator.pop(context, distance);
                }
              },
              child: Text(
                  "Confirm Measurement (${distance?.toStringAsFixed(2) ?? 'N/A'} cm)"),
            ),
          ),
        ],
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController?.onPlaneTap = _handleTapOnPlane;
  }

  void _handleTapOnPlane(List<ArCoreHitTestResult> hits) {
    if (hits.isEmpty) return;

    final hit = hits.first;
    final position = vector.Vector3(
      hit.pose.translation.x,
      hit.pose.translation.y,
      hit.pose.translation.z,
    );

    if (startPosition == null) {
      startPosition = position;
      _addSphereAtPosition(position, Colors.blue, 'startSphere');
    } else if (endPosition == null) {
      endPosition = position;
      _addSphereAtPosition(position, Colors.red, 'endSphere');
      _calculateDistance();
    } else {
      // Reset for new measurement
      _removeNodeByName('startSphere');
      _removeNodeByName('endSphere');

      startPosition = position;
      endPosition = null;
      distance = null;

      _addSphereAtPosition(position, Colors.blue, 'startSphere');
    }
  }

  void _addSphereAtPosition(
      vector.Vector3 position, Color color, String nodeName) {
    final material = ArCoreMaterial(color: color);
    final sphere = ArCoreSphere(materials: [material], radius: 0.02);
    final node = ArCoreNode(
      shape: sphere,
      position: position,
      name: nodeName,
    );
    arCoreController?.addArCoreNode(node);
  }

  void _calculateDistance() {
    if (startPosition == null || endPosition == null) return;

    setState(() {
      distance = startPosition!.distanceTo(endPosition!) *
          100; // Convert meters to centimeters
    });
  }

  // Remove specific node by name
  void _removeNodeByName(String name) {
    arCoreController?.removeNode(nodeName: name);
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }
}

// Screen to display summary of measurements
class ReviewSummaryScreen extends StatelessWidget {
  final List<TextEditingController> measurementList;
  final String title;
  final String price;
  final String imageUrl;

  ReviewSummaryScreen({
    required this.measurementList,
    required this.title,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Review Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Image.network(imageUrl), // Display product image
            SizedBox(height: 20),
            Text(
              "Price: $price",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: measurementList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      "Measurement ${index + 1}: ${measurementList[index].text} inches",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      "Body Part: ${_AddMeasurementScreenState().bodyParts[index]}",
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
