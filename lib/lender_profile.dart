import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LenderProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String investmentCapacity;
  final String riskAppetite;

  const LenderProfileScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.investmentCapacity,
    required this.riskAppetite,
  });

  @override
  State<LenderProfileScreen> createState() => _LenderProfileScreenState();
}

class _LenderProfileScreenState extends State<LenderProfileScreen> {
  bool _isEditing = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  bool _paymentReminders = true;
  bool _aiRiskAlerts = true;
  bool _marketingEmails = false;

  // ── Brand colours ─────────────────────────────────────────
  static const _green = Color(0xFF1E3A8A);
  static const _greenDark = Color(0xFF1E3A8A);
  static const _greenLight = Color(0xFFE1F5EE);
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

  static const _font = 'Poppins';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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

  // ── sign out dialog ───────────────────────────────────────
  Future<void> _confirmSignOut() async {
    final ok = await showDialog<bool>(
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
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: _ts(13, FontWeight.w500, _green)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Sign Out', style: _ts(13, FontWeight.w600, _error)),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: _pageBg,
      // ── no default AppBar — we draw our own inside the green header
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ══════════════════════════════════════════════
            //  GREEN HEADER
            // ══════════════════════════════════════════════
            Container(
              color: _greenDark,
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
                          setState(() => _isEditing = !_isEditing);
                          if (!_isEditing) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Profile updated successfully',
                                ),
                                backgroundColor: _green,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
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
                          color: _green,
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
                            color: _green,
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

                  // ── Email · Phone (editable) ─────────────
                  _isEditing
                      ? Column(
                          children: [
                            _HeaderField(
                              controller: _emailController,
                              hint: 'Email',
                              keyboard: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 6),
                            _HeaderField(
                              controller: _phoneController,
                              hint: 'Phone',
                              keyboard: TextInputType.phone,
                            ),
                          ],
                        )
                      : Text(
                          '${_emailController.text}  ·  '
                          '${_phoneController.text}',
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
                        label: 'Verified Investor',
                      ),
                      const SizedBox(width: 8),
                      _WhitePill(
                        icon: Icons.check_circle_rounded,
                        label: 'KYC Done',
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
                  // ── INVESTOR SUMMARY ─────────────────────
                  _Label('Investor Summary'),
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
                      childAspectRatio: 2.8,
                      children: [
                        _SummaryCell('PKR 8.5L', 'Total Invested', _green),
                        _SummaryCell('PKR 72,400', 'Returns Earned', _success),
                        _SummaryCell('7', 'Active Loans', _info),
                        _SummaryCell('13.2%', 'Avg. Return', _amber),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // ── ACCOUNT ──────────────────────────────
                  _Label('Account'),
                  const SizedBox(height: 10),

                  _Tile(
                    iconBg: _greenLight,
                    icon: Icons.person_outline_rounded,
                    iconColor: _green,
                    title: 'Personal Information',
                    subtitle: 'Name, CNIC, address',
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  _Tile(
                    iconBg: _infoBg,
                    icon: Icons.credit_card_rounded,
                    iconColor: _info,
                    title: 'Bank Account',
                    subtitle: 'HBL ···· 4521 · Linked',
                    onTap: () {},
                    badge: _Badge(
                      label: 'Linked',
                      bg: _successBg,
                      fg: _success,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _Tile(
                    iconBg: _amberBg,
                    icon: Icons.shield_rounded,
                    iconColor: _amber,
                    title: 'Security & KYC',
                    subtitle: '2FA enabled · Verified',
                    onTap: () {},
                    badge: _Badge(
                      label: 'Verified',
                      bg: _successBg,
                      fg: _success,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // ── PREFERENCES ──────────────────────────
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
                          iconBg: _greenLight,
                          icon: Icons.notifications_active_rounded,
                          iconColor: _green,
                          title: 'Payment Reminders',
                          subtitle: 'Notify on due dates',
                          value: _paymentReminders,
                          onChanged: (v) =>
                              setState(() => _paymentReminders = v),
                          divider: true,
                        ),
                        _ToggleRow(
                          iconBg: _infoBg,
                          icon: Icons.auto_graph_rounded,
                          iconColor: _info,
                          title: 'AI Risk Alerts',
                          subtitle: 'Alert on high-risk loans',
                          value: _aiRiskAlerts,
                          onChanged: (v) => setState(() => _aiRiskAlerts = v),
                          divider: true,
                        ),
                        _ToggleRow(
                          iconBg: const Color(0xFFF1F5F9),
                          icon: Icons.campaign_rounded,
                          iconColor: _txtHint,
                          title: 'Marketing Emails',
                          subtitle: 'Promotions & offers',
                          value: _marketingEmails,
                          onChanged: (v) =>
                              setState(() => _marketingEmails = v),
                          divider: false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // ── SUPPORT ──────────────────────────────
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

                  // ── Footer ───────────────────────────────
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

const _font = 'Poppins';
TextStyle _txt(double sz, FontWeight fw, Color c, {double ls = 0}) => TextStyle(
  fontFamily: _font,
  fontSize: sz,
  fontWeight: fw,
  color: c,
  letterSpacing: ls,
);

// Semi-transparent icon button for the green header
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

// Text field styled for the dark green header
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
      style: _txt(13, FontWeight.w400, Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: _txt(13, FontWeight.w400, Colors.white54),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    ),
  );
}

// White pill badge in the header
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
        Text(label, style: _txt(10, FontWeight.w500, Colors.white)),
      ],
    ),
  );
}

// Section label  e.g.  "INVESTOR SUMMARY"
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: _txt(10, FontWeight.w600, const Color(0xFF94A3B8), ls: 0.6),
  );
}

// Investor summary cell  (value + label, coloured value)
class _SummaryCell extends StatelessWidget {
  final String value, label;
  final Color color;
  const _SummaryCell(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(value, style: _txt(15, FontWeight.w700, color)),
      const SizedBox(height: 2),
      Text(label, style: _txt(10, FontWeight.w400, const Color(0xFF64748B))),
    ],
  );
}

// Coloured small badge  e.g. "Linked"  "Verified"
class _Badge extends StatelessWidget {
  final String label;
  final Color bg, fg;
  const _Badge({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(label, style: _txt(10, FontWeight.w600, fg)),
  );
}

// Account / Support list tile
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
          // icon box
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
          // text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: _txt(13, FontWeight.w500, const Color(0xFF1E293B)),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: _txt(11, FontWeight.w400, const Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          // badge or chevron
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

// Preference toggle row
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
                    style: _txt(13, FontWeight.w500, const Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: _txt(11, FontWeight.w400, const Color(0xFF64748B)),
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
                activeTrackColor: const Color(0xFF1D9E75),
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
