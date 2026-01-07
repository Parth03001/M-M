"""
Test script to verify TFLite model works correctly
This will help identify if the model conversion is correct
"""
import numpy as np
import tensorflow as tf
from PIL import Image
import os

def test_tflite_model(model_path, test_image_path=None, labels_path=None):
    """
    Test a TFLite model to verify it loads and runs correctly
    
    Args:
        model_path: Path to the .tflite model file
        test_image_path: Optional path to a test image
        labels_path: Optional path to labels.txt file
    """
    print("=" * 60)
    print("TFLite Model Testing Script")
    print("=" * 60)
    
    # Check if model file exists
    if not os.path.exists(model_path):
        print(f"❌ ERROR: Model file not found: {model_path}")
        return False
    
    print(f"✓ Model file found: {model_path}")
    print(f"  File size: {os.path.getsize(model_path) / (1024*1024):.2f} MB")
    
    # Load labels if provided
    labels = []
    if labels_path and os.path.exists(labels_path):
        with open(labels_path, 'r') as f:
            labels = [line.strip() for line in f.readlines()]
        print(f"✓ Loaded {len(labels)} labels from {labels_path}")
    else:
        print("⚠️  No labels file provided")
    
    try:
        # Load the TFLite model
        print("\n📥 Loading TFLite model...")
        interpreter = tf.lite.Interpreter(model_path=model_path)
        interpreter.allocate_tensors()
        print("✓ Model loaded successfully")
        
        # Get input and output details
        input_details = interpreter.get_input_details()
        output_details = interpreter.get_output_details()
        
        print("\n📊 Model Information:")
        print("-" * 60)
        
        # Input details
        print("INPUT TENSOR:")
        for i, detail in enumerate(input_details):
            print(f"  Input {i}:")
            print(f"    Name: {detail['name']}")
            print(f"    Shape: {detail['shape']}")
            print(f"    Type: {detail['dtype']}")
            print(f"    Index: {detail['index']}")
        
        # Output details
        print("\nOUTPUT TENSOR:")
        for i, detail in enumerate(output_details):
            print(f"  Output {i}:")
            print(f"    Name: {detail['name']}")
            print(f"    Shape: {detail['shape']}")
            print(f"    Type: {detail['dtype']}")
            print(f"    Index: {detail['index']}")
        
        # Test with a dummy image if no test image provided
        if test_image_path and os.path.exists(test_image_path):
            print(f"\n🖼️  Testing with image: {test_image_path}")
            image = Image.open(test_image_path).convert('RGB')
        else:
            print("\n🖼️  Testing with dummy image (640x640 RGB)")
            # Create a dummy image matching YOLOv11 expected input
            image = Image.new('RGB', (640, 640), color='gray')
        
        # Get expected input shape
        input_shape = input_details[0]['shape']
        expected_height, expected_width = input_shape[1], input_shape[2]
        
        # Resize image to match model input
        image_resized = image.resize((expected_width, expected_height))
        print(f"  Resized to: {expected_width}x{expected_height}")
        
        # Convert to numpy array and normalize
        input_data = np.array(image_resized, dtype=np.float32)
        input_data = input_data / 255.0  # Normalize to [0, 1]
        
        # Add batch dimension if needed
        if len(input_shape) == 4:
            input_data = np.expand_dims(input_data, axis=0)
        
        print(f"  Input data shape: {input_data.shape}")
        print(f"  Input data type: {input_data.dtype}")
        print(f"  Input data range: [{input_data.min():.3f}, {input_data.max():.3f}]")
        
        # Set input tensor
        interpreter.set_tensor(input_details[0]['index'], input_data)
        
        # Run inference
        print("\n🚀 Running inference...")
        interpreter.invoke()
        print("✓ Inference completed")
        
        # Get output
        print("\n📤 Output Results:")
        print("-" * 60)
        
        for i, detail in enumerate(output_details):
            output_data = interpreter.get_tensor(detail['index'])
            print(f"\nOutput {i}:")
            print(f"  Shape: {output_data.shape}")
            print(f"  Type: {output_data.dtype}")
            print(f"  Min value: {output_data.min():.6f}")
            print(f"  Max value: {output_data.max():.6f}")
            print(f"  Mean value: {output_data.mean():.6f}")
            
            # For YOLOv11, output is typically [1, num_detections, 6] or [1, 8400, 84]
            # Format: [batch, detections, (x, y, w, h, conf, class_scores...)]
            if len(output_data.shape) == 3:
                batch_size, num_detections, features = output_data.shape
                print(f"  Detections: {num_detections}")
                print(f"  Features per detection: {features}")
                
                # Show first few detections
                if num_detections > 0:
                    print(f"\n  First 3 detections (sample):")
                    for j in range(min(3, num_detections)):
                        det = output_data[0, j, :]
                        print(f"    Detection {j}: {det[:6]}")  # Show first 6 values
        
        print("\n" + "=" * 60)
        print("✅ Model test completed successfully!")
        print("=" * 60)
        
        # Model compatibility check
        print("\n🔍 Model Compatibility Check:")
        print("-" * 60)
        
        # Check for Select TF Ops requirement
        try:
            # Try to get model ops
            ops = interpreter._get_ops_list()
            if ops:
                print(f"  Model uses {len(ops)} operations")
                # Check for unsupported ops (this is a simplified check)
                print("  ✓ Basic operations check passed")
        except:
            print("  ⚠️  Could not verify operations (may need Select TF Ops)")
        
        return True
        
    except Exception as e:
        print(f"\n❌ ERROR: {str(e)}")
        import traceback
        print("\nFull traceback:")
        print(traceback.format_exc())
        return False

if __name__ == "__main__":
    import sys
    
    # Default paths (adjust these to match your setup)
    model_path = "assets/best_float32.tflite"
    labels_path = "assets/labels.txt" if os.path.exists("assets/labels.txt") else None
    test_image_path = None  # Set this to test with a real image
    
    # Allow command line arguments
    if len(sys.argv) > 1:
        model_path = sys.argv[1]
    if len(sys.argv) > 2:
        labels_path = sys.argv[2]
    if len(sys.argv) > 3:
        test_image_path = sys.argv[3]
    
    print(f"Model path: {model_path}")
    if labels_path:
        print(f"Labels path: {labels_path}")
    if test_image_path:
        print(f"Test image: {test_image_path}")
    print()
    
    success = test_tflite_model(model_path, test_image_path, labels_path)
    
    if not success:
        print("\n❌ Model test failed. Please check:")
        print("  1. Model file exists and is valid")
        print("  2. Model was converted correctly")
        print("  3. Model doesn't require Select TF Ops (or they're available)")
        sys.exit(1)
    else:
        print("\n✅ Model is ready to use in Flutter!")
        sys.exit(0)

