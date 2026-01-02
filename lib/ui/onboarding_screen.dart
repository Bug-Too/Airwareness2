import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import 'search_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Text(
                l10n.welcomeTitle,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.welcomeSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[400],
                    ),
              ),
              const Spacer(),
              _buildOption(
                context,
                title: l10n.sensitiveGroup,
                description: l10n.sensitiveGroupDesc,
                isSensitive: true,
                icon: Icons.personal_injury,
              ),
              const SizedBox(height: 16),
              _buildOption(
                context,
                title: l10n.generalPopulation,
                description: l10n.generalPopulationDesc,
                isSensitive: false,
                icon: Icons.person,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context,
      {required String title,
      required String description,
      required bool isSensitive,
      required IconData icon}) {
    return Material(
      color: const Color(0xFF1C1C1E),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Complete onboarding, then go to Search since we need a location
          final provider = Provider.of<AppProvider>(context, listen: false);
          provider.completeOnboarding(isSensitive).then((_) {
            if (!context.mounted) return;
             Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          });
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white10),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
