import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../services/model_service.dart';
import '../services/model_service_impl.dart';

class ClassifierScreen extends StatefulWidget {
  @override
  _ClassifierScreenState createState() => _ClassifierScreenState();
}

class _ClassifierScreenState extends State<ClassifierScreen>
    with SingleTickerProviderStateMixin {
  late ModelService _modelService;
  XFile? _image;
  String _result = '';
  double _confidence = 0.0;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // Initialize platform-specific model service using conditional import
    _modelService = createModelService();

    // Load model asynchronously after UI is built
    // This ensures the UI shows even if model loading fails
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadModel();
    });

    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
  }

  Future<void> loadModel() async {
    try {
      await _modelService.loadModel();
      print('✓ Model service initialized');
    } catch (e, stackTrace) {
      print('❌ Error loading model: $e');
      print('Stack trace: $stackTrace');
      // Don't crash the app if model fails to load
      // The UI will still work, just ML inference won't be available
    }
  }

  Future<void> classifyImage(XFile imageFile) async {
    if (!_modelService.isLoaded && !kIsWeb) {
      print('❌ Model not loaded');
      setState(() {
        _result = 'Model not loaded';
        _confidence = 0;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Read image bytes
      final imageBytes = await imageFile.readAsBytes();

      // Classify using model service
      final result = await _modelService.classifyImage(imageBytes);

      setState(() {
        _result = result['result'] as String;
        _confidence = result['confidence'] as double;
        _isLoading = false;
      });

      _animationController.forward(from: 0);
    } catch (e) {
      print('❌ Error during classification: $e');
      setState(() {
        if (kIsWeb) {
          _result = 'Not Available on Web';
        } else {
          _result = 'Error';
        }
        _confidence = 0;
        _isLoading = false;
      });
    }
  }

  Future<void> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() => _image = photo);
        await classifyImage(photo);
      }
    } catch (e) {
      print('❌ Error taking photo: $e');
    }
  }

  Future<void> pickFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() => _image = photo);
        await classifyImage(photo);
      }
    } catch (e) {
      print('❌ Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
              Theme.of(context).colorScheme.tertiaryContainer,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.verified_user,
                          size: 50,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Quality Inspector',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      'AI-Powered Quality Control',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: _image == null
                    ? _buildEmptyState(context)
                    : _buildImagePreview(context),
              ),

              // Bottom buttons
              Padding(
                padding: EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: _isLoading ? null : pickFromGallery,
                        icon: Icon(Icons.photo_library),
                        label: Text('Gallery'),
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        onPressed: _isLoading ? null : takePhoto,
                        icon: Icon(Icons.camera_alt, size: 24),
                        label: Text('Capture', style: TextStyle(fontSize: 16)),
                        style: FilledButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                        ),
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo,
            size: 100,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
          SizedBox(height: 24),
          Text(
            'No image selected',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 8),
          Text(
            'Tap the camera button to start',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Image with animation
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              margin: EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: FutureBuilder<Uint8List>(
                  future: _image!.readAsBytes(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Image.memory(
                        snapshot.data!,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      );
                    }
                    return Container(
                      width: double.infinity,
                      height: 300,
                      color: Colors.grey[300],
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Loading indicator
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Analyzing...'),
                ],
              ),
            ),

          // Result card
          if (_result.isNotEmpty && !_isLoading)
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut,
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _result == 'OK'
                    ? Colors.green.withOpacity(0.2)
                    : _result == 'Not Available on Web'
                        ? Colors.orange.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _result == 'OK'
                      ? Colors.green
                      : _result == 'Not Available on Web'
                          ? Colors.orange
                          : Colors.red,
                  width: 3,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _result == 'OK'
                        ? Icons.check_circle
                        : _result == 'Not Available on Web'
                            ? Icons.info
                            : Icons.cancel,
                    color: _result == 'OK'
                        ? Colors.green
                        : _result == 'Not Available on Web'
                            ? Colors.orange
                            : Colors.red,
                    size: 60,
                  ),
                  SizedBox(height: 16),
                  Text(
                    _result,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: _result == 'OK'
                          ? Colors.green
                          : _result == 'Not Available on Web'
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                  if (_result != 'Not Available on Web') ...[
                    SizedBox(height: 8),
                    Text(
                      'Confidence: ${_confidence.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ] else ...[
                    SizedBox(height: 8),
                    Text(
                      'Please use Windows, Android, or iOS\nfor ML inference',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _modelService.dispose();
    super.dispose();
  }
}

