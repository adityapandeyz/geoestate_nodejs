import 'dart:convert';

class User {
  final int id;
  final String email;
  final String password;
  final String token;
  final String type;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.token,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'type': type,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? 0,
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? address,
    String? type,
    String? token,
    List<dynamic>? cart,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      type: type ?? this.type,
      token: token ?? this.token,
    );
  }
}
