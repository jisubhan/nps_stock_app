import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MiniChart extends StatelessWidget {
  final List<double> priceHistory;
  final bool isPositive;

  const MiniChart({
    super.key,
    required this.priceHistory,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    if (priceHistory.isEmpty) {
      return const Center(
        child: Text('차트 데이터 없음'),
      );
    }

    final spots = priceHistory.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();

    final minY = priceHistory.reduce((a, b) => a < b ? a : b);
    final maxY = priceHistory.reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.1;

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (priceHistory.length - 1).toDouble(),
        minY: minY - padding,
        maxY: maxY + padding,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: isPositive ? Colors.red : Colors.blue,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: isPositive ? Colors.red : Colors.blue,
                  strokeWidth: 0,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: (isPositive ? Colors.red : Colors.blue).withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.black87,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final price = barSpot.y.toInt();
                return LineTooltipItem(
                  '${price ~/ 1000}K원',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
