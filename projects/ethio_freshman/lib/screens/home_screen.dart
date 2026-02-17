import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'course_details_screen.dart';
import 'gpa_calculator_screen.dart';
import 'payment_screen.dart'; // IMPORTANT: Link to the payment page

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // THE FULL LIST: 10 Essential Freshman Courses
  final List<Map<String, dynamic>> courses = const [
    {"name": "Logic", "icon": Icons.psychology, "color": Colors.blue},
    {"name": "Psychology", "icon": Icons.face, "color": Colors.orange},
    {"name": "Geography", "icon": Icons.public, "color": Colors.green},
    {"name": "English I", "icon": Icons.menu_book, "color": Colors.red},
    {"name": "Maths", "icon": Icons.calculate, "color": Colors.purple},
    {"name": "Physics", "icon": Icons.bolt, "color": Colors.indigo},
    {"name": "Chemistry", "icon": Icons.science, "color": Colors.teal},
    {"name": "Biology", "icon": Icons.biotech, "color": Colors.lightGreen},
    {"name": "Economics", "icon": Icons.trending_up, "color": Colors.amber},
    {"name": "Inclusivity", "icon": Icons.group, "color": Colors.pink},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      
      // 1. APP BAR
      appBar: AppBar(
        title: const Text("starting", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {})
        ],
      ),

      // 2. THE SIDEBAR (DRAWER) - Professional Menu
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: AppColors.primaryBlue),
              accountName: Text("Freshman Student", style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text("Ethiopia"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 45, color: AppColors.primaryBlue),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: AppColors.primaryBlue),
              title: const Text("Dashboard"),
              onTap: () => Navigator.pop(context),
            ),
            // THE ACTIVATION LINK
            ListTile(
              leading: const Icon(Icons.verified_user, color: Colors.green),
              title: const Text("Contact Support / Activate"),
              subtitle: const Text("Send payment receipt here"),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About the App"),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text("Share App"),
              onTap: () {},
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      // 3. MAIN BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PREMIUM BANNER (MONEY MAKER)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1e3c72), Color(0xFF2a5298)]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars, color: AppColors.premiumGold, size: 50),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("GET PRO ACCESS", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Unlock all Exams & PDF Modules", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentOrange, foregroundColor: Colors.white),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentScreen()));
                    },
                    child: const Text("UPGRADE"),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 25),
            
            // GPA CALCULATOR BAR
            InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GpaCalculatorScreen())),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.calculate, color: AppColors.primaryBlue),
                    SizedBox(width: 15),
                    Text("GPA Calculator", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),
            const Text("Your Courses", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            
            // COURSE GRID
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), 
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CourseDetailsScreen(courseName: course['name'])));
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: (course['color'] as Color).withValues(alpha: 0.1), 
                            shape: BoxShape.circle
                          ),
                          child: Icon(course['icon'], size: 40, color: course['color']),
                        ),
                        const SizedBox(height: 12),
                        Text(course['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}