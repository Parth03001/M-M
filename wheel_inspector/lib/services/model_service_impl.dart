import 'model_service.dart';
import 'model_service_efficientnet.dart';

enum ModelType { efficientnet, efficientnetAug, efficientnetCrop }

/// Display name and config for each model type
class ModelConfig {
  final String displayName;
  final String assetPath;
  final double cropRatio;

  const ModelConfig({
    required this.displayName,
    required this.assetPath,
    required this.cropRatio,
  });
}

const Map<ModelType, ModelConfig> modelConfigs = {
  ModelType.efficientnet: ModelConfig(
    displayName: 'EfficientNet',
    assetPath: 'assets/wheel_efficientnet.tflite',
    cropRatio: 0.55,
  ),
  ModelType.efficientnetAug: ModelConfig(
    displayName: 'EfficientNet AUG',
    assetPath: 'assets/wheel_efficientnet_AUG.tflite',
    cropRatio: 0.55,
  ),
  ModelType.efficientnetCrop: ModelConfig(
    displayName: 'EfficientNet CROP',
    assetPath: 'assets/wheel_efficientnet_CROP.tflite',
    cropRatio: 0.75,
  ),
};

/// Factory function to create the appropriate model service
ModelService createModelService({ModelType type = ModelType.efficientnet}) {
  final config = modelConfigs[type]!;
  return ModelServiceEfficientNet(
    assetPath: config.assetPath,
    cropRatio: config.cropRatio,
  );
}
