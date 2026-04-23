import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final methods = [
      {"method": "Bank Transfer", "details": "Meezan Bank, Account #123456"},
      {"method": "EasyPaisa", "details": "Mobile Wallet #0300-1234567"},
      {"method": "JazzCash", "details": "Mobile Wallet #0301-7654321"},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Payment Methods"),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: methods.length,
        itemBuilder: (context, index) {
          final method = methods[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.payment, color: Color(0xFF1E3A8A)),
              title: Text(
                method["method"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(method["details"]!),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                ),
                onPressed: () {},
                child: const Text("Pay"),
              ),
            ),
          );
        },
      ),
    );
  }
}
