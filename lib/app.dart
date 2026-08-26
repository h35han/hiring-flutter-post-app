import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_post_app/features/auth/bloc/auth_cubit.dart';

import 'core/storage/secure_storage.dart';
import 'features/auth/data/auth_repository.dart';
import 'router.dart';

class App extends StatelessWidget {
  const App({super.key});

  static final storage = SecureStorage();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider<AuthRepository>(create: (_) => AuthRepository(storage))],
      child: MultiBlocProvider(
        providers: [BlocProvider(create: (context) => AuthCubit(context.read<AuthRepository>())..login())],
        child: Builder(builder: (context) => MaterialApp.router(routerConfig: buildRouter(context))),
      ),
    );
  }
}
