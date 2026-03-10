import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';
import 'wheel_selection_screen.dart';
import 'history_screen.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  bool _isProcessing = false;

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null && code.length >= 17) {
        setState(() => _isProcessing = true);
        
        final String vin = code.substring(0, 17);
        final db = context.read<AppDatabase>();
        
        final id = await db.insertVinScan(
          VinScansCompanion.insert(vin: vin)
        );

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WheelSelectionScreen(
                vinId: id,
                vin: vin,
              ),
            ),
          ).then((_) => setState(() => _isProcessing = false));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan VIN QR Code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _onDetect,
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  // Corner markers for visual feedback
                  Positioned(top: 0, left: 0, child: _buildCorner(top: true, left: true)),
                  Positioned(top: 0, right: 0, child: _buildCorner(top: true, left: false)),
                  Positioned(bottom: 0, left: 0, child: _buildCorner(top: false, left: true)),
                  Positioned(bottom: 0, right: 0, child: _buildCorner(top: false, left: false)),
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Text(
              'Align VIN QR code within the square',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildCorner({required bool top, required bool left}) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border(
          top: top ? const BorderSide(color: Colors.blue, width: 4) : BorderSide.none,
          bottom: !top ? const BorderSide(color: Colors.blue, width: 4) : BorderSide.none,
          left: left ? const BorderSide(color: Colors.blue, width: 4) : BorderSide.none,
          right: !left ? const BorderSide(color: Colors.blue, width: 4) : BorderSide.none,
        ),
      ),
    );
  }
}
