import 'package:flutter/material.dart';
import 'personal_info.dart';

class BorrowerScreen extends StatelessWidget {
  const BorrowerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Borrower Information"),
        backgroundColor: Color(0xFF1E3A8A), // dark
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1E3A8A), // dark
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PersonalInfoScreen()),
            );
          },
          child: const Text("Start Loan Application →"),
        ),
      ),
    );
  }
}
