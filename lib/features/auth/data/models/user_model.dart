class User {
  final String name;

  User({required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    if (json['name'] == null || json['name'] is! String) {
      throw FormatException("Missing or invalid required field: 'name'");
    }

    return User(name: json['name']);
  }
}
