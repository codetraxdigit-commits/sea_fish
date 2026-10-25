import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishtrack/features/fishing_trip/presentation/pages/start_fishing_trip_screen.dart';
import 'package:fishtrack/features/fishing_trip/presentation/widgets/_ActiveTripView.dart';
import 'package:fishtrack/features/fishing_trip/presentation/widgets/_NoBoatView.dart';
import 'package:fishtrack/features/fishing_trip/presentation/widgets/_StartTripView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../tracking/presentation/bloc/live_tracking_bloc.dart';
import '../../../tracking/presentation/pages/live_tracking_screen.dart';

import '../bloc/fishing_trip_bloc.dart';
import '../bloc/fishing_trip_event.dart';
import '../bloc/fishing_trip_state.dart';

class FishingTripScreen extends StatelessWidget {
  const FishingTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Fishing Trip'),
        actions: [
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.fishingTripHistory);
                },
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<FishingTripBloc, FishingTripState>(
        listener: (context, state) {
          if (state.status == FishingTripBlocStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Something went wrong.'),
                backgroundColor: AppColors.errorRed,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == FishingTripBlocStatus.initial ||
              state.status == FishingTripBlocStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final boat = state.boat;

          if (boat == null) {
            return NoBoatView(
              onAddBoat: () {
                Navigator.pushNamed(context, AppRoutes.addBoat);
              },
            );
          }

          final activeTrip = state.activeTrip;

          if (activeTrip == null) {
            return StartTripView(
              boatName: boat.boatName,
              onStart: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<FishingTripBloc>(),
                      child: StartFishingTripScreen(boatId: boat.id),
                    ),
                  ),
                );
              },
            );
          }

          return ActiveTripView(
            boatName: boat.boatName,
            trip: activeTrip,
            onTrack: () {
              final fishermanId = FirebaseAuth.instance.currentUser?.uid;

              if (fishermanId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please log in again.'),
                  ),
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider<LiveTrackingBloc>(
                    create: (_) => sl<LiveTrackingBloc>(),
                    child: LiveTrackingScreen(
                      fishermanId: fishermanId,
                      boatId: boat.id,
                      tripId: activeTrip.id,
                    ),
                  ),
                ),
              );
            },
            onEnd: () {
              _showEndTripDialog(context, activeTrip.id);
            },
          );
        },
      ),
    );
  }

  void _showEndTripDialog(BuildContext context, String tripId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('End Fishing Trip?'),
          content: const Text(
            'Are you sure you want to end this fishing trip?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                context.read<FishingTripBloc>().add(
                  FishingTripEndRequested(tripId: tripId),
                );
              },
              child: const Text('End Trip'),
            ),
          ],
        );
      },
    );
  }
}
