// schemes_service.dart
import 'dart:async';

enum SchemeStatus { eligible, underReview, notEligible }

class SchemeData {
  final int id;
  final String name;
  final String description;
  final String amount;
  final List<String> eligibility;
  final String applicationLink;
  final String category;
  final SchemeStatus status;

  SchemeData({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.eligibility,
    required this.applicationLink,
    required this.category,
    required this.status,
  });

  // Helper to get status color
  int get statusColor {
    switch (status) {
      case SchemeStatus.eligible:
        return 0xFF4CAF50; // Green
      case SchemeStatus.underReview:
        return 0xFFFFC107; // Amber
      case SchemeStatus.notEligible:
        return 0xFFF44336; // Red
    }
  }

  // Helper to get status text
  String get statusText {
    switch (status) {
      case SchemeStatus.eligible:
        return 'Eligible';
      case SchemeStatus.underReview:
        return 'Under Review';
      case SchemeStatus.notEligible:
        return 'Not Eligible';
    }
  }
}

class SchemesService {
  // Singleton instance
  static final SchemesService _instance = SchemesService._internal();
  factory SchemesService() => _instance;
  SchemesService._internal();

  // Mock schemes data
  final List<SchemeData> _schemes = [
    SchemeData(
      id: 1,
      name: "PM-KISAN Scheme",
      description: "Direct income support of ₹6,000 per year to eligible farmer families",
      amount: "₹6,000/year",
      eligibility: [
        "Small and marginal farmers",
        "Landholding up to 2 hectares",
        "Valid Aadhaar card",
      ],
      applicationLink: "https://pmkisan.gov.in/",
      category: "income_support",
      status: SchemeStatus.eligible,
    ),
    SchemeData(
      id: 2,
      name: "Drip Irrigation Subsidy",
      description: "Up to 50% subsidy on drip irrigation systems",
      amount: "50% subsidy",
      eligibility: [
        "Farmers with irrigation facilities",
        "Minimum 0.5 hectare land",
        "No previous subsidy claimed",
      ],
      applicationLink: "https://pmksy.gov.in/",
      category: "subsidy",
      status: SchemeStatus.underReview,
    ),
    SchemeData(
      id: 3,
      name: "Crop Insurance Scheme",
      description: "Comprehensive risk solution for crop loss coverage",
      amount: "Up to ₹2 lakh coverage",
      eligibility: [
        "All farmers (loanee and non-loanee)",
        "Coverage for pre-sowing to post-harvest",
        "Premium varies by crop",
      ],
      applicationLink: "https://pmfby.gov.in/",
      category: "insurance",
      status: SchemeStatus.eligible,
    ),
    SchemeData(
      id: 4,
      name: "Soil Health Card Scheme",
      description: "Free soil testing and nutrient recommendations",
      amount: "Free service",
      eligibility: [
        "All farmers",
        "Valid land documents",
      ],
      applicationLink: "https://soilhealth.dac.gov.in/",
      category: "advisory",
      status: SchemeStatus.eligible,
    ),
  ];

  // Simulate network delay
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Get all schemes
  Future<List<SchemeData>> getAllSchemes() async {
    await _simulateDelay();
    return _schemes;
  }

  /// Get scheme by ID
  Future<SchemeData?> getSchemeById(int id) async {
    await _simulateDelay();
    try {
      return _schemes.firstWhere((scheme) => scheme.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search schemes by query
  Future<List<SchemeData>> searchSchemes(String query) async {
    await _simulateDelay();
    final lowerQuery = query.toLowerCase();
    return _schemes.where((scheme) =>
    scheme.name.toLowerCase().contains(lowerQuery) ||
        scheme.description.toLowerCase().contains(lowerQuery) ||
        scheme.category.toLowerCase().contains(lowerQuery)).toList();
  }

  /// Get schemes by category
  Future<List<SchemeData>> getSchemesByCategory(String category) async {
    await _simulateDelay();
    return _schemes.where((scheme) => scheme.category == category).toList();
  }

  /// Get scheme recommendation based on user query
  Future<String> getSchemeRecommendation(String userQuery) async {
    await _simulateDelay();
    final query = userQuery.toLowerCase();

    if (query.contains("income") || query.contains("money") || query.contains("support")) {
      return "Based on your query, I recommend the PM-KISAN Scheme which provides ₹6,000 per year direct income support to eligible farmers.";
    }

    if (query.contains("irrigation") || query.contains("water") || query.contains("drip")) {
      return "For irrigation needs, the Drip Irrigation Subsidy scheme offers up to 50% subsidy on drip irrigation systems.";
    }

    if (query.contains("insurance") || query.contains("crop loss") || query.contains("protection")) {
      return "The Crop Insurance Scheme provides comprehensive coverage for crop losses with coverage up to ₹2 lakh.";
    }

    if (query.contains("soil") || query.contains("fertilizer") || query.contains("nutrients")) {
      return "The Soil Health Card Scheme provides free soil testing and nutrient recommendations to optimize your crop yield.";
    }

    return "I found several relevant schemes. The PM-KISAN scheme provides direct income support, while other schemes offer subsidies for irrigation, crop insurance, and soil health services.";
  }
}

// Global instance similar to your export
final schemesService = SchemesService();