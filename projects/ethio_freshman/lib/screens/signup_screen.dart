import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? selectedUniv;

  final List<String> universities = ["Addis Ababa Univ", "ASTU", "Jimma Univ", "Bahir Dar Univ", "Haramaya Univ"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Full Name")),
              const SizedBox(height: 10),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email/Phone")),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedUniv,
                decoration: const InputDecoration(labelText: "Select University"),
                items: universities.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                onChanged: (val) => setState(() => selectedUniv = val),
              ),
              const SizedBox(height: 10),
              TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.blue),
                onPressed: () {
                  // 💡 SMART VALIDATION
                  if (nameController.text.isEmpty || emailController.text.isEmpty || selectedUniv == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields!")));
                  } else {
                    Navigator.pop(context); // Go back to login
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account Created! Please Login."), backgroundColor: Colors.green));
                  }
                }, 
                child: const Text("SIGN UP", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}