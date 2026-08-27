import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_post_app/features/auth/bloc/auth_cubit.dart';
import 'package:flutter_post_app/features/auth/data/models/user_model.dart';
import 'package:test/test.dart';

import '../../../helpers/mocks.dart';

void main() {
  late FakeAuthRepository repository;
  late AuthCubit cubit;

  setUp(() {
    repository = FakeAuthRepository();
    cubit = AuthCubit(repository);
  });

  tearDown(() => cubit.close());

  test('initialState_isInitial', () {
    expect(cubit.state, isA<InitialAuthState>());
  });

  blocTest<AuthCubit, AuthState>(
    'login_withValidCredentials_emitsLoadingThenAuthenticated',
    build: () {
      repository.setUser(const User(name: 'emilys'));
      return AuthCubit(repository);
    },
    act: (cubit) => cubit.login(name: 'emilys', password: 'emilyspass'),
    expect: () => [
      isA<LoadingAuthState>(),
      isA<AuthenticatedAuthState>().having((s) => s.user.name, 'user.name', 'emilys'),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'login_withInvalidCredentials_emitsLoadingThenFailed',
    build: () {
      repository.whenLoginThrows(Exception('bad credentials'));
      return AuthCubit(repository);
    },
    act: (cubit) => cubit.login(name: 'emilys', password: 'wrongpass'),
    expect: () => [isA<LoadingAuthState>(), isA<FailedAuthState>()],
  );

  blocTest<AuthCubit, AuthState>(
    'logout_emitsUnauthenticated',
    build: () => AuthCubit(repository),
    seed: () => AuthenticatedAuthState(const User(name: 'emilys')),
    act: (cubit) => cubit.logout(),
    expect: () => [isA<UnauthenticatedAuthState>()],
  );

  blocTest<AuthCubit, AuthState>(
    'sync_withActiveSession_loadsUser',
    build: () {
      repository.setSessionActive(true);
      repository.setUser(const User(name: 'bob'));
      return AuthCubit(repository);
    },
    act: (cubit) => cubit.sync(),
    expect: () => [
      isA<UnauthenticatedAuthState>(),
      isA<LoadingAuthState>(),
      isA<AuthenticatedAuthState>().having((s) => s.user.name, 'user.name', 'bob'),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'sync_withouSession_staysUnauthenticated',
    build: () {
      repository.setSessionActive(false);
      return AuthCubit(repository);
    },
    act: (cubit) => cubit.sync(),
    expect: () => [isA<UnauthenticatedAuthState>()],
  );
}
