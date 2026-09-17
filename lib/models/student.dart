// Demonstrates: classes, constructors, encapsulation, inheritance, OOP concepts

/// Base class shared by anyone the app might track (student, faculty, etc.)
class Person {
  // Encapsulation: private fields, exposed via getters
  final String _name;
  final String _email;

  // Constructor
  Person(this._name, this._email);

  String get name => _name;
  String get email => _email;

  // A method that a subclass can override (polymorphism)
  String describe() {
    return '$_name ($_email)';
  }
}

/// Student extends Person -> Inheritance
class Student extends Person {
  final String enrollmentNo;
  final String department;
  final int semester;
  double cgpa;
  double attendancePercentage;
  final List<String> subjects;

  // Constructor calling the superclass constructor
  Student({
    required String name,
    required String email,
    required this.enrollmentNo,
    required this.department,
    required this.semester,
    required this.cgpa,
    required this.attendancePercentage,
    required this.subjects,
  }) : super(name, email);

  // Overriding a method from the parent class (polymorphism)
  @override
  String describe() {
    return '${super.describe()} — Sem $semester, $department';
  }

  // A simple method using conditional logic
  String attendanceStatus() {
    if (attendancePercentage >= 75) {
      return 'Good standing';
    } else if (attendancePercentage >= 60) {
      return 'Warning';
    } else {
      return 'Detained risk';
    }
  }

  // A method using a loop
  String subjectList() {
    final buffer = StringBuffer();
    for (var i = 0; i < subjects.length; i++) {
      buffer.write(subjects[i]);
      if (i != subjects.length - 1) buffer.write(', ');
    }
    return buffer.toString();
  }
}

/// A small helper class showing a plain function + basic Dart data types.
/// Used by the "Dart Concepts" screen to show variables/operators in action.
class DartConceptsDemo {
  // Constants & variables of different data types
  static const String appName = 'Smart Student Companion';
  static const int foundingYear = 2026;
  static const double passingCgpa = 5.0;
  static const bool isBeta = true;

  // A function demonstrating parameters, operators and a loop
  static int sumOfFirstN(int n) {
    var total = 0; // variable
    for (var i = 1; i <= n; i++) {
      total += i; // operator
    }
    return total;
  }

  // A function demonstrating conditional statements
  static String gradeFromCgpa(double cgpa) {
    if (cgpa >= 9.0) {
      return 'A+';
    } else if (cgpa >= 8.0) {
      return 'A';
    } else if (cgpa >= 7.0) {
      return 'B';
    } else if (cgpa >= 6.0) {
      return 'C';
    } else {
      return 'Needs Improvement';
    }
  }
}
