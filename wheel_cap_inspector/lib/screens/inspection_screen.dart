import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:drift/drift.dart' as drift;
import '../services/model_service.dart';
import '../models/inspection_result.dart';
import '../database/database.dart';

class InspectionScreen extends StatefulWidget {
  final int vinId;
  final String position;
  final String? nextLabel;

  const InspectionScreen({
    super.key, 
    required this.vinId, 
    required this.position,
    this.nextLabel,
  });

  @override
  State<InspectionScreen> createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isAnalyzing = false;
  Uint8List? _capturedImageBytes;
  InspectionResult? _result;
  final ModelService _modelService = ModelService();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _modelService.loadModel();
    await _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (mounted) setState(() => _isCameraInitialized = true);
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  Future<void> _captureAndAnalyze() async {
    if (_isAnalyzing || _cameraController == null) return;

    setState(() {
      _isAnalyzing = true;
      _result = null;
    });

    try {
      final image = await _cameraController!.takePicture();
      final bytes = await image.readAsBytes();

      if (mounted) setState(() => _capturedImageBytes = bytes);

      final result = await _modelService.analyze(bytes, widget.position);
      if (mounted) setState(() => _result = result);

      if (mounted) {
        final db = context.read<AppDatabase>();
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/inspection_${widget.vinId}_${widget.position}.jpg';
        await File(image.path).copy(path);

        await db.insertInspection(
          InspectionsCompanion.insert(
            vinScanId: widget.vinId,
            wheelPosition: widget.position,
            status: result.isOk ? 'OK' : 'NOT OK (${result.label})',
            confidence: result.confidence,
            imagePath: drift.Value(path),
          ),
        );
      }
    } catch (e) {
      debugPrint('Analysis error: $e');
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  void _reset() {
    setState(() {
      _capturedImageBytes = null;
      _result = null;
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
        title: Text('Inspect Wheel: ${widget.position}'),
        actions: [
          if (_capturedImageBytes != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _isAnalyzing ? null : _reset,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: _buildMainView(),
            ),
          ),
          _buildBottomPanel(),
        ],
      ),
    );
  }

  Widget _buildMainView() {
    if (_capturedImageBytes != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(_capturedImageBytes!, fit: BoxFit.contain),
          if (_result != null && _result!.boxes.isNotEmpty)
            CustomPaint(
              painter: DetectionPainter(
                boxes: _result!.boxes,
                fit: BoxFit.contain,
              ),
            ),
          if (_isAnalyzing)
            Container(
              color: Colors.black45,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'AI Analyzing...',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
        ],
      );
    }
    if (_isCameraInitialized && _cameraController != null) {
      return Stack(
        alignment: Alignment.center,
        children: [
          CameraPreview(_cameraController!),
          _buildGuidelines(),
        ],
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildGuidelines() {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white54, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          'Center wheel cap here\n(${widget.position})',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_result != null) ...[
            _buildResultCard(),
            const SizedBox(height: 20),
          ],
          if (_result == null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_isAnalyzing || _capturedImageBytes != null)
                    ? null
                    : _captureAndAnalyze,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: _isAnalyzing
                    ? const Text('Processing...')
                    : const Text('Capture & Analyze'),
              ),
            ),
          if (_result != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  if (widget.nextLabel != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Next Wheel: ${widget.nextLabel}'),
                      ),
                    ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Back to Progress List'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    final isOk = _result!.isOk;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOk ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOk ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isOk ? Icons.check_circle : Icons.error,
            color: isOk ? Colors.green : Colors.red,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _result!.label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Confidence: ${(_result!.confidence * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetectionPainter extends CustomPainter {
  final List<InspectionBox> boxes;
  final BoxFit fit;

  DetectionPainter({required this.boxes, required this.fit});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (var box in boxes) {
      if (box.className.contains('Rim')) {
        paint.color = Colors.greenAccent;
      } else {
        paint.color = Colors.blueAccent;
      }

      final rect = Rect.fromLTRB(
        box.x1 * size.width,
        box.y1 * size.height,
        box.x2 * size.width,
        box.y2 * size.height,
      );

      canvas.drawRect(rect, paint);

      textPainter.text = TextSpan(
        text: '${box.className} ${(box.confidence * 100).toStringAsFixed(0)}%',
        style: TextStyle(
          color: Colors.white,
          backgroundColor: paint.color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(rect.left, rect.top - 15));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
