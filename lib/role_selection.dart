import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'borrower_profile.dart';
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
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Borrower button → final borrower profile screen
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Color.fromARGB(255, 255, 255, 255),
                  width: 2,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 20,
                ),
              ),
              onPressed: () async {
                await _setLoginState('borrower');
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BorrowerProfileScreen(
                        borrower: BorrowerData(
                          fullName: userName,
                          cnic: '42201-1234567-8',
                          city: 'Karachi',
                          employmentType: 'Salaried',
                          annualIncome: 1450000,
                          monthlyObligations: 22000,
                          homeOwnership: 'Rented',
                          employmentLength: 4,
                          creditScore: 720,
                          loanAmount: 320000,
                          loanPurpose: 'Home repairs',
                          loanTerm: 24,
                        ),
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
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Lender button → Lender route
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Color.fromARGB(255, 255, 255, 255),
                  width: 2,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 20,
                ),
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
                  color: Color.fromARGB(255, 255, 255, 255),
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
