import 'package:fishtrack/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ActiveTripView extends StatelessWidget {
  final String boatName;
  final dynamic trip;
  final VoidCallback onEnd;
  final VoidCallback onTrack;

  const ActiveTripView({
    required this.boatName,
    required this.trip,
    required this.onEnd,
    required this.onTrack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.successGreen.withOpacity(0.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.successGreen.withOpacity(0.25),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.sailing,
                  size: 55,
                  color: AppColors.successGreen,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Fishing Trip Active',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  boatName,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onTrack,
              icon: const Icon(Icons.my_location),
              label: const Text('Live Boat Location'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onEnd,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
              ),
              icon: const Icon(Icons.stop, color: Colors.white),
              label: const Text(
                'End Fishing Trip',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
