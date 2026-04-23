import 'package:flutter/material.dart';

class LenderHome extends StatelessWidget {
  final String lenderName;

  const LenderHome({super.key, required this.lenderName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Browse"),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: "Portfolio",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Invest & Earn, $lenderName",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text("Total invested: PKR 2L"),
            const Text("Returns earned: PKR 18,200"),
            const SizedBox(height: 20),
            const Text(
              "Browse Loan Requests:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text("PKR 3,00,000 – 24mo"),
                subtitle: const Text(
                  "Debt consolidation • Grade B • 12.5% p.a. • Low Risk",
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text("PKR 1,50,000 – 12mo"),
                subtitle: const Text(
                  "Medical • Grade C • 16.3% p.a. • Med Risk",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
