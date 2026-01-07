import 'package:flutter/material.dart';
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

                                  return Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color:
                                            Color(0xFFD4AF37), // Golden-yellow
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
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
                                      trailing: Icon(
                                        Icons.chevron_right,
                                        color: Color(0xFFDC143C), // Crimson red
                                      ),
                                      onTap: () {
                                        // TODO: Show details (image, bounding box, etc.)
                                      },
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
}
