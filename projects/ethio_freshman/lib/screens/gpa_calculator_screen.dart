import 'package:flutter/material.dart';

class GpaCalculatorScreen extends StatefulWidget {
  const GpaCalculatorScreen({super.key});

  @override
  State<GpaCalculatorScreen> createState() => _GpaCalculatorScreenState();
}

class _GpaCalculatorScreenState extends State<GpaCalculatorScreen> {
  // Data structure for a single course row
  List<Map<String, dynamic>> userCourses = [
    {"name": "Logic", "credit": 3, "grade": 4.0}, // Default rows
    {"name": "Civics", "credit": 3, "grade": 4.0},
  ];

  double totalGpa = 0.0;

  // Grade to Point conversion (Ethiopian Standard)
  final Map<String, double> gradePoints = {
    "A": 4.0, "A-": 3.75, "B+": 3.5, "B": 3.0, "B-": 2.75, "C+": 2.5, "C": 2.0, "D": 1.0, "F": 0.0
  };

  void calculateGpa() {
    double totalPoints = 0;
    int totalCredits = 0;

    for (var course in userCourses) {
      totalPoints += (course['grade'] * course['credit']);
      totalCredits += (course['credit'] as int);
    }

    setState(() {
      totalGpa = totalPoints / totalCredits;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GPA Calculator"), backgroundColor: Colors.blue, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: userCourses.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(userCourses[index]['name']),
                      subtitle: Text("Credits: ${userCourses[index]['credit']}"),
                      trailing: DropdownButton<double>(
                        value: userCourses[index]['grade'],
                        items: gradePoints.entries.map((e) => DropdownMenuItem(value: e.value, child: Text(e.key))).toList(),
                        onChanged: (val) {
                          setState(() => userCourses[index]['grade'] = val);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Text("Your GPA: ${totalGpa.toStringAsFixed(2)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.orange),
              onPressed: calculateGpa,
              child: const Text("Calculate Result", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add More Course"),
              onPressed: () {
                setState(() {
                  userCourses.add({"name": "New Course", "credit": 3, "grade": 4.0});
                });
              },
            )
          ],
        ),
      ),
    );
  }
}