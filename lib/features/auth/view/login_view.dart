import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FilledButton(
              onPressed: () => context.read<AuthCubit>().login(name: "emilys", password: "emilyspass"),
              child: Text("Login"),
            ),
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
