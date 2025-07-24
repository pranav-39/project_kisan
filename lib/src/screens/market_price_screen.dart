// lib/screens/market_prices_screen.dart
import 'package:flutter/material.dart';
import 'package:project_kisan_flutter/widgets/bottom_navigation.dart';
import 'package:project_kisan_flutter/widgets/floating_voice_button.dart';
import 'package:project_kisan_flutter/services/query_client.dart';
import 'package:provider/provider.dart';

class MarketPrice {
  final String crop;
  final double price;
  final String unit;
  final String market;
  final String trend;
  final double trendPercentage;

  MarketPrice({
    required this.crop,
    required this.price,
    required this.unit,
    required this.market,
    required this.trend,
    required this.trendPercentage,
  });
}

class MarketPricesScreen extends StatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  State<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _marketInsight = '';
  bool _isLoadingInsight = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  IconData _getTrendIcon(String trend) {
    switch (trend) {
      case 'up':
        return Icons.arrow_upward;
      case 'down':
        return Icons.arrow_downward;
      default:
        return Icons.horizontal_rule;
    }
  }

  Color _getTrendColor(String trend) {
    switch (trend) {
      case 'up':
        return Colors.green;
      case 'down':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getTrendBgColor(String trend) {
    switch (trend) {
      case 'up':
        return Colors.green[50]!;
      case 'down':
        return Colors.red[50]!;
      default:
        return Colors.grey[50]!;
    }
  }

  Future<void> _getMarketInsight() async {
    if (_searchController.text.trim().isEmpty) return;

    setState(() {
      _isLoadingInsight = true;
    });

    try {
      final queryClient = Provider.of<QueryClient>(context, listen: false);
      final insight = await queryClient.fetch<String>(
        '/api/market-insight',
            () => _mockInsightApiCall(),
      );

      setState(() {
        _marketInsight = insight;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to get market insight'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoadingInsight = false;
      });
    }
  }

  Future<String> _mockInsightApiCall() async {
    await Future.delayed(const Duration(seconds: 1));
    return "Tomato prices are trending up by 5% this week due to increased demand in Bangalore markets. Consider selling your harvest in the next 2-3 days for maximum profit.";
  }

  Future<List<MarketPrice>> _fetchMarketPrices() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      MarketPrice(
        crop: 'Tomato',
        price: 2500,
        unit: 'kg',
        market: 'Bangalore APMC',
        trend: 'up',
        trendPercentage: 5.0,
      ),
      MarketPrice(
        crop: 'Potato',
        price: 1800,
        unit: 'kg',
        market: 'Mysore APMC',
        trend: 'down',
        trendPercentage: 2.5,
      ),
      MarketPrice(
        crop: 'Onion',
        price: 2200,
        unit: 'kg',
        market: 'Hubli APMC',
        trend: 'up',
        trendPercentage: 3.2,
      ),
      MarketPrice(
        crop: 'Carrot',
        price: 1500,
        unit: 'kg',
        market: 'Belgaum APMC',
        trend: 'stable',
        trendPercentage: 0.0,
      ),
      MarketPrice(
        crop: 'Cabbage',
        price: 1200,
        unit: 'kg',
        market: 'Dharwad APMC',
        trend: 'up',
        trendPercentage: 1.8,
      ),
      MarketPrice(
        crop: 'Cauliflower',
        price: 2000,
        unit: 'kg',
        market: 'Shimoga APMC',
        trend: 'down',
        trendPercentage: 3.0,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Market Prices'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<QueryClient>(context, listen: false)
                  .invalidate('/api/market-prices');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Market prices updated'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<MarketPrice>>(
        future: Provider.of<QueryClient>(context)
            .fetch('/api/market-prices', _fetchMarketPrices),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading market prices...'),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No market data available'));
          }

          final marketPrices = snapshot.data!;
          final filteredPrices = _searchController.text.isEmpty
              ? marketPrices
              : marketPrices
              .where((price) => price.crop
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search and Insight Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Market Analysis',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  hintText:
                                  'Ask about crop prices (e.g., "What is tomato price today?")',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                                onSubmitted: (_) => _getMarketInsight(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _isLoadingInsight ? null : _getMarketInsight,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(16),
                              ),
                              child: _isLoadingInsight
                                  ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Icon(Icons.search),
                            ),
                          ],
                        ),
                        if (_marketInsight.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.auto_awesome, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text(
                                      'AI Market Insight',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(_marketInsight),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Price Cards Grid
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: filteredPrices.map((price) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      price.crop,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      price.market,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getTrendBgColor(price.trend),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _getTrendIcon(price.trend),
                                        size: 14,
                                        color: _getTrendColor(price.trend),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${price.trend == 'up' ? '+' : price.trend == 'down' ? '-' : ''}${price.trendPercentage.toStringAsFixed(1)}%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: _getTrendColor(price.trend),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              '₹${(price.price / 100).toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '/${price.unit}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const Spacer(),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Last updated: Today',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 0),
                                  ),
                                  child: const Text(
                                    'View Trends',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // Price Comparison Section
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Price Comparison',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('Crop')),
                              DataColumn(label: Text('Current Price')),
                              DataColumn(label: Text('Yesterday')),
                              DataColumn(label: Text('Change')),
                              DataColumn(label: Text('Market')),
                            ],
                            rows: filteredPrices.map((price) {
                              return DataRow(cells: [
                                DataCell(Text(price.crop)),
                                DataCell(Text(
                                    '₹${(price.price / 100).toStringAsFixed(0)}/${price.unit}')),
                                DataCell(Text(
                                    '₹${((price.price - (price.price * price.trendPercentage / 100)) / 100).toStringAsFixed(0)}')),
                                DataCell(
                                  Row(
                                    children: [
                                      Icon(
                                        _getTrendIcon(price.trend),
                                        size: 16,
                                        color: _getTrendColor(price.trend),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${price.trendPercentage.toStringAsFixed(1)}%',
                                        style: TextStyle(
                                          color: _getTrendColor(price.trend),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(Text(price.market)),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomNavigation(),
      floatingActionButton: const FloatingVoiceButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}