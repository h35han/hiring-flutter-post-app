part of 'featured_posts_cubit.dart';

enum FeaturedPostsStatus { initial, loading, success, failure }

class FeaturedPostsState extends Equatable {
  final FeaturedPostsStatus status;
  final List<Post> posts;
  final String? errorMessage;

  const FeaturedPostsState({this.status = FeaturedPostsStatus.initial, this.posts = const [], this.errorMessage});

  FeaturedPostsState copyWith({FeaturedPostsStatus? status, List<Post>? posts, String? errorMessage}) {
    return FeaturedPostsState(status: status ?? this.status, posts: posts ?? this.posts, errorMessage: errorMessage);
  }

  @override
  List<Object?> get props => [status, posts, errorMessage];
}
