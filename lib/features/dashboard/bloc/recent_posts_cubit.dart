import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/dashboard_repository.dart';
import '../data/models/post_model.dart';

part 'recent_posts_state.dart';

class RecentPostsCubit extends Cubit<RecentPostsState> {
  RecentPostsCubit(this._repository) : super(const RecentPostsState());

  final DashboardRepository _repository;

  Future<void> load({int? offset = 0}) async {
    emit(state.copyWith(status: RecentPostsStatus.loading));
    try {
      final posts = await _repository.fetchRecentPosts(offset: offset);
      emit(state.copyWith(status: RecentPostsStatus.success, posts: posts));
    } catch (error) {
      emit(state.copyWith(status: RecentPostsStatus.failure, errorMessage: error.toString()));
    }
  }

  Future<void> refresh() => load();
}
