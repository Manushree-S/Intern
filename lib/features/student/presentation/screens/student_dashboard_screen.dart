import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../auth/presentation/controllers/auth_controller.dart';

class StudentDashboardScreen extends ConsumerWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    final user = authState.asData?.value;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Portal'),
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
              // Welcome & Streak Card
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
                        child: Text(
                          (user?.displayName.isNotEmpty ?? false)
                              ? user!.displayName[0].toUpperCase()
                              : 'S',
                          style: const TextStyle(fontSize: 22, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back, ${user?.displayName ?? "Student"}!',
                              style: AppTypography.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Institution ID: ${user?.institutionId ?? "N/A"}',
                              style: AppTypography.bodyMedium.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryAmber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_fire_department, color: AppColors.secondaryAmber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              '3 Days',
                              style: AppTypography.labelLarge.copyWith(color: AppColors.secondaryAmber),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Academic Quick Metrics
              Text('Academic Overview', style: AppTypography.titleMedium),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'Attendance',
                      value: '94%',
                      subtitle: 'Target: >85%',
                      icon: Icons.calendar_today_outlined,
                      accentColor: AppColors.successGreen,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      title: 'Course Progress',
                      value: '68%',
                      subtitle: '3 Active Courses',
                      icon: Icons.school_outlined,
                      accentColor: AppColors.primaryBlueLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'Upcoming Quizzes',
                      value: '2',
                      subtitle: 'Next: Mathematics',
                      icon: Icons.timer_outlined,
                      accentColor: AppColors.warningOrange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      title: 'Pending Tasks',
                      value: '1',
                      subtitle: 'Science Lab Due Fri',
                      icon: Icons.assignment_outlined,
                      accentColor: AppColors.errorRed,
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

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  const _MetricCard({
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
            Text(value, style: AppTypography.headlineMedium.copyWith(color: accentColor)),
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
