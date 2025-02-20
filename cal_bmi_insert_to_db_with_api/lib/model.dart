class Employee {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final double height;
  final double weight;
  final double bmi;
  final String bmiType;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.height,
    required this.weight,
    required this.bmi,
    required this.bmiType,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      height: json['height'],
      weight: json['weight'],
      bmi: json['bmi'],
      bmiType: json['bmiType'],
    );
  }
}