import 'package:flutter/material.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.search_outlined),
      selectedIcon: Icon(Icons.search),
      label: 'Explore',
    ),
    NavigationDestination(
      icon: Icon(Icons.notifications_outlined),
      selectedIcon: Icon(Icons.notifications),
      label: 'Alerts',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  static const List<_FeatureCardData> _featureCards = [
    _FeatureCardData(
      title: 'Authentication',
      subtitle: 'Login, registration and fleet access',
      icon: Icons.lock_outline_rounded,
    ),
    _FeatureCardData(
      title: 'Fisherman',
      subtitle: 'Profiles, performance and compliance',
      icon: Icons.person_2_outlined,
    ),
    _FeatureCardData(
      title: 'Boat',
      subtitle: 'Vessel monitoring and maintenance',
      icon: Icons.sailing_rounded,
    ),
    _FeatureCardData(
      title: 'Fishing Trip',
      subtitle: 'Journeys, weather and logs',
      icon: Icons.map_outlined,
    ),
    _FeatureCardData(
      title: 'Fish Market',
      subtitle: 'Market pricing and demand',
      icon: Icons.storefront_rounded,
    ),
    _FeatureCardData(
      title: 'Auction',
      subtitle: 'Live participants and bids',
      icon: Icons.gavel_rounded,
    ),
    _FeatureCardData(
      title: 'Order',
      subtitle: 'Deliveries, shipments and invoices',
      icon: Icons.inventory_2_outlined,
    ),
    _FeatureCardData(
      title: 'Tracking',
      subtitle: 'Routes and live telemetry',
      icon: Icons.location_on_outlined,
    ),
    _FeatureCardData(
      title: 'Emergency',
      subtitle: 'SOS and rapid response',
      icon: Icons.emergency_share_outlined,
    ),
    _FeatureCardData(
      title: 'Vendor',
      subtitle: 'Suppliers and equipment partners',
      icon: Icons.handshake_outlined,
    ),
    _FeatureCardData(
      title: 'Admin',
      subtitle: 'Management and reporting',
      icon: Icons.admin_panel_settings_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FishTrack'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.brightness_6_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Operations overview',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Active boats',
                      value: '128',
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Trips today',
                      value: '42',
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: _featureCards.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, index) {
                    final card = _featureCards[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              child: Icon(
                                card.icon,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              card.title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              card.subtitle,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) =>
            setState(() => _selectedIndex = value),
        destinations: _destinations,
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withValues(alpha: 0.12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _FeatureCardData {
  const _FeatureCardData({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}
