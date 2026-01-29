import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/model_manager.dart';
import '../services/model_service_impl.dart';
import '../services/image_preprocessor.dart';
import '../models/detection_result.dart';
import 'dart:math' as math;

class WheelDetectionScreen extends StatefulWidget {
  const WheelDetectionScreen({super.key});

  @override
  State<WheelDetectionScreen> createState() => _WheelDetectionScreenState();
}

class _WheelDetectionScreenState extends State<WheelDetectionScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isAnalyzing = false;
  Uint8List? _capturedImageBytes;
  DetectionResult? _detectionResult;
  String _resultMessage = '';
  Color _resultColor = Colors.grey;
  List<String> _debugLogs = [];
  bool _showDebug = false;
  Uint8List? _preprocessedImageBytes; // For showing preprocessed view

  final ModelManager _modelManager = ModelManager();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Load model first
      await _modelManager.loadModel();
      print('✓ Model loaded successfully');

      // Initialize camera
      await _initializeCamera();
    } catch (e) {
      print('❌ Error initializing app: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing: $e')),
        );
      }
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No cameras available');
      }

      // Use back camera
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print('❌ Error initializing camera: $e');
      rethrow;
    }
  }

  Future<void> _captureAndAnalyze() async {
    if (_isAnalyzing || _cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _capturedImageBytes = null;
      _detectionResult = null;
      _resultMessage = 'Analyzing...';
      _resultColor = Colors.orange;
      _debugLogs = [];
    });

    try {
      // Capture image
      final XFile imageFile = await _cameraController!.takePicture();
      final imageBytes = await imageFile.readAsBytes();

      setState(() {
        _capturedImageBytes = imageBytes;
      });

      // Generate preprocessed preview for EfficientNet mode
      if (_modelManager.currentType == ModelType.efficientnet) {
        try {
          final preprocessor = ImagePreprocessor();
          _preprocessedImageBytes = preprocessor.preprocessForDisplay(imageBytes);
        } catch (e) {
          print('Preview generation failed: $e');
        }
      }

      // Run detection
      if (_modelManager.modelService != null) {
        final result = await _modelManager.modelService!.detectAndClassify(imageBytes);

        setState(() {
          _detectionResult = result;
          _debugLogs = result.debugLogs;
          _analyzeWheelCombination(result);
        });
      } else {
        throw Exception('Model not loaded');
      }
    } catch (e) {
      print('❌ Error during capture/analysis: $e');
      setState(() {
        _resultMessage = 'Error: $e';
        _resultColor = Colors.red;
      });
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  void _analyzeWheelCombination(DetectionResult result) {
    if (result.boxes.isEmpty) {
      _resultMessage = 'No wheel parts detected';
      _resultColor = Colors.orange;
      return;
    }

    // Check if this is an EfficientNet classification (classId >= 10)
    final firstBox = result.boxes.first;
    if (firstBox.classId >= 10) {
      // EfficientNet direct classification
      final className = firstBox.className;
      final confidence = (firstBox.confidence * 100).toStringAsFixed(1);

      if (className.contains('OK') && !className.contains('NOT')) {
        _resultMessage = '✓ $className\n($confidence% confidence)';
        _resultColor = Colors.green;
      } else {
        _resultMessage = '✗ $className\n($confidence% confidence)';
        _resultColor = Colors.red;
      }
      print('EfficientNet result: $className ($confidence%)');
      return;
    }

    // YOLO detection mode - group detections by classId
    Set<int> detectedClasses = result.boxes.map((box) => box.classId).toSet();

    print('Detected classes: $detectedClasses');

    // Class mapping:
    // 0 = rim_black
    // 1 = cap_black
    // 2 = rim_grey
    // 3 = cap_grey

    // Check combinations
    if (detectedClasses.contains(0) && detectedClasses.contains(1)) {
      _resultMessage = '✓ AX7 OK';
      _resultColor = Colors.green;
    } else if (detectedClasses.contains(0) && detectedClasses.contains(2)) {
      _resultMessage = '✗ AX7 NOT OK';
      _resultColor = Colors.red;
    } else if (detectedClasses.contains(2) && detectedClasses.contains(3)) {
      _resultMessage = '✓ AX7L OK';
      _resultColor = Colors.green;
    } else if (detectedClasses.contains(2) && detectedClasses.contains(1)) {
      _resultMessage = '✗ AX7L NOT OK';
      _resultColor = Colors.red;
    } else {
      _resultMessage = 'Incomplete detection\nDetected: ${result.boxes.map((b) => b.className).join(", ")}';
      _resultColor = Colors.orange;
    }

    print('Result: $_resultMessage');
  }

  void _retake() {
    setState(() {
      _capturedImageBytes = null;
      _preprocessedImageBytes = null;
      _detectionResult = null;
      _resultMessage = '';
      _resultColor = Colors.grey;
      _debugLogs = [];
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wheel Inspector'),
        backgroundColor: Colors.blue,
        actions: [
          // Model switch toggle
          TextButton.icon(
            icon: Icon(
              _modelManager.currentType == ModelType.efficientnet
                  ? Icons.psychology
                  : Icons.center_focus_strong,
              color: Colors.white,
            ),
            label: Text(
              _modelManager.currentType == ModelType.efficientnet ? 'EN' : 'YOLO',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              final newType = _modelManager.currentType == ModelType.efficientnet
                  ? ModelType.yolo
                  : ModelType.efficientnet;
              _retake();
              setState(() {});
              try {
                await _modelManager.loadModel(type: newType);
                setState(() {});
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to load ${newType.name} model: $e')),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: Icon(_showDebug ? Icons.bug_report : Icons.bug_report_outlined),
            onPressed: () {
              setState(() {
                _showDebug = !_showDebug;
              });
            },
            tooltip: 'Toggle Debug',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Camera/Image display area
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: Center(
                    child: _buildCameraOrImageView(),
                  ),
                ),
              ),

              // Result display
              if (_resultMessage.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: _resultColor.withOpacity(0.2),
                  child: Column(
                    children: [
                      Text(
                        _resultMessage,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _resultColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_detectionResult != null) ...[
                        const SizedBox(height: 10),
                        if (_modelManager.currentType == ModelType.efficientnet) ...[
                          Text(
                            'Model: EfficientNet-B0 (classifier)',
                            style: TextStyle(fontSize: 12, color: Colors.black45),
                          ),
                          if (_preprocessedImageBytes != null) ...[
                            const SizedBox(height: 8),
                            const Text('Preprocessed input:', style: TextStyle(fontSize: 11, color: Colors.black45)),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(_preprocessedImageBytes!, width: 112, height: 112),
                            ),
                          ],
                        ] else ...[
                          Text(
                            'Detected: ${_detectionResult!.boxes.length} objects',
                            style: const TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            children: _detectionResult!.boxes.map((box) {
                              return Chip(
                                label: Text(
                                  '${box.className} (${(box.confidence * 100).toStringAsFixed(0)}%)',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: Colors.blue.shade100,
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),

              // Control buttons
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_capturedImageBytes != null) ...[
                      // Retake button
                      ElevatedButton.icon(
                        onPressed: _isAnalyzing ? null : _retake,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retake'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          backgroundColor: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                    // Capture/Analyzing button
                    ElevatedButton.icon(
                      onPressed: (_isAnalyzing || _capturedImageBytes != null) ? null : _captureAndAnalyze,
                      icon: Icon(_isAnalyzing ? Icons.hourglass_empty : Icons.camera),
                      label: Text(_isAnalyzing ? 'Analyzing...' : 'Capture'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor: Colors.blue,
                        disabledBackgroundColor: Colors.blue.shade200,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Debug panel overlay
          if (_showDebug && _debugLogs.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 300,
                color: Colors.black.withOpacity(0.9),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.blue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Debug Logs',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _showDebug = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _debugLogs.length,
                        itemBuilder: (context, index) {
                          final log = _debugLogs[index];
                          Color logColor = Colors.white;
                          if (log.contains('✓')) logColor = Colors.green;
                          if (log.contains('❌') || log.contains('⚠️')) logColor = Colors.orange;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            child: Text(
                              log,
                              style: TextStyle(
                                color: logColor,
                                fontSize: 10,
                                fontFamily: 'monospace',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCameraOrImageView() {
    if (_capturedImageBytes != null) {
      // Show captured image with bounding boxes
      return _buildImageWithBoxes();
    } else if (_isCameraInitialized && _cameraController != null) {
      // Show live camera preview
      return Stack(
        children: [
          CameraPreview(_cameraController!),
          // Scanner overlay frame
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  // Corner brackets
                  ..._buildCornerBrackets(),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      // Loading state
      return const CircularProgressIndicator(color: Colors.white);
    }
  }

  List<Widget> _buildCornerBrackets() {
    const double bracketSize = 30;
    const double bracketWidth = 3;

    return [
      // Top-left
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: bracketSize,
          height: bracketSize,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.red, width: bracketWidth),
              left: BorderSide(color: Colors.red, width: bracketWidth),
            ),
          ),
        ),
      ),
      // Top-right
      Positioned(
        top: 0,
        right: 0,
        child: Container(
          width: bracketSize,
          height: bracketSize,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.red, width: bracketWidth),
              right: BorderSide(color: Colors.red, width: bracketWidth),
            ),
          ),
        ),
      ),
      // Bottom-left
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          width: bracketSize,
          height: bracketSize,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.red, width: bracketWidth),
              left: BorderSide(color: Colors.red, width: bracketWidth),
            ),
          ),
        ),
      ),
      // Bottom-right
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: bracketSize,
          height: bracketSize,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.red, width: bracketWidth),
              right: BorderSide(color: Colors.red, width: bracketWidth),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildImageWithBoxes() {
    if (_capturedImageBytes == null || _detectionResult == null) {
      return Image.memory(_capturedImageBytes!, fit: BoxFit.contain);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Image.memory(
              _capturedImageBytes!,
              fit: BoxFit.contain,
            ),
            // Draw bounding boxes
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: BoundingBoxPainter(
                boxes: _detectionResult!.boxes,
                imageBytes: _capturedImageBytes!,
              ),
            ),
          ],
        );
      },
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final List<BoundingBox> boxes;
  final Uint8List imageBytes;

  BoundingBoxPainter({required this.boxes, required this.imageBytes});

  @override
  void paint(Canvas canvas, Size size) {
    // Decode image to get original dimensions
    final image = _decodeImageSync(imageBytes);
    if (image == null) return;

    final imageWidth = image.width.toDouble();
    final imageHeight = image.height.toDouble();

    // Calculate scale to fit in display
    final scaleX = size.width / imageWidth;
    final scaleY = size.height / imageHeight;
    final scale = math.min(scaleX, scaleY);

    final scaledWidth = imageWidth * scale;
    final scaledHeight = imageHeight * scale;

    // Calculate offset to center image
    final offsetX = (size.width - scaledWidth) / 2;
    final offsetY = (size.height - scaledHeight) / 2;

    // Draw each bounding box
    for (final box in boxes) {
      final x1 = box.x1 * scale + offsetX;
      final y1 = box.y1 * scale + offsetY;
      final x2 = box.x2 * scale + offsetX;
      final y2 = box.y2 * scale + offsetY;

      // Color based on class
      Color boxColor = Colors.green;
      if (box.className.contains('grey')) {
        boxColor = Colors.blue;
      }

      final paint = Paint()
        ..color = boxColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      canvas.drawRect(
        Rect.fromLTRB(x1, y1, x2, y2),
        paint,
      );

      // Draw label background
      final textSpan = TextSpan(
        text: '${box.className} ${(box.confidence * 100).toStringAsFixed(0)}%',
        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final labelRect = Rect.fromLTWH(
        x1,
        y1 - textPainter.height - 4,
        textPainter.width + 8,
        textPainter.height + 4,
      );

      canvas.drawRect(
        labelRect,
        Paint()..color = boxColor.withOpacity(0.8),
      );

      textPainter.paint(canvas, Offset(x1 + 4, y1 - textPainter.height - 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  // Synchronous image decoder helper
  ({int width, int height})? _decodeImageSync(Uint8List bytes) {
    // Simple PNG/JPEG header parsing to extract dimensions
    try {
      if (bytes.length > 24 && bytes[0] == 0xFF && bytes[1] == 0xD8) {
        // JPEG
        int pos = 2;
        while (pos < bytes.length - 8) {
          if (bytes[pos] == 0xFF) {
            if (bytes[pos + 1] == 0xC0 || bytes[pos + 1] == 0xC2) {
              final height = (bytes[pos + 5] << 8) | bytes[pos + 6];
              final width = (bytes[pos + 7] << 8) | bytes[pos + 8];
              return (width: width, height: height);
            }
            pos += 2 + ((bytes[pos + 2] << 8) | bytes[pos + 3]);
          } else {
            pos++;
          }
        }
      } else if (bytes.length > 24 && bytes[0] == 0x89 && bytes[1] == 0x50) {
        // PNG
        final width = (bytes[16] << 24) | (bytes[17] << 16) | (bytes[18] << 8) | bytes[19];
        final height = (bytes[20] << 24) | (bytes[21] << 16) | (bytes[22] << 8) | bytes[23];
        return (width: width, height: height);
      }
    } catch (e) {
      print('Error decoding image dimensions: $e');
    }
    return null;
  }
}
