import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/question_model.dart';

class DatabaseService {
  final supabase = Supabase.instance.client;

  // 1. Fetch Questions for Quiz
  Future<List<Question>> fetchQuestions(String courseName) async {
    final response = await supabase
        .from('questions')
        .select()
        .ilike('course_name', courseName); // Use ilike for safety

    return response.map((q) => Question(
      questionText: q['text'],
      options: q['options'] is String 
          ? (q['options'] as String).replaceAll('{', '').replaceAll('}', '').split(',')
          : List<String>.from(q['options']),
      correctAnswerIndex: q['correct_index'],
      explanation: q['explanation'],
    )).toList();
  }

  // 2. Fetch PDF Materials
  Future<List<Map<String, dynamic>>> fetchMaterials(String courseName) async {
    final response = await supabase
        .from('materials')
        .select()
        .ilike('course_name', courseName); // Use ilike for safety
    return List<Map<String, dynamic>>.from(response);
  }
}