import 'package:flutter_post_app/features/dashboard/data/models/post_model.dart';
import 'package:test/test.dart';

void main() {
  final json = <String, dynamic>{
    'id': 1,
    'title': 'Hello',
    'body': 'World',
    'reactions': {'likes': 5, 'dislikes': 1},
    'views': 100,
    'userId': 42,
  };

  group('Post', () {
    test('fromJson_withValidJson_returnsPost', () {
      final post = Post.fromJson(json);
      expect(post.id, 1);
      expect(post.title, 'Hello');
      expect(post.body, 'World');
      expect(post.views, 100);
      expect(post.userId, 42);
    });

    test('toJson_roundTripsCorrectly', () {
      final post = Post.fromJson(json);
      expect(post.toJson(), json);
    });

    test('likes_returnsLikesCountFromReactions', () {
      final post = Post.fromJson(json);
      expect(post.likes, 5);
    });
  });
}
