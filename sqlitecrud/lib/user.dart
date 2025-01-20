class User {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String createdAt;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],      // เพิ่ม password
      createdAt: map['createdAt'],   // เพิ่ม createdAt
    );
  }
}