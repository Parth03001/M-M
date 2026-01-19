# Quick Start Guide - Wheel Inspector

## Before You Begin

You need to add your trained TFLite model file!

## Step 1: Add Your Model

Copy your `wheel_model.tflite` file to:
```
android/app/src/main/assets/wheel_model.tflite
```

**Important**: The model MUST be named exactly `wheel_model.tflite`

## Step 2: Verify Model Training

Your model should detect these 4 classes:
- Class 0: rim_black
- Class 1: cap_black
- Class 2: rim_grey
- Class 3: cap_grey

## Step 3: Install Dependencies

```bash
cd wheel_inspector
flutter pub get
```

## Step 4: Run the App

```bash
flutter run
```

## How It Works

### Detection Logic

The app captures an image and detects wheel components. Based on the detected class combinations:

| You Detect | Result |
|-----------|---------|
| rim_black + cap_black | ✓ AX7 OK |
| rim_black + rim_grey | ✗ AX7 NOT OK |
| rim_grey + cap_grey | ✓ AX7L OK |
| rim_grey + cap_black | ✗ AX7L NOT OK |

### Using the App

1. **Launch**: App opens to camera view
2. **Position**: Point camera at wheel (both rim and cap visible)
3. **Capture**: Tap blue "Capture" button
4. **Wait**: Model processes image (1-2 seconds)
5. **Result**: See detection boxes and OK/NOT OK verdict
6. **Retake**: If needed, tap "Retake" to capture again

### Debug Mode

Tap the bug icon in the app bar to see:
- Model loading logs
- Detection inference details
- Bounding box coordinates
- Confidence scores
- Any errors or warnings

## Troubleshooting

### "Model not loaded" error
- Check `wheel_model.tflite` is in `android/app/src/main/assets/`
- Verify file name is exactly `wheel_model.tflite` (not .pt or .onnx)

### "No detections found"
- Ensure good lighting
- Get both rim and cap in frame
- Hold camera steady
- Try adjusting distance

### Camera won't open
- Grant camera permission in device settings
- Check AndroidManifest.xml has CAMERA permission

## Next Steps

After successful testing:
1. Adjust confidence threshold if needed (see README.md)
2. Customize detection logic for your requirements
3. Add save functionality if needed
4. Deploy to production devices

## File Structure Summary

```
wheel_inspector/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── screens/
│   │   └── wheel_detection_screen.dart  # Main UI
│   ├── services/                    # Model services
│   └── models/                      # Data classes
├── assets/
│   └── labels.txt                   # Class names
├── android/
│   └── app/src/main/assets/
│       └── wheel_model.tflite       # YOUR MODEL HERE
└── README.md                        # Full documentation
```

---

**Remember**: Always add your `wheel_model.tflite` file before building!
