import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/FiledReading.dart';
import 'package:intl/intl.dart';

class MapOverlayWidget extends StatelessWidget {
  final FieldReading reading;
  final VoidCallback onClose;

  const MapOverlayWidget({
    Key? key,
    required this.reading,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.25,
      minChildSize: 0.10,
      maxChildSize: 0.5,
      builder: (context, scrollController) {
        return Material(
          elevation: 12,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.white,
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Timestamp
                  Text(
                    DateFormat('dd MMM yyyy hh.mm a').format(reading.timestamp),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nutrient bubbles
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildReadingBubble('Soil Moisture', reading.soilMoisture, Colors.brown),
                      _buildReadingBubble('Nitrogen', reading.nitrogen, const Color.fromRGBO(255, 64, 129, 1)),
                      _buildReadingBubble('Phosphorus', reading.phosphorous, Colors.lightBlue),
                      _buildReadingBubble('Potassium', reading.potassium, Colors.green),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // // Optional close button (can be removed or customized)
                  // ElevatedButton(
                  //   onPressed: onClose,
                  //   child: const Text("Close"),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReadingBubble(String label, double value, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: color,
          child: Text(
            '$value',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold , fontSize:13 ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 70,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }
}

