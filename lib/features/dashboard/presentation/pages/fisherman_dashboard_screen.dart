import 'package:fishtrack/core/di/injection.dart';
import 'package:fishtrack/core/routes/app_routes.dart';
import 'package:fishtrack/features/boat/presentation/bloc/boat_bloc.dart';
import 'package:fishtrack/features/boat/presentation/pages/my_boat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/boat_status_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/quick_action_card.dart';

class FishermanDashboardScreen extends StatefulWidget {
  const FishermanDashboardScreen({
    super.key,
  });

  @override
  State<FishermanDashboardScreen> createState() =>
      _FishermanDashboardScreenState();
}

class _FishermanDashboardScreenState
    extends State<FishermanDashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardBloc>().add(
        const DashboardFetchRequested(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state.status == DashboardStatus.initial ||
                state.status == DashboardStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryBlue,
                ),
              );
            }

            if (state.status == DashboardStatus.failure) {
              return _buildErrorState(
                state.errorMessage ?? 'Something went wrong.',
              );
            }

            final dashboard = state.dashboard;

            if (dashboard == null) {
              return _buildErrorState(
                'Dashboard data is unavailable.',
              );
            }

            return RefreshIndicator(
              color: AppColors.primaryBlue,
              onRefresh: () async {
                context.read<DashboardBloc>().add(
                  const DashboardRefreshRequested(),
                );

                await Future.delayed(
                  const Duration(milliseconds: 500),
                );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  30,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 700,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        DashboardHeader(
                          userName: dashboard.userName,
                          role: dashboard.role,
                          notificationCount:
                          dashboard.notificationCount,
                          onNotificationTap:
                          _openNotifications,
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'Your Boat',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: 12),

                        BoatStatusCard(
                          hasBoat: dashboard.hasBoat,
                          boatName: dashboard.boatName,
                          boatStatus: dashboard.boatStatus,
                          registrationNumber:
                          dashboard.boatRegistrationNumber,
                          hasActiveTrip:
                          dashboard.hasActiveTrip,
                          onTap: _openBoat,
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          "Today's Summary",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            DashboardStatCard(
                              icon: Icons.set_meal_outlined,
                              value:
                              '${dashboard.todayCatchKg.toStringAsFixed(1)} kg',
                              title: 'Today\'s Catch',
                            ),
                            const SizedBox(width: 12),
                            DashboardStatCard(
                              icon: Icons.currency_rupee,
                              value:
                              '₹${dashboard.todaySales.toStringAsFixed(0)}',
                              title: 'Today\'s Sales',
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: 12),

                        GridView.count(
                          crossAxisCount:
                          MediaQuery.of(context).size.width >= 600
                              ? 4
                              : 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          shrinkWrap: true,
                          physics:
                          const NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.15,
                          children: [
                            QuickActionCard(
                              icon: Icons.sailing_outlined,
                              title: dashboard.hasActiveTrip
                                  ? 'View Trip'
                                  : 'Start Trip',
                              onTap: _openTrips,
                            ),
                            QuickActionCard(
                              icon: Icons.set_meal_outlined,
                              title: 'Add Catch',
                              onTap: _addCatch,
                            ),
                            QuickActionCard(
                              icon: Icons.storefront_outlined,
                              title: 'Marketplace',
                              onTap: _openMarketplace,
                            ),
                            QuickActionCard(
                              icon: Icons.warning_amber_rounded,
                              title: 'SOS',
                              danger: true,
                              onTap: _openEmergency,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        _buildActiveTripCard(
                          dashboard.hasActiveTrip,
                          dashboard.tripType,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildActiveTripCard(
      bool hasActiveTrip,
      String tripType,
      ) {
    if (!hasActiveTrip) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.cardBorder,
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'No active fishing trip right now.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.successGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.successGreen.withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.successGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sailing,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Trip Active',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  tripType.isEmpty
                      ? 'Your fishing trip is active.'
                      : tripType,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return NavigationBar(
      selectedIndex: _selectedIndex,
      backgroundColor: AppColors.surface,
      indicatorColor:
      AppColors.primaryBlue.withOpacity(0.10),
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });

        switch (index) {
          case 0:
            break;
          case 1:
            _openTrips();
            break;
          case 2:
            _openMarketplace();
            break;
          case 3:
            _openProfile();
            break;
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.sailing_outlined),
          selectedIcon: Icon(Icons.sailing),
          label: 'Trips',
        ),
        NavigationDestination(
          icon: Icon(Icons.storefront_outlined),
          selectedIcon: Icon(Icons.storefront),
          label: 'Market',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
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
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load dashboard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<DashboardBloc>().add(
                  const DashboardFetchRequested(),
                );
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  void _openNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications coming next.'),
      ),
    );
  }

  void _openBoat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<BoatBloc>()
            ..add(const BoatFetchRequested()),
          child: const MyBoatScreen(),
        ),
      ),
    );

      print('Navigating to My Boat screen...');
  }

  void _openTrips() {
    Navigator.pushNamed(
      context,
      AppRoutes.fishingTrip,
    );
  }

  void _addCatch() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add catch screen coming next.'),
      ),
    );
  }

  void _openMarketplace() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fish marketplace coming next.'),
      ),
    );
  }

  void _openEmergency() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('SOS module coming next.'),
      ),
    );
  }

  void _openProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile screen coming next.'),
      ),
    );
  }
}