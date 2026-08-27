import 'package:flutter_post_app/features/auth/data/models/user_model.dart';
import 'package:test/test.dart';

void main() {
  group('User', () {
    test('fromJson_withValidJson_returnsUser', () {
      final user = User.fromJson({'name': 'Alice'});
      expect(user.name, 'Alice');
    });

    test('fromJson_withMissingName_throwsFormatException', () {
      expect(() => User.fromJson({}), throwsFormatException);
    });

    test('equality_sameNameAreEqual', () {
      const a = User(name: 'Bob');
      const b = User(name: 'Bob');
      expect(a, equals(b));
    });
  });
}
