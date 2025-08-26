import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/language_provider.dart';
import 'providers/survey_provider.dart';
import 'screens/onboarding_screen.dart';
import 'utils/language_utils.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LanguageProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (context) => SurveyProvider(),
        ),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'AI Survey Assistant',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF5B5FE9),
                primary: const Color(0xFF5B5FE9),
                secondary: const Color(0xFF00C6AE),
                surface: Colors.white,
                onPrimary: Colors.white,
                onSecondary: Colors.white,
                onSurface: Colors.black,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              textTheme: const TextTheme(
                displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 0.2),
                headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  side: const BorderSide(color: Color(0xFF5B5FE9)),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              cardTheme: CardThemeData(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF5B5FE9),
                foregroundColor: Colors.white, 
                elevation: 0,
                centerTitle: true,
                titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF5B5FE9)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF00C6AE), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LanguageUtils.supportedLocales,
            locale: languageProvider.currentLocale,
            initialRoute: AppRoutes.onboarding,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
} 