import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'providers/home_provider.dart';
import 'providers/theme_provider.dart';
import 'l10n/app_localizations.dart';
// import 'utils/dummy_data_generator.dart';
import 'views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase初期化
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Crashlytics設定
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // 日本語ロケールの初期化
  await initializeDateFormatting('ja_JP', null);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  // // Clear existing data first
  // await DummyDataGenerator.clearAllData();

  // // Generate new dummy data
  // await DummyDataGenerator.generateDummyData();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Whodat?',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.getThemeData(context).copyWith(
              textTheme: GoogleFonts.notoSansJpTextTheme(
                themeProvider.getThemeData(context).textTheme,
              ),
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            navigatorObservers: <NavigatorObserver>[observer],
            home: Builder(
              builder: (context) {
                // テーマカラーを初期化
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  themeProvider.loadThemeColor();
                });
                return const HomeView();
              },
            ),
          );
        },
      ),
    );
  }

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );
}
