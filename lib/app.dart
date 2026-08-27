import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'core/session/session_handler.dart';
import 'core/storage/secure_storage.dart';
import 'features/auth/bloc/auth_cubit.dart';
import 'features/auth/data/auth_repository.dart';
import 'router.dart';
import 'ui/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  static final sessionHandler = SessionHandler(SecureStorage());
  static final client = http.Client();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider<AuthRepository>(create: (_) => AuthRepository(sessionHandler, client))],
      child: MultiBlocProvider(
        providers: [BlocProvider(create: (context) => AuthCubit(context.read<AuthRepository>())..sync())],
        child: MaterialApp.router(theme: appThemeData, routerConfig: buildRouter(sessionHandler)),
      ),
    );
  }
}
