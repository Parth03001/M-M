import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../services/model_manager.dart';
import '../services/detection_result.dart';
import '../services/database_service.dart';

class CaptureScreen extends StatefulWidget {
  final String connectorName;

  const CaptureScreen({
    Key? key,
    required this.connectorName,
  }) : super(key: key);

  @override
  _CaptureScreenState createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  File? _capturedImage;
  Uint8List? _imageBytes;
  DetectionResult? _detectionResult;
  BoundingBox? _selectedBox;
  bool _isAnalyzing = false;
  img.Image? _decodedImage;
  double? _imageDisplayWidth;
  double? _imageDisplayHeight;
  List<String> _debugLogs = [];
  bool _showDebugPanel = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        // Use back camera by default
        final backCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => _cameras!.first,
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
      }
    } catch (e) {
      print('Error initializing camera: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error initializing camera: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Camera not ready. Please wait...'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // Show loading immediately
      setState(() {
        _isAnalyzing = true;
        _detectionResult = null;
        _selectedBox = null;
      });

      // Take picture from camera controller
      final XFile image = await _cameraController!.takePicture();

      // Read image bytes
      final bytes = await image.readAsBytes();

      setState(() {
        _imageBytes = bytes;
        _imageDisplayWidth = null;
        _imageDisplayHeight = null;
        if (!kIsWeb) {
          _capturedImage = File(image.path);
        }
      });

      // Decode image for size info
      _decodedImage = img.decodeImage(bytes);

      // Analyze the image (loading state already set)
      await _analyzeImage(bytes);
    } catch (e) {
      // On error, make sure loading is turned off
      setState(() {
        _isAnalyzing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error capturing image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _analyzeImage(Uint8List imageBytes) async {
    final modelService = ModelManager().modelService;
    if (modelService == null || !modelService.isLoaded) {
      setState(() {
        _isAnalyzing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Model not loaded. Please log in again.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Loading state already set in _captureImage, but ensure it's set here too
    if (!_isAnalyzing) {
      setState(() {
        _isAnalyzing = true;
      });
    }

    try {
      _debugLogs.clear(); // Clear previous logs
      _debugLogs.add('🔍 Starting analysis...');
      _debugLogs.add('📸 Image size: ${imageBytes.length} bytes');

      // Decode image to get dimensions
      final decodedImg = img.decodeImage(imageBytes);
      if (decodedImg != null) {
        _debugLogs.add(
            '📐 Image dimensions: ${decodedImg.width}x${decodedImg.height}');
      }

      _debugLogs.add('🤖 Calling model service...');
      _debugLogs.add('   Model loaded: ${modelService.isLoaded}');

      // Wrap in additional try-catch to capture full error details
      DetectionResult result;
      try {
        result = await modelService.detectAndClassify(imageBytes);
      } catch (modelError, stackTrace) {
        _debugLogs.add('❌ Model service error: $modelError');
        _debugLogs.add('   Error type: ${modelError.runtimeType}');
        _debugLogs.add('   Stack trace: $stackTrace');

        // Re-throw to be caught by outer catch
        rethrow;
      }

      setState(() {
        _detectionResult = result;
        // Select the box with highest confidence, or first box if available
        if (result.boxes.isNotEmpty) {
          // Sort by confidence (highest first) and select the top one
          final sortedBoxes = List<BoundingBox>.from(result.boxes)
            ..sort((a, b) => b.confidence.compareTo(a.confidence));
          _selectedBox = sortedBoxes.first;
        } else {
          _selectedBox = null;
        }

        // Add all debug logs from model service
        _debugLogs.addAll(result.debugLogs);

        // Add summary
        _debugLogs.add('━━━━━━━━━━━━━━━━━━━━');
        _debugLogs.add(
            '✅ Analysis complete: ${result.boxes.length} detection(s) found');
        if (result.boxes.isNotEmpty) {
          for (int i = 0; i < result.boxes.length; i++) {
            final box = result.boxes[i];
            _debugLogs.add(
                'Detection $i: ${box.className} (${(box.confidence * 100).toStringAsFixed(1)}%)');
            _debugLogs.add(
                '  Box: [${box.x1.toStringAsFixed(0)}, ${box.y1.toStringAsFixed(0)}, ${box.x2.toStringAsFixed(0)}, ${box.y2.toStringAsFixed(0)}]');
          }
        }

        // Keep only last 100 logs to show all details
        if (_debugLogs.length > 100) {
          _debugLogs.removeRange(0, _debugLogs.length - 100);
        }
      });
    } catch (e, stackTrace) {
      setState(() {
        _debugLogs.add('❌ CRITICAL ERROR: $e');
        _debugLogs.add('   Error type: ${e.runtimeType}');
        _debugLogs.add('   Full stack trace:');
        _debugLogs.add('   $stackTrace');
        _debugLogs.add('━━━━━━━━━━━━━━━━━━━━');
        _debugLogs.add('💡 Possible solutions:');
        _debugLogs.add(
            '   1. Check if model file exists: assets/best_float32.tflite');
        _debugLogs.add('   2. Verify model is compatible with tflite_flutter');
        _debugLogs.add('   3. Check Android logcat for native errors');
        _debugLogs.add('   4. Model may need re-conversion');

        // Keep all error logs
        if (_debugLogs.length > 150) {
          _debugLogs.removeRange(0, _debugLogs.length - 150);
        }
      });

      // Print to console for debugging
      print('❌ CAPTURE SCREEN ERROR: $e');
      print('Stack trace: $stackTrace');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error analyzing image: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  void _selectBox(BoundingBox box) {
    setState(() {
      _selectedBox = box;
    });
  }

  void _retakePhoto() {
    setState(() {
      _imageBytes = null;
      _capturedImage = null;
      _detectionResult = null;
      _selectedBox = null;
      _decodedImage = null;
      _imageDisplayWidth = null;
      _imageDisplayHeight = null;
      _isAnalyzing = false;
    });
  }

  Future<void> _saveResult() async {
    if (_imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please capture an image first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedBox == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a connector detection'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // Show loading
      setState(() {
        _isAnalyzing = true;
      });

      final dbService = DatabaseService();

      // Get active user session
      final activeSession = await dbService.database.getActiveSession();
      final userId = activeSession?.userId;

      // Get or create connector
      var connector = await dbService.getConnectorByName(widget.connectorName);
      if (connector == null) {
        connector = await dbService.createConnector(
          name: widget.connectorName,
        );
      }

      // Save image to file system (for mobile platforms)
      String imagePath = '';
      if (!kIsWeb && _capturedImage != null) {
        imagePath = _capturedImage!.path;
      } else {
        // Save image bytes to temporary file if not from file
        try {
          final directory = await getApplicationDocumentsDirectory();
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          final imageFile = File('${directory.path}/detection_$timestamp.jpg');
          await imageFile.writeAsBytes(_imageBytes!);
          imagePath = imageFile.path;
        } catch (e) {
          print('Error saving image file: $e');
          // Use a placeholder path if file save fails
          imagePath = 'memory_image_${DateTime.now().millisecondsSinceEpoch}';
        }
      }

      // Save detection to database
      await dbService.createDetection(
        connectorId: connector.id,
        imagePath: imagePath,
        imageBytes: _imageBytes, // Store image bytes in database
        className: _selectedBox!.className,
        confidence: _selectedBox!.confidence,
        x1: _selectedBox!.x1,
        y1: _selectedBox!.y1,
        x2: _selectedBox!.x2,
        y2: _selectedBox!.y2,
        classId: _selectedBox!.classId,
        userId: userId,
      );

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Result saved successfully: ${_selectedBox!.className}'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to connector list
        Navigator.pop(context, {
          'connector': widget.connectorName,
          'imageBytes': _imageBytes,
          'result': _selectedBox!.className,
          'confidence': _selectedBox!.confidence,
          'bbox': {
            'x1': _selectedBox!.x1,
            'y1': _selectedBox!.y1,
            'x2': _selectedBox!.x2,
            'y2': _selectedBox!.y2,
          },
          if (!kIsWeb && _capturedImage != null) 'image': _capturedImage,
        });
      }
    } catch (e) {
      print('Error saving detection: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving result: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });
      }
    }
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
              Colors.white,
              Color(0xFFFFF5F5), // Very light white with red tint
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
                  color: Color(0xFFDC143C), // Crimson red
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'CAPTURE®',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 48), // Balance the back button
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
                        Color(0xFFFFF5F5), // Very light white with red tint
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Camera Preview or Captured Image
                      Positioned.fill(
                        child: _imageBytes == null
                            ? _isCameraInitialized && _cameraController != null
                                ? CameraPreview(_cameraController!)
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Color(0xFFDC143C),
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
                            : LayoutBuilder(
                                builder: (context, constraints) {
                                  // Calculate display size maintaining aspect ratio
                                  if (_decodedImage != null) {
                                    final imageWidth =
                                        _decodedImage!.width.toDouble();
                                    final imageHeight =
                                        _decodedImage!.height.toDouble();
                                    final maxWidth = constraints.maxWidth * 0.9;
                                    final maxHeight =
                                        constraints.maxHeight * 0.7;

                                    final scale = (maxWidth / imageWidth <
                                            maxHeight / imageHeight)
                                        ? maxWidth / imageWidth
                                        : maxHeight / imageHeight;

                                    if (_imageDisplayWidth == null ||
                                        _imageDisplayHeight == null) {
                                      setState(() {
                                        _imageDisplayWidth = imageWidth * scale;
                                        _imageDisplayHeight =
                                            imageHeight * scale;
                                      });
                                    }
                                  }

                                  return Center(
                                    child: Stack(
                                      children: [
                                        // Display image
                                        if (_imageDisplayWidth != null &&
                                            _imageDisplayHeight != null)
                                          Container(
                                            width: _imageDisplayWidth,
                                            height: _imageDisplayHeight,
                                            child: Image.memory(
                                              _imageBytes!,
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
                              ),
                      ),
                      // Scanner overlay frame (only show on camera preview)
                      if (_imageBytes == null && _isCameraInitialized)
                        Center(
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFDC143C),
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Corner brackets
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                            color: Color(0xFFDC143C), width: 3),
                                        left: BorderSide(
                                            color: Color(0xFFDC143C), width: 3),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                            color: Color(0xFFDC143C), width: 3),
                                        right: BorderSide(
                                            color: Color(0xFFDC143C), width: 3),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xFFDC143C), width: 3),
                                        left: BorderSide(
                                            color: Color(0xFFDC143C), width: 3),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xFFDC143C), width: 3),
                                        right: BorderSide(
                                            color: Color(0xFFDC143C), width: 3),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Loading overlay - more prominent
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFFDC143C),
                                    ),
                                    strokeWidth: 4,
                                  ),
                                  SizedBox(height: 24),
                                  Text(
                                    'Analyzing...',
                                    style: TextStyle(
                                      color: Color(0xFFDC143C),
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
                      // Status indicator (OK/NOT OK) - uses selected box
                      if (!_isAnalyzing &&
                          _detectionResult != null &&
                          _selectedBox != null)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: _selectedBox!.className == 'OK'
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _selectedBox!.className == 'OK'
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  _selectedBox!.className,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Debug panel toggle button
                      Positioned(
                        top: 16,
                        left: 16,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showDebugPanel = !_showDebugPanel;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.bug_report,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      // Debug panel
                      if (_showDebugPanel)
                        Positioned(
                          bottom: 100,
                          left: 16,
                          right: 16,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            constraints: BoxConstraints(maxHeight: 200),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Debug Logs',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _debugLogs.clear();
                                        });
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _debugLogs.map((log) {
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 4),
                                          child: Text(
                                            log,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ), // Close Container
              ), // Close Expanded

              // Camera Action Buttons
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Retake button (only show when image is captured)
                    if (_imageBytes != null)
                      Padding(
                        padding: EdgeInsets.only(right: 40),
                        child: GestureDetector(
                          onTap: _retakePhoto,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    // Capture button
                    GestureDetector(
                      onTap: _captureImage,
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Color(0xFFDC143C), // Crimson red
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFDC143C).withOpacity(0.5),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _imageBytes == null
                              ? Icons.camera_alt
                              : Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // SAVE RESULT Button
              Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveResult,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFDC143C), // Crimson red
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'SAVE RESULT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBoundingBoxes() {
    if (_detectionResult == null ||
        _imageDisplayWidth == null ||
        _imageDisplayHeight == null ||
        _decodedImage == null ||
        _imageBytes == null) {
      return [];
    }

    // Calculate scale - account for BoxFit.contain
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
      final isSelected = _selectedBox == box;
      final color = box.className == 'OK' ? Colors.green : Colors.red;
      final borderWidth = isSelected ? 4.0 : 2.0;

      // Scale and offset bounding box coordinates
      final x1 = (box.x1 * scaleX) + offsetX;
      final y1 = (box.y1 * scaleY) + offsetY;
      final x2 = (box.x2 * scaleX) + offsetX;
      final y2 = (box.y2 * scaleY) + offsetY;

      final width = x2 - x1;
      final height = y2 - y1;

      return Positioned(
        left: x1,
        top: y1,
        child: GestureDetector(
          onTap: () => _selectBox(box),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              border: Border.all(
                color: color,
                width: borderWidth,
              ),
              color: color.withOpacity(isSelected ? 0.2 : 0.1),
            ),
            child: Stack(
              children: [
                // Label at top
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    child: Text(
                      '${box.className} ${(box.confidence * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
