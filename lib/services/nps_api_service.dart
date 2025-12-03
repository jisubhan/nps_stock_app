import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stock.dart';
import '../config/api_config.dart';

class NpsApiService {
  // API 서버 URL (환경에 따라 자동 선택)
  static String get baseUrl => ApiConfig.baseUrl;

  // 연기금(국민연금 포함) Top5 주식 데이터 가져오기
  Future<List<Stock>> getTop5Stocks() async {
    try {
      // 로컬 Python 서버에서 데이터 가져오기
      final data = await _fetchFromLocalServer();

      if (data.isEmpty) {
        // 데이터가 없으면 샘플 데이터 반환
        return _getSampleData();
      }

      return data;
    } catch (e) {
      print('API 오류: $e');
      // API 실패 시 샘플 데이터 반환
      return _getSampleData();
    }
  }

  // 로컬 Python 서버에서 데이터 가져오기
  Future<List<Stock>> _fetchFromLocalServer() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/nps/top5'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final stocks = jsonData['stocks'] as List;

        print('서버에서 ${stocks.length}개 데이터 수신');

        return stocks.map((stock) {
          final priceHistory = (stock['price_history'] as List?)
                  ?.map((e) => (e as num).toDouble())
                  .toList() ??
              [];

          return Stock(
            name: stock['name'] ?? '',
            code: stock['code'] ?? '',
            shares: stock['shares'] ?? 0,
            amount: (stock['amount'] ?? 0).toDouble(),
            currentPrice: (stock['current_price'] ?? 0).toDouble(),
            changeRate: (stock['change_rate'] ?? 0).toDouble(),
            priceHistory: priceHistory.isEmpty ? [0] : priceHistory,
          );
        }).toList();
      } else {
        throw Exception('서버 응답 오류: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('로컬 서버 연결 실패: $e');
    }
  }

  // 샘플 데이터 (API 실패 시 또는 테스트용)
  List<Stock> _getSampleData() {
    return [
      Stock(
        name: '삼성전자',
        code: '005930',
        shares: 150000000,
        amount: 8500000000000,
        currentPrice: 72000,
        changeRate: 2.5,
        priceHistory: [68000, 69500, 70000, 71000, 70500, 72000],
      ),
      Stock(
        name: 'SK하이닉스',
        code: '000660',
        shares: 45000000,
        amount: 4200000000000,
        currentPrice: 125000,
        changeRate: -1.2,
        priceHistory: [120000, 123000, 126000, 127000, 126500, 125000],
      ),
      Stock(
        name: 'POSCO홀딩스',
        code: '005490',
        shares: 18000000,
        amount: 3800000000000,
        currentPrice: 285000,
        changeRate: 3.8,
        priceHistory: [270000, 275000, 278000, 282000, 283000, 285000],
      ),
      Stock(
        name: '현대자동차',
        code: '005380',
        shares: 28000000,
        amount: 3500000000000,
        currentPrice: 195000,
        changeRate: 1.5,
        priceHistory: [188000, 190000, 192000, 193000, 194500, 195000],
      ),
      Stock(
        name: 'LG화학',
        code: '051910',
        shares: 12000000,
        amount: 3200000000000,
        currentPrice: 420000,
        changeRate: -0.8,
        priceHistory: [415000, 418000, 422000, 425000, 423000, 420000],
      ),
    ];
  }
}
