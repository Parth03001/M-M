import 'package:flutter/material.dart';
import 'scanner_screen.dart';
import 'history_screen.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart';
import 'capture_screen.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class ConnectorListScreen extends StatefulWidget {
  final String? scannedBarcode;
  final String? vin;
  final String? modelName;

  const ConnectorListScreen({
    Key? key,
    this.scannedBarcode,
    this.vin,
    this.modelName,
  }) : super(key: key);

  @override
  _ConnectorListScreenState createState() => _ConnectorListScreenState();
}

class _ConnectorListScreenState extends State<ConnectorListScreen> {
  int _selectedIndex = 0; // Home is selected

  // List of connectors
  final List<String> connectors = [
    'Lite Connector A',
    'Lite Connector B',
    'Lite Connector C',
    'Lite Connector D',
    'Lite Connector E',
  ];

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
            // Top Header with back button and logo
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFFDC143C), // Crimson red
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'LITE CONNECTOR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            if (widget.modelName != null &&
                                widget.modelName!.isNotEmpty)
                              Text(
                                widget.modelName!,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    // Logo in white circle
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

            // Title Bar - LITE CONNECTOR
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFD4AF37), // Golden-yellow
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color: Color(0xFFD4AF37), // Golden-yellow
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'LITE CONNECTOR',
                    style: TextStyle(
                      color: Color(0xFFDC143C), // Crimson red
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  if (widget.modelName != null &&
                      widget.modelName!.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Text(
                      'Model: ${widget.modelName}',
                      style: TextStyle(
                        color: Color(0xFFDC143C).withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                  if (widget.vin != null && widget.vin!.isNotEmpty) ...[
                    SizedBox(height: 2),
                    Text(
                      'VIN: ${widget.vin}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Connector List
            Expanded(
              child: Container(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: connectors.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        onPressed: () {
                          // Open capture screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CaptureScreen(
                                connectorName: connectors[index],
                              ),
                            ),
                          ).then((result) {
                            // Handle result if needed
                            if (result != null) {
                              // Result was saved, you can show a message or update UI
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Result saved for ${result['connector']}'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: Color(0xFFD4AF37), // Golden-yellow
                              width: 1,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              connectors[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFDC143C), // Crimson red
                              ),
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Color(0xFFDC143C), // Crimson red
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ScannerScreen()),
                  );
                } else if (index == 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                } else if (index == 2) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ScannerScreen()),
                  );
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
}
