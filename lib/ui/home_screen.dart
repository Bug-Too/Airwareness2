import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        },
        backgroundColor: const Color(0xFF1C1C1E),
        child: const Icon(Icons.settings, color: Colors.white),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          final l10n = AppLocalizations.of(context)!;

          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.currentLocation == null) {
            return Center(child: Text(l10n.noLocationSelected));
          }

          final aqi = provider.airQuality?.aqi ?? 0;

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
                          provider.currentLocation?.name ?? l10n.unknownLocation,
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
                              _getAqiLabel(context, provider.aqiLabelKey),
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
                      
                      // Grid for Recommendations (Mask, Windows, Sunscreen, Umbrella)
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                         childAspectRatio: 1.1,
                        children: [
                          if (provider.showMask)
                            _buildActionCard(
                              icon: Icons.masks,
                              label: l10n.wearingMask, 
                              isActive: true,
                            ),
                           if (provider.showSunscreen)
                             _buildActionCard(
                              icon: Icons.wb_sunny,
                              label: l10n.sunscreen,
                              isActive: true,
                            ),
                          if (provider.showUmbrella)
                            _buildActionCard(
                              icon: Icons.umbrella,
                              label: l10n.umbrella,
                              isActive: true,
                            ),
                          if (provider.closeWindows)
                            _buildActionCard(
                              icon: Icons.window, 
                              label: l10n.closeWindows,
                              isActive: true,
                            ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // List Items for Activity and Purifier
                      _buildActionListTile(
                        icon: Icons.directions_run,
                        label: _getActivityRecommendation(context, provider.activityRecommendationKey),
                        isActive: true, // Always show status
                      ),
                      const SizedBox(height: 8),
                      // Purifier
                      if (provider.purifierOn)
                        _buildActionListTile(
                          icon: Icons.air,
                          label: l10n.airPurifier,
                          isActive: true,
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

  String _getAqiLabel(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'aqiGood': return l10n.aqiGood;
      case 'aqiModerate': return l10n.aqiModerate;
      case 'aqiUnhealthySensitive': return l10n.aqiUnhealthySensitive;
      case 'aqiUnhealthy': return l10n.aqiUnhealthy;
      case 'aqiVeryUnhealthy': return l10n.aqiVeryUnhealthy;
      case 'aqiHazardous': return l10n.aqiHazardous;
      default: return key;
    }
  }

  String _getActivityRecommendation(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'actGood': return l10n.actGood;
      case 'actModerateGeneral': return l10n.actModerateGeneral;
      case 'actModerateSensitive': return l10n.actModerateSensitive;
      case 'actUnhealthySensitiveGeneral': return l10n.actUnhealthySensitiveGeneral;
      case 'actUnhealthySensitiveSensitive': return l10n.actUnhealthySensitiveSensitive;
      case 'actUnhealthyGeneral': return l10n.actUnhealthyGeneral;
      case 'actUnhealthySensitive': return l10n.actUnhealthySensitive;
      case 'actVeryUnhealthyGeneral': return l10n.actVeryUnhealthyGeneral;
      case 'actVeryUnhealthySensitive': return l10n.actVeryUnhealthySensitive;
      case 'actHazardousGeneral': return l10n.actHazardousGeneral;
      case 'actHazardousSensitive': return l10n.actHazardousSensitive;
      default: return key;
    }
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
