class User {
  final int? id;
  final String username;
  final String email;
  final String pwd;
  final double weight;
  final double height;
  final double bmi;
  final String bmiType;

  // Constructor
  User({
    this.id,
    required this.username,
    required this.email,
    required this.pwd,
    required this.weight,
    required this.height,
  })  : bmi = calculateBmi(weight, height),
        bmiType = determineBmiType(calculateBmi(weight, height)); // Auto-assign BMI Type

  // BMI Calculation
  static double calculateBmi(double weight, double height) {
    return weight / ((height / 100) * (height / 100));
  }

  // Determine BMI Type
  static String determineBmiType(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 24.9) {
      return 'Normal';
    } else if (bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  // Convert User object to Map (for DB insertion)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'pwd': pwd,
      'weight': weight,
      'height': height,
      'bmi': bmi, // Store BMI in DB
      'bmi_type': bmiType, // Store BMI Type in DB
    };
  }

  // Create User object from Map (for DB queries)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map["id"],
      username: map['username'],
      email: map['email'],
      pwd: map['pwd'],
      weight: map['weight'],
      height: map['height'],
    );
  }
}