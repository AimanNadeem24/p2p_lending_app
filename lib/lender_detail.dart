import 'package:flutter/material.dart';
import 'loan_success.dart'; // new success screen

class LenderDetailScreen extends StatelessWidget {
  final String borrowerName;
  final String city;
  final String type;
  final String loanAmount;
  final String interestRate;
  final String riskLevel;
  final String term;

  const LenderDetailScreen({
    super.key,
    required this.borrowerName,
    required this.city,
    required this.type,
    required this.loanAmount,
    required this.interestRate,
    required this.riskLevel,
    required this.term,
  });

  @override
  Widget build(BuildContext context) {
    final initials = borrowerName.isNotEmpty
        ? borrowerName.substring(0, 2).toUpperCase()
        : "NA";

    return Scaffold(
      appBar: AppBar(title: const Text("Borrower Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Header with avatar + borrower info
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF1E3A8A), // app theme blue
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      borrowerName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(city),
                    Text(type),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Loan Details section
            const Text(
              "LOAN DETAILS",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(loanAmount),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Purpose: Debt consolidation"),
                    Text("Duration: $term"),
                    Text("Interest Rate: $interestRate"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // AI Risk Score section
            const Text(
              "AI RISK SCORE",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text("Risk Level: $riskLevel"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Risk Score Amount: PKR 100,000"),
                    Text("Numerical Score: 72"),
                    Text("Default Probability: 28%"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Financial Info section
            const Text(
              "FINANCIAL INFO",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: const Text("Income: PKR 100,000"),
                subtitle: const Text("Monthly Payment: PKR 25,000"),
              ),
            ),
            const SizedBox(height: 30),

            // Give Loan button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A), // app theme blue
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Navigate to Loan Success screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoanSuccessScreen(
                        borrowerName: borrowerName,
                        amount: 500000,
                        months: 36,
                        rate: 14.5,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Give Loan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
