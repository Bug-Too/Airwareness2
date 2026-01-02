import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.currentLocation == null) {
            return const Center(child: Text('No location selected'));
          }

          final aqi = provider.airQuality?.aqi ?? 0;
          final weather = provider.weather;

          // Logic mapping to screenshot actions
          // "Wear a mask" - pollution based
          bool showMask = (aqi > 100 && provider.isSensitive) || aqi > 150;
          
          // "Close windows" - pollution based
          bool closeWindows = aqi > 100;
          
          // "Limit outdoor activities"
          bool limitOutdoor = aqi > 100;
          
          // "Air Purifier On"
          bool purifierOn = aqi > 50;

          return SafeArea(
            child: RefreshIndicator(
              onRefresh: provider.fetchData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // City Name
                      GestureDetector(
                         onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SearchScreen()),
                            );
                          },
                        child: Text(
                          provider.currentLocation?.name ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 32, 
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Big AQI Number
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            aqi.toString(),
                            style: const TextStyle(
                              fontSize: 96,
                              fontWeight: FontWeight.w200, // Thin font
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'US AQI',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Status Bar Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1E),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getAqiLabel(aqi),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Custom Gradient Progress
                            SizedBox(
                              height: 4,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.blue,
                                          Colors.green,
                                          Colors.yellow,
                                          Colors.orange,
                                          Colors.red,
                                          Colors.purple,
                                          Colors.brown,
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Thumb/Indicator
                                  Align(
                                    alignment: Alignment((aqi / 300).clamp(0.0, 1.0) * 2 - 1, 0),
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black, width: 1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Grid for Mask / Windows
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionCard(
                              icon: Icons.masks,
                              label: 'Wear a mask', 
                              isActive: showMask,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildActionCard(
                              icon: Icons.window, 
                              label: 'Close windows',
                              isActive: closeWindows,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // List Items
                      _buildActionListTile(
                        icon: Icons.directions_run,
                        label: 'Limit outdoor activities',
                        isActive: limitOutdoor,
                      ),
                      const SizedBox(height: 8),
                      _buildActionListTile(
                        icon: Icons.air,
                        label: 'Air Purifier On',
                        isActive: purifierOn,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getAqiLabel(int aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy for Sensitive Groups';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  Widget _buildActionCard({required IconData icon, required String label, required bool isActive}) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionListTile({required IconData icon, required String label, required bool isActive}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
