import 'model_service.dart';
import 'model_service_impl.dart';

/// Global model service manager - singleton pattern
class ModelManager {
  static final ModelManager _instance = ModelManager._internal();
  factory ModelManager() => _instance;
  ModelManager._internal();

  ModelService? _modelService;
  bool _isLoading = false;
  ModelType _currentType = ModelType.efficientnet;

  ModelService? get modelService => _modelService;
  bool get isLoaded => _modelService?.isLoaded ?? false;
  bool get isLoading => _isLoading;
  ModelType get currentType => _currentType;

  /// Initialize and load the model
  Future<void> loadModel({ModelType type = ModelType.efficientnet}) async {
    if (_isLoading) return;

    // If switching model variant, dispose old one
    if (_currentType != type) {
      dispose();
    }

    if (isLoaded) return;

    _isLoading = true;
    _currentType = type;
    try {
      _modelService = createModelService(type: type);
      await _modelService!.loadModel();
      print('✓ Model loaded successfully via ModelManager (${type.name})');
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
