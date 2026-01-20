import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/model_manager.dart';
import '../models/detection_result.dart';
import 'package:image/image.dart' as img;

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
  double? _imageDisplayWidth;
  double? _imageDisplayHeight;
  img.Image? _decodedImage;

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
      _resultMessage = '';
      _resultColor = Colors.grey;
      _debugLogs = [];
      _imageDisplayWidth = null;
      _imageDisplayHeight = null;
      _decodedImage = null;
    });

    try {
      // Capture image
      final XFile imageFile = await _cameraController!.takePicture();
      final imageBytes = await imageFile.readAsBytes();

      // Decode image for dimensions
      _decodedImage = img.decodeImage(imageBytes);

      setState(() {
        _capturedImageBytes = imageBytes;
      });

      // Run detection
      if (_modelManager.modelService != null) {
        final result = await _modelManager.modelService!.detectAndClassify(imageBytes);

        setState(() {
          _detectionResult = result;
          _debugLogs = result.debugLogs;
        });

        // Validate detection count
        if (result.boxes.length != 2) {
          // Show popup for invalid detection count
          _showInvalidDetectionDialog(result.boxes.length);
        } else {
          _analyzeWheelCombination(result);
        }
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

  void _showInvalidDetectionDialog(int detectedCount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 12),
              Text('Image Not Clicked Properly'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expected: 2 objects (1 rim + 1 cap)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Detected: $detectedCount ${detectedCount == 1 ? 'object' : 'objects'}',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Please retake the image ensuring both the wheel rim and cap are clearly visible.',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _retake();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Retake Image'),
            ),
          ],
        );
      },
    );
  }

  void _analyzeWheelCombination(DetectionResult result) {
    if (result.boxes.isEmpty) {
      _resultMessage = 'No wheel parts detected';
      _resultColor = Colors.orange;
      return;
    }

    // Group detections by className (not classId, since model class order may vary)
    Set<String> detectedClasses = result.boxes.map((box) => box.className).toSet();

    print('Detected class names: $detectedClasses');
    print('Detected class IDs: ${result.boxes.map((box) => box.classId).toSet()}');

    // Check combinations based on class names
    bool hasRimBlack = detectedClasses.contains('rim_black');
    bool hasRimGrey = detectedClasses.contains('rim_grey');
    bool hasCapBlack = detectedClasses.contains('cap_black');
    bool hasCapGrey = detectedClasses.contains('cap_grey');

    if (hasRimBlack && hasCapBlack) {
      // rim_black + cap_black = AX7 OK
      _resultMessage = 'AX7 OK';
      _resultColor = Colors.green;
    } else if (hasRimBlack && hasCapGrey) {
      // rim_black + cap_grey = AX7 NOT OK
      _resultMessage = 'AX7 NOT OK';
      _resultColor = Colors.red;
    } else if (hasRimGrey && hasCapGrey) {
      // rim_grey + cap_grey = AX7L OK
      _resultMessage = 'AX7L OK';
      _resultColor = Colors.green;
    } else if (hasRimGrey && hasCapBlack) {
      // rim_grey + cap_black = AX7L NOT OK
      _resultMessage = 'AX7L NOT OK';
      _resultColor = Colors.red;
    } else {
      // Incomplete detection or unexpected combination
      _resultMessage = 'Incomplete detection\nDetected: ${detectedClasses.join(", ")}';
      _resultColor = Colors.orange;
    }

    print('Result: $_resultMessage');
  }

  void _retake() {
    setState(() {
      _capturedImageBytes = null;
      _detectionResult = null;
      _resultMessage = '';
      _resultColor = Colors.grey;
      _debugLogs = [];
      _imageDisplayWidth = null;
      _imageDisplayHeight = null;
      _decodedImage = null;
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade300,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'Wheel Inspector',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _showDebug ? Icons.bug_report : Icons.bug_report_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _showDebug = !_showDebug;
                        });
                      },
                      tooltip: 'Toggle Debug',
                    ),
                  ],
                ),
              ),

              // Main Content Area
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.blue.shade50,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Camera Preview or Captured Image
                      Positioned.fill(
                        child: _capturedImageBytes == null
                            ? _isCameraInitialized && _cameraController != null
                                ? CameraPreview(_cameraController!)
                                : Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.blue.shade800,
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Initializing camera...',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                            : _buildImageWithBoxes(),
                      ),
                      // Scanner overlay frame (only show on camera preview)
                      if (_capturedImageBytes == null && _isCameraInitialized)
                        Center(
                          child: Container(
                            width: 280,
                            height: 280,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue.shade600,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              children: _buildCornerBrackets(),
                            ),
                          ),
                        ),
                      // Loading overlay
                      if (_isAnalyzing)
                        Container(
                          color: Colors.black.withOpacity(0.7),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue.shade800,
                                    ),
                                    strokeWidth: 4,
                                  ),
                                  SizedBox(height: 24),
                                  Text(
                                    'Analyzing...',
                                    style: TextStyle(
                                      color: Colors.blue.shade800,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Please wait while we process your image',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Result display
              if (_resultMessage.isNotEmpty && !_isAnalyzing)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _resultColor.withOpacity(0.2),
                    border: Border(
                      top: BorderSide(color: _resultColor, width: 3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _resultMessage,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _resultColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_detectionResult != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Detected: ${_detectionResult!.boxes.length} objects',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          children: _detectionResult!.boxes.map((box) {
                            // Determine color based on class type
                            Color chipColor = box.className.contains('rim')
                                ? Colors.blue.shade100
                                : Colors.green.shade100;

                            return Chip(
                              label: Text(
                                '${box.className} (${(box.confidence * 100).toStringAsFixed(0)}%)',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: chipColor,
                              side: BorderSide.none,
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),

              // Control buttons
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
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
                          backgroundColor: Colors.grey.shade600,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                    // Capture button
                    ElevatedButton.icon(
                      onPressed: (_isAnalyzing || _capturedImageBytes != null) ? null : _captureAndAnalyze,
                      icon: Icon(_isAnalyzing ? Icons.hourglass_empty : Icons.camera_alt),
                      label: Text(_isAnalyzing ? 'Analyzing...' : 'Capture'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.blue.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ],
                ),
              ),

              // Debug panel overlay
              if (_showDebug && _debugLogs.isNotEmpty)
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9),
                    border: Border(
                      top: BorderSide(color: Colors.blue.shade700, width: 3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.blue.shade800,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Debug Logs',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
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
                            if (log.contains('❌') || log.contains('⚠️')) {
                              logColor = Colors.orange;
                            }

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
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCornerBrackets() {
    const double bracketSize = 30;
    const double bracketWidth = 3;
    final color = Colors.blue.shade600;

    return [
      // Top-left
      Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: bracketSize,
          height: bracketSize,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: color, width: bracketWidth),
              left: BorderSide(color: color, width: bracketWidth),
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
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: color, width: bracketWidth),
              right: BorderSide(color: color, width: bracketWidth),
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
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: bracketWidth),
              left: BorderSide(color: color, width: bracketWidth),
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
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: bracketWidth),
              right: BorderSide(color: color, width: bracketWidth),
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildImageWithBoxes() {
    if (_capturedImageBytes == null) {
      return Image.memory(_capturedImageBytes!, fit: BoxFit.contain);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate display size maintaining aspect ratio (same as classifier_app)
        if (_decodedImage != null) {
          final imageWidth = _decodedImage!.width.toDouble();
          final imageHeight = _decodedImage!.height.toDouble();
          final maxWidth = constraints.maxWidth * 0.9;
          final maxHeight = constraints.maxHeight * 0.7;

          final scale = (maxWidth / imageWidth < maxHeight / imageHeight)
              ? maxWidth / imageWidth
              : maxHeight / imageHeight;

          if (_imageDisplayWidth == null || _imageDisplayHeight == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _imageDisplayWidth = imageWidth * scale;
                _imageDisplayHeight = imageHeight * scale;
              });
            });
          }
        }

        return Center(
          child: Stack(
            children: [
              // Display image (same structure as classifier_app)
              if (_imageDisplayWidth != null && _imageDisplayHeight != null)
                Container(
                  width: _imageDisplayWidth,
                  height: _imageDisplayHeight,
                  child: Image.memory(
                    _capturedImageBytes!,
                    fit: BoxFit.contain,
                  ),
                ),
              // Bounding boxes overlay
              if (_detectionResult != null &&
                  _imageDisplayWidth != null &&
                  _imageDisplayHeight != null &&
                  _decodedImage != null)
                ..._buildBoundingBoxes(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildBoundingBoxes() {
    if (_detectionResult == null ||
        _imageDisplayWidth == null ||
        _imageDisplayHeight == null ||
        _decodedImage == null ||
        _capturedImageBytes == null) {
      return [];
    }

    // Calculate scale - account for BoxFit.contain (SAME AS CLASSIFIER_APP)
    final imageAspectRatio = _decodedImage!.width / _decodedImage!.height;
    final containerAspectRatio = _imageDisplayWidth! / _imageDisplayHeight!;

    double scaleX, scaleY, offsetX, offsetY;

    if (imageAspectRatio > containerAspectRatio) {
      // Image is wider - fit to width
      scaleX = _imageDisplayWidth! / _decodedImage!.width;
      scaleY = scaleX;
      offsetX = 0;
      offsetY = (_imageDisplayHeight! - (_decodedImage!.height * scaleY)) / 2;
    } else {
      // Image is taller - fit to height
      scaleY = _imageDisplayHeight! / _decodedImage!.height;
      scaleX = scaleY;
      offsetX = (_imageDisplayWidth! - (_decodedImage!.width * scaleX)) / 2;
      offsetY = 0;
    }

    return _detectionResult!.boxes.map((box) {
      // Determine color based on class type
      Color color;
      if (box.className.contains('rim')) {
        color = Colors.blue; // Rim = Blue
      } else if (box.className.contains('cap')) {
        color = Colors.green; // Cap = Green
      } else {
        color = Colors.orange; // Unknown
      }

      // Scale and offset bounding box coordinates (SAME AS CLASSIFIER_APP)
      final x1 = (box.x1 * scaleX) + offsetX;
      final y1 = (box.y1 * scaleY) + offsetY;
      final x2 = (box.x2 * scaleX) + offsetX;
      final y2 = (box.y2 * scaleY) + offsetY;

      final width = x2 - x1;
      final height = y2 - y1;

      return Positioned(
        left: x1,
        top: y1,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(
              color: color,
              width: 4.5, // Thicker border
            ),
            color: color.withOpacity(0.05), // More transparent fill
          ),
        ),
      );
    }).toList();
  }

}
