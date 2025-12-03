class ApiConfig {
  // 환경에 따른 API URL 설정
  static const String _productionUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://your-app-name.up.railway.app',  // Railway 배포 후 여기에 실제 URL 입력
  );

  static const String _developmentUrl = 'http://localhost:5001';

  // 현재 환경 확인
  static const bool isProduction = bool.fromEnvironment(
    'dart.vm.product',
    defaultValue: false,
  );

  // 사용할 base URL
  static String get baseUrl => isProduction ? _productionUrl : _developmentUrl;

  // API 엔드포인트들
  static String get top5StocksEndpoint => '$baseUrl/api/nps/top5';
  static String get healthCheckEndpoint => '$baseUrl/api/health';
}
