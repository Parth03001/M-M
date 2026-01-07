import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'connector_list_screen.dart';

class BarcodeScanResultScreen extends StatelessWidget {
  final Barcode barcodeData;

  BarcodeScanResultScreen({
    Key? key,
    required this.barcodeData,
  }) : super(key: key) {
    // Print all barcode data to console
    _printAllBarcodeData();
  }

  void _printAllBarcodeData() {
    print('═══════════════════════════════════════════════════════');
    print('📱 ALL BARCODE DATA:');
    print('═══════════════════════════════════════════════════════');
    print('Raw Value: ${barcodeData.rawValue}');
    print('Display Value: ${barcodeData.displayValue}');
    print('Type: ${barcodeData.type}');
    print('Format: ${barcodeData.format}');
    print('Raw Bytes Length: ${barcodeData.rawBytes?.length ?? 0}');
    print('Raw Bytes: ${barcodeData.rawBytes}');
    
    if (barcodeData.calendarEvent != null) {
      print('Calendar Event: ${barcodeData.calendarEvent}');
    }
    if (barcodeData.contactInfo != null) {
      print('Contact Info: ${barcodeData.contactInfo}');
    }
    if (barcodeData.driverLicense != null) {
      print('Driver License: ${barcodeData.driverLicense}');
    }
    if (barcodeData.email != null) {
      print('Email: ${barcodeData.email}');
    }
    if (barcodeData.geoPoint != null) {
      print('Geo Point: ${barcodeData.geoPoint}');
    }
    if (barcodeData.phone != null) {
      print('Phone: ${barcodeData.phone}');
    }
    if (barcodeData.sms != null) {
      print('SMS: ${barcodeData.sms}');
    }
    if (barcodeData.url != null) {
      print('URL: ${barcodeData.url}');
    }
    if (barcodeData.wifi != null) {
      print('WiFi: ${barcodeData.wifi}');
    }
    print('═══════════════════════════════════════════════════════');
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
                          'SCAN RESULT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Success Icon
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 60,
                          ),
                        ),
                      ),
                      SizedBox(height: 32),

                      // Title
                      Center(
                        child: Text(
                          'Barcode Scanned Successfully!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDC143C),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 40),

                      // All Barcode Data Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
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
                            Text(
                              'All Barcode Data',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFDC143C),
                              ),
                            ),
                            SizedBox(height: 20),
                            _buildDataRow(
                              icon: Icons.qr_code,
                              label: 'Raw Value',
                              value: barcodeData.rawValue ?? 'N/A',
                            ),
                            SizedBox(height: 16),
                            Divider(color: Colors.grey[300], height: 1),
                            SizedBox(height: 16),
                            _buildDataRow(
                              icon: Icons.text_fields,
                              label: 'Display Value',
                              value: barcodeData.displayValue ?? 'N/A',
                            ),
                            SizedBox(height: 16),
                            Divider(color: Colors.grey[300], height: 1),
                            SizedBox(height: 16),
                            _buildDataRow(
                              icon: Icons.category,
                              label: 'Barcode Type',
                              value: barcodeData.type.name,
                            ),
                            SizedBox(height: 16),
                            Divider(color: Colors.grey[300], height: 1),
                            SizedBox(height: 16),
                            _buildDataRow(
                              icon: Icons.format_align_left,
                              label: 'Format',
                              value: barcodeData.format.name,
                            ),
                            if (barcodeData.rawBytes != null) ...[
                              SizedBox(height: 16),
                              Divider(color: Colors.grey[300], height: 1),
                              SizedBox(height: 16),
                              _buildDataRow(
                                icon: Icons.data_object,
                                label: 'Raw Bytes Length',
                                value: '${barcodeData.rawBytes!.length} bytes',
                              ),
                            ],
                            if (barcodeData.calendarEvent != null) ...[
                              SizedBox(height: 16),
                              Divider(color: Colors.grey[300], height: 1),
                              SizedBox(height: 16),
                              _buildDataRow(
                                icon: Icons.event,
                                label: 'Calendar Event',
                                value: barcodeData.calendarEvent.toString(),
                              ),
                            ],
                            if (barcodeData.contactInfo != null) ...[
                              SizedBox(height: 16),
                              Divider(color: Colors.grey[300], height: 1),
                              SizedBox(height: 16),
                              _buildDataRow(
                                icon: Icons.contact_mail,
                                label: 'Contact Info',
                                value: barcodeData.contactInfo.toString(),
                              ),
                            ],
                            if (barcodeData.driverLicense != null) ...[
                              SizedBox(height: 16),
                              Divider(color: Colors.grey[300], height: 1),
                              SizedBox(height: 16),
                              _buildDataRow(
                                icon: Icons.credit_card,
                                label: 'Driver License',
                                value: barcodeData.driverLicense.toString(),
                              ),
                            ],
                            if (barcodeData.email != null) ...[
                              SizedBox(height: 16),
                              Divider(color: Colors.grey[300], height: 1),
                              SizedBox(height: 16),
                              _buildDataRow(
                                icon: Icons.email,
                                label: 'Email',
                                value: barcodeData.email.toString(),
                              ),
                            ],
                            if (barcodeData.geoPoint != null) ...[
                              SizedBox(height: 16),
                              Divider(color: Colors.grey[300], height: 1),
                              SizedBox(height: 16),
                              _buildDataRow(
                                icon: Icons.location_on,
                                label: 'Geo Point',
                                value: barcodeData.geoPoint.toString(),
                              ),
                            ],
                            if (barcodeData.phone != null) ...[
                              SizedBox(height: 16),
                              Divider(color: Colors.grey[300], height: 1),
                              SizedBox(height: 16),
                              _buildDataRow(
                                icon: Icons.phone,
                                label: 'Phone',
                                value: barcodeData.phone.toString(),
                              ),
                            ],
                            if (barcodeData.sms != null) ...[
                              SizedBox(height: 16),
                              Divider(color: Colors.grey[300], height: 1),
                              SizedBox(height: 16),
                              _buildDataRow(
                                icon: Icons.sms,
                                label: 'SMS',
                                value: barcodeData.sms.toString(),
                              ),
                            ],
                            if (barcodeData.url != null) ...[
                              SizedBox(height: 16),
                              Divider(color: Colors.grey[300], height: 1),
                              SizedBox(height: 16),
                              _buildDataRow(
                                icon: Icons.link,
                                label: 'URL',
                                value: barcodeData.url.toString(),
                              ),
                            ],
                            if (barcodeData.wifi != null) ...[
                              SizedBox(height: 16),
                              Divider(color: Colors.grey[300], height: 1),
                              SizedBox(height: 16),
                              _buildDataRow(
                                icon: Icons.wifi,
                                label: 'WiFi',
                                value: barcodeData.wifi.toString(),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Detailed Object Data Section
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
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
                            Text(
                              'Detailed Object Data',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFDC143C),
                              ),
                            ),
                            SizedBox(height: 20),
                            _buildObjectDataSection(),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),

                      // Continue Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to connector list with raw barcode data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConnectorListScreen(
                                  scannedBarcode: barcodeData.rawValue,
                                  vin: '',
                                  modelName: barcodeData.displayValue ?? '',
                                ),
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
                      SizedBox(height: 16),

                      // Scan Again Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFFDC143C),
                            side: BorderSide(
                              color: Color(0xFFDC143C),
                              width: 2,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'SCAN AGAIN',
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Color(0xFFDC143C),
          size: 24,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              SelectableText(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildObjectDataSection() {
    final List<Map<String, dynamic>> objectData = [];

    // Add all properties
    objectData.add({'label': 'Raw Value', 'value': barcodeData.rawValue?.toString() ?? 'null'});
    objectData.add({'label': 'Display Value', 'value': barcodeData.displayValue?.toString() ?? 'null'});
    objectData.add({'label': 'Type', 'value': barcodeData.type.toString()});
    objectData.add({'label': 'Format', 'value': barcodeData.format.toString()});
    
    if (barcodeData.rawBytes != null) {
      objectData.add({'label': 'Raw Bytes (Hex)', 'value': _bytesToHex(barcodeData.rawBytes!)});
      objectData.add({'label': 'Raw Bytes Length', 'value': '${barcodeData.rawBytes!.length} bytes'});
    } else {
      objectData.add({'label': 'Raw Bytes', 'value': 'null'});
    }

    // Add nested objects
    if (barcodeData.calendarEvent != null) {
      objectData.add({'label': 'Calendar Event', 'value': _formatCalendarEvent(barcodeData.calendarEvent!)});
    }
    if (barcodeData.contactInfo != null) {
      objectData.add({'label': 'Contact Info', 'value': _formatContactInfo(barcodeData.contactInfo!)});
    }
    if (barcodeData.driverLicense != null) {
      objectData.add({'label': 'Driver License', 'value': _formatDriverLicense(barcodeData.driverLicense!)});
    }
    if (barcodeData.email != null) {
      objectData.add({'label': 'Email', 'value': _formatEmail(barcodeData.email!)});
    }
    if (barcodeData.geoPoint != null) {
      objectData.add({'label': 'Geo Point', 'value': _formatGeoPoint(barcodeData.geoPoint!)});
    }
    if (barcodeData.phone != null) {
      objectData.add({'label': 'Phone', 'value': _formatPhone(barcodeData.phone!)});
    }
    if (barcodeData.sms != null) {
      objectData.add({'label': 'SMS', 'value': _formatSMS(barcodeData.sms!)});
    }
    if (barcodeData.url != null) {
      objectData.add({'label': 'URL', 'value': barcodeData.url!.url});
    }
    if (barcodeData.wifi != null) {
      objectData.add({'label': 'WiFi', 'value': _formatWiFi(barcodeData.wifi!)});
    }

    return Column(
      children: objectData.asMap().entries.map((entry) {
        final index = entry.key;
        final data = entry.value;
        return Column(
          children: [
            if (index > 0) ...[
              SizedBox(height: 16),
              Divider(color: Colors.grey[300], height: 1),
              SizedBox(height: 16),
            ],
            _buildDataRow(
              icon: _getIconForLabel(data['label']),
              label: data['label'],
              value: data['value'],
            ),
          ],
        );
      }).toList(),
    );
  }

  String _bytesToHex(List<int> bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' ').toUpperCase();
  }

  String _formatCalendarEvent(dynamic calendarEvent) {
    try {
      return 'Title: ${calendarEvent.title ?? 'N/A'}\n'
          'Description: ${calendarEvent.description ?? 'N/A'}\n'
          'Start: ${calendarEvent.start?.toString() ?? 'N/A'}\n'
          'End: ${calendarEvent.end?.toString() ?? 'N/A'}\n'
          'Location: ${calendarEvent.location ?? 'N/A'}\n'
          'Organizer: ${calendarEvent.organizer ?? 'N/A'}';
    } catch (e) {
      return calendarEvent.toString();
    }
  }

  String _formatContactInfo(dynamic contactInfo) {
    try {
      return 'Name: ${contactInfo.name ?? 'N/A'}\n'
          'Organization: ${contactInfo.organization ?? 'N/A'}\n'
          'Addresses: ${contactInfo.addresses?.join(', ') ?? 'N/A'}\n'
          'Phones: ${contactInfo.phones?.join(', ') ?? 'N/A'}\n'
          'Emails: ${contactInfo.emails?.join(', ') ?? 'N/A'}\n'
          'URLs: ${contactInfo.urls?.join(', ') ?? 'N/A'}';
    } catch (e) {
      return contactInfo.toString();
    }
  }

  String _formatDriverLicense(dynamic driverLicense) {
    try {
      return 'Document Type: ${driverLicense.documentType ?? 'N/A'}\n'
          'License Number: ${driverLicense.licenseNumber ?? 'N/A'}\n'
          'FirstName: ${driverLicense.firstName ?? 'N/A'}\n'
          'Middle Name: ${driverLicense.middleName ?? 'N/A'}\n'
          'Last Name: ${driverLicense.lastName ?? 'N/A'}\n'
          'Address: ${driverLicense.addressStreet ?? 'N/A'}\n'
          'City: ${driverLicense.addressCity ?? 'N/A'}\n'
          'State: ${driverLicense.addressState ?? 'N/A'}\n'
          'Zip: ${driverLicense.addressZip ?? 'N/A'}\n'
          'Birth Date: ${driverLicense.birthDate ?? 'N/A'}\n'
          'Issue Date: ${driverLicense.issueDate ?? 'N/A'}\n'
          'Expiry Date: ${driverLicense.expiryDate ?? 'N/A'}';
    } catch (e) {
      return driverLicense.toString();
    }
  }

  String _formatEmail(dynamic email) {
    try {
      return 'Address: ${email.address ?? 'N/A'}\n'
          'Subject: ${email.subject ?? 'N/A'}\n'
          'Body: ${email.body ?? 'N/A'}';
    } catch (e) {
      return email.toString();
    }
  }

  String _formatGeoPoint(dynamic geoPoint) {
    try {
      return 'Latitude: ${geoPoint.latitude ?? 'N/A'}\n'
          'Longitude: ${geoPoint.longitude ?? 'N/A'}\n'
          'Altitude: ${geoPoint.altitude ?? 'N/A'}';
    } catch (e) {
      return geoPoint.toString();
    }
  }

  String _formatPhone(dynamic phone) {
    try {
      return 'Number: ${phone.number ?? 'N/A'}';
    } catch (e) {
      return phone.toString();
    }
  }

  String _formatSMS(dynamic sms) {
    try {
      return 'Number: ${sms.number ?? 'N/A'}\n'
          'Message: ${sms.message ?? 'N/A'}';
    } catch (e) {
      return sms.toString();
    }
  }

  String _formatWiFi(dynamic wifi) {
    try {
      return 'SSID: ${wifi.ssid ?? 'N/A'}\n'
          'Password: ${wifi.password ?? 'N/A'}\n'
          'Encryption Type: ${wifi.encryptionType?.toString() ?? 'N/A'}';
    } catch (e) {
      return wifi.toString();
    }
  }

  IconData _getIconForLabel(String label) {
    if (label.contains('Raw Value') || label.contains('Raw Bytes')) {
      return Icons.qr_code;
    } else if (label.contains('Display')) {
      return Icons.text_fields;
    } else if (label.contains('Type') || label.contains('Format')) {
      return Icons.category;
    } else if (label.contains('Calendar')) {
      return Icons.event;
    } else if (label.contains('Contact')) {
      return Icons.contact_mail;
    } else if (label.contains('License')) {
      return Icons.credit_card;
    } else if (label.contains('Email')) {
      return Icons.email;
    } else if (label.contains('Geo') || label.contains('Location')) {
      return Icons.location_on;
    } else if (label.contains('Phone')) {
      return Icons.phone;
    } else if (label.contains('SMS')) {
      return Icons.sms;
    } else if (label.contains('URL')) {
      return Icons.link;
    } else if (label.contains('WiFi')) {
      return Icons.wifi;
    }
    return Icons.info;
  }
}

