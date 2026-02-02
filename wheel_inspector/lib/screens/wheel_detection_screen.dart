import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/model_manager.dart';
import '../services/model_service_impl.dart';
import '../models/detection_result.dart';

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

    final confidence = result.boxes.first.confidence;
    if (confidence < 0.25) {
      _resultMessage = '';
      _resultColor = Colors.grey;
      // Show low-confidence dialog after frame renders
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showLowConfidenceDialog();
      });
      return;
    }

    final className = result.boxes.first.className;
    if (className.contains('OK') && !className.contains('NOT')) {
      _resultMessage = '✓ $className';
      _resultColor = Colors.green;
    } else {
      _resultMessage = '✗ $className';
      _resultColor = Colors.red;
    }
  }

  void _showLowConfidenceDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Low Confidence',
          style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please capture the image properly.',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            SizedBox(height: 12),
            Text(
              'Suggestions:',
              style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 14),
            ),
            SizedBox(height: 6),
            Text(
              '• Zoom in a little closer to the wheel\n'
              '• Avoid capturing from too far away\n'
              '• Make sure the wheel is centered in frame\n'
              '• Ensure good lighting on the wheel',
              style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _retake();
            },
            child: const Text('Retake', style: TextStyle(color: Colors.orangeAccent, fontSize: 15)),
          ),
        ],
      ),
    );
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
        disabledForegroundColor: Colors.white70,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
    );
  }

  Widget _buildCameraOrImageView() {
    if (_capturedImageBytes != null) {
      return _buildCapturedImage();
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

  Widget _buildCapturedImage() {
    return Image.memory(
      _capturedImageBytes!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
