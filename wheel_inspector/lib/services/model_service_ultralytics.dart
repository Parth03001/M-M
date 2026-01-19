import 'dart:typed_data';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'model_service.dart';
import '../models/detection_result.dart';

/// Ultralytics YOLO implementation - Official YOLO plugin
class ModelServiceUltralytics implements ModelService {
  YOLO? _yolo;
  List<String> _labels = [];
  List<String> _loadModelLogs = [];
  static const double confThreshold = 0.25;

  @override
  bool get isLoaded => _yolo != null;

  @override
  Future<void> loadModel() async {
    _loadModelLogs.clear();
    void addLog(String message) {
      _loadModelLogs.add(message);
    }

    try {
      // Load labels first
      await _loadLabels(addLog);

      addLog('📥 Loading YOLO model using Ultralytics plugin...');

      // Initialize YOLO with the wheel_model
      // For Android: model should be in android/app/src/main/assets/
      // Model path should be without extension for Android
      _yolo = YOLO(
        modelPath: 'wheel_model', // Model name without .tflite extension
        task: YOLOTask.detect, // Object detection task
      );

      // Load the model
      addLog('   Loading model...');
      final success = await _yolo!.loadModel();

      if (!success) {
        throw Exception('Failed to load YOLO model');
      }

      addLog('✓ YOLO model loaded successfully');
      addLog('   Model path: wheel_model');
      addLog('   Task: Detection');
      addLog('   Labels loaded: ${_labels.length}');
      if (_labels.isNotEmpty) {
        addLog(
            '   Label mapping: ${_labels.asMap().entries.map((e) => '${e.key}=${e.value}').join(", ")}');
      }
    } catch (e, stackTrace) {
      addLog('❌ Error loading YOLO model: $e');
      addLog('   Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Load labels from assets/labels.txt
  /// Note: Labels are OPTIONAL - YOLO models have built-in class names
  /// Labels.txt is only needed if you want to override/customize class names
  Future<void> _loadLabels(void Function(String) addLog) async {
    try {
      addLog('📋 Loading labels from assets/labels.txt (optional)...');
      final String labelsString =
          await rootBundle.loadString('assets/labels.txt');
      _labels = labelsString
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();

      if (_labels.isEmpty) {
        addLog('ℹ️  No labels found in labels.txt');
        addLog('   Model will use built-in class names');
        _labels = []; // Empty - use model's class names
      } else {
        addLog(
            '✓ Loaded ${_labels.length} custom labels: ${_labels.join(", ")}');
        addLog('   These will override model class names if classId matches');
      }
    } catch (e) {
      addLog('ℹ️  labels.txt not found or failed to load: $e');
      addLog('   Model will use built-in class names (this is normal)');
      _labels = []; // Empty - use model's class names
    }
  }

  @override
  Future<DetectionResult> detectAndClassify(
    Uint8List imageBytes, {
    int imageWidth = 640,
    int imageHeight = 640,
  }) async {
    if (_yolo == null) {
      throw Exception('Model not loaded');
    }

    List<String> debugLogs = [];

    // Include load model logs at the start
    if (_loadModelLogs.isNotEmpty) {
      debugLogs.add('━━━━━━━━━━━━━━━━━━━━');
      debugLogs.add('📋 Model Loading Logs:');
      debugLogs.addAll(_loadModelLogs);
      debugLogs.add('━━━━━━━━━━━━━━━━━━━━');
    }

    void addLog(String message) {
      debugLogs.add(message);
    }

    try {
      addLog('🔍 Running YOLO inference...');

      // Decode image
      img.Image? originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) {
        throw Exception('Failed to decode image');
      }

      final origWidth = originalImage.width;
      final origHeight = originalImage.height;

      addLog('📸 Image size: ${origWidth}x${origHeight}');
      addLog('📸 Image bytes: ${imageBytes.length}');

      // Run YOLO inference
      addLog('🚀 Calling YOLO.predict()...');

      final Map<String, dynamic> results = await _yolo!.predict(
        imageBytes,
        confidenceThreshold: confThreshold,
        iouThreshold: 0.45,
      );

      addLog('✅ YOLO inference completed');
      addLog('   Results keys: ${results.keys.toList()}');

      // Extract boxes from results
      List<dynamic> boxesList = [];

      if (results.containsKey('detections')) {
        boxesList = results['detections'] as List<dynamic>? ?? [];
        addLog('   Found ${boxesList.length} detections in "detections" key');
      } else if (results.containsKey('boxes')) {
        boxesList = results['boxes'] as List<dynamic>? ?? [];
        addLog('   Found ${boxesList.length} detections in "boxes" key');
      } else {
        addLog('   ⚠️  No "detections" or "boxes" key found in results');
        for (final key in results.keys) {
          if (results[key] is List) {
            boxesList = results[key] as List<dynamic>;
            addLog('   Found ${boxesList.length} items in "$key" key');
            break;
          }
        }
      }

      if (boxesList.isEmpty) {
        addLog('   ⚠️  No detections found in results');
      }

      // Convert YOLO results to BoundingBox format
      List<BoundingBox> boxes = [];

      for (int i = 0; i < boxesList.length; i++) {
        final boxData = boxesList[i];
        try {
          addLog('   Processing detection $i...');

          final boxMap = boxData as Map<String, dynamic>;

          addLog('     Box keys: ${boxMap.keys.toList()}');
          addLog('     Box values:');
          boxMap.forEach((key, value) {
            addLog('       $key: $value (${value.runtimeType})');
          });

          final String className = boxMap['class'] as String? ??
              boxMap['className'] as String? ??
              boxMap['name'] as String? ??
              'Unknown';

          final double confidence =
              (boxMap['confidence'] as num?)?.toDouble() ??
                  (boxMap['conf'] as num?)?.toDouble() ??
                  (boxMap['score'] as num?)?.toDouble() ??
                  0.0;

          final classId = (boxMap['classId'] as num?)?.toInt() ??
              (boxMap['classIndex'] as num?)?.toInt();

          addLog(
              '     Class: $className, Confidence: $confidence, ClassId: $classId');

          if (confidence < confThreshold) {
            addLog(
                '     ⚠️  Skipped: confidence $confidence < threshold $confThreshold');
            continue;
          }

          // Extract bounding box coordinates
          double x1 = 0.0, y1 = 0.0, x2 = 0.0, y2 = 0.0;

          if (boxMap.containsKey('boundingBox')) {
            final bbox = boxMap['boundingBox'];
            addLog('     Found boundingBox: $bbox (${bbox.runtimeType})');

            if (bbox is Map) {
              final bboxMap = bbox as Map<String, dynamic>;
              addLog('     boundingBox keys: ${bboxMap.keys.toList()}');
              addLog('     boundingBox values: $bboxMap');

              if (bboxMap.containsKey('left') &&
                  bboxMap.containsKey('top') &&
                  bboxMap.containsKey('right') &&
                  bboxMap.containsKey('bottom')) {
                x1 = (bboxMap['left'] as num?)?.toDouble() ?? 0.0;
                y1 = (bboxMap['top'] as num?)?.toDouble() ?? 0.0;
                x2 = (bboxMap['right'] as num?)?.toDouble() ?? 0.0;
                y2 = (bboxMap['bottom'] as num?)?.toDouble() ?? 0.0;
                addLog(
                    '     Using boundingBox (left,top,right,bottom): [$x1, $y1, $x2, $y2]');
              } else if (bboxMap.containsKey('x') &&
                  bboxMap.containsKey('y') &&
                  bboxMap.containsKey('width') &&
                  bboxMap.containsKey('height')) {
                final x = (bboxMap['x'] as num?)?.toDouble() ?? 0.0;
                final y = (bboxMap['y'] as num?)?.toDouble() ?? 0.0;
                final width = (bboxMap['width'] as num?)?.toDouble() ?? 0.0;
                final height = (bboxMap['height'] as num?)?.toDouble() ?? 0.0;
                x1 = x;
                y1 = y;
                x2 = x + width;
                y2 = y + height;
                addLog(
                    '     Using boundingBox (x,y,width,height): [$x1, $y1, $x2, $y2]');
              }
            } else if (bbox is List && bbox.length >= 4) {
              x1 = (bbox[0] as num?)?.toDouble() ?? 0.0;
              y1 = (bbox[1] as num?)?.toDouble() ?? 0.0;
              x2 = (bbox[2] as num?)?.toDouble() ?? 0.0;
              y2 = (bbox[3] as num?)?.toDouble() ?? 0.0;
              addLog('     Using boundingBox (list): [$x1, $y1, $x2, $y2]');
            }
          }

          if ((x1 == 0.0 && y1 == 0.0 && x2 == 0.0 && y2 == 0.0) &&
              boxMap.containsKey('normalizedBox')) {
            final nbox = boxMap['normalizedBox'];
            addLog('     Found normalizedBox: $nbox (${nbox.runtimeType})');

            if (nbox is Map) {
              final nboxMap = nbox as Map<String, dynamic>;
              addLog('     normalizedBox keys: ${nboxMap.keys.toList()}');
              addLog('     normalizedBox values: $nboxMap');

              if (nboxMap.containsKey('left') &&
                  nboxMap.containsKey('top') &&
                  nboxMap.containsKey('right') &&
                  nboxMap.containsKey('bottom')) {
                x1 = (nboxMap['left'] as num?)?.toDouble() ?? 0.0;
                y1 = (nboxMap['top'] as num?)?.toDouble() ?? 0.0;
                x2 = (nboxMap['right'] as num?)?.toDouble() ?? 0.0;
                y2 = (nboxMap['bottom'] as num?)?.toDouble() ?? 0.0;

                x1 = x1 * origWidth;
                y1 = y1 * origHeight;
                x2 = x2 * origWidth;
                y2 = y2 * origHeight;
                addLog(
                    '     Using normalizedBox (left,top,right,bottom, converted): [$x1, $y1, $x2, $y2]');
              } else if (nboxMap.containsKey('x') &&
                  nboxMap.containsKey('y') &&
                  nboxMap.containsKey('width') &&
                  nboxMap.containsKey('height')) {
                final x = (nboxMap['x'] as num?)?.toDouble() ?? 0.0;
                final y = (nboxMap['y'] as num?)?.toDouble() ?? 0.0;
                final width = (nboxMap['width'] as num?)?.toDouble() ?? 0.0;
                final height = (nboxMap['height'] as num?)?.toDouble() ?? 0.0;

                double centerX = x * origWidth;
                double centerY = y * origHeight;
                double bboxWidth = width * origWidth;
                double bboxHeight = height * origHeight;

                x1 = centerX - bboxWidth / 2;
                y1 = centerY - bboxHeight / 2;
                x2 = centerX + bboxWidth / 2;
                y2 = centerY + bboxHeight / 2;
                addLog(
                    '     Using normalizedBox (x,y,width,height, converted): [$x1, $y1, $x2, $y2]');
              }
            } else if (nbox is List && nbox.length >= 4) {
              x1 = ((nbox[0] as num?)?.toDouble() ?? 0.0) * origWidth;
              y1 = ((nbox[1] as num?)?.toDouble() ?? 0.0) * origHeight;
              x2 = ((nbox[2] as num?)?.toDouble() ?? 0.0) * origWidth;
              y2 = ((nbox[3] as num?)?.toDouble() ?? 0.0) * origHeight;
              addLog(
                  '     Using normalizedBox (list, converted): [$x1, $y1, $x2, $y2]');
            }
          }

          if (x1 == 0.0 && y1 == 0.0 && x2 == 0.0 && y2 == 0.0) {
            addLog(
                '     ⚠️  No boundingBox/normalizedBox found, trying direct keys...');
            if (boxMap.containsKey('x1') &&
                boxMap.containsKey('y1') &&
                boxMap.containsKey('x2') &&
                boxMap.containsKey('y2')) {
              x1 = (boxMap['x1'] as num?)?.toDouble() ?? 0.0;
              y1 = (boxMap['y1'] as num?)?.toDouble() ?? 0.0;
              x2 = (boxMap['x2'] as num?)?.toDouble() ?? 0.0;
              y2 = (boxMap['y2'] as num?)?.toDouble() ?? 0.0;
              addLog('     Using direct x1,y1,x2,y2: [$x1, $y1, $x2, $y2]');
            } else if (boxMap.containsKey('x') &&
                boxMap.containsKey('y') &&
                boxMap.containsKey('width') &&
                boxMap.containsKey('height')) {
              final x = (boxMap['x'] as num?)?.toDouble() ?? 0.0;
              final y = (boxMap['y'] as num?)?.toDouble() ?? 0.0;
              final width = (boxMap['width'] as num?)?.toDouble() ?? 0.0;
              final height = (boxMap['height'] as num?)?.toDouble() ?? 0.0;
              addLog(
                  '     Using direct x,y,width,height: x=$x, y=$y, w=$width, h=$height');

              if (x <= 1.0 && y <= 1.0 && width <= 1.0 && height <= 1.0) {
                double centerX = x * origWidth;
                double centerY = y * origHeight;
                double bboxWidth = width * origWidth;
                double bboxHeight = height * origHeight;
                x1 = centerX - bboxWidth / 2;
                y1 = centerY - bboxHeight / 2;
                x2 = centerX + bboxWidth / 2;
                y2 = centerY + bboxHeight / 2;
              } else {
                x1 = x;
                y1 = y;
                x2 = x + width;
                y2 = y + height;
              }
              addLog('     Calculated from direct keys: [$x1, $y1, $x2, $y2]');
            }
          }

          addLog('     Calculated box: [$x1, $y1, $x2, $y2]');

          // Clamp to image bounds
          x1 = x1.clamp(0.0, origWidth.toDouble());
          y1 = y1.clamp(0.0, origHeight.toDouble());
          x2 = x2.clamp(0.0, origWidth.toDouble());
          y2 = y2.clamp(0.0, origHeight.toDouble());

          addLog('     Clamped box: [$x1, $y1, $x2, $y2]');

          if (x2 <= x1 || y2 <= y1) {
            addLog(
                '     ⚠️  Skipped: invalid box dimensions (x2=$x2 <= x1=$x1 or y2=$y2 <= y1=$y1)');
            continue;
          }

          String classLabel = className;
          final classIdValue = classId ?? 0;

          if ((classLabel == 'Unknown' || classLabel.isEmpty) &&
              _labels.isNotEmpty &&
              classIdValue >= 0 &&
              classIdValue < _labels.length) {
            classLabel = _labels[classIdValue];
            addLog(
                '     Detection missing class name, mapped classId $classIdValue to label: $classLabel');
          }

          boxes.add(BoundingBox(
            x1: x1,
            y1: y1,
            x2: x2,
            y2: y2,
            className: classLabel,
            confidence: confidence,
            classId: classIdValue,
          ));

          addLog(
              '   Detection: $classLabel (${(confidence * 100).toStringAsFixed(1)}%)');
          addLog(
              '     Box: [${x1.toStringAsFixed(0)}, ${y1.toStringAsFixed(0)}, ${x2.toStringAsFixed(0)}, ${y2.toStringAsFixed(0)}]');
        } catch (e) {
          addLog('   ⚠️  Error processing detection: $e');
          continue;
        }
      }

      addLog('✅ Processed ${boxes.length} valid detections');

      return DetectionResult(
        boxes: boxes,
        detectionSuccess: boxes.isNotEmpty,
        debugLogs: debugLogs,
      );
    } catch (e, stackTrace) {
      debugLogs.add('❌ Error during inference: $e');
      debugLogs.add('   Error type: ${e.runtimeType}');
      debugLogs.add('   Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> classifyImage(Uint8List imageBytes) async {
    final result = await detectAndClassify(imageBytes);
    if (result.boxes.isEmpty) {
      return {'result': 'NO_DETECTION', 'confidence': 0.0};
    }
    final firstBox = result.boxes[0];
    return {
      'result': firstBox.className,
      'confidence': firstBox.confidence * 100
    };
  }

  @override
  void dispose() {
    _yolo?.dispose();
    _yolo = null;
  }
}
