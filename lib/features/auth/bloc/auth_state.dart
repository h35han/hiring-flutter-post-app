part of "auth_cubit.dart";

sealed class AuthState {}

class InitialAuthState extends AuthState {}

class LoggedInAuthState extends AuthState {}
