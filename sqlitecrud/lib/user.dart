class User {
  final int? id;
  final String username;
  final String email;
  final String password; // เพิ่ม field password
  final String? createdAt; // เพิ่ม field createdAt

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password, // เพิ่ม password ใน constructor
    this.createdAt, // เพิ่ม createdAt ใน constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password, // เพิ่ม password ใน toMap
      'createdAt': createdAt, // เพิ่ม createdAt ใน toMap
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'], // เพิ่ม password ใน fromMap
      createdAt: map['createdAt'], // เพิ่ม createdAt ใน fromMap
    );
  }
}