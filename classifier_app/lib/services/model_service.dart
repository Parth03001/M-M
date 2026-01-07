import 'dart:typed_data';
import 'detection_result.dart';

/// Abstract interface for model inference
abstract class ModelService {
  /// Load the model
  Future<void> loadModel();

  /// Detect objects in an image and classify them
  /// Returns DetectionResult with bounding boxes and classifications
  Future<DetectionResult> detectAndClassify(Uint8List imageBytes,
      {int imageWidth = 640, int imageHeight = 640});

  /// Classify an image (legacy method, kept for compatibility)
  /// Returns a map with 'result' (String) and 'confidence' (double)
  Future<Map<String, dynamic>> classifyImage(Uint8List imageBytes);

  /// Dispose resources
  void dispose();

  /// Check if model is loaded
  bool get isLoaded;
}
