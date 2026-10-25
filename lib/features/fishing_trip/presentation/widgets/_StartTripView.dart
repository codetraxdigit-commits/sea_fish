import 'package:fishtrack/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StartTripView extends StatelessWidget {
  final String boatName;
  final VoidCallback onStart;

  const StartTripView({
    required this.boatName,
    required this.onStart,
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
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color:
                AppColors.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sailing,
                size: 50,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ready to go fishing?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              boatName,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onStart,
                icon: const Icon(
                  Icons.play_arrow,
                ),
                label: const Text(
                  'Start Fishing Trip',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}