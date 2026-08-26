import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";

import "core/util/stream_listenable.dart";
import "features/auth/bloc/auth_cubit.dart";
import "features/auth/view/login_view.dart";
import "features/dashboard/view/dashboard_screen.dart";

GoRouter buildRouter(BuildContext context) {
  return GoRouter(
    refreshListenable: StreamListenable(context.read<AuthCubit>().stream),
    redirect: (ctx, tate) => context.read<AuthCubit>().state is LoggedInAuthState ? "/dashboard" : "/login",
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
    ],
  );
}
