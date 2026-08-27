import 'package:flutter_post_app/core/session/session_handler.dart';
import 'package:flutter_post_app/features/dashboard/data/dashboard_repository.dart';
import 'package:test/test.dart';

import '../../../helpers/mocks.dart';

void main() {
  late StubHttpClient httpStub;
  late DashboardRepository repo;

  setUp(() {
    httpStub = StubHttpClient();
    repo = DashboardRepository(SessionHandler(FakeSecureStorage()), httpStub.client);
  });

  Map<String, dynamic> postsBody(List<Map<String, dynamic>> posts) =>
      {'posts': posts, 'total': posts.length, 'skip': 0, 'limit': 10};

  Map<String, dynamic> postJson({int id = 1}) => {
        'id': id,
        'title': 'Post $id',
        'body': 'Body $id',
        'reactions': {'likes': 10},
        'views': 200,
        'userId': 5,
      };

  group('fetchRecentPosts', () {
    test('returnsPostsFromResponse', () async {
      httpStub.stubGet('posts', jsonResponse(postsBody([postJson(id: 1), postJson(id: 2)])));

      final posts = await repo.fetchRecentPosts();

      expect(posts, hasLength(2));
      expect(posts[0].id, 1);
    });

    test('sendsCorrectQueryParams', () async {
      httpStub.stubGet('posts', jsonResponse(postsBody([])));

      await repo.fetchRecentPosts(offset: 20);

      final uri = httpStub.requests.first.uri;
      expect(uri.queryParameters['skip'], '20');
      expect(uri.queryParameters['sortBy'], 'id');
      expect(uri.queryParameters['order'], 'desc');
    });
  });

  group('searchPosts', () {
    test('returnsMatchingPosts', () async {
      httpStub.stubGet('posts/search', jsonResponse(postsBody([postJson(id: 3), postJson(id: 7)])));

      final posts = await repo.searchPosts('phone');

      expect(posts, hasLength(2));
      expect(posts[0].id, 3);
    });

    test('sendsCorrectQueryParams', () async {
      httpStub.stubGet('posts/search', jsonResponse(postsBody([])));

      await repo.searchPosts('laptop', offset: 10);

      final uri = httpStub.requests.first.uri;
      expect(uri.queryParameters['q'], 'laptop');
      expect(uri.queryParameters['skip'], '10');
    });
  });

  group('fetchFeaturedPosts', () {
    test('returnsPostsSortedByViews', () async {
      httpStub.stubGet('posts', jsonResponse(postsBody([postJson(id: 10)])));

      final posts = await repo.fetchFeaturedPosts();

      expect(posts, hasLength(1));
      expect(posts[0].id, 10);
    });

    test('onMalformedJson_throwsFormatException', () async {
      httpStub.stubGet('posts', rawResponse('not json'));

      expect(() => repo.fetchRecentPosts(), throwsFormatException);
    });
  });
}
