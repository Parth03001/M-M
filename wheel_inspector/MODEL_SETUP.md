# Wheel Model Setup Guide

## Issue: "Platform error" during prediction

The app is building successfully but fails during image prediction with a "platform error". This is because **the wheel_model.tflite file is missing**.

## Root Cause

The code references `wheel_model.tflite` but this file doesn't exist in the project:
- ❌ Missing: `wheel_inspector/assets/wheel_model.tflite`
- ❌ Missing: `wheel_inspector/android/app/src/main/assets/wheel_model.tflite`

## Solution: Add Your Trained Model

### Step 1: Prepare Your Model

You need a YOLO model trained to detect wheel components. The model should:
- Be in **TFLite format** (`.tflite` file)
- Be trained for **object detection**
- Detect these classes:
  - Class 0: rim_black
  - Class 1: cap_black
  - Class 2: rim_grey
  - Class 3: cap_grey

### Step 2: Add Model to Flutter Assets

1. Copy your trained model to the Flutter assets folder:
   ```bash
   cp /path/to/your/wheel_model.tflite wheel_inspector/assets/
   ```

### Step 3: Add Model to Android Assets (CRITICAL)

The Ultralytics YOLO plugin loads models from Android assets, not Flutter assets.

1. Copy the model to Android assets:
   ```bash
   cp wheel_inspector/assets/wheel_model.tflite wheel_inspector/android/app/src/main/assets/
   ```

2. Verify the file exists:
   ```bash
   ls -lh wheel_inspector/android/app/src/main/assets/wheel_model.tflite
   ```

### Step 4: Verify Labels

Check that `wheel_inspector/assets/labels.txt` contains your class names:
```
rim_black
cap_black
rim_grey
cap_grey
```

### Step 5: Rebuild the App

```bash
cd wheel_inspector
flutter clean
flutter pub get
flutter build apk --release
```

## Comparison with classifier_app

The classifier_app works because it has the model in both locations:
- ✅ `classifier_app/assets/best_float32.tflite` (37.9 MB)
- ✅ `classifier_app/android/app/src/main/assets/best_float32.tflite` (37.9 MB)

Your wheel_inspector needs the same structure:
- ✅ `wheel_inspector/assets/wheel_model.tflite` (your model)
- ✅ `wheel_inspector/android/app/src/main/assets/wheel_model.tflite` (same model)

## How the Model is Loaded

Looking at `model_service_ultralytics.dart` line 34-36:
```dart
_yolo = YOLO(
  modelPath: 'wheel_model', // Model name without .tflite extension
  task: YOLOTask.detect,
);
```

The Ultralytics plugin looks for `wheel_model.tflite` in:
- **Android:** `android/app/src/main/assets/wheel_model.tflite`
- **iOS:** Not configured yet

## Testing After Adding Model

1. Install the APK on your device
2. Open the app
3. Point camera at a wheel
4. Tap the capture button
5. The app should:
   - Load the model successfully
   - Run inference on the captured image
   - Display detected wheel components
   - Show "Good Combination" or "Bad Combination" based on detections

## Alternative: Use a Placeholder Model for Testing

If you don't have a trained model yet, you can temporarily use the classifier model to test if the pipeline works:

```bash
# Temporarily copy classifier model as wheel_model
cp classifier_app/android/app/src/main/assets/best_float32.tflite \
   wheel_inspector/android/app/src/main/assets/wheel_model.tflite

cp classifier_app/assets/best_float32.tflite \
   wheel_inspector/assets/wheel_model.tflite
```

**Note:** This will make the app work but detections will be wrong since it's trained for different classes. Use this only to verify the prediction pipeline works.

## Need Help Training a Model?

Check `classifier_app/convert_pt_to_tflite_colab.ipynb` for guidance on converting YOLO models to TFLite format.
