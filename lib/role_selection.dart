import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'personal_info.dart'; // ✅ start with PersonalInfoScreen
import 'borrower_data.dart';

class RoleSelectionScreen extends StatelessWidget {
  final String userName;

  const RoleSelectionScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Greeting text
            Text(
              "Hey $userName, which role do you want to choose?",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Borrower button → start flow with PersonalInfoScreen
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white, width: 2),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              onPressed: () async {
                await _setLoginState('borrower');
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonalInfoScreen(
                        userName: userName,
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                "💰 Borrower",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Lender button → Lender route
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white, width: 2),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              onPressed: () async {
                await _setLoginState('lender');
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/lender');
                }
              },
              child: const Text(
                "📈 Lender",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setLoginState(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userRole', role);
  }
}