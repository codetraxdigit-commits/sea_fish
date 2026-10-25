import 'package:fishtrack/features/fishing_trip/presentation/bloc/fishing_trip_bloc.dart';
import 'package:fishtrack/features/fishing_trip/presentation/bloc/fishing_trip_event.dart';
import 'package:fishtrack/features/fishing_trip/presentation/bloc/fishing_trip_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartFishingTripScreen extends StatelessWidget {
  final String boatId;

  const StartFishingTripScreen({
    super.key,
    required this.boatId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Fishing Trip'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocConsumer<FishingTripBloc,
              FishingTripState>(
            listener: (context, state) {
              if (state.status ==
                  FishingTripBlocStatus.success) {
                Navigator.pop(context, true);
              }

              if (state.status ==
                  FishingTripBlocStatus.failure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      state.errorMessage ??
                          'Unable to start trip.',
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              final loading =
                  state.status ==
                      FishingTripBlocStatus.loading;

              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: loading
                      ? null
                      : () {
                    context
                        .read<FishingTripBloc>()
                        .add(
                      FishingTripStartRequested(
                        boatId: boatId,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.sailing,
                  ),
                  label: loading
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Start Fishing Trip',
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}