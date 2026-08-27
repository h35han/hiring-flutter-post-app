import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final String title;
  final String body;
  final Map<String, dynamic> reactions;
  final int views;
  final int userId;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.reactions,
    required this.views,
    required this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      reactions: json['reactions'] as Map<String, dynamic>,
      views: json['views'] as int,
      userId: json['userId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'body': body, 'reactions': reactions, 'views': views, 'userId': userId};
  }

  @override
  List<Object?> get props => [id, title, body, reactions, views, userId];

  int get likes => reactions['likes'];
}
