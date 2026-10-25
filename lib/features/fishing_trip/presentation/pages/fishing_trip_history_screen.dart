import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/fishing_trip_bloc.dart';
import '../bloc/fishing_trip_event.dart';
import '../bloc/fishing_trip_state.dart';
import '../widgets/trip_history_card.dart';

class FishingTripHistoryScreen extends StatelessWidget {
  const FishingTripHistoryScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fishing Trip History',
        ),
      ),
      body: BlocConsumer<FishingTripBloc, FishingTripState>(
        listener: (context, state) {
          if (state.status ==
              FishingTripBlocStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ??
                      'Unable to load trip history.',
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status ==
              FishingTripBlocStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status ==
              FishingTripBlocStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status ==
              FishingTripBlocStatus.failure &&
              state.history.isEmpty) {
            return _ErrorView(
              message: state.errorMessage ??
                  'Unable to load trip history.',
              onRetry: () {
                context.read<FishingTripBloc>().add(
                  const FishingTripHistoryRequested(),
                );
              },
            );
          }

          if (state.history.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<FishingTripBloc>().add(
                  const FishingTripHistoryRequested(),
                );

                await Future.delayed(
                  const Duration(milliseconds: 500),
                );
              },
              child: ListView(
                physics:
                const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
                  Center(
                    child: Text(
                      'No fishing trips yet.',
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<FishingTripBloc>().add(
                const FishingTripHistoryRequested(),
              );

              await Future.delayed(
                const Duration(milliseconds: 500),
              );
            },
            child: ListView.builder(
              physics:
              const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: state.history.length,
              itemBuilder: (context, index) {
                final trip = state.history[index];

                return Padding(
                  padding:
                  const EdgeInsets.only(bottom: 12),
                  child: TripHistoryCard(
                    trip: trip,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load trips',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text(
                'Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }
}