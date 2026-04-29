import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'borrower_data.dart';

class BorrowerProfileScreen extends StatefulWidget {
  final BorrowerData borrower;
  final void Function(BorrowerData updated)? onSave;

  const BorrowerProfileScreen({super.key, required this.borrower, this.onSave});

  @override
  State<BorrowerProfileScreen> createState() => _BorrowerProfileScreenState();
}

class _BorrowerProfileScreenState extends State<BorrowerProfileScreen> {
  bool _isEditing = false;

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

  static const List<String> _employmentTypes = [
    'Salaried',
    'Self-Employed',
    'Freelance',
    'Business Owner',
    'Retired',
    'Unemployed',
  ];

  late String _selectedEmploymentType;

  bool _emailNotifications = true;
  bool _loanAlerts = true;
  bool _paymentReminders = true;

  // ── Brand colours ─────────────────────────────────────────
  static const _primary = Color(0xFF1E3A8A);
  static const _primaryDark = Color(0xFF1E3A8A);
  static const _primaryLight = Color(0xFFDBEAFE);
  static const _pageBg = Color(0xFFF1F5F9);
  static const _cardBg = Color(0xFFFFFFFF);
  static const _border = Color(0xFFE2E8F0);
  static const _txt1 = Color(0xFF1E293B);
  static const _txt2 = Color(0xFF64748B);
  static const _txtHint = Color(0xFF94A3B8);
  static const _success = Color(0xFF16A34A);
  static const _successBg = Color(0xFFDCFCE7);
  static const _info = Color(0xFF2563EB);
  static const _infoBg = Color(0xFFDBEAFE);
  static const _amber = Color(0xFFD97706);
  static const _amberBg = Color(0xFFFEF9C3);
  static const _purple = Color(0xFF7C3AED);
  static const _purpleBg = Color(0xFFF5F3FF);
  static const _error = Color(0xFFDC2626);
  static const _errorBg = Color(0xFFFEE2E2);
  static const _red = Color(0xFFEF4444);

  static const _font = 'Poppins';

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

    _selectedEmploymentType = _employmentTypes.contains(b.employmentType)
        ? b.employmentType
        : _employmentTypes.first;
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

  // ── helpers ───────────────────────────────────────────────
  TextStyle _ts(double sz, FontWeight fw, Color c, {double ls = 0}) =>
      TextStyle(
        fontFamily: _font,
        fontSize: sz,
        fontWeight: fw,
        color: c,
        letterSpacing: ls,
      );

  String get _initials {
    final parts = _nameController.text.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return _nameController.text
        .substring(0, _nameController.text.length.clamp(0, 2))
        .toUpperCase();
  }

  int get _creditScore => int.tryParse(_creditScoreController.text) ?? 0;

  String get _creditRating {
    if (_creditScore >= 750) return 'Excellent';
    if (_creditScore >= 700) return 'Very Good';
    if (_creditScore >= 650) return 'Good';
    if (_creditScore >= 600) return 'Fair';
    return 'Poor';
  }

  Color get _creditColor {
    if (_creditScore >= 750) return _success;
    if (_creditScore >= 700) return const Color(0xFF10B981);
    if (_creditScore >= 650) return _info;
    if (_creditScore >= 600) return _amber;
    return _error;
  }

  Future<void> _saveProfile() async {
    setState(() => _isEditing = false);

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully'),
          backgroundColor: _success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Future<void> _doSignOut() async {
    final prefs = await SharedPreferences.getInstance();

    // ✅ Prototype-friendly logout: clears any saved login/session keys
    await prefs.clear();

    if (!mounted) return;

    // ✅ Close the dialog first
    Navigator.of(context).pop();

    // ✅ Navigate to login/welcome and remove previous screens
    // IMPORTANT: If your app uses a different route, change "/" to it (e.g. "/login")
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Sign Out', style: _ts(16, FontWeight.w600, _txt1)),
        content: Text(
          'Are you sure you want to sign out?',
          style: _ts(13, FontWeight.w400, _txt2),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: _ts(13, FontWeight.w500, _primary)),
          ),
          TextButton(
            onPressed: _doSignOut,
            child: Text('Sign Out', style: _ts(13, FontWeight.w600, _error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: _pageBg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ══════════════════════════════════════════════
            //  BLUE HEADER
            // ══════════════════════════════════════════════
            Container(
              color: _primaryDark,
              padding: EdgeInsets.fromLTRB(20, topPad + 10, 20, 30),
              child: Column(
                children: [
                  // top bar: back + title + edit
                  Row(
                    children: [
                      _IconBtn(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Text(
                        'My Profile',
                        style: _ts(16, FontWeight.w600, Colors.white),
                      ),
                      const Spacer(),
                      _IconBtn(
                        icon: _isEditing
                            ? Icons.check_rounded
                            : Icons.edit_rounded,
                        onTap: () {
                          if (_isEditing) {
                            _saveProfile();
                          } else {
                            setState(() => _isEditing = true);
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // ── Avatar with camera badge ─────────────
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          color: _primary,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colors.white38, width: 3),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _initials,
                          style: _ts(28, FontWeight.w700, Colors.white),
                        ),
                      ),
                      Positioned(
                        bottom: -4,
                        right: -4,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 14,
                            color: _primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── Name (editable) ──────────────────────
                  _isEditing
                      ? _HeaderField(
                          controller: _nameController,
                          hint: 'Full name',
                        )
                      : Text(
                          _nameController.text,
                          style: _ts(
                            19,
                            FontWeight.w700,
                            Colors.white,
                            ls: -0.3,
                          ),
                        ),

                  const SizedBox(height: 4),

                  // ── City · Employment (editable) ────────
                  _isEditing
                      ? Column(
                          children: [
                            _HeaderField(
                              controller: _cityController,
                              hint: 'City',
                            ),
                            const SizedBox(height: 6),
                            _HeaderField(
                              controller: _cnicController,
                              hint: 'CNIC',
                            ),
                          ],
                        )
                      : Text(
                          '${_cityController.text}  ·  '
                          '$_selectedEmploymentType',
                          textAlign: TextAlign.center,
                          style: _ts(11, FontWeight.w400, Colors.white70),
                        ),

                  const SizedBox(height: 14),

                  // ── Badges ───────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _WhitePill(
                        icon: Icons.verified_rounded,
                        label: 'KYC Verified',
                      ),
                      const SizedBox(width: 8),
                      _WhitePill(
                        icon: Icons.trending_up_rounded,
                        label: _creditRating,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ══════════════════════════════════════════════
            //  BODY
            // ══════════════════════════════════════════════
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── CREDIT SCORE ─────────────────────────
                  _Label('Credit Profile'),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _border, width: 0.5),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _creditColor.withOpacity(0.1),
                                border: Border.all(
                                  color: _creditColor,
                                  width: 3,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _creditScore.toString(),
                                    style: _ts(
                                      28,
                                      FontWeight.w700,
                                      _creditColor,
                                    ),
                                  ),
                                  Text(
                                    '/900',
                                    style: _ts(10, FontWeight.w500, _txt2),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Credit Score',
                                    style: _ts(14, FontWeight.w600, _txt1),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _creditRating,
                                    style: _ts(
                                      13,
                                      FontWeight.w500,
                                      _creditColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: _border,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: LinearProgressIndicator(
                                        value: _creditScore / 900,
                                        backgroundColor: Colors.transparent,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          _creditColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // ── FINANCIAL SUMMARY ────────────────────
                  _Label('Financial Summary'),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _border, width: 0.5),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.2,
                      children: [
                        _SummaryCell(
                          'PKR ${_incomeController.text}',
                          'Annual Income',
                          _primary,
                        ),
                        _SummaryCell(
                          'PKR ${_obligationsController.text}',
                          'Monthly Obligations',
                          _amber,
                        ),
                        _SummaryCell(
                          'PKR ${_loanAmountController.text}',
                          'Loan Amount',
                          _info,
                        ),
                        _SummaryCell(
                          '${_loanTermController.text} months',
                          'Loan Term',
                          _purple,
                        ),
                      ],
                    ),
                  ),

                  _Label('Personal Information'),
                  const SizedBox(height: 10),

                  if (!_isEditing)
                    _Tile(
                      iconBg: _primaryLight,
                      icon: Icons.person_outline_rounded,
                      iconColor: _primary,
                      title: 'Full Name',
                      subtitle: _nameController.text,
                      onTap: () {},
                    )
                  else
                    _EditableField(
                      label: 'Full Name',
                      controller: _nameController,
                    ),

                  const SizedBox(height: 8),

                  if (!_isEditing)
                    _Tile(
                      iconBg: _infoBg,
                      icon: Icons.badge_rounded,
                      iconColor: _info,
                      title: 'CNIC',
                      subtitle: _cnicController.text,
                      onTap: () {},
                    )
                  else
                    _EditableField(label: 'CNIC', controller: _cnicController),

                  const SizedBox(height: 8),

                  if (!_isEditing)
                    _Tile(
                      iconBg: const Color(0xFFFECECA),
                      icon: Icons.location_on_outlined,
                      iconColor: _red,
                      title: 'City',
                      subtitle: _cityController.text,
                      onTap: () {},
                    )
                  else
                    _EditableField(label: 'City', controller: _cityController),

                  const SizedBox(height: 22),

                  _Label('Employment & Income'),
                  const SizedBox(height: 10),

                  if (!_isEditing)
                    _Tile(
                      iconBg: _purpleBg,
                      icon: Icons.work_outline_rounded,
                      iconColor: _purple,
                      title: 'Employment Type',
                      subtitle: _selectedEmploymentType,
                      onTap: () {},
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _border, width: 0.5),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedEmploymentType,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: _employmentTypes
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: _ts(13, FontWeight.w500, _txt1),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => _selectedEmploymentType = v);
                            }
                          },
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),

                  if (!_isEditing)
                    _Tile(
                      iconBg: _successBg,
                      icon: Icons.trending_up_outlined,
                      iconColor: _success,
                      title: 'Annual Income',
                      subtitle: 'PKR ${_incomeController.text}',
                      onTap: () {},
                    )
                  else
                    _EditableField(
                      label: 'Annual Income',
                      controller: _incomeController,
                      keyboard: TextInputType.number,
                    ),

                  const SizedBox(height: 8),

                  if (!_isEditing)
                    _Tile(
                      iconBg: _amberBg,
                      icon: Icons.receipt_outlined,
                      iconColor: _amber,
                      title: 'Monthly Obligations',
                      subtitle: 'PKR ${_obligationsController.text}',
                      onTap: () {},
                    )
                  else
                    _EditableField(
                      label: 'Monthly Obligations',
                      controller: _obligationsController,
                      keyboard: TextInputType.number,
                    ),

                  const SizedBox(height: 8),

                  if (!_isEditing)
                    _Tile(
                      iconBg: _infoBg,
                      icon: Icons.calendar_today_outlined,
                      iconColor: _info,
                      title: 'Employment Length',
                      subtitle: '${_employmentLengthController.text} years',
                      onTap: () {},
                    )
                  else
                    _EditableField(
                      label: 'Employment Length (years)',
                      controller: _employmentLengthController,
                      keyboard: TextInputType.number,
                    ),

                  const SizedBox(height: 22),

                  _Label('Loan Details'),
                  const SizedBox(height: 10),

                  if (!_isEditing)
                    _Tile(
                      iconBg: _primaryLight,
                      icon: Icons.money_rounded,
                      iconColor: _primary,
                      title: 'Loan Amount',
                      subtitle: 'PKR ${_loanAmountController.text}',
                      onTap: () {},
                    )
                  else
                    _EditableField(
                      label: 'Loan Amount',
                      controller: _loanAmountController,
                      keyboard: TextInputType.number,
                    ),

                  const SizedBox(height: 8),

                  if (!_isEditing)
                    _Tile(
                      iconBg: _purpleBg,
                      icon: Icons.schedule_rounded,
                      iconColor: _purple,
                      title: 'Loan Term',
                      subtitle: '${_loanTermController.text} months',
                      onTap: () {},
                    )
                  else
                    _EditableField(
                      label: 'Loan Term (months)',
                      controller: _loanTermController,
                      keyboard: TextInputType.number,
                    ),

                  const SizedBox(height: 8),

                  if (!_isEditing)
                    _Tile(
                      iconBg: _amberBg,
                      icon: Icons.description_outlined,
                      iconColor: _amber,
                      title: 'Loan Purpose',
                      subtitle: _loanPurposeController.text,
                      onTap: () {},
                    )
                  else
                    _EditableField(
                      label: 'Loan Purpose',
                      controller: _loanPurposeController,
                      maxLines: 2,
                    ),

                  const SizedBox(height: 22),

                  _Label('Preferences'),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _border, width: 0.5),
                    ),
                    child: Column(
                      children: [
                        _ToggleRow(
                          iconBg: _primaryLight,
                          icon: Icons.notifications_active_rounded,
                          iconColor: _primary,
                          title: 'Payment Reminders',
                          subtitle: 'Get notified before due dates',
                          value: _paymentReminders,
                          onChanged: (v) =>
                              setState(() => _paymentReminders = v),
                          divider: true,
                        ),
                        _ToggleRow(
                          iconBg: _infoBg,
                          icon: Icons.auto_graph_rounded,
                          iconColor: _info,
                          title: 'Loan Alerts',
                          subtitle: 'Status & repayment updates',
                          value: _loanAlerts,
                          onChanged: (v) => setState(() => _loanAlerts = v),
                          divider: true,
                        ),
                        _ToggleRow(
                          iconBg: const Color(0xFFF1F5F9),
                          icon: Icons.mail_outline_rounded,
                          iconColor: _txtHint,
                          title: 'Email Notifications',
                          subtitle: 'Important updates',
                          value: _emailNotifications,
                          onChanged: (v) =>
                              setState(() => _emailNotifications = v),
                          divider: false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  _Label('Support'),
                  const SizedBox(height: 10),

                  _Tile(
                    iconBg: _purpleBg,
                    icon: Icons.help_outline_rounded,
                    iconColor: _purple,
                    title: 'Help & Support',
                    subtitle: 'FAQs, contact us',
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  _Tile(
                    iconBg: const Color(0xFFF8FAFC),
                    icon: Icons.description_outlined,
                    iconColor: _txt2,
                    title: 'Terms & Privacy Policy',
                    subtitle: 'Legal documents',
                    onTap: () {},
                  ),

                  const SizedBox(height: 8),

                  // ── SIGN OUT ─────────────────────────────
                  GestureDetector(
                    onTap: _confirmSignOut,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _error.withOpacity(0.35),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: _errorBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.logout_rounded,
                              color: _error,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Sign Out',
                              style: _ts(14, FontWeight.w600, _error),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: _error,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  Center(
                    child: Column(
                      children: [
                        Text(
                          'PaisaConnect v1.0.0',
                          style: _ts(10, FontWeight.w400, _txtHint),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'AI-Powered P2P Lending · Pakistan',
                          style: _ts(10, FontWeight.w400, _txtHint),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ════════════════════════════════════════════════════════════════

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      );
}

class _HeaderField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboard;
  const _HeaderField({
    required this.controller,
    required this.hint,
    this.keyboard = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: controller,
          keyboardType: keyboard,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.white54,
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      );
}

class _WhitePill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _WhitePill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 12),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF94A3B8),
          letterSpacing: 0.6,
        ),
      );
}

class _SummaryCell extends StatelessWidget {
  final String value, label;
  final Color color;
  const _SummaryCell(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      );
}

class _Tile extends StatelessWidget {
  final Color iconBg, iconColor;
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  final Widget? badge;

  const _Tile({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              if (badge != null)
                badge!
              else
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF94A3B8),
                  size: 18,
                ),
            ],
          ),
        ),
      );
}

class _ToggleRow extends StatelessWidget {
  final Color iconBg, iconColor;
  final IconData icon;
  final String title, subtitle;
  final bool value, divider;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 17),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 0.85,
                  child: Switch.adaptive(
                    value: value,
                    onChanged: onChanged,
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFF1E3A8A),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFFE2E8F0),
                  ),
                ),
              ],
            ),
          ),
          if (divider)
            const Divider(
              height: 1,
              thickness: 0.5,
              color: Color(0xFFE2E8F0),
              indent: 62,
              endIndent: 14,
            ),
        ],
      );
}

class _EditableField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboard;
  final int maxLines;

  const _EditableField({
    required this.label,
    required this.controller,
    this.keyboard = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboard,
            maxLines: maxLines,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF94A3B8),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
      );
}