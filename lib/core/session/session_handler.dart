import 'dart:async';

import '../storage/secure_storage.dart';

enum SessionStatus { authenticated, unauthenticated }

class SessionState {
  final SessionStatus status;
  final String? token;

  const SessionState(this.status, {this.token});
}

class SessionHandler {
  SessionState state;

  final SecureStorage _storage;

  final _controller = StreamController<SessionState>.broadcast();

  SessionHandler(this._storage) : state = SessionState(SessionStatus.unauthenticated);

  Future setSession(String token) async {
    await _storage.write('access_token', token);
    state = SessionState(SessionStatus.authenticated, token: token);
    _controller.add(state);
  }

  Future clearSession() async {
    await _storage.delete('access_token');
    state = SessionState(SessionStatus.unauthenticated);
    _controller.add(state);
  }

  Future<String?> getCachedToken() => _storage.read('access_token');

  void dispose() => _controller.close();

  Stream<SessionState> get stream => _controller.stream;
}
