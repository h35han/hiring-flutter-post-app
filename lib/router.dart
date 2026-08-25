import "package:flutter/widgets.dart";
import "package:go_router/go_router.dart";

import "./features/auth/view/login_screen.dart";
import "./features/dashboard/view/dashboard_screen.dart";

GoRouter buildRouter(Listenable refreshListenable) {
  return GoRouter(
    refreshListenable: refreshListenable,
    redirect: (ctx, tate) => null,
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
    ],
  );
}
