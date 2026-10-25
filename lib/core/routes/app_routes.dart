import 'package:fishtrack/core/di/injection.dart';
import 'package:fishtrack/features/boat/presentation/bloc/boat_bloc.dart';
import 'package:fishtrack/features/boat/presentation/pages/add_boat_screen.dart';
import 'package:fishtrack/features/boat/presentation/pages/my_boat_screen.dart';
import 'package:fishtrack/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:fishtrack/features/dashboard/presentation/pages/fisherman_dashboard_screen.dart';
import 'package:fishtrack/features/fishing_trip/presentation/bloc/fishing_trip_bloc.dart';
import 'package:fishtrack/features/fishing_trip/presentation/bloc/fishing_trip_event.dart';
import 'package:fishtrack/features/fishing_trip/presentation/pages/fishing_trip_history_screen.dart';
import 'package:fishtrack/features/fishing_trip/presentation/pages/fishing_trip_screen.dart';
import 'package:fishtrack/features/fishing_trip/presentation/pages/start_fishing_trip_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const auth = '/auth';
  static const dashboard = '/dashboard';
  static const market = '/market';
  static const tracking = '/tracking';

  static const String fishermanDashboard =
      '/fisherman-dashboard';

  static const String myBoat = '/my-boat';

  static const String addBoat = '/add-boat';

  static const String fishingTrip = '/fishing-trip';

  static const String startFishingTrip =
      '/start-fishing-trip';

  static const String fishingTripHistory =
      '/fishing-trip-history';

  static Route<dynamic> generateRoute(
      RouteSettings settings,
      ) {
    switch (settings.name) {

      case fishermanDashboard:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<DashboardBloc>()
              ..add(
                const DashboardFetchRequested(),
              ),
            child: const FishermanDashboardScreen(),
          ),
        );

      case myBoat:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) {
              final bloc = sl<BoatBloc>();

              bloc.add(
                const BoatFetchRequested(),
              );

              return bloc;
            },
            child: const MyBoatScreen(),
          ),
        );

      case addBoat:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<BoatBloc>(),
            child: const AddBoatScreen(),
          ),
        );
      case AppRoutes.fishingTrip:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<FishingTripBloc>()
              ..add(
                const FishingTripFetchActiveRequested(),
              ),
            child: const FishingTripScreen(),
          ),
        );

      case AppRoutes.startFishingTrip:
        final boatId = settings.arguments as String;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<FishingTripBloc>(),
            child: StartFishingTripScreen(
              boatId: boatId,
            ),
          ),
        );

      case AppRoutes.fishingTripHistory:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<FishingTripBloc>()
              ..add(
                const FishingTripHistoryRequested(),
              ),
            child: const FishingTripHistoryScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
}