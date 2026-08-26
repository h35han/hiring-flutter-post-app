part of "auth_cubit.dart";

sealed class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialAuthState extends AuthState {}

class LoadingAuthState extends AuthState {}

class AuthenticatedAuthState extends AuthState {
  final User user;

  AuthenticatedAuthState(this.user);

  @override
  List<Object?> get props => [user];
}

class UnauthenticatedAuthState extends AuthState {}

class FailedAuthState extends AuthState {
  final String message;

  FailedAuthState(this.message);

  @override
  List<Object?> get props => [message];
}
