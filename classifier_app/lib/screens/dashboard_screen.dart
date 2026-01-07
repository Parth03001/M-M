import 'package:flutter/material.dart';
import 'scanner_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../services/database_service.dart';
import '../database/database.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 1; // Dashboard is selected
  final DatabaseService _dbService = DatabaseService();
  bool _isLoading = true;
  
  // Analytics data
  int _totalDetections = 0;
  int _okCount = 0;
  int _notOkCount = 0;
  double _averageConfidence = 0.0;
  double _successRate = 0.0;
  List<Detection> _recentDetections = [];
  Map<String, int> _connectorStats = {};
  List<Map<String, dynamic>> _dailyStats = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get active user session
      final activeSession = await _dbService.database.getActiveSession();
      final userId = activeSession?.userId;

      // Fetch all detections
      final detections = await _dbService.getDetections(userId: userId);
      
      // Calculate statistics
      _totalDetections = detections.length;
      _okCount = detections.where((d) => d.className == 'OK').length;
      _notOkCount = detections.where((d) => d.className != 'OK').length;
      
      // Calculate average confidence
      if (detections.isNotEmpty) {
        final totalConfidence = detections.fold<double>(
          0.0,
          (sum, d) => sum + d.confidence,
        );
        _averageConfidence = totalConfidence / detections.length;
      }

      // Calculate success rate
      _successRate = _totalDetections > 0 ? (_okCount / _totalDetections) * 100 : 0.0;

      // Get recent detections (last 5)
      _recentDetections = detections.take(5).toList();

      // Calculate connector statistics
      _connectorStats = {};
      for (final detection in detections) {
        final connector = await _dbService.getConnectorById(detection.connectorId);
        final connectorName = connector?.name ?? 'Unknown';
        _connectorStats[connectorName] = (_connectorStats[connectorName] ?? 0) + 1;
      }

      // Calculate daily statistics (last 7 days)
      _dailyStats = _calculateDailyStats(detections);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading dashboard data: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading dashboard: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Map<String, dynamic>> _calculateDailyStats(List<Detection> detections) {
    final now = DateTime.now();
    final dailyMap = <String, Map<String, int>>{};

    // Initialize last 7 days
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      dailyMap[dateKey] = {'OK': 0, 'NOT_OK': 0, 'total': 0};
    }

    // Count detections per day
    for (final detection in detections) {
      final date = detection.detectedAt;
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      if (dailyMap.containsKey(dateKey)) {
        dailyMap[dateKey]!['total'] = (dailyMap[dateKey]!['total'] ?? 0) + 1;
        if (detection.className == 'OK') {
          dailyMap[dateKey]!['OK'] = (dailyMap[dateKey]!['OK'] ?? 0) + 1;
        } else {
          dailyMap[dateKey]!['NOT_OK'] = (dailyMap[dateKey]!['NOT_OK'] ?? 0) + 1;
        }
      }
    }

    return dailyMap.entries.map((entry) {
      return {
        'date': entry.key,
        'ok': entry.value['OK'] ?? 0,
        'notOk': entry.value['NOT_OK'] ?? 0,
        'total': entry.value['total'] ?? 0,
      };
    }).toList();
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
        child: SafeArea(
          child: Column(
            children: [
              // Top Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Color(0xFFDC143C), // Crimson red
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          'DASHBOARD',
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

              // Dashboard Content
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFDC143C),
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadDashboardData,
                        color: Color(0xFFDC143C),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Statistics Cards Row
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      title: 'Total Detections',
                                      value: '$_totalDetections',
                                      icon: Icons.assessment,
                                      color: Color(0xFFDC143C),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: _buildStatCard(
                                      title: 'Success Rate',
                                      value: '${_successRate.toStringAsFixed(1)}%',
                                      icon: Icons.trending_up,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),

                              // OK vs NOT OK Cards
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      title: 'OK',
                                      value: '$_okCount',
                                      icon: Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: _buildStatCard(
                                      title: 'NOT OK',
                                      value: '$_notOkCount',
                                      icon: Icons.cancel,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),

                              // Average Confidence Card
                              _buildStatCard(
                                title: 'Average Confidence',
                                value: '${(_averageConfidence * 100).toStringAsFixed(1)}%',
                                icon: Icons.analytics,
                                color: Color(0xFFD4AF37),
                                fullWidth: true,
                              ),
                              SizedBox(height: 20),

                              // Daily Statistics Chart
                              if (_dailyStats.isNotEmpty) ...[
                                Text(
                                  'Last 7 Days Activity',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFDC143C),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Color(0xFFD4AF37),
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
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: _dailyStats.map((stat) {
                                      final maxTotal = _dailyStats
                                          .map((s) => s['total'] as int)
                                          .reduce((a, b) => a > b ? a : b);
                                      final height = maxTotal > 0
                                          ? (stat['total'] as int) / maxTotal * 160
                                          : 0.0;
                                      return Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 4),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Expanded(
                                                child: Stack(
                                                  alignment: Alignment.bottomCenter,
                                                  children: [
                                                    // Total bar (background)
                                                    Container(
                                                      width: double.infinity,
                                                      height: height > 0 ? height : 0,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius: BorderRadius.vertical(
                                                          top: Radius.circular(4),
                                                        ),
                                                      ),
                                                    ),
                                                    // OK bar
                                                    if (stat['ok'] as int > 0)
                                                      Container(
                                                        width: double.infinity,
                                                        height: maxTotal > 0
                                                            ? (stat['ok'] as int) / maxTotal * 160
                                                            : 0.0,
                                                        decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius: BorderRadius.vertical(
                                                            top: Radius.circular(4),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                _formatDate(stat['date'] as String),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey[600],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                '${stat['total']}',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFDC143C),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],

                              // Connector Statistics
                              if (_connectorStats.isNotEmpty) ...[
                                Text(
                                  'Connector Statistics',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFDC143C),
                                  ),
                                ),
                                SizedBox(height: 12),
                                ..._connectorStats.entries.map((entry) {
                                  final percentage = _totalDetections > 0
                                      ? (entry.value / _totalDetections) * 100
                                      : 0.0;
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Color(0xFFD4AF37),
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                entry.key,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFFDC143C),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${entry.value}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFDC143C),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(
                                            value: percentage / 100,
                                            backgroundColor: Colors.grey[200],
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Color(0xFFDC143C),
                                            ),
                                            minHeight: 8,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '${percentage.toStringAsFixed(1)}%',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                                SizedBox(height: 20),
                              ],

                              // Recent Detections
                              Text(
                                'Recent Detections',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFDC143C),
                                ),
                              ),
                              SizedBox(height: 12),
                              if (_recentDetections.isEmpty)
                                Container(
                                  padding: EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Color(0xFFD4AF37),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'No detections yet',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                ..._recentDetections.map((detection) {
                                  return FutureBuilder<Connector?>(
                                    future: _dbService
                                        .getConnectorById(detection.connectorId),
                                    builder: (context, snapshot) {
                                      final connectorName = snapshot.hasData
                                          ? snapshot.data!.name
                                          : 'Connector ${detection.connectorId}';
                                      final isOk = detection.className == 'OK';
                                      final dateTime = detection.detectedAt;
                                      final dateStr =
                                          '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
                                      final timeStr =
                                          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

                                      return Container(
                                        margin: EdgeInsets.only(bottom: 12),
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Color(0xFFD4AF37),
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.05),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: isOk
                                                    ? Colors.green
                                                        .withOpacity(0.1)
                                                    : Colors.red.withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                isOk
                                                    ? Icons.check_circle
                                                    : Icons.cancel,
                                                color:
                                                    isOk ? Colors.green : Colors.red,
                                                size: 24,
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    connectorName,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color(0xFFDC143C),
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    '$dateStr $timeStr',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        detection.className,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: isOk
                                                              ? Colors.green
                                                              : Colors.red,
                                                        ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        '${(detection.confidence * 100).toStringAsFixed(1)}%',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }),
                            ],
                          ),
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
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFD4AF37),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: color,
                size: 28,
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFDC143C),
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        final monthNames = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ];
        return '$day\n${monthNames[month - 1]}';
      }
    } catch (e) {
      // Ignore
    }
    return dateStr;
  }
}

