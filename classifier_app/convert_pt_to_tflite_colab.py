"""
YOLO PyTorch to TensorFlow Lite Converter for Google Colab
Run this in a Colab notebook with GPU runtime
"""

# Install required packages
!pip install ultralytics tensorflow onnx onnx-tf tf2onnx -q

import torch
import tensorflow as tf
from ultralytics import YOLO
import numpy as np
from pathlib import Path

print("=" * 60)
print("YOLO PyTorch to TensorFlow Lite Converter")
print("=" * 60)
print()

# Configuration
MODEL_PATH = "/content/best.pt"  # Upload your model to Colab first
OUTPUT_PATH = "/content/best.tflite"
INPUT_SIZE = 640  # YOLO input size

# Step 1: Load YOLO model
print("📥 Step 1: Loading YOLO model...")
model = YOLO(MODEL_PATH)
print(f"✓ Model loaded: {MODEL_PATH}")
print(f"   Model type: {type(model.model)}")

# Step 2: Export to ONNX first (intermediate step)
print("\n📤 Step 2: Exporting to ONNX...")
onnx_path = MODEL_PATH.replace('.pt', '.onnx')
model.export(format='onnx', imgsz=INPUT_SIZE, simplify=True, opset=13)
print(f"✓ ONNX model saved: {onnx_path}")

# Step 3: Convert ONNX to TensorFlow
print("\n🔄 Step 3: Converting ONNX to TensorFlow...")
import onnx
from onnx_tf.backend import prepare

onnx_model = onnx.load(onnx_path)
tf_rep = prepare(onnx_model)
tf_model_path = onnx_path.replace('.onnx', '_tf')
tf_rep.export_graph(tf_model_path)
print(f"✓ TensorFlow model saved: {tf_model_path}")

# Step 4: Convert TensorFlow to TFLite
print("\n🔧 Step 4: Converting to TensorFlow Lite...")

# Load the saved model
converter = tf.lite.TFLiteConverter.from_saved_model(tf_model_path)

# Optimize for mobile
converter.optimizations = [tf.lite.Optimize.DEFAULT]

# Set input/output types
converter.target_spec.supported_types = [tf.float32]
converter.inference_input_type = tf.float32
converter.inference_output_type = tf.float32

# Convert
tflite_model = converter.convert()

# Save
with open(OUTPUT_PATH, 'wb') as f:
    f.write(tflite_model)

print(f"✓ TensorFlow Lite model saved: {OUTPUT_PATH}")
print(f"   File size: {len(tflite_model) / (1024 * 1024):.2f} MB")

# Step 5: Verify the model
print("\n✅ Step 5: Verifying TFLite model...")
interpreter = tf.lite.Interpreter(model_path=OUTPUT_PATH)
interpreter.allocate_tensors()

# Get input and output details
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

print(f"   Input shape: {input_details[0]['shape']}")
print(f"   Input type: {input_details[0]['dtype']}")
print(f"   Output shape: {output_details[0]['shape']}")
print(f"   Output type: {output_details[0]['dtype']}")

# Test with dummy input
print("\n🧪 Step 6: Testing with dummy input...")
test_input = np.random.rand(1, 3, INPUT_SIZE, INPUT_SIZE).astype(np.float32)
interpreter.set_tensor(input_details[0]['index'], test_input)
interpreter.invoke()
test_output = interpreter.get_tensor(output_details[0]['index'])
print(f"   Test output shape: {test_output.shape}")
print(f"   Test successful! ✓")

print("\n" + "=" * 60)
print("✅ Conversion completed successfully!")
print("=" * 60)
print(f"\n📥 Download the model:")
print(f"   from google.colab import files")
print(f"   files.download('{OUTPUT_PATH}')")


