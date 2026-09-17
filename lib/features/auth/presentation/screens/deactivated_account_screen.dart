import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../controllers/auth_controller.dart';

class DeactivatedAccountScreen extends ConsumerWidget {
  const DeactivatedAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.errorRed.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.block_flipped,
                      size: 56,
                      color: AppColors.errorRed,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Account Suspended / Deactivated',
                    style: AppTypography.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your account has been deactivated by your educational institution. You are currently restricted from accessing courses, assignments, and quizzes.\n\nPlease contact your school administration or IT department for assistance.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 200,
                    child: AppButton(
                      label: 'Return to Login',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.arrow_back,
                      onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
