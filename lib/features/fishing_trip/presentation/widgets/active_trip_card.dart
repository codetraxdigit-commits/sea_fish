import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/fishing_trip_entity.dart';

class ActiveTripCard extends StatelessWidget {
  final FishingTripEntity trip;
  final VoidCallback onEndTrip;

  const ActiveTripCard({
    super.key,
    required this.trip,
    required this.onEndTrip,
  });

  String _formatDuration() {
    final duration = DateTime.now().difference(
      trip.startTime,
    );

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    return '${hours}h ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.errorRed,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Fishing Trip Active',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _info(
              Icons.access_time,
              'Started',
              _formatTime(trip.startTime),
            ),

            const SizedBox(height: 12),

            _info(
              Icons.timer_outlined,
              'Duration',
              _formatDuration(),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: onEndTrip,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorRed,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(
                  Icons.stop_circle_outlined,
                ),
                label: const Text(
                  'End Fishing Trip',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(
      IconData icon,
      String title,
      String value,
      ) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primaryBlue,
        ),
        const SizedBox(width: 12),
        Text(
          '$title: ',
          style: const TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;

    final hour12 = hour == 0
        ? 12
        : hour > 12
        ? hour - 12
        : hour;

    final period = hour >= 12 ? 'PM' : 'AM';

    return '$hour12:${minute.toString().padLeft(2, '0')} $period';
  }
}