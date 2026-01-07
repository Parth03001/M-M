import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'scanner_screen.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../services/database_service.dart';
import '../database/database.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedIndex = 1; // History is selected
  List<Detection> _detections = [];
  bool _isLoading = true;
  final DatabaseService _dbService = DatabaseService();
  Set<int> _expandedItems = {}; // Track which items are expanded

  @override
  void initState() {
    super.initState();
    _loadDetections();
  }

  Future<void> _loadDetections() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get active user session to filter by user if needed
      final activeSession = await _dbService.database.getActiveSession();
      final userId = activeSession?.userId;

      // Fetch all detections (or filter by userId if needed)
      final detections = await _dbService.getDetections(
        userId: userId,
      );

      setState(() {
        _detections = detections;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading detections: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading history: $e'),
            backgroundColor: Colors.red,
          ),
        );
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
                        child: Text(
                          'HISTORY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
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

            // History List
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFDC143C),
                        ),
                      ),
                    )
                  : _detections.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                size: 80,
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No History',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Your detection history will appear here',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadDetections,
                          color: Color(0xFFDC143C),
                          child: ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: _detections.length,
                            itemBuilder: (context, index) {
                              return FutureBuilder<Connector?>(
                                future: _dbService.getConnectorById(
                                    _detections[index].connectorId),
                                builder: (context, snapshot) {
                                  final detection = _detections[index];
                                  final connectorName = snapshot.hasData
                                      ? snapshot.data!.name
                                      : 'Connector ${detection.connectorId}';
                                  final dateTime = detection.detectedAt;
                                  final dateStr =
                                      '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
                                  final hour = dateTime.hour > 12
                                      ? dateTime.hour - 12
                                      : (dateTime.hour == 0
                                          ? 12
                                          : dateTime.hour);
                                  final period =
                                      dateTime.hour >= 12 ? 'PM' : 'AM';
                                  final timeStr =
                                      '${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period';
                                  final isSuccess = detection.className == 'OK';
                                  final isExpanded = _expandedItems.contains(detection.id);

                                  return Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFFDC143C).withOpacity(0.08),
                                          blurRadius: 10,
                                          offset: Offset(0, 3),
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: isSuccess
                                                  ? Colors.green.withOpacity(0.1)
                                                  : Colors.red.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              isSuccess
                                                  ? Icons.check_circle
                                                  : Icons.cancel,
                                              color: isSuccess
                                                  ? Colors.green
                                                  : Colors.red,
                                              size: 24,
                                            ),
                                          ),
                                          title: Text(
                                            connectorName,
                                            style: TextStyle(
                                              color:
                                                  Color(0xFFDC143C), // Crimson red
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 4),
                                              Text(
                                                '$dateStr at $timeStr',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Result: ${detection.className}',
                                                    style: TextStyle(
                                                      color: isSuccess
                                                          ? Colors.green
                                                          : Colors.red,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    '(${(detection.confidence * 100).toStringAsFixed(1)}%)',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          trailing: AnimatedRotation(
                                            duration: Duration(milliseconds: 200),
                                            turns: isExpanded ? 0.25 : 0,
                                            child: Icon(
                                              Icons.chevron_right,
                                              color: Color(0xFFDC143C), // Crimson red
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              if (isExpanded) {
                                                _expandedItems.remove(detection.id);
                                              } else {
                                                _expandedItems.add(detection.id);
                                              }
                                            });
                                          },
                                        ),
                                        // Expandable content - Image with bounding box
                                        if (isExpanded)
                                          detection.imageBytes != null &&
                                                  _hasValidBoundingBox(detection)
                                              ? _buildExpandedContent(detection)
                                              : _buildNoImageMessage(),
                                      ],
                                    ),
                                  );
                                },
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
                  // Already on history screen
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

  bool _hasValidBoundingBox(Detection detection) {
    // Check if bounding box coordinates are valid
    // Valid box should have x2 > x1 and y2 > y1, and all values should be > 0
    return detection.boundingBoxX1 >= 0 &&
        detection.boundingBoxY1 >= 0 &&
        detection.boundingBoxX2 > detection.boundingBoxX1 &&
        detection.boundingBoxY2 > detection.boundingBoxY1;
  }

  Widget _buildNoImageMessage() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Divider(color: Colors.grey[300], thickness: 1),
          SizedBox(height: 16),
          Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey[400],
            size: 48,
          ),
          SizedBox(height: 12),
          Text(
            'No image data available',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'This detection was saved without image data',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(Detection detection) {
    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Divider
            Divider(color: Colors.grey[300], thickness: 1),
            SizedBox(height: 12),

            // Image with bounding box
            Container(
              constraints: BoxConstraints(maxHeight: 400),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return FutureBuilder<Widget>(
                    future: _buildImageWithBoundingBox(
                      detection.imageBytes!,
                      detection.boundingBoxX1,
                      detection.boundingBoxY1,
                      detection.boundingBoxX2,
                      detection.boundingBoxY2,
                      detection.className,
                      detection.confidence,
                      constraints.maxWidth,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFDC143C),
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Error loading image',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        );
                      } else {
                        return snapshot.data ?? SizedBox.shrink();
                      }
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 12),

            // Detection details
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: detection.className == 'OK'
                      ? Colors.green.withOpacity(0.3)
                      : Colors.red.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Classification:',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        detection.className,
                        style: TextStyle(
                          color: detection.className == 'OK'
                              ? Colors.green
                              : Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Confidence:',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${(detection.confidence * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: Color(0xFFDC143C),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> _buildImageWithBoundingBox(
    Uint8List imageBytes,
    double x1,
    double y1,
    double x2,
    double y2,
    String className,
    double confidence,
    double maxWidth,
  ) async {
    // Decode image to get dimensions
    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final imageWidth = image.width.toDouble();
    final imageHeight = image.height.toDouble();

    // Calculate display size maintaining aspect ratio
    final aspectRatio = imageWidth / imageHeight;
    final displayWidth = maxWidth * 0.95;
    final displayHeight = displayWidth / aspectRatio;

    // Calculate scale factors
    final scaleX = displayWidth / imageWidth;
    final scaleY = displayHeight / imageHeight;

    // Scale bounding box coordinates
    final scaledX1 = x1 * scaleX;
    final scaledY1 = y1 * scaleY;
    final scaledX2 = x2 * scaleX;
    final scaledY2 = y2 * scaleY;

    final boxWidth = scaledX2 - scaledX1;
    final boxHeight = scaledY2 - scaledY1;

    final color = className == 'OK' ? Colors.green : Colors.red;

    return Center(
      child: Container(
        width: displayWidth,
        height: displayHeight,
        child: Stack(
          children: [
            // Image
            Image.memory(
              imageBytes,
              width: displayWidth,
              height: displayHeight,
              fit: BoxFit.contain,
            ),
            // Bounding box
            Positioned(
              left: scaledX1,
              top: scaledY1,
              child: Container(
                width: boxWidth,
                height: boxHeight,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: color,
                    width: 1.5,
                  ),
                  color: color.withOpacity(0.1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
