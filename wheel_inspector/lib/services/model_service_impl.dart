import 'model_service.dart';
import 'model_service_ultralytics.dart';
import 'model_service_efficientnet.dart';

enum ModelType { yolo, efficientnet }

/// Factory function to create the appropriate model service
ModelService createModelService({ModelType type = ModelType.efficientnet}) {
  switch (type) {
    case ModelType.yolo:
      return ModelServiceUltralytics();
    case ModelType.efficientnet:
      return ModelServiceEfficientNet();
  }
}
