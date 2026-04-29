import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'financial_info.dart';
import 'borrower_data.dart';

class PersonalInfoScreen extends StatefulWidget {
  // ✅ Added: accept userName (because main.dart / role_selection.dart pass it)
  final String? userName;

  const PersonalInfoScreen({super.key, this.userName});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cnicController = TextEditingController();
  final _cityController = TextEditingController();
  String? _employmentType;

  @override
  void initState() {
    super.initState();
    // ✅ Optional: if userName was provided earlier, pre-fill the Full Name field
    if (widget.userName != null && widget.userName!.trim().isNotEmpty) {
      _nameController.text = widget.userName!.trim();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cnicController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ white background
      appBar: AppBar(
        title: const Text("Personal Information"),
        backgroundColor: const Color(0xFF1E3A8A), // dark blue
        foregroundColor: Colors.white,
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
                    "Please provide your personal details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Full Name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: const Icon(
                        Icons.person,
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
                    validator: (v) => (v == null || v.isEmpty)
                        ? "Full name required"
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // CNIC
                  TextFormField(
                    controller: _cnicController,
                    decoration: InputDecoration(
                      labelText: "CNIC Number",
                      hintText: "_____-_______-_",
                      prefixIcon: const Icon(
                        Icons.credit_card,
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
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _CNICInputFormatter(),
                    ],
                    validator: (v) {
                      if (v == null || v.isEmpty) return "CNIC required";
                      if (v.length != 15) {
                        return "CNIC must be in format #####-#######-#";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // City
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: "City",
                      prefixIcon: const Icon(
                        Icons.location_city,
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
                    validator: (v) =>
                        (v == null || v.isEmpty) ? "City required" : null,
                  ),
                  const SizedBox(height: 16),

                  // Employment Type
                  DropdownButtonFormField<String>(
                    initialValue: _employmentType,
                    decoration: InputDecoration(
                      labelText: "Employment Type",
                      prefixIcon: const Icon(
                        Icons.work,
                        color: Color(0xFF1E3A8A),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Self-Employed",
                        child: Text("Self-Employed"),
                      ),
                      DropdownMenuItem(
                        value: "Trainee",
                        child: Text("Trainee"),
                      ),
                      DropdownMenuItem(
                        value: "Internee",
                        child: Text("Internee"),
                      ),
                      DropdownMenuItem(
                        value: "Unemployed",
                        child: Text("Unemployed"),
                      ),
                    ],
                    onChanged: (val) => setState(() => _employmentType = val),
                    validator: (val) =>
                        val == null ? "Employment type required" : null,
                  ),
                  const SizedBox(height: 24),

                  // Next button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final personalData = BorrowerData(
                            fullName: _nameController.text,
                            cnic: _cnicController.text,
                            city: _cityController.text,
                            employmentType: _employmentType!,
                            annualIncome: 0,
                            monthlyObligations: 0,
                            homeOwnership: "",
                            employmentLength: 0,
                            creditScore: 0,
                            loanAmount: 0,
                            loanPurpose: "",
                            loanTerm: 0,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FinancialInfoScreen(
                                personalData: personalData,
                              ),
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

class _CNICInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll('-', '');
    if (digits.length > 13) digits = digits.substring(0, 13);

    String formatted = '';
    for (int i = 0; i < digits.length; i++) {
      formatted += digits[i];
      if (i == 4 || i == 11) formatted += '-';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}