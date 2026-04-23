import 'package:flutter/material.dart';
import 'lender_dashboard.dart';

class LenderInfoFormScreen extends StatefulWidget {
  const LenderInfoFormScreen({super.key});

  @override
  State<LenderInfoFormScreen> createState() => _LenderInfoFormScreenState();
}

class _LenderInfoFormScreenState extends State<LenderInfoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _capacityController = TextEditingController();

  String? _riskAppetite; // dropdown value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lender Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (val) => val!.isEmpty ? "Enter your name" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (val) => val!.isEmpty ? "Enter your email" : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                validator: (val) => val!.isEmpty ? "Enter your phone" : null,
              ),
              TextFormField(
                controller: _capacityController,
                decoration: const InputDecoration(
                  labelText: "Investment Capacity (PKR)",
                ),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val!.isEmpty ? "Enter investment capacity" : null,
              ),
              const SizedBox(height: 16),

              // ✅ Dropdown for Risk Appetite
              DropdownButtonFormField<String>(
                initialValue: _riskAppetite,
                decoration: const InputDecoration(labelText: "Risk Appetite"),
                items: const [
                  DropdownMenuItem(value: "Low", child: Text("Low")),
                  DropdownMenuItem(value: "Medium", child: Text("Medium")),
                  DropdownMenuItem(value: "High", child: Text("High")),
                ],
                onChanged: (val) => setState(() => _riskAppetite = val),
                validator: (val) => val == null ? "Select risk appetite" : null,
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LenderDashboardScreen(
                          lenderName: _nameController.text,
                          email: _emailController.text,
                          phone: _phoneController.text,
                          investmentCapacity: _capacityController.text,
                          riskAppetite: _riskAppetite!,
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Save Profile",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
