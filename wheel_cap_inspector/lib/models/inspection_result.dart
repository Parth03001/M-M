class InspectionResult {
  final String label;
  final double confidence;
  final List<String> debugLogs;
  final List<String> detectedClasses;
  final List<InspectionBox> boxes;
  final bool isOk; // Store the logic result directly

  InspectionResult({
    required this.label,
    required this.confidence,
    required this.isOk,
    this.debugLogs = const [],
    this.detectedClasses = const [],
    this.boxes = const [],
  });
}

class InspectionBox {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final String className;
  final double confidence;

  InspectionBox({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.className,
    required this.confidence,
  });
}
