import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspection History'),
      ),
      body: FutureBuilder<List<VinScan>>(
        future: db.getAllVinScans(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final scans = snapshot.data ?? [];
          if (scans.isEmpty) {
            return const Center(
              child: Text('No inspection history found.'),
            );
          }

          return ListView.builder(
            itemCount: scans.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final scan = scans[index];
              return _VinScanTile(scan: scan);
            },
          );
        },
      ),
    );
  }
}

class _VinScanTile extends StatelessWidget {
  final VinScan scan;

  const _VinScanTile({required this.scan});

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    final dateStr = DateFormat('MMM dd, yyyy HH:mm').format(scan.scannedAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          scan.vin,
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        subtitle: Text(dateStr, style: const TextStyle(fontSize: 12, color: Colors.white54)),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: () => _confirmDelete(context, db),
        ),
        children: [
          FutureBuilder<List<Inspection>>(
            future: db.getInspectionsByVin(scan.id),
            builder: (context, snapshot) {
              final inspections = snapshot.data ?? [];
              if (inspections.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No wheel captures for this VIN'),
                );
              }

              return Column(
                children: inspections.map((inspection) => _InspectionTile(inspection: inspection)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, AppDatabase db) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Record?'),
        content: const Text('This will permanently remove this VIN and all associated inspection images.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent))
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await db.deleteVinScan(scan.id);
      // Trigger a rebuild by popping or using a global state - for simplicity in this demo,
      // we just assume the user might need to pull to refresh or it's handled by context.watch
    }
  }
}

class _InspectionTile extends StatelessWidget {
  final Inspection inspection;

  const _InspectionTile({required this.inspection});

  @override
  Widget build(BuildContext context) {
    final isOk = inspection.status.toLowerCase().contains('ok');
    
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: inspection.imagePath != null
              ? DecorationImage(
                  image: FileImage(File(inspection.imagePath!)),
                  fit: BoxFit.cover,
                )
              : null,
          color: Colors.black26,
        ),
      ),
      title: Text('${inspection.wheelPosition}: ${inspection.status}'),
      subtitle: Text('Confidence: ${(inspection.confidence * 100).toStringAsFixed(1)}%'),
      trailing: Icon(
        isOk ? Icons.check_circle : Icons.error,
        color: isOk ? Colors.green : Colors.red,
        size: 20,
      ),
    );
  }
}
