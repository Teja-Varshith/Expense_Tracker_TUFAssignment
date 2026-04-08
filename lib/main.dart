import 'package:expense_tracker_tuf/core/app/routes.dart';
import 'package:expense_tracker_tuf/core/theme/app_theme.dart';
import 'package:expense_tracker_tuf/core/theme/theme_provider.dart';
import 'package:expense_tracker_tuf/providers/user_provider.dart';
import 'package:expense_tracker_tuf/services/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'PayU',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (_) {
          return isLoggedIn ? loggedInRoutes : loggedOutRoutes;
        },
      ),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
