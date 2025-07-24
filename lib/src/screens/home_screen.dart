import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_kisan_flutter/widgets/bottom_navigation.dart';
import 'package:project_kisan_flutter/widgets/floating_voice_button.dart';
import 'package:project_kisan_flutter/widgets/voice_indicator.dart';
import 'package:project_kisan_flutter/services/query_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isVoiceMode = false;
  String _selectedLanguage = 'en';

  final List<Map<String, dynamic>> quickActions = [
    {
      'title': 'Crop Disease',
      'description': 'Take a photo to diagnose plant diseases instantly',
      'icon': Icons.camera_alt,
      'color': Colors.red,
      'path': '/scan',
    },
    {
      'title': 'Market Prices',
      'description': 'Check current rates and price trends',
      'icon': Icons.show_chart,
      'color': Colors.green,
      'path': '/market',
    },
    {
      'title': 'Gov Schemes',
      'description': 'Find subsidies and government support',
      'icon': Icons.account_balance,
      'color': Colors.blue,
      'path': '/schemes',
    },
    {
      'title': 'Weather',
      'description': 'Get weather updates and farming advice',
      'icon': Icons.wb_sunny,
      'color': Colors.orange,
      'path': '/weather',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final queryClient = Provider.of<QueryClient>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.eco),
            const SizedBox(width: 8),
            const Text('Project Kisan'),
          ],
        ),
        actions: [
          DropdownButton<String>(
            value: _selectedLanguage,
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'hi', child: Text('हिंदी')),
              DropdownMenuItem(value: 'kn', child: Text('ಕನ್ನಡ')),
              DropdownMenuItem(value: 'te', child: Text('తెలుగు')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {
              setState(() {
                _isVoiceMode = !_isVoiceMode;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Welcome Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1595273670150-bd0c3c392e46'),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Welcome, Rohan',
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Farming in Karnataka',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '🌾 Your AI agricultural assistant is ready to help!',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Tap the microphone to speak or use the tools below',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Quick Actions Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: quickActions.map((action) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, action['path']);
                        },
                        child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: action['color'].withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(action['icon'], color: action['color']),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  action['title'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  action['description'],
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                                const Spacer(),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: action['color'],
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, action['path']);
                                    },
                                    child: Text(
                                      action['title'] == 'Crop Disease'
                                          ? 'Scan Disease'
                                          : action['title'] == 'Market Prices'
                                          ? 'View Prices'
                                          : action['title'] == 'Gov Schemes'
                                          ? 'Browse Schemes'
                                          : 'Check Weather',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // Market Prices Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Today's Market Prices",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {
                                  queryClient.invalidate('/api/market-prices');
                                },
                                child: const Row(
                                  children: [
                                    Icon(Icons.refresh, size: 16),
                                    SizedBox(width: 4),
                                    Text('Refresh'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          FutureBuilder(
                            future: queryClient.fetch(
                                '/api/market-prices', _fetchMarketPrices),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final marketPrices = snapshot.data ?? [];
                              return Column(
                                children: [
                                  GridView.count(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    crossAxisCount: 3,
                                    childAspectRatio: 0.8,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    children: marketPrices.take(3).map((price) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey[200]!),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  price['crop'],
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  "${price['trend'] == 'up' ? '+' : price['trend'] == 'down' ? '-' : ''}${price['trendPercentage'].abs()}%",
                                                  style: TextStyle(
                                                    color: price['trend'] == 'up'
                                                        ? Colors.green
                                                        : price['trend'] == 'down'
                                                        ? Colors.red
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '₹${(price['price'] / 100).toStringAsFixed(0)}/${price['unit']}',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              price['market'],
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600]),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.blue),
                                    ),
                                    child: const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.auto_awesome,
                                                color: Colors.blue, size: 16),
                                            SizedBox(width: 4),
                                            Text(
                                              'AI Market Insight',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Tomato prices are trending up by 5% this week. Consider selling your harvest in the next 2-3 days for maximum profit.',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Government Schemes Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Available Government Schemes',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          FutureBuilder(
                            future: queryClient.fetch('/api/schemes', _fetchSchemes),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final schemes = snapshot.data ?? [];
                              return Column(
                                children: schemes.take(2).map((scheme) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey[200]!),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    scheme['name'],
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    scheme['description'],
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600]),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        scheme['amount'],
                                                        style: const TextStyle(
                                                            color: Colors.green,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                      const SizedBox(width: 16),
                                                      Text(
                                                        scheme['status'] ==
                                                            'eligible'
                                                            ? 'Eligible'
                                                            : scheme['status'] ==
                                                            'under_review'
                                                            ? 'Under Review'
                                                            : 'Not Eligible',
                                                        style: TextStyle(
                                                          color: scheme['status'] ==
                                                              'eligible'
                                                              ? Colors.green
                                                              : scheme['status'] ==
                                                              'under_review'
                                                              ? Colors.orange
                                                              : Colors.red,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                              ),
                                              child: const Text(
                                                'View Details',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Recent Activity
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recent Activity',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          FutureBuilder(
                            future: queryClient.fetch(
                                '/api/activities/1', _fetchActivities),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final activities = snapshot.data ?? [];
                              if (activities.isEmpty) {
                                return const Column(
                                  children: [
                                    Icon(Icons.history, size: 48, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text('No recent activity'),
                                  ],
                                );
                              }
                              return Column(
                                children: activities.take(3).map((activity) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.green[50],
                                            shape: BoxShape.circle,
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: Icon(
                                            Icons.notifications,
                                            color: Colors.green[400],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(activity['title']),
                                              Text(
                                                activity['description'],
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600]),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${DateTime.now().difference(activity['createdAt']).inDays} days ago',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey[500]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          VoiceIndicator(
            isVisible: _isVoiceMode,
            isListening: false,
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(),
      floatingActionButton: const FloatingVoiceButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<List<Map<String, dynamic>>> _fetchMarketPrices() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'crop': 'Tomato',
        'price': 2500,
        'unit': 'kg',
        'market': 'Bangalore APMC',
        'trend': 'up',
        'trendPercentage': 5.0,
      },
      {
        'crop': 'Potato',
        'price': 1800,
        'unit': 'kg',
        'market': 'Mysore APMC',
        'trend': 'down',
        'trendPercentage': 2.5,
      },
      {
        'crop': 'Onion',
        'price': 2200,
        'unit': 'kg',
        'market': 'Hubli APMC',
        'trend': 'up',
        'trendPercentage': 3.2,
      },
    ];
  }

  Future<List<Map<String, dynamic>>> _fetchSchemes() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'id': 1,
        'name': 'PM Kisan Samman Nidhi',
        'description': 'Financial support of ₹6000/year to small farmers',
        'amount': '₹6000/year',
        'status': 'eligible',
      },
      {
        'id': 2,
        'name': 'Soil Health Card Scheme',
        'description': 'Free soil testing for farmers',
        'amount': 'Free',
        'status': 'under_review',
      },
    ];
  }

  Future<List<Map<String, dynamic>>> _fetchActivities() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        'id': 1,
        'title': 'New market price alert',
        'description': 'Tomato prices increased by 5%',
        'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'id': 2,
        'title': 'Weather advisory',
        'description': 'Rain expected in your area tomorrow',
        'createdAt': DateTime.now().subtract(const Duration(days: 1)),
      },
    ];
  }
}