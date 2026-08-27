import 'package:flutter_post_app/core/session/session_handler.dart';
import 'package:test/test.dart';

import '../../helpers/mocks.dart';

void main() {
  late FakeSecureStorage storage;
  late SessionHandler handler;

  setUp(() {
    storage = FakeSecureStorage();
    handler = SessionHandler(storage);
  });

  tearDown(() => handler.dispose());

  group('SessionHandler', () {
    test('initialState_isUnauthenticated', () {
      expect(handler.state.status, SessionStatus.unauthenticated);
    });

    test('setSession_updatesStateAndPersistsToken', () async {
      await handler.setSession('jwt');
      expect(handler.state.status, SessionStatus.authenticated);
      expect(handler.state.token, 'jwt');
      expect(await storage.read('access_token'), 'jwt');
    });

    test('clearSession_resetsStateAndRemovesToken', () async {
      await handler.setSession('jwt');
      await handler.clearSession();
      expect(handler.state.status, SessionStatus.unauthenticated);
      expect(await storage.read('access_token'), isNull);
    });

    test('getCachedToken_returnsStoredToken', () async {
      expect(await handler.getCachedToken(), isNull);
      await handler.setSession('jwt');
      expect(await handler.getCachedToken(), 'jwt');
    });
  });
}
