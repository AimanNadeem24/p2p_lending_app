import 'package:flutter/material.dart';
import 'repayment_tracking.dart';

class LoanSuccessScreen extends StatelessWidget {
  final String borrowerName;
  final int amount;
  final int months;
  final double rate;

  const LoanSuccessScreen({
    super.key,
    required this.borrowerName,
    required this.amount,
    required this.months,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = Color(0xFF1E3A8A);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: themeColor,
                child: const Icon(Icons.check, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 20),
              const Text(
                "Loan Granted!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "You have successfully granted a loan of PKR $amount to $borrowerName.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _infoBox("PKR ${amount ~/ 1000}K", "Amount"),
                  _infoBox("$months mo", "Term"),
                  _infoBox("$rate%", "Rate"),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RepaymentTrackingScreen(
                        borrowerName: borrowerName,
                        loanType: "Debt consolidation - B2",
                        riskLevel: "Low Risk",
                        totalMonths: months,
                        monthsPaid: 4,
                        progress: 0.24,
                        paidAmount: 120000,
                        remainingAmount: amount - 120000,
                        totalAmount: amount,
                        interestRate: rate,
                        nextPaymentDate: "15 May 2026",
                        nextPaymentAmount: 17200,
                      ),
                    ),
                  );
                },
                child: const Text("Track Repayments"),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Done"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBox(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}
