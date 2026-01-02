import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'providers/app_provider.dart';
import 'ui/home_screen.dart';
import 'ui/onboarding_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()..init()),
      ],
      child: const AirwarenessApp(),
    ),
  );
}

class AirwarenessApp extends StatelessWidget {
  const AirwarenessApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    
    return MaterialApp(
      title: 'Airwareness2',
      debugShowCheckedModeBanner: false,
      locale: provider.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('th'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.blue,
          surface: Color(0xFF1E1E1E),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      ),
      home: const MainWrapper(),
    );
  }
}

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    
    if (!provider.isOnboardingComplete) {
      return const OnboardingScreen();
    }
    
    return const HomeScreen();
  }
}
