import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:medilink/features/vitals/domain/entities/vitals_entity.dart';

class VitalsChartWidget extends StatelessWidget {
  final List<VitalsEntity> vitals;
  final String vitalType;

  const VitalsChartWidget({
    super.key,
    required this.vitals,
    required this.vitalType,
  });

  @override
  Widget build(BuildContext context) {
    if (vitals.isEmpty) {
      return const SizedBox();
    }

    // Sort vitals by date
    final sortedVitals = List<VitalsEntity>.from(vitals)
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_getVitalLabel(vitalType)} Trend',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: _getInterval(vitalType),
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withValues(alpha: 0.3),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withValues(alpha: 0.3),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < sortedVitals.length) {
                            final date = sortedVitals[index].recordedAt;
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                '${date.day}/${date.month}',
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: _getInterval(vitalType),
                        reservedSize: 42,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(0),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                  ),
                  minX: 0,
                  maxX: (sortedVitals.length - 1).toDouble(),
                  minY: _getMinY(sortedVitals),
                  maxY: _getMaxY(sortedVitals),
                  lineBarsData: [
                    LineChartBarData(
                      spots: sortedVitals
                          .asMap()
                          .entries
                          .map((entry) =>
                              FlSpot(entry.key.toDouble(), entry.value.value))
                          .toList(),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      ),
                    ),
                    if (vitalType == 'blood_pressure' &&
                        sortedVitals.first.secondaryValue != null)
                      LineChartBarData(
                        spots: sortedVitals
                            .asMap()
                            .entries
                            .map((entry) => FlSpot(entry.key.toDouble(),
                                entry.value.secondaryValue ?? 0))
                            .toList(),
                        isCurved: true,
                        color: Colors.orange,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: true),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    if (vitalType != 'blood_pressure') {
      return const SizedBox();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(
          context,
          color: Theme.of(context).primaryColor,
          label: 'Systolic',
        ),
        const SizedBox(width: 16),
        _buildLegendItem(
          context,
          color: Colors.orange,
          label: 'Diastolic',
        ),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context,
      {required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  String _getVitalLabel(String type) {
    switch (type) {
      case 'blood_pressure':
        return 'Blood Pressure';
      case 'heart_rate':
        return 'Heart Rate';
      case 'blood_sugar':
        return 'Blood Sugar';
      case 'weight':
        return 'Weight';
      case 'temperature':
        return 'Temperature';
      case 'oxygen':
        return 'Oxygen Level';
      default:
        return type;
    }
  }

  double _getInterval(String type) {
    switch (type) {
      case 'blood_pressure':
        return 20;
      case 'heart_rate':
        return 20;
      case 'blood_sugar':
        return 20;
      case 'weight':
        return 10;
      case 'temperature':
        return 1;
      case 'oxygen':
        return 5;
      default:
        return 10;
    }
  }

  double _getMinY(List<VitalsEntity> vitals) {
    final values = vitals.map((v) => v.value).toList();
    if (vitalType == 'blood_pressure') {
      values.addAll(vitals.map((v) => v.secondaryValue ?? 0));
    }
    final min = values.reduce((a, b) => a < b ? a : b);
    return (min - 10).floorToDouble();
  }

  double _getMaxY(List<VitalsEntity> vitals) {
    final values = vitals.map((v) => v.value).toList();
    if (vitalType == 'blood_pressure') {
      values.addAll(vitals.map((v) => v.secondaryValue ?? 0));
    }
    final max = values.reduce((a, b) => a > b ? a : b);
    return (max + 10).ceilToDouble();
  }
}
