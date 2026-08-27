import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/dashboard_repository.dart';
import '../data/models/post_model.dart';

part 'featured_posts_state.dart';

class FeaturedPostsCubit extends Cubit<FeaturedPostsState> {
  FeaturedPostsCubit(this._repository) : super(const FeaturedPostsState());

  final DashboardRepository _repository;

  Future<void> load({int? offset = 0}) async {
    emit(state.copyWith(status: FeaturedPostsStatus.loading));
    try {
      final posts = await _repository.fetchFeaturedPosts(offset: offset);
      emit(state.copyWith(status: FeaturedPostsStatus.success, posts: posts));
    } catch (error) {
      emit(state.copyWith(status: FeaturedPostsStatus.failure, errorMessage: error.toString()));
    }
  }

  Future<void> refresh() => load();
}
