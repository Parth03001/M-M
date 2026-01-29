import 'dart:typed_data';
import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../models/detection_result.dart';
import 'model_service.dart';
import 'image_preprocessor.dart';

// TFLite interpreter - using tflite_flutter package
import 'package:tflite_flutter/tflite_flutter.dart';

/// EfficientNet-B0 classifier model service.
/// Unlike YOLO (detection), this classifies the entire wheel image
/// into one of 4 classes: AX7_OK, AX7_NOT_OK, AX7L_OK, AX7L_NOT_OK
class ModelServiceEfficientNet implements ModelService {
  Interpreter? _interpreter;
  bool _isLoaded = false;
  final ImagePreprocessor _preprocessor = ImagePreprocessor();

  // Class names matching training order
  static const List<String> classNames = [
    'AX7L_NOT_OK',
    'AX7L_OK',
    'AX7_NOT_OK',
    'AX7_OK',
  ];

  @override
  bool get isLoaded => _isLoaded;

  @override
  Future<void> loadModel() async {
    try {
      // Disable XNNPACK delegate — can cause "Unable to create interpreter"
      // with custom EfficientNet models
      final options = InterpreterOptions()..threads = 2;

      // Load model from Flutter asset bundle via temp file (most reliable)
      print('Loading EfficientNet model...');
      final byteData = await rootBundle.load('assets/wheel_efficientnet.tflite');
      final tempDir = await getTemporaryDirectory();
      final modelFile = File('${tempDir.path}/wheel_efficientnet.tflite');
      await modelFile.writeAsBytes(byteData.buffer.asUint8List());
      _interpreter = Interpreter.fromFile(modelFile, options: options);

      _isLoaded = true;
      print('✓ EfficientNet model loaded (${byteData.lengthInBytes ~/ 1024 ~/ 1024} MB)');
    } catch (e) {
      print('❌ Failed to load EfficientNet model: $e');
      rethrow;
    }
  }

  @override
  Future<DetectionResult> detectAndClassify(Uint8List imageBytes,
      {int imageWidth = 640, int imageHeight = 640}) async {
    if (!_isLoaded || _interpreter == null) {
      return DetectionResult(
        boxes: [],
        detectionSuccess: false,
        debugLogs: ['Model not loaded'],
      );
    }

    final logs = <String>[];

    try {
      // Step 1: Preprocess (center crop + CLAHE + resize + normalize)
      logs.add('Preprocessing: center crop (55%) + CLAHE + resize 224x224');
      final inputTensor = _preprocessor.preprocess(imageBytes);
      logs.add('✓ Preprocessing complete');

      // Step 2: Run inference
      // Input shape: [1, 3, 224, 224], Output shape: [1, num_classes]
      final inputShape = [1, 3, 224, 224];
      final outputShape = [1, classNames.length];

      // Reshape input for interpreter
      final input = inputTensor.reshape(inputShape);
      final output = List.filled(classNames.length, 0.0).reshape([1, classNames.length]);

      _interpreter!.run(input, output);

      // Step 3: Apply softmax and get prediction
      final logits = (output[0] as List).cast<double>();
      final probs = _softmax(logits);

      int bestIdx = 0;
      double bestProb = probs[0];
      for (int i = 1; i < probs.length; i++) {
        if (probs[i] > bestProb) {
          bestProb = probs[i];
          bestIdx = i;
        }
      }

      final predictedClass = classNames[bestIdx];
      logs.add('Prediction: $predictedClass (${(bestProb * 100).toStringAsFixed(1)}%)');
      for (int i = 0; i < classNames.length; i++) {
        logs.add('  ${classNames[i]}: ${(probs[i] * 100).toStringAsFixed(1)}%');
      }

      // Map EfficientNet classification to DetectionResult format
      // No bounding boxes — just a single classification result
      // We use classId to map to the wheel combination logic
      final classId = _mapToWheelClassId(predictedClass);

      return DetectionResult(
        boxes: [
          BoundingBox(
            x1: 0, y1: 0,
            x2: imageWidth.toDouble(),
            y2: imageHeight.toDouble(),
            className: predictedClass,
            confidence: bestProb,
            classId: classId,
          ),
        ],
        detectionSuccess: true,
        debugLogs: logs,
      );
    } catch (e) {
      logs.add('❌ Inference error: $e');
      return DetectionResult(
        boxes: [],
        detectionSuccess: false,
        debugLogs: logs,
      );
    }
  }

  /// Map EfficientNet class name to a synthetic classId for the UI
  int _mapToWheelClassId(String className) {
    // Return unique IDs that the screen can use directly
    switch (className) {
      case 'AX7_OK':
        return 10;
      case 'AX7_NOT_OK':
        return 11;
      case 'AX7L_OK':
        return 12;
      case 'AX7L_NOT_OK':
        return 13;
      default:
        return -1;
    }
  }

  List<double> _softmax(List<double> logits) {
    final maxLogit = logits.reduce((a, b) => a > b ? a : b);
    final exps = logits.map((l) => _exp(l - maxLogit)).toList();
    final sum = exps.reduce((a, b) => a + b);
    return exps.map((e) => e / sum).toList();
  }

  double _exp(double x) {
    if (x > 80) return double.maxFinite;
    if (x < -80) return 0.0;
    return math.exp(x);
  }

  @override
  Future<Map<String, dynamic>> classifyImage(Uint8List imageBytes) async {
    final result = await detectAndClassify(imageBytes);
    if (result.boxes.isNotEmpty) {
      return {
        'result': result.boxes.first.className,
        'confidence': result.boxes.first.confidence,
      };
    }
    return {'result': 'Unknown', 'confidence': 0.0};
  }

  @override
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isLoaded = false;
  }
}
