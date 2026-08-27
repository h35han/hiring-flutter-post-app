part of 'recent_posts_cubit.dart';

enum RecentPostsStatus { initial, loading, success, failure }

class RecentPostsState extends Equatable {
  final RecentPostsStatus status;
  final List<Post> posts;
  final String? errorMessage;

  const RecentPostsState({this.status = RecentPostsStatus.initial, this.posts = const [], this.errorMessage});

  RecentPostsState copyWith({RecentPostsStatus? status, List<Post>? posts, String? errorMessage}) {
    return RecentPostsState(status: status ?? this.status, posts: posts ?? this.posts, errorMessage: errorMessage);
  }

  @override
  List<Object?> get props => [status, posts, errorMessage];
}
