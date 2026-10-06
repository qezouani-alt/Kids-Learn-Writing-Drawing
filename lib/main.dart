import 'package:flutter/material.dart';

import 'app_state.dart';
import 'app_open_ads.dart';
import 'branding.dart';
import 'screens.dart';
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _AppBootstrap());
}

class _AppBootstrap extends StatefulWidget {
  const _AppBootstrap();

  @override
  State<_AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<_AppBootstrap> {
  late Future<AppState> _ready = _load();

  Future<AppState> _load() async {
    final ads = StartupAd();
    final adReady = ads.prepare();
    final minimumSplash = Future<void>.delayed(
      const Duration(seconds: 5),
    );
    final state = await AppState.load();
    await minimumSplash;
    await adReady;
    if (mounted) await ads.showIfReady();
    ads.dispose();
    return state;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<AppState>(
    future: _ready,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return AppScope(state: snapshot.data!, child: const LittleLinesApp());
      }
      return MaterialApp(
        title: appDisplayName,
        debugShowCheckedModeBanner: false,
        theme: _appTheme(context),
        home:
            snapshot.connectionState == ConnectionState.done &&
                snapshot.hasError
            ? Scaffold(
                body: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Could not open drawing lessons.'),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => setState(() => _ready = _load()),
                        child: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              )
            : const SplashScreen(),
      );
    },
  );
}

class LittleLinesApp extends StatelessWidget {
  const LittleLinesApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: appDisplayName,
    debugShowCheckedModeBanner: false,
    theme: _appTheme(context),
    home: const HomePage(),
  );
}

ThemeData _appTheme(BuildContext context) => ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF8FAFF),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF7459D9),
    surface: const Color(0xFFF8FAFF),
  ),
  textTheme: const TextTheme().apply(
    bodyColor: const Color(0xFF26314D),
    displayColor: const Color(0xFF26314D),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFF8FAFF),
    foregroundColor: Color(0xFF26314D),
    centerTitle: false,
  ),
);
