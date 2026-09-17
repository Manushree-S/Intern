import 'package:flutter/material.dart';

/// Responsive wrapper that adapts UI layout across mobile phones and tablets.
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final double tabletBreakpoint;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.tabletBreakpoint = 650.0,
  });

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 650.0;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= tabletBreakpoint && tablet != null) {
          return tablet!;
        }
        return mobile;
      },
    );
  }
}
