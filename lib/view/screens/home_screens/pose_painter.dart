import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'coordinates_translator.dart';

class PosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  PosePainter(this.poses, this.absoluteImageSize, this.rotation,
      this.cameraLensDirection);

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    if (poses.isEmpty) return;

    // Load t-shirt image
    final ui.Image shirtImage = await _loadImage('assets/shirt2.png');

    // Loop through detected poses
    for (Pose pose in poses) {
      final Map<PoseLandmarkType, PoseLandmark> landmarks = pose.landmarks;

      // Access landmarks for positioning
      PoseLandmark? leftShoulder = landmarks[PoseLandmarkType.leftShoulder];
      PoseLandmark? rightShoulder = landmarks[PoseLandmarkType.rightShoulder];
      PoseLandmark? leftHip = landmarks[PoseLandmarkType.leftHip];
      PoseLandmark? rightHip = landmarks[PoseLandmarkType.rightHip];

      if (leftShoulder != null &&
          rightShoulder != null &&
          leftHip != null &&
          rightHip != null) {
        // Translate pose landmarks to the canvas coordinates
        final leftShoulderOffset = Offset(
            translateX(leftShoulder.x, rotation as ui.Size, size,
                absoluteImageSize as InputImageRotation, cameraLensDirection),
            translateY(leftShoulder.y, rotation as ui.Size, size,
                absoluteImageSize as InputImageRotation, cameraLensDirection));
        final rightShoulderOffset = Offset(
            translateX(rightShoulder.x, rotation as ui.Size, size,
                absoluteImageSize as InputImageRotation, cameraLensDirection),
            translateY(rightShoulder.y, rotation as ui.Size, size,
                absoluteImageSize as InputImageRotation, cameraLensDirection));
        final leftHipOffset = Offset(
            translateX(leftHip.x, rotation as ui.Size, size,
                absoluteImageSize as InputImageRotation, cameraLensDirection),
            translateY(leftHip.y, rotation as ui.Size, size,
                absoluteImageSize as InputImageRotation, cameraLensDirection));
        final rightHipOffset = Offset(
            translateX(rightHip.x, rotation as ui.Size, size,
                absoluteImageSize as InputImageRotation, cameraLensDirection),
            translateY(rightHip.y, rotation as ui.Size, size,
                absoluteImageSize as InputImageRotation, cameraLensDirection));

        // Calculate size and position for the clothing
        double width = (rightShoulderOffset.dx - leftShoulderOffset.dx).abs();
        double height = (leftHipOffset.dy - leftShoulderOffset.dy).abs();

        Rect shirtRect = Rect.fromLTRB(
          leftShoulderOffset.dx,
          leftShoulderOffset.dy,
          rightShoulderOffset.dx,
          rightShoulderOffset.dy + height,
        );

        // Draw the t-shirt image over the body
        canvas.drawImageRect(
            shirtImage,
            Rect.fromLTWH(0, 0, shirtImage.width.toDouble(),
                shirtImage.height.toDouble()),
            shirtRect,
            Paint());
      }
    }
  }

  // Helper method to load an image from assets
  Future<ui.Image> _loadImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint every time as it's real-time processing
  }
}
