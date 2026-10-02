import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/di/injection.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'features/authentication/presentation/screen/login_screen.dart';
import 'features/authentication/presentation/screen/splash_screen.dart';
import 'features/onboarding/presentation/screen/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setupDependencies();

  runApp(const SeaLinkApp());
}

class SeaLinkApp extends StatelessWidget {
  const SeaLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SeaLink',
      theme: AppTheme.lightTheme,

      initialRoute: SplashScreen.routeName,

      routes: {
        SplashScreen.routeName: (context) =>
        const SplashScreen(),

        OnboardingScreen.routeName: (context) =>
        const OnboardingScreen(),

        LoginScreen.routeName: (context) =>
        const LoginScreen(),
      },
    );
  }
}