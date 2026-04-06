import 'package:expense_tracker_tuf/core/app/routes.dart';
import 'package:expense_tracker_tuf/core/theme/app_theme.dart';
import 'package:expense_tracker_tuf/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

void main() {
  runApp(ProviderScope(child: const App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: themeMode,
      darkTheme: AppTheme.dark,
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (_) {
          return loggedOutRoutes;
        },
      ),
      routeInformationParser: RoutemasterParser(),
    );
  }
}

