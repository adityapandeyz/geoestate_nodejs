class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final String token;
  final String type;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.token,
    required this.type,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      token: json['token'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'token': token,
      'type': type,
    };
  }
}
