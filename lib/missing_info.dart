import 'package:flutter/material.dart';

class MissingInfoScreen extends StatelessWidget {
  final String userName;

  const MissingInfoScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Your Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "⚠ Missing required info",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text("• CNIC number — required for verification"),
                  Text("• Annual income — needed for risk scoring"),
                  Text("• Loan purpose — helps match lenders"),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "ℹ Optional fields skipped — AI will use median values for prediction accuracy",
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Completing all fields improves your loan approval chances by up to 40%",
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Hello $userName, please choose an option:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/personalInfo');
              },
              child: const Text("Fill Missing Fields"),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/aiResult');
              },
              child: const Text("Continue with defaults"),
            ),
          ],
        ),
      ),
    );
  }
}
