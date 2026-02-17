import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../utils/database_service.dart';

class QuizScreen extends StatefulWidget {
  final String categoryName;
  const QuizScreen({super.key, required this.categoryName});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final DatabaseService _db = DatabaseService();
  List<Question> questions = [];
  int currentIndex = 0;
  int score = 0;
  bool isLoading = true;
  bool isAnswered = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    final data = await _db.fetchQuestions(widget.categoryName);
    setState(() {
      questions = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (questions.isEmpty) return Scaffold(appBar: AppBar(), body: const Center(child: Text("No questions found.")));

    final q = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text("${widget.categoryName} Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(q.questionText, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...List.generate(q.options.length, (index) => ListTile(
              title: Text(q.options[index]),
              onTap: () {
                if (index == q.correctAnswerIndex) score++;
                if (currentIndex < questions.length - 1) {
                  setState(() => currentIndex++);
                } else {
                  showDialog(context: context, builder: (c) => AlertDialog(title: Text("Score: $score/${questions.length}"), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))]));
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}