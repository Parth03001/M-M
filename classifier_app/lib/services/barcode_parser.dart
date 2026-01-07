/// Service to parse barcode data and extract VIN and Model Name
class BarcodeParser {
  /// Parse barcode string to extract VIN and Model Name
  /// 
  /// This is a basic parser. You may need to customize based on your barcode format.
  /// Common formats:
  /// - "VIN:ABC123|MODEL:ModelName"
  /// - JSON format
  /// - CSV format
  /// - Custom delimiter format
  static Map<String, String> parseBarcode(String barcode) {
    String vin = '';
    String modelName = '';

    // Try different parsing strategies
    barcode = barcode.trim();

    // Strategy 1: Check for VIN: and MODEL: pattern
    if (barcode.contains('VIN:') || barcode.contains('MODEL:')) {
      final parts = barcode.split('|');
      for (final part in parts) {
        final trimmed = part.trim();
        if (trimmed.toUpperCase().startsWith('VIN:')) {
          vin = trimmed.substring(4).trim();
        } else if (trimmed.toUpperCase().startsWith('MODEL:')) {
          modelName = trimmed.substring(6).trim();
        }
      }
    }
    // Strategy 2: Check for JSON format
    else if (barcode.startsWith('{') && barcode.contains('"')) {
      try {
        // Try to parse as JSON-like format
        if (barcode.contains('"vin"') || barcode.contains('"VIN"')) {
          final vinMatch = RegExp(r'"vin"\s*:\s*"([^"]+)"', caseSensitive: false)
              .firstMatch(barcode);
          if (vinMatch != null) {
            vin = vinMatch.group(1) ?? '';
          }
        }
        if (barcode.contains('"model"') || barcode.contains('"MODEL"')) {
          final modelMatch = RegExp(r'"model"\s*:\s*"([^"]+)"', caseSensitive: false)
              .firstMatch(barcode);
          if (modelMatch != null) {
            modelName = modelMatch.group(1) ?? '';
          }
        }
      } catch (e) {
        // JSON parsing failed, continue to other strategies
      }
    }
    // Strategy 3: Check for CSV format (comma-separated)
    else if (barcode.contains(',')) {
      final parts = barcode.split(',');
      if (parts.length >= 2) {
        vin = parts[0].trim();
        modelName = parts[1].trim();
      }
    }
    // Strategy 4: VIN is typically 17 characters, try to extract it
    else if (barcode.length >= 17) {
      // Try to find a 17-character alphanumeric sequence (standard VIN length)
      final vinPattern = RegExp(r'[A-HJ-NPR-Z0-9]{17}');
      final vinMatch = vinPattern.firstMatch(barcode.toUpperCase());
      if (vinMatch != null) {
        vin = vinMatch.group(0) ?? '';
        // Model name might be the rest or after the VIN
        final vinIndex = barcode.toUpperCase().indexOf(vin);
        if (vinIndex >= 0 && barcode.length > vinIndex + 17) {
          modelName = barcode.substring(vinIndex + 17).trim();
        }
      } else {
        // If no standard VIN found, treat first part as VIN
        final spaceIndex = barcode.indexOf(' ');
        if (spaceIndex > 0) {
          vin = barcode.substring(0, spaceIndex);
          modelName = barcode.substring(spaceIndex + 1);
        } else {
          vin = barcode;
        }
      }
    }
    // Strategy 5: If barcode looks like it might be just VIN or just model
    else {
      // Default: treat entire barcode as VIN if it's alphanumeric
      if (RegExp(r'^[A-Z0-9]+$', caseSensitive: false).hasMatch(barcode)) {
        vin = barcode;
      } else {
        modelName = barcode;
      }
    }

    // Clean up extracted values
    vin = vin.trim();
    modelName = modelName.trim();

    // If still empty, use the barcode as fallback
    if (vin.isEmpty && modelName.isEmpty) {
      // Try to split by common delimiters
      final delimiters = ['|', ';', '-', '_'];
      for (final delimiter in delimiters) {
        if (barcode.contains(delimiter)) {
          final parts = barcode.split(delimiter);
          if (parts.length >= 2) {
            vin = parts[0].trim();
            modelName = parts.sublist(1).join(delimiter).trim();
            break;
          }
        }
      }
    }

    return {
      'vin': vin,
      'modelName': modelName,
    };
  }
}

