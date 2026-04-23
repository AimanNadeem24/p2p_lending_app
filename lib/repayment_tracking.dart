import 'package:flutter/material.dart';

class RepaymentTrackingScreen extends StatelessWidget {
  final String borrowerName;
  final String loanType;
  final String riskLevel;
  final int totalMonths;
  final int monthsPaid;
  final double progress; // 0.0–1.0
  final int paidAmount;
  final int remainingAmount;
  final int totalAmount;
  final double interestRate;
  final String nextPaymentDate;
  final int nextPaymentAmount;

  const RepaymentTrackingScreen({
    super.key,
    required this.borrowerName,
    required this.loanType,
    required this.riskLevel,
    required this.totalMonths,
    required this.monthsPaid,
    required this.progress,
    required this.paidAmount,
    required this.remainingAmount,
    required this.totalAmount,
    required this.interestRate,
    required this.nextPaymentDate,
    required this.nextPaymentAmount,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF1E3A8A); // your app theme blue

    return Scaffold(
      appBar: AppBar(title: const Text("Repayment Tracking")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Header card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      borrowerName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(loanType),
                    Text("$riskLevel • $totalMonths months"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Progress section
            const Text(
              "Repayment Progress",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.grey[300],
              color: themeColor,
            ),
            const SizedBox(height: 8),
            Text("${(progress * 100).toStringAsFixed(0)}% complete"),
            Text("Paid: PKR $paidAmount"),
            Text("Remaining: PKR $remainingAmount"),
            Text(
              "Total: PKR $totalAmount • $monthsPaid/$totalMonths Paid • $interestRate%",
            ),
            const SizedBox(height: 20),

            // Next payment card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.payment, color: themeColor),
                title: const Text("Next Payment Due"),
                subtitle: Text("PKR $nextPaymentAmount on $nextPaymentDate"),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Reminder set")),
                    );
                  },
                  child: const Text("Remind"),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Payment schedule
            const Text(
              "Payment Schedule",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildScheduleCard(
              "Feb 15",
              "PKR 17,200 • Principal 11.8K + Interest 5.4K",
              "Paid",
              Colors.green,
            ),
            _buildScheduleCard(
              "May 15",
              "PKR 17,200 • Principal 12.1K + Interest 5.1K",
              "Due",
              Colors.red,
            ),
            _buildScheduleCard(
              "Jun 15",
              "PKR 17,200 • Upcoming",
              "Soon",
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for schedule items
  Widget _buildScheduleCard(
    String date,
    String details,
    String status,
    Color statusColor,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.calendar_today),
        title: Text(date),
        subtitle: Text(details),
        trailing: Text(
          status,
          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
