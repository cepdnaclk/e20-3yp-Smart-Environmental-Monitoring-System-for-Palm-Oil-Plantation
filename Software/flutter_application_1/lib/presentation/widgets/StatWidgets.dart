import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SensorChart extends StatefulWidget {
  final String title;
  final List<FlSpot> spots;
  final Map<int, String> labels;

  const SensorChart({
    Key? key,
    required this.title,
    required this.spots,
    required this.labels,
  }) : super(key: key);

  @override
  _SensorChartState createState() => _SensorChartState();
}

class _SensorChartState extends State<SensorChart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Export', style: TextStyle(color: Colors.blue)),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    interval: 100,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      return Text(
                        widget.labels[index] ?? '',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                // leftTitles: AxisTitles(
                //   sideTitles: SideTitles(showTitles: true, interval: 10),
                // ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 5, // Adjust this value as needed (e.g., 1, 2, or 5)
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(0), // Or use `1` for decimal if needed
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: widget.spots,
                  isCurved: true,
                  color: Colors.blue,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}




class StatsTable extends StatefulWidget {
  final List<List<String>> data;

  const StatsTable({Key? key, required this.data}) : super(key: key);

  @override
  _StatsTableState createState() => _StatsTableState();
}

class _StatsTableState extends State<StatsTable> {
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      children: [
        const TableRow(
          decoration: BoxDecoration(color: Colors.black12),
          children: [
            Padding(padding: EdgeInsets.all(8), child: Text('', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(8), child: Text('T (°C)', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(8), child: Text('Rh %', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        for (final row in widget.data)
          TableRow(
            children: row
                .map((cell) => Padding(padding: const EdgeInsets.all(8), child: Text(cell)))
                .toList(),
          ),
      ],
    );
  }
}
