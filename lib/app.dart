import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/client_branding.dart';

class EdTechApp extends ConsumerWidget {
  final ClientBranding branding;

  const EdTechApp({
    super.key,
    this.branding = const ClientBranding(),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: branding.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(branding: branding),
      darkTheme: branding.enableDarkMode ? AppTheme.darkTheme(branding: branding) : null,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
