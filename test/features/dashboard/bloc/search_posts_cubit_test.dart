import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_post_app/features/dashboard/bloc/search_posts_cubit.dart';
import 'package:flutter_post_app/features/dashboard/data/models/post_model.dart';
import 'package:test/test.dart';

import '../../../helpers/mocks.dart';

Post _post(int id) => Post(
      id: id,
      title: 'Post $id',
      body: 'Body $id',
      reactions: {'likes': id * 10},
      views: id * 100,
      userId: 1,
    );

void main() {
  late FakeDashboardRepository repository;

  setUp(() => repository = FakeDashboardRepository());

  group('SearchPostsCubit', () {
    test('initialState_isIdleWithEmptyQuery', () {
      final cubit = SearchPostsCubit(repository);
      expect(cubit.state.status, SearchPostsStatus.idle);
      expect(cubit.state.query, '');
      expect(cubit.state.posts, isEmpty);
      cubit.close();
    });

    blocTest<SearchPostsCubit, SearchPostsState>(
      'onQueryChanged_withEmptyQuery_emitsIdleWithClearedPosts',
      build: () => SearchPostsCubit(repository),
      act: (cubit) {
        cubit.onQueryChanged('phone');
        cubit.onQueryChanged('');
      },
      wait: const Duration(milliseconds: 500),
      expect: () => [
        isA<SearchPostsState>().having((s) => s.query, 'query', 'phone'),
        isA<SearchPostsState>()
            .having((s) => s.status, 'status', SearchPostsStatus.idle)
            .having((s) => s.query, 'query', '')
            .having((s) => s.posts, 'posts', isEmpty),
      ],
    );

    test('onQueryChanged_debouncesAndSearches', () async {
      repository.setSearchedPosts([_post(1), _post(2)]);
      final cubit = SearchPostsCubit(repository);

      cubit.onQueryChanged('phone');

      expect(cubit.state.query, 'phone');
      expect(cubit.state.status, SearchPostsStatus.idle);

      await Future<void>.delayed(const Duration(milliseconds: 500));

      expect(cubit.state.status, SearchPostsStatus.success);
      expect(cubit.state.posts, hasLength(2));

      await cubit.close();
    });

    test('onQueryChanged_cancelsPreviousTimer', () async {
      repository.setSearchedPosts([_post(1)]);
      final cubit = SearchPostsCubit(repository);

      cubit.onQueryChanged('phone');
      cubit.onQueryChanged('laptop');

      await Future<void>.delayed(const Duration(milliseconds: 500));

      expect(cubit.state.query, 'laptop');
      expect(cubit.state.status, SearchPostsStatus.success);
      expect(cubit.state.posts.first.id, 1);

      await cubit.close();
    });

    test('search_onError_emitsFailureState', () async {
      repository.whenSearchPostsThrows(Exception('timeout'));
      final cubit = SearchPostsCubit(repository);

      cubit.onQueryChanged('phone');
      await Future<void>.delayed(const Duration(milliseconds: 500));

      expect(cubit.state.status, SearchPostsStatus.failure);
      expect(cubit.state.errorMessage, isNotNull);

      await cubit.close();
    });

    test('clear_resetsToInitialState', () async {
      repository.setSearchedPosts([_post(1)]);
      final cubit = SearchPostsCubit(repository);

      cubit.onQueryChanged('phone');
      await Future<void>.delayed(const Duration(milliseconds: 500));
      expect(cubit.state.status, SearchPostsStatus.success);

      cubit.clear();
      expect(cubit.state.status, SearchPostsStatus.idle);
      expect(cubit.state.query, '');
      expect(cubit.state.posts, isEmpty);

      await cubit.close();
    });
  });
}
