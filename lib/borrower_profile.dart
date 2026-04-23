import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'borrower_data.dart';

class BorrowerProfileScreen extends StatefulWidget {
  final BorrowerData borrower;
  final void Function(BorrowerData updated)? onSave;

  const BorrowerProfileScreen({super.key, required this.borrower, this.onSave});

  @override
  State<BorrowerProfileScreen> createState() => _BorrowerProfileScreenState();
}

class _BorrowerProfileScreenState extends State<BorrowerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _cnicController;
  late TextEditingController _cityController;
  late TextEditingController _incomeController;
  late TextEditingController _obligationsController;
  late TextEditingController _employmentLengthController;
  late TextEditingController _creditScoreController;
  late TextEditingController _loanAmountController;
  late TextEditingController _loanPurposeController;
  late TextEditingController _loanTermController;

  // Dropdown state
  static const List<String> _employmentTypes = [
    'Salaried',
    'Self-Employed',
    'Freelance',
    'Business Owner',
    'Retired',
    'Unemployed',
  ];

  // ✅ Safe default initialization
  String _selectedEmploymentType = _employmentTypes.first;

  @override
  void initState() {
    super.initState();
    final b = widget.borrower;
    _nameController = TextEditingController(text: b.fullName);
    _cnicController = TextEditingController(text: b.cnic);
    _cityController = TextEditingController(text: b.city);
    _incomeController = TextEditingController(text: b.annualIncome.toString());
    _obligationsController = TextEditingController(
      text: b.monthlyObligations.toString(),
    );
    _employmentLengthController = TextEditingController(
      text: b.employmentLength.toString(),
    );
    _creditScoreController = TextEditingController(
      text: b.creditScore.toString(),
    );
    _loanAmountController = TextEditingController(
      text: b.loanAmount.toString(),
    );
    _loanPurposeController = TextEditingController(text: b.loanPurpose);
    _loanTermController = TextEditingController(text: b.loanTerm.toString());

    // ✅ Normalize employment type safely
    _selectedEmploymentType = _employmentTypes.contains(b.employmentType)
        ? b.employmentType
        : _employmentTypes.first;

    _creditScoreController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cnicController.dispose();
    _cityController.dispose();
    _incomeController.dispose();
    _obligationsController.dispose();
    _employmentLengthController.dispose();
    _creditScoreController.dispose();
    _loanAmountController.dispose();
    _loanPurposeController.dispose();
    _loanTermController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final updated = widget.borrower.copyWith(
      fullName: _nameController.text.trim(),
      cnic: _cnicController.text.trim(),
      city: _cityController.text.trim(),
      employmentType: _selectedEmploymentType,
      annualIncome: int.parse(_incomeController.text),
      monthlyObligations: int.parse(_obligationsController.text),
      employmentLength: int.parse(_employmentLengthController.text),
      creditScore: int.parse(_creditScoreController.text),
      loanAmount: int.parse(_loanAmountController.text),
      loanPurpose: _loanPurposeController.text.trim(),
      loanTerm: int.parse(_loanTermController.text),
    );

    await Future.delayed(const Duration(milliseconds: 400));
    widget.onSave?.call(updated);

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully'),
          backgroundColor: const Color(0xFF1E3A8A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _confirmSignOut() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You will be returned to the login screen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (_) => false,
            ),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }

  // Validators
  String? _requiredText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateCnic(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CNIC is required';
    }
    if (value.length != 13) {
      return 'CNIC must be 13 digits';
    }
    return null;
  }

  String? _validatePositiveInt(String? value, {required String field}) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }
    final parsed = int.tryParse(value);
    if (parsed == null) {
      return '$field must be a valid number';
    }
    if (parsed <= 0) {
      return '$field must be greater than 0';
    }
    return null;
  }

  String? _validateCreditScore(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Credit score is required';
    }
    final parsed = int.tryParse(value);
    if (parsed == null) {
      return 'Credit score must be a valid number';
    }
    if (parsed < 300 || parsed > 900) {
      return 'Credit score must be between 300 and 900';
    }
    return null;
  }

  String? _validateLoanTerm(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Loan term is required';
    }
    final parsed = int.tryParse(value);
    if (parsed == null) {
      return 'Loan term must be a valid number';
    }
    if (parsed <= 0 || parsed > 360) {
      return 'Loan term must be between 1 and 360 months';
    }
    return null;
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Avatar
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFF1E3A8A),
                child: Text(
                  _initials(_nameController.text),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Personal Info
            _sectionLabel('Personal Information'),
            _buildFormField(
              label: 'Full Name',
              controller: _nameController,
              validator: _requiredText,
              onChanged: (_) => setState(() {}),
              textCapitalization: TextCapitalization.words,
            ),
            _buildFormField(
              label: 'CNIC',
              controller: _cnicController,
              validator: _validateCnic,
              hint: 'XXXXX-XXXXXXX-X',
              keyboardType: TextInputType.number,
              inputFormatters: [_CnicInputFormatter()],
            ),
            _buildFormField(
              label: 'City',
              controller: _cityController,
              validator: _requiredText,
              textCapitalization: TextCapitalization.words,
            ),

            // Employment
            _sectionLabel('Employment'),
            _buildDropdown(
              label: 'Employment Type',
              value: _selectedEmploymentType,
              items: _employmentTypes,
              onChanged: (v) => setState(
                () => _selectedEmploymentType = v ?? _selectedEmploymentType,
              ),
            ),
            _buildFormField(
              label: 'Employment Length (years)',
              controller: _employmentLengthController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) =>
                  _validatePositiveInt(v, field: 'Employment length'),
            ),
            _buildFormField(
              label: 'Annual Income (PKR)',
              controller: _incomeController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => _validatePositiveInt(v, field: 'Annual income'),
              prefix: 'PKR',
            ),
            _buildFormField(
              label: 'Monthly Obligations (PKR)',
              controller: _obligationsController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) =>
                  _validatePositiveInt(v, field: 'Monthly obligations'),
              prefix: 'PKR',
            ),

            // Credit Profile
            _sectionLabel('Credit Profile'),
            _buildFormField(
              label: 'Credit Score',
              controller: _creditScoreController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _validateCreditScore,
              hint: '300 – 900',
            ),

            // Loan Application
            _sectionLabel('Loan Application'),
            _buildFormField(
              label: 'Loan Amount (PKR)',
              controller: _loanAmountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => _validatePositiveInt(v, field: 'Loan amount'),
              prefix: 'PKR',
            ),
            _buildFormField(
              label: 'Loan Purpose',
              controller: _loanPurposeController,
              validator: _requiredText,
              textCapitalization: TextCapitalization.sentences,
            ),
            _buildFormField(
              label: 'Loan Term (months)',
              controller: _loanTermController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: _validateLoanTerm,
              hint: '1 – 360',
            ),

            const SizedBox(height: 28),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isSaving ? null : _saveProfile,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 12),

            // Sign out
            Center(
              child: TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Sign Out'),
                onPressed: _confirmSignOut,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helpers
  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1E3A8A),
        letterSpacing: 0.5,
      ),
    ),
  );

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? hint,
    String? prefix,
    Widget? suffix,
    void Function(String)? onChanged,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefix != null ? '$prefix  ' : null,
        suffixIcon: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    ),
  );

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      validator: (v) =>
          v == null || v.isEmpty ? 'Please select an employment type' : null,
    ),
  );
}

// CNIC auto-formatter
class _CnicInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 13) return oldValue;
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 5 || i == 12) buf.write('-');
      buf.write(digits[i]);
    }
    final text = buf.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
