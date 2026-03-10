import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import 'inspection_screen.dart';

class WheelSelectionScreen extends StatefulWidget {
  final int vinId;
  final String vin;

  const WheelSelectionScreen({super.key, required this.vinId, required this.vin});

  @override
  State<WheelSelectionScreen> createState() => _WheelSelectionScreenState();
}

class _WheelSelectionScreenState extends State<WheelSelectionScreen> {
  // Required sequence: Front Right -> Rear Right -> Rear Left -> Front Left
  final List<Map<String, String>> _sequence = [
    {'code': 'FR', 'label': 'Front Right'},
    {'code': 'RR', 'label': 'Rear Right'},
    {'code': 'RL', 'label': 'Rear Left'},
    {'code': 'FL', 'label': 'Front Left'},
  ];

  Map<String, Inspection?> _inspections = {};
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadInspections();
  }

  Future<void> _loadInspections() async {
    final db = context.read<AppDatabase>();
    final results = await db.getInspectionsByVin(widget.vinId);
    setState(() {
      _inspections = {for (var i in results) i.wheelPosition: i};
      
      // Determine the next step in the sequence
      _currentIndex = 0;
      for (int i = 0; i < _sequence.length; i++) {
        if (_inspections.containsKey(_sequence[i]['code'])) {
          _currentIndex = i + 1;
        } else {
          _currentIndex = i;
          break;
        }
      }
      if (_currentIndex > 3) _currentIndex = 3; // Cap at last item
    });
  }

  void _startNextInspection() {
    if (_currentIndex < _sequence.length) {
      final step = _sequence[_currentIndex];
      final nextStep = _currentIndex + 1 < _sequence.length ? _sequence[_currentIndex + 1] : null;

      Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => InspectionScreen(
            vinId: widget.vinId,
            position: step['code']!,
            nextLabel: nextStep?['label'],
          ),
        ),
      ).then((shouldContinue) {
        _loadInspections().then((_) {
          if (shouldContinue == true) {
            _startNextInspection();
          }
        });
      });
    }
  }

  void _submitInspection() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inspection Submitted Successfully!'), backgroundColor: Colors.green),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final bool allDone = _inspections.length == 4;

    return Scaffold(
      appBar: AppBar(
        title: Text('VIN: ${widget.vin}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Inspection Progress',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              allDone ? 'All wheels inspected' : 'Follow the sequence below',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: _sequence.length,
                itemBuilder: (context, index) {
                  final step = _sequence[index];
                  final inspection = _inspections[step['code']];
                  final isDone = inspection != null;
                  final isCurrent = index == _currentIndex && !allDone;

                  return _buildStepTile(
                    label: step['label']!,
                    isDone: isDone,
                    isCurrent: isCurrent,
                    status: inspection?.status,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            if (!allDone)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _startNextInspection,
                  icon: const Icon(Icons.camera_alt),
                  label: Text('Capture ${_sequence[_currentIndex]['label']}'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitInspection,
                  icon: const Icon(Icons.cloud_upload),
                  label: const Text('Submit Final Inspection'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepTile({
    required String label,
    required bool isDone,
    required bool isCurrent,
    String? status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrent 
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1) 
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent 
              ? Theme.of(context).colorScheme.primary 
              : (isDone ? Colors.green : Colors.white12),
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : (isCurrent ? Icons.play_circle_filled : Icons.circle_outlined),
            color: isDone ? Colors.green : (isCurrent ? Theme.of(context).colorScheme.primary : Colors.white24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isDone || isCurrent ? Colors.white : Colors.white38,
                  ),
                ),
                if (isDone && status != null)
                  Text(
                    status,
                    style: const TextStyle(color: Colors.green, fontSize: 12),
                  ),
              ],
            ),
          ),
          if (isCurrent)
            const Text(
              'NEXT',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12),
            ),
        ],
      ),
    );
  }
}
