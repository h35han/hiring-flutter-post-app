import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_post_app/features/dashboard/bloc/recent_posts_cubit.dart';
import 'package:flutter_post_app/features/dashboard/data/models/post_model.dart';
import 'package:test/test.dart';

import '../../../helpers/mocks.dart';

Post _post(int id) =>
    Post(id: id, title: 'Post $id', body: 'Body $id', reactions: {'likes': id * 10}, views: id * 100, userId: 1);

void main() {
  late FakeDashboardRepository repository;

  setUp(() => repository = FakeDashboardRepository());

  test('initialState_isInitial', () {
    final cubit = RecentPostsCubit(repository);
    expect(cubit.state.status, RecentPostsStatus.initial);
    cubit.close();
  });

  blocTest<RecentPostsCubit, RecentPostsState>(
    'load_success_emitsLoadingThenSuccess',
    build: () {
      repository.setRecentPosts([_post(1), _post(2)]);
      return RecentPostsCubit(repository);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<RecentPostsState>().having((s) => s.status, 'status', RecentPostsStatus.loading),
      isA<RecentPostsState>()
          .having((s) => s.status, 'status', RecentPostsStatus.success)
          .having((s) => s.posts.length, 'posts.length', 2),
    ],
  );

  blocTest<RecentPostsCubit, RecentPostsState>(
    'load_error_emitsLoadingThenFailed',
    build: () {
      repository.whenRecentPostsThrows(Exception('connection refused'));
      return RecentPostsCubit(repository);
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<RecentPostsState>().having((s) => s.status, 'status', RecentPostsStatus.loading),
      isA<RecentPostsState>().having((s) => s.status, 'status', RecentPostsStatus.failure),
    ],
  );

  blocTest<RecentPostsCubit, RecentPostsState>(
    'refresh_reloadsData',
    build: () {
      repository.setRecentPosts([_post(1)]);
      return RecentPostsCubit(repository);
    },
    act: (cubit) async {
      await cubit.load();
      repository.setRecentPosts([_post(1), _post(2), _post(3)]);
      await cubit.refresh();
    },
    expect: () => [
      isA<RecentPostsState>().having((s) => s.status, 'status', RecentPostsStatus.loading),
      isA<RecentPostsState>().having((s) => s.posts.length, 'count', 1),
      isA<RecentPostsState>().having((s) => s.status, 'status', RecentPostsStatus.loading),
      isA<RecentPostsState>().having((s) => s.posts.length, 'count', 3),
    ],
  );
}
