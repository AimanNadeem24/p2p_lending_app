import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'role_selection.dart';
import 'borrower_profile.dart';
import 'borrower_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userRole = prefs.getString('userRole');

    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    if (mounted) {
      if (isLoggedIn) {
        if (userRole == 'borrower') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BorrowerProfileScreen(
                borrower: BorrowerData(
                  fullName: prefs.getString('userName') ?? 'Borrower',
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
        } else if (userRole == 'lender') {
          Navigator.pushReplacementNamed(context, '/lender');
        } else {
          // Logged in but no role selected, go to role selection
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RoleSelectionScreen(
                userName: prefs.getString('userName') ?? '',
              ),
            ),
          );
        }
      } else {
        // Not logged in, go to login
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Handshake logo
            const Text("🤝", style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            // App name
            const Text(
              "P2P Lending App",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "AI-Powered Peer-to-Peer Lending",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 40),

            // Get Started → Signup
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: const Text(
                "Get Started",
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),

            const SizedBox(height: 10),

            // Sign In → Login
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 12,
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text(
                "Sign In",
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
