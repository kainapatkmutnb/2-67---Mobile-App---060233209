class User {
  final int? id;
  final String username;
  final String email;
  final String pwd;
  final double weight;
  final double height;
  final double bmi;
  final String bmiType;
  final String bmiImage;

  // Constructor
  User({
    this.id,
    required this.username,
    required this.email,
    required this.pwd,
    required this.weight,
    required this.height,
  })  : bmi = calculateBmi(weight, height),
        bmiType = determineBmiType(calculateBmi(weight, height)),
        bmiImage = determineBmiImage(
            calculateBmi(weight, height)); // Auto-assign BMI Image

  // BMI Calculation
  static double calculateBmi(double weight, double height) {
    return weight / ((height / 100) * (height / 100));
  }

  // Determine BMI Type
  static String determineBmiType(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 23) {
      return 'Normal';
    } else if (bmi < 25) {
      return 'Risk to Overweight';
    } else if (bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  // Determine BMI Image
  static String determineBmiImage(double bmi) {
    if (bmi < 18.5) {
      return 'images/bmi-1.png';
    } else if (bmi < 23) {
      return 'images/bmi-2.png';
    } else if (bmi < 25) {
      return 'images/bmi-3.png';
    } else if (bmi < 30) {
      return 'images/bmi-4.png';
    } else {
      return 'images/bmi-5.png';
    }
  }

  // Calculate target weight for normal BMI
  double getTargetWeight() {
    // Using BMI 21 (middle of normal range 18.5-23)
    double heightInMeters = height / 100;
    return 21 * (heightInMeters * heightInMeters);
  }

  // Calculate weight adjustment needed
  String getWeightAdjustment() {
    double targetWeight = getTargetWeight();
    double difference = targetWeight - weight;

    if (bmi >= 18.5 && bmi < 23) {
      return "Your weight is normal";
    } else if (difference > 0) {
      return "Need to gain ${difference.toStringAsFixed(1)} kg";
    } else {
      return "Need to lose ${(-difference).toStringAsFixed(1)} kg";
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
      'bmi_image': bmiImage, // Store BMI Image in DB
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
