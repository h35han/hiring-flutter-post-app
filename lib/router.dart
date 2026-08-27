import "package:go_router/go_router.dart";

import "core/session/session_handler.dart";
import "core/util/stream_listenable.dart";
import "features/auth/view/login_view.dart";
import "features/dashboard/view/dashboard_screen.dart";

GoRouter buildRouter(SessionHandler sessionHandler) {
  return GoRouter(
    refreshListenable: StreamListenable(sessionHandler.stream),
    redirect: (_, __) => switch (sessionHandler.state.status) {
      SessionStatus.authenticated => '/dashboard',
      _ => '/login',
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
    ],
  );
}
