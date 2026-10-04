import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_entity.dart';

class RoleSelectionCard extends StatelessWidget {
  final UserRole role;
  final bool selected;
  final VoidCallback onTap;

  const RoleSelectionCard({
    super.key,
    required this.role,
    required this.selected,
    required this.onTap,
  });

  IconData get _icon {
    switch (role) {
      case UserRole.fisherman:
        return Icons.sailing;

      case UserRole.vendor:
        return Icons.storefront;

      case UserRole.admin:
        return Icons.admin_panel_settings;
    }
  }

  String get _title {
    switch (role) {
      case UserRole.fisherman:
        return 'Fisherman';

      case UserRole.vendor:
        return 'Vendor';

      case UserRole.admin:
        return 'Admin';
    }
  }

  String get _description {
    switch (role) {
      case UserRole.fisherman:
        return 'Manage your boat, trips and catch';

      case UserRole.vendor:
        return 'Buy fish and participate in auctions';

      case UserRole.admin:
        return 'Manage SeaLink platform';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryBlue.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.primaryBlue
                : AppColors.cardBorder,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primaryBlue
                    : AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _icon,
                color: selected
                    ? AppColors.textLight
                    : AppColors.primaryBlue,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    _title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _description,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selected
                  ? AppColors.primaryBlue
                  : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}