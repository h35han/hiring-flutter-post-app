import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/bloc/auth_cubit.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FilledButton(onPressed: () => context.read<AuthCubit>().logout(), child: Text("Logout")),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) => switch (state) {
                AuthenticatedAuthState(:final user) => Text(user.name),
                FailedAuthState(:final message) => Text(message),
                _ => SizedBox.shrink(),
              },
            ),
          ],
        ),
      ),
    );
  }
}
