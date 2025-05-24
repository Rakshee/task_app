import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartsScreen extends StatelessWidget {
  final List<FlSpot> dataPoints = [
    FlSpot(0, 3),
    FlSpot(1, 1.5),
    FlSpot(2, 4),
    FlSpot(3, 3.5),
    FlSpot(4, 5),
    FlSpot(5, 3),
    FlSpot(6, 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Line Chart')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: 6,
            minY: 0,
            maxY: 6,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  interval: 1,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    const style = TextStyle(fontSize: 12);
                    switch (value.toInt()) {
                      case 0:
                        return const Text('Mon', style: style);
                      case 1:
                        return const Text('Tue', style: style);
                      case 2:
                        return const Text('Wed', style: style);
                      case 3:
                        return const Text('Thu', style: style);
                      case 4:
                        return const Text('Fri', style: style);
                      case 5:
                        return const Text('Sat', style: style);
                      case 6:
                        return const Text('Sun', style: style);
                      default:
                        return const Text('');
                    }
                  },
                ),
              ),
            ),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: dataPoints,
                isCurved: true,
                barWidth: 3,
                color: Colors.blue,
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blue.withOpacity(0.3),
                ),
                dotData: FlDotData(show: true),
              )
            ],
          ),
        ),
      ),
    );
  }
}
