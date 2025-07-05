import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ThresholdSettingsScreen extends StatefulWidget {
  @override
  _ThresholdSettingsScreenState createState() => _ThresholdSettingsScreenState();
}

class _ThresholdSettingsScreenState extends State<ThresholdSettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  Map<String, Map<String, TextEditingController>> controllers = {
    'soilMoisture': {'lower': TextEditingController(), 'upper': TextEditingController()},
    'nitrogen': {'lower': TextEditingController(), 'upper': TextEditingController()},
    'phosphorus': {'lower': TextEditingController(), 'upper': TextEditingController()},
    'potassium': {'lower': TextEditingController(), 'upper': TextEditingController()},
  };

Future<void> loadThresholds() async {
  final doc = await FirebaseFirestore.instance.collection('config').doc('thresholds').get();
  final data = doc.data();
  if (data == null) return;

  data.forEach((param, values) {
    if (controllers[param] != null && values is Map) {
      controllers[param]!['lower']?.text = values['lower']?.toString() ?? '';
      controllers[param]!['upper']?.text = values['upper']?.toString() ?? '';
    }
  });
}



  @override
  void initState() {
    super.initState();
    loadThresholds();
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var pair in controllers.values) {
      pair['lower']?.dispose();
      pair['upper']?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set Parameter Thresholds')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const Text("Set lower and upper bounds for alerts", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              buildThresholdSection('Soil Moisture'),
              buildThresholdSection('Nitrogen'),
              buildThresholdSection('Phosphorus'),
              buildThresholdSection('Potassium'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveThresholds,
                child: Text('Save Thresholds'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildThresholdSection(String label) {
    final labelKeyMap = {
      'Soil Moisture': 'soilMoisture',
      'Nitrogen': 'nitrogen',
      'Phosphorus': 'phosphorus',
      'Potassium': 'potassium',
    };

final key = labelKeyMap[label]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controllers[key]!['lower'],
                decoration: InputDecoration(labelText: 'Lower'),
                keyboardType: TextInputType.number,
                validator: (v) => _validateNumber(v),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: controllers[key]!['upper'],
                decoration: InputDecoration(labelText: 'Upper'),
                keyboardType: TextInputType.number,
                validator: (v) => _validateNumber(v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) return 'Required';
    final num? parsed = double.tryParse(value);
    if (parsed == null) return 'Enter a valid number';
    return null;
  }

  Future<void> saveThresholds() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> dataToSave = {};
      controllers.forEach((param, bounds) {
        dataToSave[param] = {
          'lower': double.tryParse(bounds['lower']!.text),
          'upper': double.tryParse(bounds['upper']!.text),
        };
      });

      await FirebaseFirestore.instance.collection('config').doc('thresholds').set(dataToSave);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Thresholds saved successfully.')));
    }
  }
}
