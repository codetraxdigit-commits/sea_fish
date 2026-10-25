
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/live_tracking_bloc.dart';
import '../bloc/live_tracking_event.dart';
import '../bloc/live_tracking_state.dart';

class LiveTrackingScreen extends StatelessWidget {
  final String fishermanId;
  final String boatId;
  final String tripId;

  const LiveTrackingScreen({
    super.key,
    required this.fishermanId,
    required this.boatId,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Live Boat Tracking'),
      ),
      body: BlocConsumer<LiveTrackingBloc, LiveTrackingState>(
        listener: (context, state) {
          if (state.status == LiveTrackingStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Tracking failed.',
                ),
                backgroundColor: AppColors.errorRed,
              ),
            );
          }
        },
        builder: (context, state) {
          final location = state.location;
          final isTracking =
              state.status == LiveTrackingStatus.tracking;
          final isLoading =
              state.status == LiveTrackingStatus.loading;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.cardBorder,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      isTracking
                          ? Icons.gps_fixed
                          : Icons.gps_not_fixed,
                      size: 56,
                      color: isTracking
                          ? AppColors.successGreen
                          : AppColors.primaryBlue,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isTracking
                          ? 'Boat tracking is active'
                          : state.status == LiveTrackingStatus.stopped
                          ? 'Tracking stopped'
                          : 'Boat tracking',
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isTracking
                          ? 'GPS updates are being received.'
                          : 'Start tracking to share the latest GPS position.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (location != null) ...[
                      _LocationRow(
                        label: 'Latitude',
                        value: location.latitude.toStringAsFixed(6),
                      ),
                      _LocationRow(
                        label: 'Longitude',
                        value: location.longitude.toStringAsFixed(6),
                      ),
                      _LocationRow(
                        label: 'Accuracy',
                        value:
                        '${location.accuracy.toStringAsFixed(1)} m',
                      ),
                      _LocationRow(
                        label: 'Speed',
                        value:
                        '${(location.speed * 3.6).toStringAsFixed(1)} km/h',
                      ),
                      _LocationRow(
                        label: 'Last GPS update',
                        value: location.updatedAt.toLocal().toString(),
                      ),
                    ] else
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'Waiting for the first GPS position...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () {
                    context.read<LiveTrackingBloc>().add(
                      LiveTrackingStartRequested(
                        fishermanId: fishermanId,
                        boatId: boatId,
                        tripId: tripId,
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Tracking'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: isLoading || !isTracking
                      ? null
                      : () {
                    context.read<LiveTrackingBloc>().add(
                      LiveTrackingStopRequested(
                        fishermanId: fishermanId,
                      ),
                    );
                  },
                  icon: const Icon(Icons.stop_circle_outlined),
                  label: const Text('Stop Tracking'),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Boat ID: $boatId',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  final String label;
  final String value;

  const _LocationRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
