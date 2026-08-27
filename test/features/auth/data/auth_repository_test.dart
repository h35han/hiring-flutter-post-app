import 'dart:convert';
import 'dart:io';

import 'package:flutter_post_app/core/session/session_handler.dart';
import 'package:flutter_post_app/features/auth/data/auth_repository.dart';
import 'package:test/test.dart';

import '../../../helpers/mocks.dart';

void main() {
  late StubHttpClient httpStub;
  late SessionHandler sessionHandler;
  late AuthRepository repo;

  setUp(() {
    httpStub = StubHttpClient();
    sessionHandler = SessionHandler(FakeSecureStorage());
    repo = AuthRepository(sessionHandler, httpStub.client);
  });

  tearDown(() => sessionHandler.dispose());

  group('login', () {
    test('withValidCredentials_returnsUserAndStoresToken', () async {
      httpStub.stubPost('auth/login', jsonResponse({'accessToken': 'jwt', 'username': 'emilys'}));

      final user = await repo.login('emilys', 'emilyspass');
      await Future<void>.delayed(Duration.zero);

      expect(user.name, 'emilys');
      expect(sessionHandler.state.status, SessionStatus.authenticated);
    });

    test('sendsCorrectRequestBody', () async {
      httpStub.stubPost('auth/login', jsonResponse({'accessToken': 'jwt', 'username': 'emilys'}));

      await repo.login('emilys', 'emilyspass');

      final body = jsonDecode(httpStub.requests.first.body as String) as Map;
      expect(body['username'], 'emilys');
      expect(body['password'], 'emilyspass');
    });

    test('on401_throwsUnauthorizedAndClearsSession', () async {
      await sessionHandler.setSession('old_token');
      httpStub.stubPost('auth/login', jsonResponse({'msg': 'bad'}, status: HttpStatus.unauthorized));

      try {
        await repo.login('emilys', 'wrongpass');
      } on UnauthorizedException {
        // expected
      }

      await Future<void>.delayed(Duration.zero);
      expect(sessionHandler.state.status, SessionStatus.unauthenticated);
    });
  });

  group('getUser', () {
    test('withValidToken_returnsUser', () async {
      await sessionHandler.setSession('valid_token');
      httpStub.stubGet('auth/me', jsonResponse({'username': 'bob'}));

      final user = await repo.getUser();
      expect(user.name, 'bob');
    });

    test('on401_throwsUnauthorizedAndClearsSession', () async {
      await sessionHandler.setSession('expired_token');
      httpStub.stubGet('auth/me', jsonResponse({'msg': 'bad'}, status: HttpStatus.unauthorized));

      try {
        await repo.getUser();
      } on UnauthorizedException {
        // expected
      }

      await Future<void>.delayed(Duration.zero);
      expect(sessionHandler.state.status, SessionStatus.unauthenticated);
    });
  });
}
