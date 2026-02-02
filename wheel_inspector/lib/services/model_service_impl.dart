import 'model_service.dart';
import 'model_service_efficientnet.dart';

enum ModelType { efficientnet, efficientnetAug, efficientnetCrop, efficientnetV2Small }

/// Display name and config for each model type
class ModelConfig {
  final String displayName;
  final String assetPath;
  final double cropRatio;
  final int inputSize;

  const ModelConfig({
    required this.displayName,
    required this.assetPath,
    required this.cropRatio,
    this.inputSize = 224,
  });
}

const Map<ModelType, ModelConfig> modelConfigs = {
  ModelType.efficientnet: ModelConfig(
    displayName: 'EfficientNet-B0',
    assetPath: 'assets/wheel_efficientnet.tflite',
    cropRatio: 0.55,
  ),
  ModelType.efficientnetAug: ModelConfig(
    displayName: 'EfficientNet-B0 AUG',
    assetPath: 'assets/wheel_efficientnet_AUG.tflite',
    cropRatio: 0.55,
  ),
  ModelType.efficientnetCrop: ModelConfig(
    displayName: 'EfficientNet-B0 CROP',
    assetPath: 'assets/wheel_efficientnet_CROP.tflite',
    cropRatio: 0.75,
  ),
  ModelType.efficientnetV2Small: ModelConfig(
    displayName: 'EfficientNet-V2-S',
    assetPath: 'assets/wheel_efficientnet_v2_small.tflite',
    cropRatio: 0.55,
    inputSize: 384,
  ),
};

/// Factory function to create the appropriate model service
ModelService createModelService({ModelType type = ModelType.efficientnet}) {
  final config = modelConfigs[type]!;
  return ModelServiceEfficientNet(
    assetPath: config.assetPath,
    cropRatio: config.cropRatio,
    inputSize: config.inputSize,
  );
}
