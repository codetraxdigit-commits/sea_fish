import 'package:firebase_core/firebase_core.dart';
import 'package:fishtrack/features/authentication/presentation/widget/register_screen.dart';
import 'package:fishtrack/features/boat/presentation/bloc/boat_bloc.dart';
import 'package:fishtrack/features/boat/presentation/pages/add_boat_screen.dart';
import 'package:fishtrack/features/boat/presentation/pages/my_boat_screen.dart';
import 'package:fishtrack/features/dashboard/presentation/pages/fisherman_dashboard_screen.dart';
import 'package:fishtrack/features/fishing_trip/presentation/bloc/fishing_trip_bloc.dart';
import 'package:fishtrack/features/fishing_trip/presentation/bloc/fishing_trip_event.dart';
import 'package:fishtrack/features/fishing_trip/presentation/pages/fishing_trip_history_screen.dart';
import 'package:fishtrack/features/fishing_trip/presentation/pages/fishing_trip_screen.dart';
import 'package:fishtrack/features/fishing_trip/presentation/pages/start_fishing_trip_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection.dart';
import 'core/routes/app_routes.dart';
import 'features/authentication/presentation/screen/RegisterScreen.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'features/authentication/presentation/screen/login_screen.dart';
import 'features/authentication/presentation/screen/splash_screen.dart';
import 'features/onboarding/presentation/screen/onboarding_screen.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';

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
    return
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FishTrack',

        home: const OnboardingScreen(),

        routes: {
          OnboardingScreen.routeName: (context) =>
          const OnboardingScreen(),

          LoginScreen.routeName: (context) =>
          const LoginScreen(),

          RegisterScreen.routeName: (context) =>
          const RegisterScreen(),

          AppRoutes.fishermanDashboard: (context) =>
              BlocProvider(
                create: (_) => sl<DashboardBloc>(),
                child: const FishermanDashboardScreen(),
              ),

          AppRoutes.addBoat: (context) =>
              BlocProvider(
                create: (_) => sl<BoatBloc>(),
                child: const AddBoatScreen(),
              ),

          AppRoutes.myBoat: (context) =>
              BlocProvider(
                create: (_) => sl<BoatBloc>()
                  ..add(const BoatFetchRequested()),
                child: const MyBoatScreen(),
              ),

          // ✅ ADD THIS
          AppRoutes.fishingTrip: (context) =>
              BlocProvider<FishingTripBloc>(
                create: (_) => sl<FishingTripBloc>()
                  ..add(const FishingTripFetchActiveRequested()),
                child: const FishingTripScreen(),
              ),

          AppRoutes.fishingTripHistory: (context) =>
              BlocProvider<FishingTripBloc>(
                create: (_) => sl<FishingTripBloc>()
                  ..add(const FishingTripHistoryRequested()),
                child: const FishingTripHistoryScreen(),
              ),
        },
      );
  }
}