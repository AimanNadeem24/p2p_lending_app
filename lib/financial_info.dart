import 'package:flutter/material.dart';
import 'loan_request.dart';
import 'borrower_data.dart';

class FinancialInfoScreen extends StatefulWidget {
  final BorrowerData personalData;

  const FinancialInfoScreen({super.key, required this.personalData});

  @override
  State<FinancialInfoScreen> createState() => _FinancialInfoScreenState();
}

class _FinancialInfoScreenState extends State<FinancialInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _incomeController = TextEditingController();
  final _obligationsController = TextEditingController();
  final _employmentLengthController = TextEditingController();
  final _creditScoreController = TextEditingController();
  String? _homeOwnership;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ white background
      appBar: AppBar(
        title: const Text("Financial Profile"),
        backgroundColor: const Color(0xFF1E3A8A), // dark blue
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const Text(
                    "Please provide your financial details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Annual Income
                  TextFormField(
                    controller: _incomeController,
                    decoration: InputDecoration(
                      labelText: "Annual Income (PKR)",
                      prefixIcon: const Icon(
                        Icons.attach_money,
                        color: Color(0xFF1E3A8A),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF1E3A8A),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 16),

                  // Monthly Obligations
                  TextFormField(
                    controller: _obligationsController,
                    decoration: InputDecoration(
                      labelText: "Monthly Obligations (PKR)",
                      prefixIcon: const Icon(
                        Icons.money_off,
                        color: Color(0xFF1E3A8A),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF1E3A8A),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 16),

                  // Home Ownership
                  DropdownButtonFormField<String>(
                    initialValue: _homeOwnership,
                    decoration: InputDecoration(
                      labelText: "Home Ownership",
                      prefixIcon: const Icon(
                        Icons.home,
                        color: Color(0xFF1E3A8A),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: "Owned", child: Text("Owned")),
                      DropdownMenuItem(value: "Rented", child: Text("Rented")),
                      DropdownMenuItem(value: "Other", child: Text("Other")),
                    ],
                    onChanged: (val) => setState(() => _homeOwnership = val),
                    validator: (val) => val == null ? "Required" : null,
                  ),
                  const SizedBox(height: 16),

                  // Employment Length
                  TextFormField(
                    controller: _employmentLengthController,
                    decoration: InputDecoration(
                      labelText: "Employment Length (years)",
                      prefixIcon: const Icon(
                        Icons.work_history,
                        color: Color(0xFF1E3A8A),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF1E3A8A),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Credit Score
                  TextFormField(
                    controller: _creditScoreController,
                    decoration: InputDecoration(
                      labelText: "Credit Score",
                      prefixIcon: const Icon(
                        Icons.score,
                        color: Color(0xFF1E3A8A),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF1E3A8A),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),

                  // Next button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final borrowerData = BorrowerData(
                            fullName: widget.personalData.fullName,
                            cnic: widget.personalData.cnic,
                            city: widget.personalData.city,
                            employmentType: widget.personalData.employmentType,
                            annualIncome: int.parse(_incomeController.text),
                            monthlyObligations: int.parse(
                              _obligationsController.text,
                            ),
                            homeOwnership: _homeOwnership!,
                            employmentLength:
                                int.tryParse(
                                  _employmentLengthController.text,
                                ) ??
                                0,
                            creditScore:
                                int.tryParse(_creditScoreController.text) ?? 0,
                            loanAmount: 0,
                            loanPurpose: "",
                            loanTerm: 0,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  LoanRequestScreen(partialData: borrowerData),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Next →",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
