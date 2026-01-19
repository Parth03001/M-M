# Wheel Inspector Assets

## ✅ TEMPORARY PLACEHOLDER MODEL ADDED

**A placeholder model has been added to fix the "platform error".**

The current `wheel_model.tflite` (37.9 MB) is actually the classifier model (best_float32.tflite) copied from classifier_app. This allows you to **test that the prediction pipeline works**, but the detections will not be accurate for wheel inspection since it's trained for different classes.

### Current Status

- ✅ `wheel_model.tflite` exists in both locations:
  - `wheel_inspector/assets/wheel_model.tflite` (37.9 MB)
  - `wheel_inspector/android/app/src/main/assets/wheel_model.tflite` (37.9 MB)
- ✅ App should now build and run without "platform error"
- ⚠️ Detections will not be wheel-specific (placeholder model)

### To Use Your Own Trained Wheel Model

1. **Replace the placeholder model with your trained model:**
   ```bash
   # Copy your trained wheel model
   cp /path/to/your/trained_wheel_model.tflite wheel_inspector/assets/wheel_model.tflite

   # Copy to Android assets (REQUIRED)
   cp wheel_inspector/assets/wheel_model.tflite wheel_inspector/android/app/src/main/assets/
   ```

2. **Model Requirements:**
   - **Format:** TFLite (`.tflite` file)
   - **Task:** Object Detection (YOLO)
   - **Classes:** Should detect wheel components:
     - Class 0: rim_black
     - Class 1: cap_black
     - Class 2: rim_grey
     - Class 3: cap_grey

3. **Update labels.txt** if needed:
   ```
   rim_black
   cap_black
   rim_grey
   cap_grey
   ```

4. **Rebuild the app:**
   ```bash
   cd wheel_inspector
   flutter clean
   flutter build apk --release
   ```

### Why Both Locations?

The Ultralytics YOLO plugin loads models from **Android assets** (`android/app/src/main/assets/`), not Flutter assets. We keep both for consistency and potential future iOS support.

### Testing with Placeholder Model

You can test the app now with the placeholder model:
1. Build and install the APK
2. Open the app and capture an image
3. The app will run inference (but with wrong detections)
4. Replace with your trained model for actual wheel detection

See `MODEL_SETUP.md` in the root folder for detailed setup instructions.
