part of 'search_posts_cubit.dart';

enum SearchPostsStatus { idle, loading, success, failure }

class SearchPostsState extends Equatable {
  final SearchPostsStatus status;
  final String query;
  final List<Post> results;
  final String? errorMessage;

  const SearchPostsState({
    this.status = SearchPostsStatus.idle,
    this.query = '',
    this.results = const [],
    this.errorMessage,
  });

  SearchPostsState copyWith({SearchPostsStatus? status, String? query, List<Post>? results, String? errorMessage}) {
    return SearchPostsState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, query, results, errorMessage];
}
