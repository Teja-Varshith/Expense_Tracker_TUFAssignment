import 'package:expense_tracker_tuf/features/auth/screens/auth_screen.dart';
import 'package:expense_tracker_tuf/features/home/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoutes = RouteMap(
  routes: {
    "/": (_) => MaterialPage(child: AuthScreen()),
  }
);

final loggedInRoutes = RouteMap(
  routes: {
    "/": (_) => MaterialPage(child: HomePage()),
  }
);