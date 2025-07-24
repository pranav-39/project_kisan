// market_service.dart
import 'dart:async';

enum MarketTrend { up, down, stable }

class MarketData {
  final String crop;
  final int price; // in paise (₹25.00 = 2500)
  final String unit;
  final String market;
  final MarketTrend trend;
  final int trendPercentage;

  MarketData({
    required this.crop,
    required this.price,
    required this.unit,
    required this.market,
    required this.trend,
    required this.trendPercentage,
  });

  // Convert price to rupees for display
  double get priceInRupees => price / 100;

  String get formattedPrice => '₹${priceInRupees.toStringAsFixed(2)}/$unit';

  // Helper to get trend icon
  String get trendIcon {
    switch (trend) {
      case MarketTrend.up:
        return '↑';
      case MarketTrend.down:
        return '↓';
      case MarketTrend.stable:
        return '→';
    }
  }

  // Helper to get trend color
  int get trendColor {
    switch (trend) {
      case MarketTrend.up:
        return 0xFF4CAF50; // Green
      case MarketTrend.down:
        return 0xFFF44336; // Red
      case MarketTrend.stable:
        return 0xFF2196F3; // Blue
    }
  }
}

class MarketService {
  // Singleton instance
  static final MarketService _instance = MarketService._internal();
  factory MarketService() => _instance;
  MarketService._internal();

  // Mock market data
  final List<MarketData> _mockMarketData = [
    MarketData(
      crop: "Tomato",
      price: 2500,
      unit: "kg",
      market: "Bangalore Mandi",
      trend: MarketTrend.up,
      trendPercentage: 5,
    ),
    MarketData(
      crop: "Onion",
      price: 1800,
      unit: "kg",
      market: "Bangalore Mandi",
      trend: MarketTrend.down,
      trendPercentage: -3,
    ),
    MarketData(
      crop: "Rice",
      price: 3200,
      unit: "kg",
      market: "Bangalore Mandi",
      trend: MarketTrend.up,
      trendPercentage: 2,
    ),
    MarketData(
      crop: "Wheat",
      price: 2800,
      unit: "kg",
      market: "Bangalore Mandi",
      trend: MarketTrend.stable,
      trendPercentage: 0,
    ),
    MarketData(
      crop: "Maize",
      price: 2200,
      unit: "kg",
      market: "Bangalore Mandi",
      trend: MarketTrend.up,
      trendPercentage: 4,
    ),
  ];

  // Simulate network delay
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Fetches all current market prices
  Future<List<MarketData>> getCurrentPrices() async {
    await _simulateDelay();
    return _mockMarketData;
  }

  /// Gets price data for a specific crop
  Future<MarketData?> getPriceForCrop(String cropName) async {
    await _simulateDelay();
    try {
      return _mockMarketData.firstWhere(
            (item) => item.crop.toLowerCase() == cropName.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Generates a market insight message for a crop
  Future<String> getMarketInsight(String crop) async {
    final cropData = await getPriceForCrop(crop);
    if (cropData == null) {
      return "No market data available for $crop.";
    }

    final trendText = switch (cropData.trend) {
      MarketTrend.up => 'increasing',
      MarketTrend.down => 'decreasing',
      MarketTrend.stable => 'stable',
    };

    return switch (cropData.trend) {
      MarketTrend.up =>
      '${cropData.crop} prices are trending $trendText by ${cropData.trendPercentage}% this week. '
          'Consider selling your harvest in the next 2-3 days for maximum profit.',
      MarketTrend.down =>
      '${cropData.crop} prices are $trendText by ${cropData.trendPercentage.abs()}% this week. '
          'You may want to hold off selling or consider alternative crops for next season.',
      MarketTrend.stable =>
      '${cropData.crop} prices are $trendText this week. '
          'Good time for steady sales at current market rates.',
    };
  }

  /// Gets all crops available in market data
  List<String> getAvailableCrops() {
    return _mockMarketData.map((data) => data.crop).toList();
  }

  /// Gets price trend for visualization
  Map<String, dynamic> getPriceTrend(String crop) {
    final data = _mockMarketData.firstWhere(
          (item) => item.crop.toLowerCase() == crop.toLowerCase(),
      orElse: () => throw Exception('Crop not found'),
    );

    return {
      'crop': data.crop,
      'trend': data.trend,
      'percentage': data.trendPercentage,
      'icon': data.trendIcon,
      'color': data.trendColor,
    };
  }
}

// Global instance similar to your export
final marketService = MarketService();