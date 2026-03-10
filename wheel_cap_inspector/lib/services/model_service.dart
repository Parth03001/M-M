import 'dart:typed_data';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import '../models/inspection_result.dart';

class ModelService {
  static final ModelService _instance = ModelService._internal();
  factory ModelService() => _instance;
  ModelService._internal();

  Interpreter? _interpreter;
  List<String>? _labels;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  static const int _inputSize = 640; 

  Future<void> loadModel() async {
    if (_isLoaded) return;
    try {
      final interpreterOptions = InterpreterOptions();
      _interpreter = await Interpreter.fromAsset(
        'assets/models/wheel_cap_rim.tflite',
        options: interpreterOptions,
      );
      final labelFile = await rootBundle.loadString('assets/labels.txt');
      _labels = labelFile.split('\n').where((l) => l.trim().isNotEmpty).toList();
      _isLoaded = true;
    } catch (e) {
      rethrow;
    }
  }

  Future<InspectionResult> analyze(Uint8List imageBytes, String position) async {
    if (!_isLoaded || _interpreter == null) throw Exception('Model not loaded');

    // Determine current position context
    final bool isFrontPosition = position.startsWith('F');
    final String positionLabel = position == 'FR' ? 'Front Right' : 
                                 position == 'FL' ? 'Front Left' :
                                 position == 'RR' ? 'Rear Right' : 'Rear Left';

    try {
      final originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) throw Exception('Failed to decode image');

      final resizedImage = img.copyResize(originalImage, width: _inputSize, height: _inputSize);

      final input = Float32List(1 * _inputSize * _inputSize * 3);
      var pixelIndex = 0;
      for (var y = 0; y < _inputSize; y++) {
        for (var x = 0; x < _inputSize; x++) {
          final pixel = resizedImage.getPixel(x, y);
          input[pixelIndex++] = pixel.r / 255.0;
          input[pixelIndex++] = pixel.g / 255.0;
          input[pixelIndex++] = pixel.b / 255.0;
        }
      }
      final inputBuffer = input.reshape([1, _inputSize, _inputSize, 3]);

      final outputTensor = _interpreter!.getOutputTensors().first;
      final outputShape = outputTensor.shape; 
      
      var outputBuffer = List.generate(
        outputShape[0],
        (_) => List.generate(
          outputShape[1],
          (_) => List.filled(outputShape[2], 0.0),
        ),
      ).reshape(outputShape);

      _interpreter!.run(inputBuffer, outputBuffer);

      final List<InspectionBox> boxes = [];
      final List<String> detectedClasses = [];
      double maxConfidence = 0.0;
      
      final bool isTransposed = outputShape[1] < outputShape[2];
      final int numElements = isTransposed ? outputShape[2] : outputShape[1];
      final int numFeatures = isTransposed ? outputShape[1] : outputShape[2];
      final int numClasses = numFeatures - 4;

      for (var i = 0; i < numElements; i++) {
        double confidence = 0.0;
        int classId = -1;

        if (isTransposed) {
          for (var c = 0; c < numClasses; c++) {
            final score = outputBuffer[0][4 + c][i];
            if (score > confidence) {
              confidence = score;
              classId = c;
            }
          }
        } else {
          for (var c = 0; c < numClasses; c++) {
            final score = outputBuffer[0][i][4 + c];
            if (score > confidence) {
              confidence = score;
              classId = c;
            }
          }
        }

        if (confidence > 0.40) {
          double x, y, w, h;
          if (isTransposed) {
            x = outputBuffer[0][0][i];
            y = outputBuffer[0][1][i];
            w = outputBuffer[0][2][i];
            h = outputBuffer[0][3][i];
          } else {
            x = outputBuffer[0][i][0];
            y = outputBuffer[0][i][1];
            w = outputBuffer[0][i][2];
            h = outputBuffer[0][i][3];
          }

          final x1 = (x - w / 2) / _inputSize;
          final y1 = (y - h / 2) / _inputSize;
          final x2 = (x + w / 2) / _inputSize;
          final y2 = (y + h / 2) / _inputSize;

          final className = _labels![classId].trim();
          boxes.add(InspectionBox(
            x1: x1, y1: y1, x2: x2, y2: y2,
            className: className,
            confidence: confidence,
          ));

          if (!detectedClasses.contains(className)) detectedClasses.add(className);
          if (confidence > maxConfidence) maxConfidence = confidence;
        }
      }

      final List<InspectionBox> filteredBoxes = _applyNMS(boxes);

      final hasFrontRim = detectedClasses.contains('FrontRim');
      final hasRearRim = detectedClasses.contains('RearRim');
      final hasFrontCap = detectedClasses.contains('FrontCap');
      final hasRearCap = detectedClasses.contains('RearCap');

      String label = 'NOT OK';
      bool logicResult = false;

      if (isFrontPosition) {
        // Inspection at Front wheel
        if (hasFrontRim || hasRearRim) {
          // Rule: Front Rim can have either cap
          logicResult = hasFrontCap || hasRearCap;
          label = logicResult ? '$positionLabel OK' : '$positionLabel - Missing Cap';
        } else {
          label = '$positionLabel - Rim Not Detected';
        }
      } else {
        // Inspection at Rear wheel
        if (hasRearRim || hasFrontRim) {
          // Rule: Rear Rim MUST have Rear Cap
          logicResult = hasRearCap && !hasFrontCap;
          if (logicResult) {
            label = '$positionLabel OK';
          } else if (hasFrontCap) {
            label = '$positionLabel - Wrong Cap (Front Cap Detected)';
          } else {
            label = '$positionLabel - Missing Cap';
          }
        } else {
          label = '$positionLabel - Rim Not Detected';
        }
      }

      return InspectionResult(
        label: label,
        confidence: maxConfidence,
        isOk: logicResult,
        detectedClasses: detectedClasses,
        boxes: filteredBoxes,
      );
    } catch (e) {
      return InspectionResult(label: 'Error: $e', confidence: 0.0, isOk: false);
    }
  }

  List<InspectionBox> _applyNMS(List<InspectionBox> boxes) {
    if (boxes.isEmpty) return [];
    boxes.sort((a, b) => b.confidence.compareTo(a.confidence));
    final List<InspectionBox> selected = [];
    final List<bool> active = List.filled(boxes.length, true);
    for (var i = 0; i < boxes.length; i++) {
      if (!active[i]) continue;
      selected.add(boxes[i]);
      for (var j = i + 1; j < boxes.length; j++) {
        if (!active[j]) continue;
        final iou = _calculateIoU(boxes[i], boxes[j]);
        if (iou > 0.45) active[j] = false;
      }
    }
    return selected;
  }

  double _calculateIoU(InspectionBox box1, InspectionBox box2) {
    final x1 = max(box1.x1, box2.x1);
    final y1 = max(box1.y1, box2.y1);
    final x2 = min(box1.x2, box2.x2);
    final y2 = min(box1.y2, box2.y2);
    final intersectionArea = max(0.0, x2 - x1) * max(0.0, y2 - y1);
    final box1Area = (box1.x2 - box1.x1) * (box1.y2 - box1.y1);
    final box2Area = (box2.x2 - box2.x1) * (box2.y2 - box2.y1);
    return intersectionArea / (box1Area + box2Area - intersectionArea);
  }
}
