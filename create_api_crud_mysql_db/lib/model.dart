class Model {
  final String id;
  final String name;
  final String address;
  final String email;

  Model({
    required this.id,
    required this.name,
    required this.address,
    required this.email,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      email: json['email'],
    );
  }
}