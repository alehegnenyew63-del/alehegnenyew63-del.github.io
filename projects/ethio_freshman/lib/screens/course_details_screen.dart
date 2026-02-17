import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 
import '../utils/database_service.dart';
import 'quiz_screen.dart';

class CourseDetailsScreen extends StatefulWidget {
  final String courseName;
  const CourseDetailsScreen({super.key, required this.courseName});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final DatabaseService _db = DatabaseService();
  List<Map<String, dynamic>> materials = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMaterials();
  }

 void _loadMaterials() async {
    setState(() => isLoading = true);
    try {
      final data = await _db.fetchMaterials(widget.courseName);
      
      // 💡 THE DEBUGGER: This prints to your VS Code "Debug Console"
      ("DATABASE LOG: Looking for course: ${widget.courseName}");
      ("DATABASE LOG: Found ${data.length} modules in Supabase.");
      if (data.isNotEmpty) ("DATABASE LOG: First title is ${data[0]['title']}");

      setState(() {
        materials = data;
        isLoading = false;
      });
    } catch (e) {
      ("DATABASE ERROR: $e"); // This tells us if it's a Permission or Network error
      setState(() => isLoading = false);
    }
  }
  Future<void> _openPdf(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not open PDF")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.courseName),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [Tab(text: "Materials"), Tab(text: "Practice Tests")],
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            // --- TAB 1: MATERIALS WITH REFRESH ---
            RefreshIndicator(
              onRefresh: () async {
                _loadMaterials();
              },
              child: isLoading 
                ? const Center(child: CircularProgressIndicator())
                : materials.isEmpty 
                  ? ListView(
                      children: const [
                        SizedBox(height: 100),
                        Center(child: Text("No modules found. Pull down to refresh.")),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: materials.length,
                      itemBuilder: (context, index) {
                        final item = materials[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                            title: Text(item['title'] ?? "Untitled", style: const TextStyle(fontWeight: FontWeight.bold)),
                            trailing: const Icon(Icons.download, color: Colors.blue),
                            onTap: () => _openPdf(item['file_url']),
                          ),
                        );
                      },
                    ),
            ),

            // --- TAB 2: PRACTICE TESTS ---
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QuizScreen(categoryName: widget.courseName))),
                child: const Text("Start Practice Quiz"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}