import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/dashboard_repository.dart';
import '../data/models/post_model.dart';

part 'search_posts_state.dart';

class SearchPostsCubit extends Cubit<SearchPostsState> {
  SearchPostsCubit(this._repository) : super(const SearchPostsState());

  final DashboardRepository _repository;
  Timer? _debounce;

  static const _debounceDuration = Duration(milliseconds: 400);

  void onQueryChanged(String query) {
    _debounce?.cancel();

    emit(state.copyWith(query: query));

    if (query.trim().isEmpty) {
      emit(state.copyWith(status: SearchPostsStatus.idle, results: const []));
      return;
    }

    _debounce = Timer(_debounceDuration, () => _search(query));
  }

  Future<void> _search(String query) async {
    if (query != state.query) return;

    emit(state.copyWith(status: SearchPostsStatus.loading));
    try {
      final results = await _repository.searchPosts(query);
      if (query != state.query) return;
      emit(state.copyWith(status: SearchPostsStatus.success, results: results));
    } catch (e) {
      if (query != state.query) return;
      emit(state.copyWith(status: SearchPostsStatus.failure, errorMessage: e.toString()));
    }
  }

  void clear() {
    _debounce?.cancel();
    emit(const SearchPostsState());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
