import 'package:flutter/material.dart';

class LendersListScreen extends StatelessWidget {
  const LendersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lenders = [
      {"name": "Ali Khan", "amount": "PKR 200,000", "rate": "12%"},
      {"name": "Sara Ahmed", "amount": "PKR 150,000", "rate": "10.5%"},
      {"name": "Bilal Hussain", "amount": "PKR 300,000", "rate": "13%"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Available Lenders"),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lenders.length,
        itemBuilder: (context, index) {
          final lender = lenders[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF1E3A8A),
                child: Text(
                  lender["name"]![0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                lender["name"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Amount: ${lender["amount"]}\nRate: ${lender["rate"]}",
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                ),
                onPressed: () {},
                child: const Text("View"),
              ),
            ),
          );
        },
      ),
    );
  }
}
