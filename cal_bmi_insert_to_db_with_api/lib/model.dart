class Model {
  final String id;
  final String name;
  final String address;
  final String email;
  final String height;
  final String weight;
  final String bmi;
  final String bmiType;

  Model({
    required this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.height,
    required this.weight,
    required this.bmi,
    required this.bmiType,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      email: json['email'],
      height: json['height'],
      weight: json['weight'],
      bmi: json['bmi'],
      bmiType: json['bmiType'],
    );
  }
}