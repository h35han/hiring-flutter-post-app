part of 'search_posts_cubit.dart';

enum SearchPostsStatus { idle, loading, success, failure }

class SearchPostsState extends Equatable {
  final SearchPostsStatus status;
  final String query;
  final List<Post> posts;
  final String? errorMessage;

  const SearchPostsState({
    this.status = SearchPostsStatus.idle,
    this.query = '',
    this.posts = const [],
    this.errorMessage,
  });

  SearchPostsState copyWith({SearchPostsStatus? status, String? query, List<Post>? posts, String? errorMessage}) {
    return SearchPostsState(
      status: status ?? this.status,
      query: query ?? this.query,
      posts: posts ?? this.posts,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, query, posts, errorMessage];
}
