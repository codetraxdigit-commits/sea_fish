import 'package:fishtrack/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NoBoatView extends StatelessWidget {
  final VoidCallback onAddBoat;

  const NoBoatView({
    required this.onAddBoat,
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
              Icons.directions_boat_outlined,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 20),
            const Text(
              'No Boat Registered',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Register your boat before starting a fishing trip.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAddBoat,
              icon: const Icon(Icons.add),
              label: const Text(
                'Register Boat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}