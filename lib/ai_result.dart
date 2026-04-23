import 'package:flutter/material.dart';
import 'borrower_data.dart';

class AIResultScreen extends StatelessWidget {
  final BorrowerData data;

  const AIResultScreen({super.key, required this.data});

  Map<String, dynamic> _calculateResults() {
    final loanTerm = data.loanTerm == 0 ? 1 : data.loanTerm;

    double riskScore = (data.creditScore / 850) * 100;
    riskScore = riskScore.clamp(0, 100);

    double interestRate = 20 - (riskScore / 10);
    if (interestRate < 5) interestRate = 5;

    double monthlyInstallment =
        (data.loanAmount * (1 + (interestRate / 100))) / loanTerm;

    String grade;
    if (riskScore >= 80) {
      grade = "A1";
    } else if (riskScore >= 70) {
      grade = "B2";
    } else if (riskScore >= 60) {
      grade = "C1";
    } else {
      grade = "D";
    }

    double defaultProbability = 100 - riskScore;

    String riskCategory;
    if (riskScore >= 70) {
      riskCategory = "Low Risk";
    } else if (riskScore >= 50) {
      riskCategory = "Medium Risk";
    } else {
      riskCategory = "High Risk";
    }

    return {
      "riskScore": riskScore.round(),
      "riskCategory": riskCategory,
      "interestRate": interestRate.toStringAsFixed(1),
      "monthlyInstallment": monthlyInstallment.round(),
      "loanGrade": grade,
      "defaultProbability": defaultProbability.round(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final results = _calculateResults();

    return Scaffold(
      backgroundColor: Colors.white, // ✅ white background
      appBar: AppBar(
        title: const Text("AI Default Risk Score"),
        backgroundColor: const Color(0xFF1E3A8A), // dark blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular score
            CircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xFF1E3A8A),
              child: Text(
                "${results['riskScore']}",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              results['riskCategory'],
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF1E3A8A),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // Loan grade card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                "Loan grade: ${results['loanGrade']}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF1E3A8A),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Default probability progress bar
            LinearProgressIndicator(
              value: results['defaultProbability'] / 100,
              minHeight: 12,
              backgroundColor: Colors.grey.shade300,
              color: Colors.blue.shade700,
            ),
            const SizedBox(height: 8),
            Text(
              "Default probability: ${results['defaultProbability']}%",
              style: const TextStyle(color: Color(0xFF1E3A8A), fontSize: 14),
            ),

            const SizedBox(height: 24),

            // Other details
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Suggested Interest Rate:         ${results['interestRate']}% p.a.",
                    style: const TextStyle(
                      color: Color(0xFF1E3A8A),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Monthly Installment:                PKR ${results['monthlyInstallment']}",
                    style: const TextStyle(
                      color: Color(0xFF1E3A8A),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/borrowerHome',
                    arguments: data,
                  );
                },
                child: const Text(
                  "Accept & List Loan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade100,
                  foregroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Re-apply with changes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
