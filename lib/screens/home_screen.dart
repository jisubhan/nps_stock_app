import 'package:flutter/material.dart';
import '../models/stock.dart';
import '../services/nps_api_service.dart';
import '../widgets/stock_card.dart';
// import '../widgets/banner_ad_widget.dart';  // TODO: 앱 출시 후 AdMob 활성화

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NpsApiService _apiService = NpsApiService();
  List<Stock> _stocks = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadStocks();
  }

  Future<void> _loadStocks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final stocks = await _apiService.getTop5Stocks();
      setState(() {
        _stocks = stocks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStocks,
            tooltip: '새로고침',
          ),
        ],
      ),
      body: _buildBody(),
      // TODO: 앱 출시 후 AdMob 활성화
      // bottomNavigationBar: Container(
      //   color: Colors.white,
      //   child: const SafeArea(
      //     child: BannerAdWidget(),
      //   ),
      // ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('데이터를 불러오는 중...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '오류 발생',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadStocks,
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (_stocks.isEmpty) {
      return const Center(
        child: Text('데이터가 없습니다.'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadStocks,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _stocks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: StockCard(
              stock: _stocks[index],
              rank: index + 1,
            ),
          );
        },
      ),
    );
  }
}
