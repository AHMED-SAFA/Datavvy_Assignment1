import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';

enum AuthStatus { checking, unauthenticated, authenticated, failure }

class AuthState {
  final AuthStatus status;
  final String? username;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.username,
    this.errorMessage,
  });

  const AuthState.checking() : this(status: AuthStatus.checking);
  const AuthState.unauthenticated() : this(status: AuthStatus.unauthenticated);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit({required this._repository})
      : super(const AuthState.checking());

  Future<void> restoreSession() async {
    if (await _repository.isAuthenticated()) {
      emit(AuthState(
        status: AuthStatus.authenticated,
        username: await _repository.getCurrentUser(),
      ));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> login(String username, String password) async {
    emit(AuthState(status: AuthStatus.checking));
    try {
      final currentUser = await _repository.login(username, password);
      emit(AuthState(status: AuthStatus.authenticated, username: currentUser));
    } catch (error) {
      emit(AuthState(
        status: AuthStatus.failure,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthState.unauthenticated());
  }
}
