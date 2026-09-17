import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../auth/presentation/controllers/auth_controller.dart';

class TeacherDashboardScreen extends ConsumerWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    final user = authState.asData?.value;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Educator & Staff Portal'),
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
              // Teacher Header
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
                        child: const Icon(Icons.psychology_outlined, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Educator: ${user?.displayName ?? "Teacher"}',
                              style: AppTypography.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Assigned Classes: Grade 7-A, Grade 8-B',
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

              Text('Class Management & Evaluation', style: AppTypography.titleMedium),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _TeacherCard(
                      title: 'Pending Reviews',
                      value: '14',
                      subtitle: 'Submissions awaiting score',
                      icon: Icons.assignment_late_outlined,
                      accentColor: AppColors.warningOrange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TeacherCard(
                      title: "Today's Attendance",
                      value: 'Pending',
                      subtitle: 'Grade 7-A not marked',
                      icon: Icons.how_to_reg_outlined,
                      accentColor: AppColors.errorRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _TeacherCard(
                      title: 'Active Students',
                      value: '58',
                      subtitle: 'Across 2 assigned sections',
                      icon: Icons.groups_outlined,
                      accentColor: AppColors.primaryBlueLight,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TeacherCard(
                      title: 'Avg Class Score',
                      value: '82%',
                      subtitle: 'Term Assessments',
                      icon: Icons.insights_outlined,
                      accentColor: AppColors.successGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeacherCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  const _TeacherCard({
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
