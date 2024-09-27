import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Line Chart Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: true), // Show grid lines
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              bottomTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: true)),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                spots: _getMockData(),
                dotData: FlDotData(show: true), // Dots on the line
                belowBarData: BarAreaData(
                    show: true, color: Colors.blue.withOpacity(0.2)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Mock data for the line chart
  List<FlSpot> _getMockData() {
    return [
      FlSpot(0, 1),
      FlSpot(1, 1.5),
      FlSpot(2, 1.4),
      FlSpot(3, 3.4),
      FlSpot(4, 2),
      FlSpot(5, 2.2),
      FlSpot(6, 1.8),
    ];
  }
}

void main() => runApp(MaterialApp(home: LineChartSample()));
