// lib/screens/government_schemes_screen.dart
import 'package:flutter/material.dart';
import 'package:project_kisan_flutter/widgets/bottom_navigation.dart';
import 'package:project_kisan_flutter/widgets/floating_voice_button.dart';
import 'package:project_kisan_flutter/services/query_client.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Scheme {
  final int id;
  final String name;
  final String description;
  final String amount;
  final List<String> eligibility;
  final String applicationLink;
  final String category;
  final String status;

  Scheme({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.eligibility,
    required this.applicationLink,
    required this.category,
    required this.status,
  });
}

class GovernmentSchemesScreen extends StatefulWidget {
  const GovernmentSchemesScreen({super.key});

  @override
  State<GovernmentSchemesScreen> createState() => _GovernmentSchemesScreenState();
}

class _GovernmentSchemesScreenState extends State<GovernmentSchemesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _recommendation = '';
  bool _isLoadingRecommendation = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'eligible':
        return Colors.green;
      case 'under_review':
        return Colors.orange;
      case 'not_eligible':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'eligible':
        return Colors.green[50]!;
      case 'under_review':
        return Colors.orange[50]!;
      case 'not_eligible':
        return Colors.red[50]!;
      default:
        return Colors.grey[50]!;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'income_support':
        return Icons.attach_money;
      case 'subsidy':
        return Icons.percent;
      case 'insurance':
        return Icons.security;
      case 'advisory':
        return Icons.school;
      default:
        return Icons.description;
    }
  }

  Future<void> _getRecommendation() async {
    if (_searchController.text.trim().isEmpty) return;

    setState(() {
      _isLoadingRecommendation = true;
    });

    try {
      final queryClient = Provider.of<QueryClient>(context, listen: false);
      final recommendation = await queryClient.fetch<String>(
        '/api/schemes/recommend',
            () => _mockRecommendationApiCall(),
      );

      setState(() {
        _recommendation = recommendation;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to get scheme recommendation'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoadingRecommendation = false;
      });
    }
  }

  Future<String> _mockRecommendationApiCall() async {
    await Future.delayed(const Duration(seconds: 1));
    return "Based on your query, we recommend the PM-KISAN scheme which provides income support of ₹6000/year to small and marginal farmers. You appear to be eligible based on your land holdings.";
  }

  Future<List<Scheme>> _fetchSchemes() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Scheme(
        id: 1,
        name: 'PM-KISAN Scheme',
        description:
        'Income support of ₹6000/year to small and marginal farmers',
        amount: '₹6000/year',
        eligibility: [
          'Small and marginal farmers',
          'Land holding up to 2 hectares',
          'Valid bank account'
        ],
        applicationLink: 'https://pmkisan.gov.in',
        category: 'income_support',
        status: 'eligible',
      ),
      Scheme(
        id: 2,
        name: 'Soil Health Card Scheme',
        description: 'Free soil testing for farmers',
        amount: 'Free',
        eligibility: [
          'All farmers',
          'Valid Aadhaar card',
          'Land ownership documents'
        ],
        applicationLink: 'https://soilhealth.dac.gov.in',
        category: 'advisory',
        status: 'under_review',
      ),
      Scheme(
        id: 3,
        name: 'Pradhan Mantri Fasal Bima Yojana',
        description: 'Crop insurance scheme',
        amount: 'Premium from 1.5% to 5%',
        eligibility: [
          'All farmers',
          'Cultivated land',
          'Valid Aadhaar card'
        ],
        applicationLink: 'https://pmfby.gov.in',
        category: 'insurance',
        status: 'eligible',
      ),
      Scheme(
        id: 4,
        name: 'Micro Irrigation Fund',
        description: 'Subsidy for drip and sprinkler irrigation',
        amount: 'Up to 55% subsidy',
        eligibility: [
          'Farmers with minimum 0.5 hectare',
          'Water scarcity area priority'
        ],
        applicationLink: 'https://pmksy.gov.in',
        category: 'subsidy',
        status: 'not_eligible',
      ),
    ];
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Government Schemes'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Scheme>>(
        future: Provider.of<QueryClient>(context)
            .fetch('/api/schemes', _fetchSchemes),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading schemes...'),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No schemes available'));
          }

          final schemes = snapshot.data!;
          final filteredSchemes = _searchController.text.isEmpty
              ? schemes
              : schemes.where((scheme) =>
          scheme.name.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
              scheme.description.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ) ||
              scheme.category.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ))
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search and Recommendation Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Find Relevant Schemes',
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
                                  'Describe your need (e.g., "subsidies for drip irrigation")',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                                onSubmitted: (_) => _getRecommendation(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _isLoadingRecommendation
                                  ? null
                                  : _getRecommendation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(16),
                              ),
                              child: _isLoadingRecommendation
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
                        if (_recommendation.isNotEmpty) ...[
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
                                    Icon(Icons.lightbulb, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text(
                                      'AI Recommendation',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(_recommendation),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Filter Tabs
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('All Schemes'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Income Support'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Subsidies'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Insurance'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Advisory'),
                      ),
                    ],
                  ),
                ),

                // Schemes List
                const SizedBox(height: 16),
                Column(
                  children: filteredSchemes.map((scheme) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Icon(
                                    _getCategoryIcon(scheme.category),
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        scheme.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Chip(
                                        label: Text(
                                          scheme.category
                                              .replaceAll('_', ' ')
                                              .toUpperCase(),
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        backgroundColor: Colors.grey[100],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(scheme.description),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  scheme.amount,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusBgColor(scheme.status),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    scheme.status == 'eligible'
                                        ? 'Eligible'
                                        : scheme.status == 'under_review'
                                        ? 'Under Review'
                                        : 'Not Eligible',
                                    style: TextStyle(
                                      color: _getStatusColor(scheme.status),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Eligibility:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Column(
                              children: scheme.eligibility
                                  .map(
                                    (criteria) => Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text('• '),
                                      Expanded(child: Text(criteria)),
                                    ],
                                  ),
                                ),
                              )
                                  .toList(),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _launchUrl(scheme.applicationLink),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text('Apply Now'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    child: const Text('View Details'),
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

                // Quick Links
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Links',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          children: [
                            OutlinedButton(
                              onPressed: () {},
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.agriculture,
                                      size: 32, color: Colors.blue),
                                  SizedBox(height: 8),
                                  Text(
                                    'PM-KISAN Portal',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {},
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.grass,
                                      size: 32, color: Colors.green),
                                  SizedBox(height: 8),
                                  Text(
                                    'Soil Health Card',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {},
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.security,
                                      size: 32, color: Colors.orange),
                                  SizedBox(height: 8),
                                  Text(
                                    'Crop Insurance',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
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