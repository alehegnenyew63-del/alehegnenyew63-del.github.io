import 'package:flutter/material.dart';
import '../main.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.psychology, size: 80, color: Colors.blue),
            const Text("Start", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email/Phone", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder())),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 55), backgroundColor: Colors.blue),
              onPressed: () {
                // 💡 SMART VALIDATION
                if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in all fields!")));
                } else {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigationWrapper()));
                }
              }, 
              child: const Text("LOGIN", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen())), child: const Text("Create Account")),
          ],
        ),
      ),
    );
  }
}