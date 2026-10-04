import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/boat_entity.dart';
import '../bloc/boat_bloc.dart';

class MyBoatScreen extends StatelessWidget {
  const MyBoatScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Boat'),
      ),
      body: BlocConsumer<BoatBloc, BoatState>(
        listener: (context, state) {
          if (state.status == BoatStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Unable to load boat.',
                ),
              ),
            );
          }
          // if (state.status == BoatStatus.success) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(
          //       content: Text('Boat registered successfully'),
          //     ),
          //   );
          //
          //   Navigator.pop(context, true);
          // }
        },
        builder: (context, state) {
          if (state.status == BoatStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final boat = state.boat; // No boat registered
          if (boat == null) {
            return _NoBoatView(
              onAddBoat: () async {
                final result = await Navigator.pushNamed(
                  context,
                  AppRoutes.addBoat,
                ); // Boat was successfully added.
                if (result == true && context.mounted) {

                  print("call bloc fetch");
                  context.read<BoatBloc>().add(
                    const BoatFetchRequested(),
                  );
                }
              },
            );
          }
// Boat found
          return RefreshIndicator(
            onRefresh: () async {
              context.read<BoatBloc>().add(
                const BoatFetchRequested(),
              );
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _BoatImage(
                  imageUrl: boat.imageUrl,
                ),
                const SizedBox(height: 20),
                Text(
                  boat.boatName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                _StatusChip(
                  status: boat.status,
                ),
                const SizedBox(height: 24),
                _InfoCard(
                  boat: boat,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Edit boat will be available here.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.edit_outlined,
                    ),
                    label: const Text('Edit Boat'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NoBoatView extends StatelessWidget {
  final VoidCallback onAddBoat;
  const _NoBoatView({
    required this.onAddBoat,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.directions_boat_outlined,
                size: 64,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Boat Registered',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Register your fishing boat to start managing trips and catches.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 220,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: onAddBoat,
                icon: const Icon(Icons.add),
                label: const Text('Add Boat'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoatImage extends StatelessWidget {
  final String imageUrl;
  const _BoatImage({
    required this.imageUrl,
  });
  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.directions_boat,
          size: 80,
          color: AppColors.textSecondary,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Image.network(
        imageUrl,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            height: 220,
            color: AppColors.background,
            child: const Icon(
              Icons.directions_boat,
              size: 80,
            ),
          );
        },
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({
    required this.status,
  });
  @override
  Widget build(BuildContext context) {
    final bool active = status.toLowerCase() == 'active';
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: active
              ? AppColors.successGreen.withOpacity(0.1)
              : AppColors.pendingYellow.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                active ? AppColors.successGreen : AppColors.pendingYellow,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              active ? 'Active' : status,
              style: TextStyle(
                color:
                active ? AppColors.successGreen : AppColors.pendingYellow,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final BoatEntity boat;
  const _InfoCard({
    required this.boat,
  });
  Widget _row(
      IconData icon,
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primaryBlue,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          children: [
            _row(
              Icons.confirmation_number_outlined,
              'Registration',
              boat.registrationNumber,
            ),
            const Divider(),
            _row(
              Icons.sailing_outlined,
              'Boat Type',
              boat.boatType,
            ),
            const Divider(),
            _row(
              Icons.scale_outlined,
              'Capacity',
              '${boat.capacityKg.toStringAsFixed(0)} KG',
            ),
            const Divider(),
            _row(
              Icons.settings_outlined,
              'Engine Number',
              boat.engineNumber,
            ),
            const Divider(),
            _row(
              Icons.badge_outlined,
              'License',
              boat.licenseNumber,
            ),
          ],
        ),
      ),
    );
  }
}
