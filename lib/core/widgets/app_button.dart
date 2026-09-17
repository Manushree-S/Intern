import 'package:flutter/material.dart';
import '../constants/app_typography.dart';

enum AppButtonVariant { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? prefixIcon;
  final AppButtonVariant variant;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.prefixIcon,
    this.variant = AppButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget childWidget;
    if (isLoading) {
      childWidget = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == AppButtonVariant.outline || variant == AppButtonVariant.text
                ? theme.colorScheme.primary
                : Colors.white,
          ),
        ),
      );
    } else {
      final List<Widget> children = [];
      if (prefixIcon != null) {
        children.add(Icon(prefixIcon, size: 18));
        children.add(const SizedBox(width: 8));
      }
      children.add(Text(label, style: AppTypography.labelLarge));

      childWidget = Row(
        mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }

    Widget buttonWidget;
    switch (variant) {
      case AppButtonVariant.primary:
        buttonWidget = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: childWidget,
        );
        break;
      case AppButtonVariant.secondary:
        buttonWidget = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary,
          ),
          child: childWidget,
        );
        break;
      case AppButtonVariant.outline:
        buttonWidget = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: childWidget,
        );
        break;
      case AppButtonVariant.text:
        buttonWidget = TextButton(
          onPressed: isLoading ? null : onPressed,
          child: childWidget,
        );
        break;
    }

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: buttonWidget);
    }
    return buttonWidget;
  }
}
