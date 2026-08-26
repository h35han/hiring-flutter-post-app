import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/auth_repository.dart';
import '../data/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(InitialAuthState());

  void login({required String name, required String password}) async {
    emit(LoadingAuthState());

    try {
      var user = await _repository.login(name, password);
      emit(AuthenticatedAuthState(user));
    } catch (error) {
      emit(FailedAuthState("Authentication failed"));
    }
  }

  void logout() async {
    emit(UnauthenticatedAuthState());

    try {
      await _repository.logout();
    } catch (error) {
      emit(FailedAuthState("Authentication failed"));
    }
  }

  void sync() async {
    emit(UnauthenticatedAuthState());

    try {
      var active = await _repository.isSessionActive();
      if (active) {
        emit(LoadingAuthState());
        var user = await _repository.getUser();
        emit(AuthenticatedAuthState(user));
      }
    } on UnauthorizedException {
      emit(UnauthenticatedAuthState());
    } catch (error) {
      emit(FailedAuthState("Authentication failed"));
    }
  }
}
