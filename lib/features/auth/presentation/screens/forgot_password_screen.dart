import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    final success = await ref
        .read(authControllerProvider.notifier)
        .requestPasswordRecovery(email);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'If the email is registered and eligible for self-recovery, reset instructions have been sent.',
            ),
            backgroundColor: AppColors.successGreen,
          ),
        );
      } else {
        final failure = ref.read(authControllerProvider).failure;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure?.message ?? 'Failed to send recovery request.'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Password Recovery'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Institutional Recovery Notice
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: theme.colorScheme.primary.withOpacity(0.15)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: theme.colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Institutional Account Recovery',
                              style: AppTypography.titleMedium.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'For Grade 7+ students who do not have personal recovery emails, password resets must be issued by your class teacher or institution administrator.\n\nPlease contact your school IT administrator with your Roll Number to receive a temporary reset password.',
                          style: AppTypography.bodyMedium.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  Text(
                    'Staff & Self-Service Email Recovery',
                    style: AppTypography.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'If you have an institution-linked staff or student email with external inbox access, enter it below:',
                    style: AppTypography.bodyMedium.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.65),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _emailController,
                    label: 'Registered Email',
                    hintText: 'name@school.edu',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  AppButton(
                    label: 'Send Recovery Email',
                    isLoading: authState.isLoading,
                    prefixIcon: Icons.send_outlined,
                    onPressed: _handleReset,
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
