import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;

  const User({required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    if (json['name'] == null || json['name'] is! String) {
      throw FormatException("Missing or invalid required field: 'name'");
    }

    return User(name: json['name']);
  }

  @override
  List<Object?> get props => [name];
}
