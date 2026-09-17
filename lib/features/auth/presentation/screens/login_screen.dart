import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/client_branding.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authControllerProvider.notifier).signInWithEmailPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

    if (!success && mounted) {
      final failure = ref.read(authControllerProvider).failure;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure?.message ?? 'Sign-in failed. Please verify your credentials.'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final theme = Theme.of(context);
    const branding = ClientBranding();

    final isIOS = !kIsWeb && Platform.isIOS;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Institution Brand Header
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.school_rounded,
                        size: 44,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      branding.appName,
                      style: AppTypography.displayLarge.copyWith(
                        fontSize: 26,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Institution Portal • Sign in with school credentials',
                      style: AppTypography.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.65),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),

                    // Credentials Input
                    AppTextField(
                      controller: _emailController,
                      label: 'Institution Email / User ID',
                      hintText: 'e.g. student@school.edu',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your institution email or user ID';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hintText: '••••••••',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push(RouteNames.forgotPassword),
                        child: const Text('Forgot Password / Recovery?'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sign In Button
                    AppButton(
                      label: 'Sign In to Institution',
                      isLoading: authState.isLoading,
                      prefixIcon: Icons.login,
                      onPressed: _handleLogin,
                    ),

                    const SizedBox(height: 28),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            'OR USE INSTITUTION SSO',
                            style: AppTypography.labelSmall.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Google SSO
                    AppButton(
                      label: 'Sign in with Google Workspace',
                      variant: AppButtonVariant.outline,
                      prefixIcon: Icons.g_mobiledata_rounded,
                      onPressed: authState.isLoading
                          ? null
                          : () => ref.read(authControllerProvider.notifier).signInWithGoogle(),
                    ),

                    // Apple SSO (Mandatory for iOS App Store compliance)
                    if (isIOS) ...[
                      const SizedBox(height: 12),
                      AppButton(
                        label: 'Sign in with Apple',
                        variant: AppButtonVariant.outline,
                        prefixIcon: Icons.apple,
                        onPressed: authState.isLoading
                            ? null
                            : () => ref.read(authControllerProvider.notifier).signInWithApple(),
                      ),
                    ],

                    const SizedBox(height: 36),
                    // Notice: No public signup link
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 20, color: theme.colorScheme.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Accounts are provisioned by the school. Public registration is not supported.',
                              style: AppTypography.bodyMedium.copyWith(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
