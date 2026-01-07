import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'connector_list_screen.dart';
import 'history_screen.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart';
import 'barcode_scan_result_screen.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../services/database_service.dart';
import '../services/detection_result.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  int _selectedIndex = 0; // Home is selected
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );
  String? _scannedBarcode;
  bool _isProcessing = false;
  bool _hasNavigated = false; // Prevent multiple navigations
  List<BoundingBox> _boundingBoxes = [];

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _handleBarcodeDetect(BarcodeCapture barcodeCapture) async {
    if (_isProcessing || barcodeCapture.barcodes.isEmpty || _hasNavigated)
      return;

    final barcode = barcodeCapture.barcodes.first;
    if (barcode.rawValue == null) return;

    // Avoid processing the same barcode multiple times
    if (_scannedBarcode == barcode.rawValue) return;

    setState(() {
      _isProcessing = true;
      _scannedBarcode = barcode.rawValue;
      _hasNavigated = true; // Prevent multiple navigations
    });

    try {
      // Save barcode scan to database
      final dbService = DatabaseService();
      final activeSession = await dbService.database.getActiveSession();

      await dbService.createBarcodeScan(
        barcode: barcode.rawValue!,
        barcodeType: barcode.type.name,
        scannedData: barcode.displayValue,
        userId: activeSession?.userId,
      );

      // Navigate to scan result screen to show ALL barcode data
      await Future.delayed(Duration(milliseconds: 500));

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BarcodeScanResultScreen(
              barcodeData: barcode,
            ),
          ),
        ).then((_) {
          // Reset navigation flag when returning from result screen
          if (mounted) {
            setState(() {
              _hasNavigated = false;
              _scannedBarcode = null;
            });
          }
        });
      }
    } catch (e) {
      print('Error processing barcode: $e');
      if (mounted) {
        setState(() {
          _hasNavigated = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing barcode: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFFFF5F5), // Very light white with red tint
            ],
          ),
        ),
        child: Column(
          children: [
            // Top Header - SCAN BARCODE with Logo
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFFDC143C), // Crimson red
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'SCAN BARCODE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(width: 20),
                    // Logo in white circle - moved a little right
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFFDC143C), // Red border
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 25,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scanner Area with Camera
            Expanded(
              child: Container(
                child: Stack(
                  children: [
                    // Camera Preview
                    Positioned.fill(
                      child: Stack(
                        children: [
                          MobileScanner(
                            controller: _scannerController,
                            onDetect: _handleBarcodeDetect,
                          ),
                          // Scanner frame overlay
                          Center(
                            child: Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFFDC143C),
                                  width: 2,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  // Corner brackets
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              color: Color(0xFFDC143C),
                                              width: 3),
                                          left: BorderSide(
                                              color: Color(0xFFDC143C),
                                              width: 3),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              color: Color(0xFFDC143C),
                                              width: 3),
                                          right: BorderSide(
                                              color: Color(0xFFDC143C),
                                              width: 3),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Color(0xFFDC143C),
                                              width: 3),
                                          left: BorderSide(
                                              color: Color(0xFFDC143C),
                                              width: 3),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Color(0xFFDC143C),
                                              width: 3),
                                          right: BorderSide(
                                              color: Color(0xFFDC143C),
                                              width: 3),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bounding boxes overlay
                    if (_boundingBoxes.isNotEmpty)
                      ..._buildBoundingBoxesOverlay(),
                    // Processing indicator
                    if (_isProcessing)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFDC143C),
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Processing...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Action Buttons Section
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  // Manual scan button (optional - barcode auto-detects)
                  if (_scannedBarcode != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Scanned: $_scannedBarcode',
                        style: TextStyle(
                          color: Color(0xFFDC143C),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isProcessing
                          ? null
                          : () {
                              // Manually navigate if needed
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConnectorListScreen(),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFDC143C), // Crimson red
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'VIEW CONNECTORS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Navigation Bar
            CustomBottomNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                if (index == 0) {
                  // Already on scanner screen (Home)
                } else if (index == 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                } else if (index == 2) {
                  // Already on scanner screen (Center action button)
                } else if (index == 3) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryScreen()),
                  );
                } else if (index == 4) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBoundingBoxesOverlay() {
    return _boundingBoxes.map((box) {
      final color = box.className == 'OK' ? Colors.green : Colors.red;

      // Scale bounding box coordinates to screen size
      // Assuming camera preview fills the screen
      final x1 = box.x1;
      final y1 = box.y1;
      final x2 = box.x2;
      final y2 = box.y2;
      final width = x2 - x1;
      final height = y2 - y1;

      return Positioned(
        left: x1,
        top: y1,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(
              color: color,
              width: 2,
            ),
            color: color.withOpacity(0.1),
          ),
          child: Stack(
            children: [
              // Label at top
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  child: Text(
                    '${box.className} ${(box.confidence * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

// Custom painter for dashed scan line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFFDC143C).withOpacity(0.5) // Crimson red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dashWidth = 10.0;
    final dashSpace = 5.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
