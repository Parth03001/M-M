import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Replicates the Python preprocessing pipeline in Dart:
/// 1. Center crop (55% hub region)
/// 2. Light CLAHE on luminance channel
/// 3. Resize to 224x224
class ImagePreprocessor {
  final double cropRatio;
  final int targetSize;
  final double claheClipLimit;

  ImagePreprocessor({
    this.cropRatio = 0.55,
    this.targetSize = 224,
    this.claheClipLimit = 2.0,
  });

  /// Full preprocessing pipeline: crop -> CLAHE -> resize -> normalize to float32 tensor
  /// Returns [1, 3, 224, 224] float32 buffer (NCHW format for EfficientNet)
  Float32List preprocess(Uint8List imageBytes) {
    var image = img.decodeImage(imageBytes);
    if (image == null) throw Exception('Failed to decode image');

    // Step 1: Center crop hub region
    image = _centerCrop(image);

    // Step 2: Light CLAHE on luminance
    image = _applyClahe(image);

    // Step 3: Resize to model input size
    image = img.copyResize(image, width: targetSize, height: targetSize,
        interpolation: img.Interpolation.average);

    // Step 4: Convert to normalized float32 tensor [1, 3, 224, 224]
    return _toNormalizedTensor(image);
  }

  /// Returns preprocessed image as JPEG bytes (for display/debug)
  Uint8List preprocessForDisplay(Uint8List imageBytes) {
    var image = img.decodeImage(imageBytes);
    if (image == null) throw Exception('Failed to decode image');

    image = _centerCrop(image);
    image = _applyClahe(image);
    image = img.copyResize(image, width: targetSize, height: targetSize,
        interpolation: img.Interpolation.average);

    return Uint8List.fromList(img.encodeJpg(image, quality: 95));
  }

  img.Image _centerCrop(img.Image image) {
    final w = image.width;
    final h = image.height;
    final marginX = (w * (1 - cropRatio) / 2).toInt();
    final marginY = (h * (1 - cropRatio) / 2).toInt();
    return img.copyCrop(image,
        x: marginX,
        y: marginY,
        width: w - 2 * marginX,
        height: h - 2 * marginY);
  }

  /// Simplified CLAHE: histogram equalization on luminance channel.
  /// Full tile-based CLAHE is complex; this approximation normalizes
  /// lighting similarly to the Python version for factory images.
  img.Image _applyClahe(img.Image image) {
    // Convert to grayscale luminance, equalize, then blend back
    final width = image.width;
    final height = image.height;
    final result = img.Image(width: width, height: height);

    // Extract luminance values
    final lum = List<int>.filled(width * height, 0);
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = image.getPixel(x, y);
        // ITU-R BT.601 luminance
        final l = (0.299 * pixel.r + 0.587 * pixel.g + 0.114 * pixel.b).round().clamp(0, 255);
        lum[y * width + x] = l;
      }
    }

    // Build histogram and CDF for equalization
    final hist = List<int>.filled(256, 0);
    for (final v in lum) {
      hist[v]++;
    }
    final cdf = List<int>.filled(256, 0);
    cdf[0] = hist[0];
    for (int i = 1; i < 256; i++) {
      cdf[i] = cdf[i - 1] + hist[i];
    }
    final cdfMin = cdf.firstWhere((v) => v > 0, orElse: () => 0);
    final total = width * height;

    // Map luminance through equalized CDF
    final lumMap = List<int>.filled(256, 0);
    for (int i = 0; i < 256; i++) {
      if (total - cdfMin > 0) {
        lumMap[i] = (((cdf[i] - cdfMin) / (total - cdfMin)) * 255).round().clamp(0, 255);
      }
    }

    // Blend: mix original with equalized (light CLAHE effect)
    // clipLimit controls blend strength: 2.0 -> ~40% equalized
    final blendFactor = (claheClipLimit / 5.0).clamp(0.0, 1.0);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = image.getPixel(x, y);
        final origLum = lum[y * width + x];
        final eqLum = lumMap[origLum];

        // Scale RGB channels by luminance ratio
        final scale = origLum > 0
            ? (origLum + blendFactor * (eqLum - origLum)) / origLum
            : 1.0;

        final r = (pixel.r * scale).round().clamp(0, 255);
        final g = (pixel.g * scale).round().clamp(0, 255);
        final b = (pixel.b * scale).round().clamp(0, 255);

        result.setPixelRgb(x, y, r, g, b);
      }
    }

    return result;
  }

  /// Convert image to [1, 3, 224, 224] float32 tensor with ImageNet normalization
  Float32List _toNormalizedTensor(img.Image image) {
    const mean = [0.485, 0.456, 0.406];
    const std = [0.229, 0.224, 0.225];

    final tensor = Float32List(1 * 3 * targetSize * targetSize);
    final channelSize = targetSize * targetSize;

    for (int y = 0; y < targetSize; y++) {
      for (int x = 0; x < targetSize; x++) {
        final pixel = image.getPixel(x, y);
        final idx = y * targetSize + x;

        // NCHW format: [batch, channel, height, width]
        tensor[0 * channelSize + idx] = (pixel.r / 255.0 - mean[0]) / std[0]; // R
        tensor[1 * channelSize + idx] = (pixel.g / 255.0 - mean[1]) / std[1]; // G
        tensor[2 * channelSize + idx] = (pixel.b / 255.0 - mean[2]) / std[2]; // B
      }
    }

    return tensor;
  }
}
