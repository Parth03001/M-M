import 'model_service.dart';
import 'model_service_impl.dart';

/// Global model service manager - singleton pattern
class ModelManager {
  static final ModelManager _instance = ModelManager._internal();
  factory ModelManager() => _instance;
  ModelManager._internal();

  ModelService? _modelService;
  bool _isLoading = false;

  ModelService? get modelService => _modelService;
  bool get isLoaded => _modelService?.isLoaded ?? false;
  bool get isLoading => _isLoading;

  /// Initialize and load the model
  Future<void> loadModel() async {
    if (_isLoading || isLoaded) {
      return;
    }

    _isLoading = true;
    try {
      _modelService = createModelService();
      await _modelService!.loadModel();
      print('✓ Model loaded successfully via ModelManager');
    } catch (e) {
      print('❌ Error loading model via ModelManager: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  /// Dispose the model service
  void dispose() {
    _modelService?.dispose();
    _modelService = null;
    _isLoading = false;
  }
}

