class Stock {
  final String name;
  final String code;
  final int shares; // 보유 주식 수
  final double amount; // 매수 금액 (원)
  final double currentPrice; // 현재가
  final double changeRate; // 변동률 (%)
  final List<double> priceHistory; // 차트용 가격 히스토리

  Stock({
    required this.name,
    required this.code,
    required this.shares,
    required this.amount,
    required this.currentPrice,
    required this.changeRate,
    required this.priceHistory,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      shares: json['shares'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      currentPrice: (json['currentPrice'] ?? 0).toDouble(),
      changeRate: (json['changeRate'] ?? 0).toDouble(),
      priceHistory: (json['priceHistory'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'shares': shares,
      'amount': amount,
      'currentPrice': currentPrice,
      'changeRate': changeRate,
      'priceHistory': priceHistory,
    };
  }

  // 총 평가금액 계산
  double get totalValue => shares * currentPrice;

  // 수익률 계산
  double get profitRate => ((totalValue - amount) / amount) * 100;
}
