import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../auth/presentation/controllers/auth_controller.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    final user = authState.asData?.value;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Institution Admin & Roster Portal'),
        actions: [
          IconButton(
            tooltip: 'Sign Out',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Admin Header Card
              Card(
                elevation: 0,
                color: theme.colorScheme.primary.withOpacity(0.06),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: theme.colorScheme.primary,
                        child: const Icon(Icons.admin_panel_settings_outlined, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Administrator: ${user?.displayName ?? "Admin"}',
                              style: AppTypography.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Institution: ${user?.institutionId ?? "Pilot Institution"}',
                              style: AppTypography.bodyMedium.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text('Administrative Roster & Operations', style: AppTypography.titleMedium),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _AdminCard(
                      title: 'Total Enrolled',
                      value: '98',
                      subtitle: 'Active pilot students',
                      icon: Icons.people_alt_outlined,
                      accentColor: AppColors.primaryBlueLight,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _AdminCard(
                      title: 'Active Faculty',
                      value: '8',
                      subtitle: 'Assigned teachers',
                      icon: Icons.badge_outlined,
                      accentColor: AppColors.successGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _AdminCard(
                      title: 'Fee Collections',
                      value: '92%',
                      subtitle: 'Term fees reconciled',
                      icon: Icons.account_balance_wallet_outlined,
                      accentColor: AppColors.secondaryAmber,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _AdminCard(
                      title: 'Overall Attendance',
                      value: '91.4%',
                      subtitle: 'Institution average',
                      icon: Icons.fact_check_outlined,
                      accentColor: AppColors.infoCyan,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text('Quick Roster Actions', style: AppTypography.titleMedium),
              const SizedBox(height: 12),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.file_upload_outlined, color: theme.colorScheme.primary),
                ),
                title: const Text('Bulk Import Students / Teachers (CSV)'),
                subtitle: const Text('Upload roster spreadsheet with validation'),
                trailing: const Icon(Icons.chevron_right),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: AppColors.borderLight),
                ),
                onPressed: () {
                  // Will be connected in Phase 5
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryAmber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.receipt_long_outlined, color: AppColors.secondaryAmber),
                ),
                title: const Text('Fee Invoicing & Payment Reconciliation'),
                subtitle: const Text('Manage institutional dues & transaction receipts'),
                trailing: const Icon(Icons.chevron_right),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: AppColors.borderLight),
                ),
                onPressed: () {
                  // Will be connected in Phase 5
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  const _AdminCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: accentColor, size: 24),
            const SizedBox(height: 12),
            Text(value, style: AppTypography.headlineMedium.copyWith(color: accentColor, fontSize: 22)),
            const SizedBox(height: 4),
            Text(title, style: AppTypography.titleMedium.copyWith(fontSize: 14)),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
