import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_post_app/features/dashboard/bloc/featured_posts_cubit.dart';
import 'package:flutter_post_app/features/dashboard/data/models/post_model.dart';
import 'package:test/test.dart';

import '../../../helpers/mocks.dart';

Post _post(int id) =>
    Post(id: id, title: 'Post $id', body: 'Body $id', reactions: {'likes': id * 10}, views: id * 100, userId: 1);

void main() {
  late FakeDashboardRepository repository;

  setUp(() => repository = FakeDashboardRepository());

  test('initialState_isInitial', () {
    final cubit = FeaturedPostsCubit(repository);
    expect(cubit.state.status, FeaturedPostsStatus.initial);
    cubit.close();
  });

  blocTest<FeaturedPostsCubit, FeaturedPostsState>(
    'load_success_emitsLoadingThenSucces',
    build: () {
      repository.setFeaturedPosts([_post(1), _post(2)]);
      return FeaturedPostsCubit(repository);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<FeaturedPostsState>().having((s) => s.status, 'status', FeaturedPostsStatus.loading),
      isA<FeaturedPostsState>()
          .having((s) => s.status, 'status', FeaturedPostsStatus.success)
          .having((s) => s.posts.length, 'posts.length', 2),
    ],
  );

  blocTest<FeaturedPostsCubit, FeaturedPostsState>(
    'load_error_emitsLoadingThenFailure',
    build: () {
      repository.whenFeaturedPostsThrows(Exception('timeout'));
      return FeaturedPostsCubit(repository);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<FeaturedPostsState>().having((s) => s.status, 'status', FeaturedPostsStatus.loading),
      isA<FeaturedPostsState>().having((s) => s.status, 'status', FeaturedPostsStatus.failure),
    ],
  );

  blocTest<FeaturedPostsCubit, FeaturedPostsState>(
    'refresh_reloadsData',
    build: () {
      repository.setFeaturedPosts([_post(1)]);
      return FeaturedPostsCubit(repository);
    },
    act: (cubit) async {
      await cubit.load();
      repository.setFeaturedPosts([_post(1), _post(2)]);
      await cubit.refresh();
    },
    expect: () => [
      isA<FeaturedPostsState>().having((s) => s.status, 'status', FeaturedPostsStatus.loading),
      isA<FeaturedPostsState>().having((s) => s.posts.length, 'count', 1),
      isA<FeaturedPostsState>().having((s) => s.status, 'status', FeaturedPostsStatus.loading),
      isA<FeaturedPostsState>().having((s) => s.posts.length, 'count', 2),
    ],
  );
}
