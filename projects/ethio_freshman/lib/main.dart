import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/exams_repository_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🌉 Bridge to Supabase
  await Supabase.initialize(
    url: 'https://ynptughbcisccefuvpuoa.supabase.co', 
    anonKey: 'eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlucHR1Z2hiY2lzY2NlZnV2cHVhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA3NTA5MzYsImV4cCI6MjA4NjMyNjkzNn0', 
  );

  runApp(const StartApp());
}

class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Start',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginScreen(), // Start at Login
    );
  }
}

// 🎯 The Dashboard Wrapper
class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});
  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [const HomeScreen(), const ExamsRepositoryScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history_edu), label: "Exams Bank"),
        ],
      ),
    );
  }
}