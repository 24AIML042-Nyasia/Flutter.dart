import 'package:flutter/material.dart';
import '../models/student.dart';
import '../theme.dart';

/// This screen exists purely for Practical 1: it shows, on-screen, the
/// output of basic Dart concepts (variables, constants, data types,
/// operators, conditionals, loops, functions, classes & inheritance)
/// so the demo is visual instead of just console prints.
class DartConceptsScreen extends StatelessWidget {
  const DartConceptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Variables & data types
    String appName = DartConceptsDemo.appName; // String
    int year = DartConceptsDemo.foundingYear; // int
    double minCgpa = DartConceptsDemo.passingCgpa; // double
    bool beta = DartConceptsDemo.isBeta; // bool

    // Operators + function call
    int sumTo10 = DartConceptsDemo.sumOfFirstN(10);

    // Conditionals via a function
    final sampleCgpas = [9.2, 8.1, 6.8, 5.5, 4.0];

    // Inheritance / OOP demo
    final demoStudent = Student(
      name: 'Rahul Patel',
      email: 'rahul.patel@college.edu',
      enrollmentNo: '24CE001',
      department: 'Computer Engineering',
      semester: 5,
      cgpa: 8.9,
      attendancePercentage: 91,
      subjects: ['MAD', 'DBMS', 'AI', 'CN'],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Dart Concepts Demo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(
            'Variables & Data Types',
            AppColors.babyBlue,
            [
              'String appName = "$appName"',
              'int year = $year',
              'double minCgpa = $minCgpa',
              'bool isBeta = $beta',
            ],
          ),
          _section(
            'Operators & Functions',
            AppColors.mintGreen,
            ['sumOfFirstN(10) using a for-loop + operators = $sumTo10'],
          ),
          _section(
            'Conditional Statements (if / else if)',
            AppColors.peach,
            [
              for (final cgpa in sampleCgpas)
                'CGPA $cgpa → grade ${DartConceptsDemo.gradeFromCgpa(cgpa)}',
            ],
          ),
          _section(
            'Loops (for)',
            AppColors.softYellow,
            [
              'Subjects joined via a for-loop: ${demoStudent.subjectList()}',
            ],
          ),
          _section(
            'Classes, Constructors & Inheritance',
            AppColors.blushPink,
            [
              'Student extends Person (inheritance)',
              demoStudent.describe(),
              'Attendance status (encapsulated method): '
                  '${demoStudent.attendanceStatus()}',
            ],
          ),
        ],
      ),
    );
  }

  Widget _section(String title, Color color, List<String> lines) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                '•  $line',
                style: const TextStyle(fontSize: 13, color: AppColors.textDark),
              ),
            ),
        ],
      ),
    );
  }
}
