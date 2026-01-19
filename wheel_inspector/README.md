# Wheel Inspector App

A single-screen Flutter application for wheel component inspection using TensorFlow Lite object detection.

## Overview

This app detects wheel components (rims and caps) and determines the correct wheel model based on detected combinations:

### Detection Classes
- **Class 0**: rim_black
- **Class 1**: cap_black
- **Class 2**: rim_grey
- **Class 3**: cap_grey

### Detection Logic

| Detected Classes | Result |
|-----------------|---------|
| rim_black (0) + cap_black (1) | ✓ AX7 OK |
| rim_black (0) + rim_grey (2) | ✗ AX7 NOT OK |
| rim_grey (2) + cap_grey (3) | ✓ AX7L OK |
| rim_grey (2) + cap_black (1) | ✗ AX7L NOT OK |

## Features

- **Single Screen Interface**: Simple camera capture and detection
- **Real-time Camera Preview**: Live view with capture guide overlay
- **Instant Detection**: Automatic model inference on captured images
- **Visual Feedback**: Bounding boxes drawn on detected objects
- **Result Display**: Clear OK/NOT OK status with detected classes
- **Debug Mode**: Toggle debug panel to view inference logs

## Setup Instructions

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio or VS Code with Flutter extension
- Android device or emulator (API 21+)

### Installation Steps

1. **Add the TFLite Model**

   Place your trained `wheel_model.tflite` file in:
   ```
   android/app/src/main/assets/wheel_model.tflite
   ```

   The model should be:
   - YOLO object detection format
   - Trained for 4 classes (rim_black, cap_black, rim_grey, cap_grey)
   - Exported as TFLite float32

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

## Project Structure

```
wheel_inspector/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── screens/
│   │   └── wheel_detection_screen.dart    # Main detection screen
│   ├── services/
│   │   ├── model_service.dart             # Model service interface
│   │   ├── model_service_impl.dart        # Service factory
│   │   ├── model_service_ultralytics.dart # YOLO implementation
│   │   └── model_manager.dart             # Singleton manager
│   └── models/
│       └── detection_result.dart          # Detection data classes
├── assets/
│   └── labels.txt                         # Class labels
├── android/
│   └── app/src/main/assets/
│       └── wheel_model.tflite             # **ADD YOUR MODEL HERE**
└── pubspec.yaml                           # Dependencies
```

## Usage

1. **Launch the App**: Open on your device
2. **Point Camera**: Aim at wheel components (rim + cap together in frame)
3. **Capture Image**: Tap the blue "Capture" button
4. **View Results**:
   - See detection boxes overlaid on image
   - Read the result (AX7 OK/NOT OK or AX7L OK/NOT OK)
   - Check detected classes and confidence scores
5. **Retake (if needed)**: Tap "Retake" to capture again
6. **Debug Info**: Tap bug icon in app bar to view detailed logs

## Key Dependencies

```yaml
dependencies:
  ultralytics_yolo: ^0.1.43  # YOLO model inference
  camera: ^0.11.0+2          # Camera access
  image: ^4.1.7              # Image processing
  path_provider: ^2.1.2      # File system access
```

## Android Configuration

- **Minimum SDK**: API 21 (Android 5.0)
- **Target SDK**: Latest
- **Compile SDK**: 36
- **Java Version**: 17
- **Permissions**: CAMERA, READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE

## Model Requirements

The `wheel_model.tflite` should be:

1. **Format**: TensorFlow Lite (float32)
2. **Task**: Object Detection (YOLO)
3. **Input**: 640x640 RGB image
4. **Output**: Bounding boxes with class IDs and confidence scores
5. **Classes**: 4 classes mapped to rim and cap types

### Training Your Model

Use Ultralytics YOLO for training:

```python
from ultralytics import YOLO

# Train model
model = YOLO('yolov8n.pt')
model.train(data='wheel_dataset.yaml', epochs=100)

# Export to TFLite
model.export(format='tflite', imgsz=640)
```

### Dataset Format (YOLO)

```yaml
# wheel_dataset.yaml
path: /path/to/dataset
train: images/train
val: images/val

names:
  0: rim_black
  1: cap_black
  2: rim_grey
  3: cap_grey
```

## Troubleshooting

### Model Not Loading

- Verify `wheel_model.tflite` exists in `android/app/src/main/assets/`
- Check model format is TFLite (not .pt or .onnx)
- Ensure model uses standard TFLite ops (no Flex ops)

### Camera Permission Denied

- Check AndroidManifest.xml has CAMERA permission
- Grant permission manually in device settings

### No Detections

- Ensure good lighting
- Center wheel components in frame
- Check model is trained correctly
- View debug logs for inference details

### Build Errors

- Run `flutter clean && flutter pub get`
- Check Java version is 17
- Verify Android SDK is up to date

## Customization

### Change Detection Logic

Edit `_analyzeWheelCombination()` in `wheel_detection_screen.dart`:

```dart
void _analyzeWheelCombination(DetectionResult result) {
  Set<int> detectedClasses = result.boxes.map((box) => box.classId).toSet();

  // Add your custom logic here
  if (detectedClasses.contains(0) && detectedClasses.contains(1)) {
    _resultMessage = '✓ AX7 OK';
    _resultColor = Colors.green;
  }
  // ... more conditions
}
```

### Adjust Confidence Threshold

Edit `confThreshold` in `model_service_ultralytics.dart`:

```dart
static const double confThreshold = 0.25; // Change to 0.4, 0.5, etc.
```

## License

This project is provided as-is for wheel inspection purposes.

## Support

For issues or questions:
1. Check debug logs (tap bug icon in app)
2. Verify model file is present and correct
3. Review console output for errors

---

**Note**: Remember to add your `wheel_model.tflite` file to `android/app/src/main/assets/` before building!
