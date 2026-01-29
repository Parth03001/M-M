"""
Export trained EfficientNet-B0 model to TFLite for Flutter deployment.

Usage:
    python export_to_tflite.py --checkpoint wheel_model_output/best_model.pth --output wheel_efficientnet.tflite
"""

import torch
import torch.nn as nn
import argparse
import json
from pathlib import Path


def build_model(num_classes=4, dropout=0.3):
    from torchvision.models import efficientnet_b0
    model = efficientnet_b0(weights=None)
    in_features = model.classifier[1].in_features
    model.classifier = nn.Sequential(
        nn.Dropout(p=dropout),
        nn.Linear(in_features, num_classes)
    )
    return model


def export_tflite(checkpoint_path, output_path, num_classes=4):
    try:
        import onnx
        from onnx_tf.backend import prepare
        import tensorflow as tf
    except ImportError:
        print("Install required packages:")
        print("  pip install onnx onnx-tf tensorflow")
        return

    # Load PyTorch model
    model = build_model(num_classes=num_classes)
    state_dict = torch.load(checkpoint_path, map_location='cpu', weights_only=True)
    model.load_state_dict(state_dict)
    model.eval()

    # Step 1: PyTorch -> ONNX
    onnx_path = output_path.replace('.tflite', '.onnx')
    dummy_input = torch.randn(1, 3, 224, 224)
    torch.onnx.export(
        model, dummy_input, onnx_path,
        input_names=['input'],
        output_names=['output'],
        opset_version=13,
        dynamic_axes=None
    )
    print(f"ONNX saved: {onnx_path}")

    # Step 2: ONNX -> TF SavedModel
    onnx_model = onnx.load(onnx_path)
    tf_rep = prepare(onnx_model)
    tf_path = output_path.replace('.tflite', '_tf')
    tf_rep.export_graph(tf_path)
    print(f"TF SavedModel saved: {tf_path}")

    # Step 3: TF SavedModel -> TFLite
    converter = tf.lite.TFLiteConverter.from_saved_model(tf_path)
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    tflite_model = converter.convert()

    with open(output_path, 'wb') as f:
        f.write(tflite_model)
    print(f"TFLite saved: {output_path} ({len(tflite_model) / 1024 / 1024:.1f} MB)")


def export_onnx_only(checkpoint_path, output_path, num_classes=4):
    """Simpler export: just ONNX. Convert to TFLite using external tools if needed."""
    model = build_model(num_classes=num_classes)
    state_dict = torch.load(checkpoint_path, map_location='cpu', weights_only=True)
    model.load_state_dict(state_dict)
    model.eval()

    onnx_path = output_path.replace('.tflite', '.onnx')
    dummy_input = torch.randn(1, 3, 224, 224)
    torch.onnx.export(
        model, dummy_input, onnx_path,
        input_names=['input'],
        output_names=['output'],
        opset_version=13,
    )
    print(f"ONNX saved: {onnx_path}")
    print("Convert to TFLite with: python -m tf2onnx.convert --onnx model.onnx --output model.tflite")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--checkpoint", default="wheel_model_output/best_model.pth")
    parser.add_argument("--output", default="wheel_efficientnet.tflite")
    parser.add_argument("--num-classes", type=int, default=4)
    parser.add_argument("--onnx-only", action="store_true", help="Only export ONNX (skip TFLite)")
    args = parser.parse_args()

    if args.onnx_only:
        export_onnx_only(args.checkpoint, args.output, args.num_classes)
    else:
        export_tflite(args.checkpoint, args.output, args.num_classes)
