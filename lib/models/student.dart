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
  final List<String> notifications;

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
    this.notifications = const [],
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

