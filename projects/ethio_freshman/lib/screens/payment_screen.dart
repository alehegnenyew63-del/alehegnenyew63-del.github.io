import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for copying text
import 'package:url_launcher/url_launcher.dart'; 
import '../utils/app_colors.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  // 🚀 ELITE FUNCTION: Opens your Telegram chat
  Future<void> _contactTelegram(BuildContext context) async {
    const String username = "takeacare"; 
    final Uri telegramUrl = Uri.parse("https://t.me/$username");

    try {
      if (!await launchUrl(telegramUrl, mode: LaunchMode.externalApplication)) {
        await launchUrl(telegramUrl, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open Telegram. Please contact @takeacare manually."))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Get Premium Access"), backgroundColor: Colors.blue),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Icon(Icons.workspace_premium, size: 80, color: AppColors.premiumGold)),
            const SizedBox(height: 10),
            const Center(
              child: Text("Upgrade for only 150 ETB!", 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
            ),
            const SizedBox(height: 30),
            _buildBenefitItem(Icons.check_circle, "Unlock All 13+ University Final Exams"),
            _buildBenefitItem(Icons.check_circle, "Downloadable PDF Modules"),
            _buildBenefitItem(Icons.check_circle, "Unlimited Practice Quizzes"),
            const SizedBox(height: 30),
            
            const Text("How to Pay:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            
            // Methods - Make sure to use your REAL account numbers here
            _buildPaymentMethod("TeleBirr", "0912345678", Icons.phone_android, Colors.blue, context),
            _buildPaymentMethod("CBE (Commercial Bank)", "1000123456789", Icons.account_balance, Colors.purple, context),
            
            const SizedBox(height: 30),
            const Text(
              "⚠️ IMPORTANT: After payment, send a screenshot of your receipt to our Telegram to activate your account.",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
            ),
            const SizedBox(height: 25),
            
            // 🚀 THE TELEGRAM BUTTON
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                backgroundColor: const Color(0xFF0088cc),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () => _contactTelegram(context), 
              icon: const Icon(Icons.send, color: Colors.white),
              label: const Text("Send Screenshot to @takeacare", 
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [Icon(icon, color: Colors.green, size: 20), const SizedBox(width: 10), Text(text)]),
    );
  }

  Widget _buildPaymentMethod(String name, String acc, IconData icon, Color color, BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Acc: $acc"),
        trailing: IconButton(
          icon: const Icon(Icons.copy), 
          onPressed: () {
            Clipboard.setData(ClipboardData(text: acc));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$name account copied!")));
          }
        ),
      ),
    );
  }
}