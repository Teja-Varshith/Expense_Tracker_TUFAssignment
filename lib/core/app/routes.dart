import 'package:expense_tracker_tuf/features/auth/screens/auth_screen.dart';
import 'package:expense_tracker_tuf/features/home/screens/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoutes = RouteMap(
  routes: {
    "/": (_) => const MaterialPage(child: AuthScreen()),
  },
);

final loggedInRoutes = RouteMap(
  routes: {
    "/": (_) => const MaterialPage(child: AppShell()),
  },
);