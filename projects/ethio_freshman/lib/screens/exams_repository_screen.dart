import 'package:flutter/material.dart';

class ExamsRepositoryScreen extends StatelessWidget {
  const ExamsRepositoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This list represents real business data
    final List<Map<String, String>> exams = [
      {"univ": "AAU", "course": "Logic Mid Exam", "year": "2014 E.C"},
      {"univ": "ASTU", "course": "Maths Final Exam", "year": "2015 E.C"},
      {"univ": "Jimma", "course": "Geography Mid Exam", "year": "2013 E.C"},
      {"univ": "AAU", "course": "Psychology Final", "year": "2015 E.C"},
      {"univ": "Haramaya", "course": "English Mid Exam", "year": "2014 E.C"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Exam Bank"), backgroundColor: Colors.blue, foregroundColor: Colors.white),
      body: Column(
        children: [
          // Professional Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search for exams (e.g. AAU Logic)",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Icon(Icons.filter_list, size: 16),
                SizedBox(width: 5),
                Text("Filtering by: All Universities", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: exams.length,
              itemBuilder: (context, index) {
                final exam = exams[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[50],
                      child: Text(exam['univ']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(exam['course']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Year: ${exam['year']}"),
                    trailing: const Icon(Icons.download, color: Colors.blue),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Downloading Exam... Upgrade to Pro for fast access.")),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}