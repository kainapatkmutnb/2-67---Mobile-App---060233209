class User {
  final int? id; // User's ID (nullable to handle new users)
  final String username; // User's username
  final String email; // User's email
  final String password; // User's password
  final String createdAt; // Timestamp when the user was created

  // Constructor
  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  // Convert User object to Map (for database insertion)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // 'id' is nullable for new users (can be null)
      'username': username,
      'email': email,
      'password': password,
      'createdAt': createdAt,
    };
  }

  // Create User object from Map (for database queries)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'], // 'id' can be null if not set yet
      username: map['username'],
      email: map['email'],
      password: map['password'],
      createdAt: map['createdAt'],
    );
  }
}