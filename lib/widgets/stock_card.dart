import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/stock.dart';
import 'mini_chart.dart';

class StockCard extends StatelessWidget {
  final Stock stock;
  final int rank;

  const StockCard({
    super.key,
    required this.stock,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final priceFormat = NumberFormat('#,###원');
    final isPositive = stock.changeRate >= 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 순위와 종목명
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getRankColor(rank),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$rank',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stock.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        stock.code,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // 변동률
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.red[50] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${isPositive ? '+' : ''}${stock.changeRate.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: isPositive ? Colors.red : Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 차트
            SizedBox(
              height: 80,
              child: MiniChart(
                priceHistory: stock.priceHistory,
                isPositive: isPositive,
              ),
            ),
            const SizedBox(height: 16),

            // 주식 정보
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    '보유 주식',
                    '${numberFormat.format(stock.shares)}주',
                  ),
                  const Divider(height: 16),
                  _buildInfoRow(
                    '매수 금액',
                    '${numberFormat.format(stock.amount ~/ 100000000)}억원',
                  ),
                  const Divider(height: 16),
                  _buildInfoRow(
                    '현재가',
                    priceFormat.format(stock.currentPrice),
                  ),
                  const Divider(height: 16),
                  _buildInfoRow(
                    '평가 금액',
                    '${numberFormat.format(stock.totalValue ~/ 100000000)}억원',
                    valueColor: isPositive ? Colors.red : Colors.blue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    Color? valueColor,
    bool bold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }
}
