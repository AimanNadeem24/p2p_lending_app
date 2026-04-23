import 'package:flutter/material.dart';
import 'ai_result.dart';
import 'borrower_data.dart';

class LoanRequestScreen extends StatefulWidget {
  final BorrowerData partialData;

  const LoanRequestScreen({super.key, required this.partialData});

  @override
  State<LoanRequestScreen> createState() => _LoanRequestScreenState();
}

class _LoanRequestScreenState extends State<LoanRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();
  final _termController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ white background
      appBar: AppBar(
        title: const Text("Loan Request"),
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
                    "Please provide your loan request details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Loan Amount
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: "Loan Amount (PKR)",
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

                  // Loan Purpose
                  TextFormField(
                    controller: _purposeController,
                    decoration: InputDecoration(
                      labelText: "Loan Purpose",
                      prefixIcon: const Icon(
                        Icons.assignment,
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
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 16),

                  // Loan Term
                  TextFormField(
                    controller: _termController,
                    decoration: InputDecoration(
                      labelText: "Loan Term (months)",
                      prefixIcon: const Icon(
                        Icons.calendar_month,
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

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "Describe your need?",
                      prefixIcon: const Icon(
                        Icons.description,
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
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  // Submit button
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
                            fullName: widget.partialData.fullName,
                            cnic: widget.partialData.cnic,
                            city: widget.partialData.city,
                            employmentType: widget.partialData.employmentType,
                            annualIncome: widget.partialData.annualIncome,
                            monthlyObligations:
                                widget.partialData.monthlyObligations,
                            homeOwnership: widget.partialData.homeOwnership,
                            employmentLength:
                                widget.partialData.employmentLength,
                            creditScore: widget.partialData.creditScore,
                            loanAmount: int.parse(_amountController.text),
                            loanPurpose: _purposeController.text,
                            loanTerm: int.parse(_termController.text),
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AIResultScreen(data: borrowerData),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Submit Application",
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
