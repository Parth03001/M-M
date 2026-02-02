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
  ModelType _selectedModelType = ModelType.efficientnet;

  final ModelManager _modelManager = ModelManager();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _modelManager.loadModel(type: _selectedModelType);
      print('✓ Model loaded successfully');
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
      if (cameras.isEmpty) throw Exception('No cameras available');

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
        setState(() => _isCameraInitialized = true);
      }
    } catch (e) {
      print('❌ Error initializing camera: $e');
      rethrow;
    }
  }

  Future<void> _switchModel(ModelType type) async {
    if (type == _selectedModelType && _modelManager.isLoaded) return;
    _retake();
    setState(() {
      _selectedModelType = type;
    });
    try {
      await _modelManager.loadModel(type: type);
      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load model: $e')),
        );
      }
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
      final XFile imageFile = await _cameraController!.takePicture();
      final imageBytes = await imageFile.readAsBytes();

      setState(() => _capturedImageBytes = imageBytes);

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
      setState(() => _isAnalyzing = false);
    }
  }

  void _analyzeWheelCombination(DetectionResult result) {
    if (result.boxes.isEmpty) {
      _resultMessage = 'No wheel parts detected';
      _resultColor = Colors.orange;
      return;
    }

    final firstBox = result.boxes.first;
    if (firstBox.classId >= 10) {
      final className = firstBox.className;
      if (className.contains('OK') && !className.contains('NOT')) {
        _resultMessage = '✓ $className';
        _resultColor = Colors.green;
      } else {
        _resultMessage = '✗ $className';
        _resultColor = Colors.red;
      }
      return;
    }

    Set<int> detectedClasses = result.boxes.map((box) => box.classId).toSet();

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
  }

  void _retake() {
    setState(() {
      _capturedImageBytes = null;
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
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text(
          'Wheel Inspector',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _showDebug ? Icons.bug_report : Icons.bug_report_outlined,
              color: _showDebug ? Colors.amber : Colors.white70,
            ),
            onPressed: () => setState(() => _showDebug = !_showDebug),
            tooltip: 'Toggle Debug',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Model selector bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFF16213E),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF0F3460), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.model_training, color: Colors.white70, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F3460),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<ModelType>(
                            value: _selectedModelType,
                            isExpanded: true,
                            dropdownColor: const Color(0xFF16213E),
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            icon: const Icon(Icons.expand_more, color: Colors.white70),
                            items: ModelType.values.map((type) {
                              final config = modelConfigs[type]!;
                              return DropdownMenuItem(
                                value: type,
                                child: Text(config.displayName),
                              );
                            }).toList(),
                            onChanged: _isAnalyzing
                                ? null
                                : (type) {
                                    if (type != null) _switchModel(type);
                                  },
                          ),
                        ),
                      ),
                    ),
                    if (_modelManager.isLoading) ...[
                      const SizedBox(width: 10),
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
                      ),
                    ],
                  ],
                ),
              ),

              // Camera / Image area
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: SizedBox.expand(
                    child: _buildCameraOrImageView(),
                  ),
                ),
              ),

              // Result banner
              if (_resultMessage.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                  decoration: BoxDecoration(
                    color: _resultColor.withOpacity(0.15),
                    border: Border(
                      top: BorderSide(color: _resultColor.withOpacity(0.4), width: 2),
                    ),
                  ),
                  child: Text(
                    _resultMessage,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: _resultColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Control buttons
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                color: const Color(0xFF1A1A2E),
                child: Row(
                  children: [
                    if (_capturedImageBytes != null)
                      Expanded(
                        child: _buildButton(
                          icon: Icons.refresh,
                          label: 'Retake',
                          color: const Color(0xFF535C68),
                          onPressed: _isAnalyzing ? null : _retake,
                        ),
                      ),
                    if (_capturedImageBytes != null)
                      const SizedBox(width: 12),
                    Expanded(
                      child: _buildButton(
                        icon: _isAnalyzing ? Icons.hourglass_empty : Icons.camera_alt,
                        label: _isAnalyzing ? 'Analyzing...' : 'Capture',
                        color: const Color(0xFF0F3460),
                        onPressed: (_isAnalyzing || _capturedImageBytes != null)
                            ? null
                            : _captureAndAnalyze,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Debug overlay
          if (_showDebug && _debugLogs.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.92),
                  border: const Border(
                    top: BorderSide(color: Colors.amber, width: 1),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Debug Logs',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                            onPressed: () => setState(() => _showDebug = false),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: _debugLogs.length,
                        itemBuilder: (context, index) {
                          final log = _debugLogs[index];
                          Color logColor = Colors.white70;
                          if (log.contains('✓')) logColor = Colors.greenAccent;
                          if (log.contains('❌') || log.contains('⚠️')) logColor = Colors.orangeAccent;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 2),
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

  Widget _buildButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: color,
        disabledBackgroundColor: color.withOpacity(0.4),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
    );
  }

  Widget _buildCameraOrImageView() {
    if (_capturedImageBytes != null) {
      return _buildImageWithBoxes();
    } else if (_isCameraInitialized && _cameraController != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_cameraController!),
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(children: _buildCornerBrackets()),
            ),
          ),
        ],
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white70),
      );
    }
  }

  List<Widget> _buildCornerBrackets() {
    const double bracketSize = 28;
    const double bracketWidth = 3;
    const color = Colors.white;

    return [
      Positioned(top: 0, left: 0, child: Container(width: bracketSize, height: bracketSize,
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: color, width: bracketWidth), left: BorderSide(color: color, width: bracketWidth))))),
      Positioned(top: 0, right: 0, child: Container(width: bracketSize, height: bracketSize,
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: color, width: bracketWidth), right: BorderSide(color: color, width: bracketWidth))))),
      Positioned(bottom: 0, left: 0, child: Container(width: bracketSize, height: bracketSize,
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: color, width: bracketWidth), left: BorderSide(color: color, width: bracketWidth))))),
      Positioned(bottom: 0, right: 0, child: Container(width: bracketSize, height: bracketSize,
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: color, width: bracketWidth), right: BorderSide(color: color, width: bracketWidth))))),
    ];
  }

  Widget _buildImageWithBoxes() {
    if (_capturedImageBytes == null || _detectionResult == null) {
      return Image.memory(_capturedImageBytes!, fit: BoxFit.cover, width: double.infinity, height: double.infinity);
    }

    final drawableBoxes = _detectionResult!.boxes.where((b) => b.classId < 10).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.memory(
              _capturedImageBytes!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            if (drawableBoxes.isNotEmpty)
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: BoundingBoxPainter(
                  boxes: drawableBoxes,
                  imageBytes: _capturedImageBytes!,
                  fitMode: BoxFit.cover,
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
  final BoxFit fitMode;

  BoundingBoxPainter({required this.boxes, required this.imageBytes, this.fitMode = BoxFit.contain});

  @override
  void paint(Canvas canvas, Size size) {
    final image = _decodeImageSync(imageBytes);
    if (image == null) return;

    final imageWidth = image.width.toDouble();
    final imageHeight = image.height.toDouble();

    final scaleX = size.width / imageWidth;
    final scaleY = size.height / imageHeight;
    final scale = fitMode == BoxFit.cover
        ? math.max(scaleX, scaleY)
        : math.min(scaleX, scaleY);

    final scaledWidth = imageWidth * scale;
    final scaledHeight = imageHeight * scale;

    final offsetX = (size.width - scaledWidth) / 2;
    final offsetY = (size.height - scaledHeight) / 2;

    for (final box in boxes) {
      final x1 = box.x1 * scale + offsetX;
      final y1 = box.y1 * scale + offsetY;
      final x2 = box.x2 * scale + offsetX;
      final y2 = box.y2 * scale + offsetY;

      Color boxColor = Colors.green;
      if (box.className.contains('grey')) boxColor = Colors.blue;

      final paint = Paint()
        ..color = boxColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      canvas.drawRect(Rect.fromLTRB(x1, y1, x2, y2), paint);

      final textSpan = TextSpan(
        text: box.className,
        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      );
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();

      final labelRect = Rect.fromLTWH(x1, y1 - textPainter.height - 4, textPainter.width + 8, textPainter.height + 4);
      canvas.drawRect(labelRect, Paint()..color = boxColor.withOpacity(0.8));
      textPainter.paint(canvas, Offset(x1 + 4, y1 - textPainter.height - 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  ({int width, int height})? _decodeImageSync(Uint8List bytes) {
    try {
      if (bytes.length > 24 && bytes[0] == 0xFF && bytes[1] == 0xD8) {
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
