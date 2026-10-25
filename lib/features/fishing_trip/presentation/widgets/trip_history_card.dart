import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/fishing_trip_entity.dart';

class TripHistoryCard extends StatelessWidget {
  final FishingTripEntity trip;

  const TripHistoryCard({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.sailing_outlined,
            color: AppColors.primaryBlue,
          ),
        ),
        title: Text(
          _formatDate(trip.startTime),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          _duration(),
        ),
        trailing: const Icon(
          Icons.check_circle,
          color: AppColors.successGreen,
        ),
      ),
    );
  }

  String _duration() {
    if (trip.endTime == null) {
      return 'Active';
    }

    final duration = trip.endTime!.difference(
      trip.startTime,
    );

    return '${duration.inHours}h '
        '${duration.inMinutes.remainder(60)}m';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}