import 'package:flutter/material.dart';

class LoanDetailScreen extends StatelessWidget {
  final String loanId;
  final int loanAmount;
  final double interestRate;
  final String loanGrade;
  final String status;

  final List<Map<String, String>> repaymentSchedule;
  final List<Map<String, String>> repaymentHistory;

  const LoanDetailScreen({
    super.key,
    required this.loanId,
    required this.loanAmount,
    required this.interestRate,
    required this.loanGrade,
    required this.status,
    required this.repaymentSchedule,
    required this.repaymentHistory,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Calculate repayment progress
    final totalInstallments =
        repaymentHistory.length + repaymentSchedule.length;
    final paidInstallments = repaymentHistory.length;
    final progress = totalInstallments > 0
        ? paidInstallments / totalInstallments
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Loan Details"),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Loan summary card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Loan ID: $loanId",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Amount: PKR $loanAmount",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Interest: $interestRate% p.a.",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Grade: $loanGrade",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Status: $status",
                      style: TextStyle(
                        fontSize: 16,
                        color: status == "Active"
                            ? Colors.green
                            : Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ✅ Repayment progress bar
            const Text(
              "Repayment Progress",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              color: const Color(0xFF1E3A8A),
              minHeight: 10,
            ),
            const SizedBox(height: 8),
            Text(
              "$paidInstallments of $totalInstallments installments paid "
              "(${(progress * 100).toStringAsFixed(0)}%)",
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 20),

            // Repayment history section
            const Text(
              "Repayment History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            repaymentHistory.isEmpty
                ? const Text("No past repayments yet.")
                : Column(
                    children: repaymentHistory.map((item) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          title: Text(
                            "${item['month']} — PKR ${item['amount']}",
                          ),
                          trailing: const Text(
                            "Paid",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
