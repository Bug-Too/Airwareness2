import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import 'search_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          // Language Section
          ListTile(
            title: Text(l10n.language),
            trailing: DropdownButton<Locale>(
              value: provider.locale,
              dropdownColor: const Color(0xFF1E1E1E),
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('th'),
                  child: Text('ไทย'),
                ),
              ],
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  provider.setLocale(newLocale);
                }
              },
            ),
          ),
          const Divider(color: Colors.white10),
          
          // Sensitivity Section
          SwitchListTile(
            title: Text(l10n.sensitiveGroup),
            subtitle: Text(
              provider.isSensitive ? l10n.sensitiveGroupDesc : l10n.generalPopulationDesc,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            value: provider.isSensitive,
            onChanged: (val) {
              provider.completeOnboarding(val);
            },
          ),
           const Divider(color: Colors.white10),

          // Location Section (Re-pick location)
           ListTile(
            title: Text(l10n.searchLocation),
            subtitle: Text(provider.currentLocation?.name ?? l10n.unknownLocation),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
