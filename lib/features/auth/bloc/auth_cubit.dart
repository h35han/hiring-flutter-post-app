import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_post_app/features/auth/data/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(InitialAuthState());

  void login() {
    emit(LoggedInAuthState());
  }

  void logout() {
    emit(InitialAuthState());
  }
}
