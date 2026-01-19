class DetectionResult {
  final List<BoundingBox> boxes;
  final bool detectionSuccess;
  final List<String> debugLogs;

  DetectionResult({
    required this.boxes,
    required this.detectionSuccess,
    this.debugLogs = const [],
  });
}

class BoundingBox {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final String className;
  final double confidence;
  final int classId;

  BoundingBox({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.className,
    required this.confidence,
    required this.classId,
  });

  double get width => x2 - x1;
  double get height => y2 - y1;
  double get centerX => (x1 + x2) / 2;
  double get centerY => (y1 + y2) / 2;
}
