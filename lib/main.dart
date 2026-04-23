import 'package:flutter/material.dart';
import 'splash.dart';
import 'login.dart';
import 'signup.dart';
import 'borrower_dashboard.dart';
import 'borrower_home.dart';
import 'missing_info.dart';
import 'loan_detail.dart';
import 'borrower_data.dart';
import 'ai_result.dart';
import 'personal_info.dart'; // borrower info form
import 'settings_screen.dart';
import 'otp_screen.dart';
import 'theme.dart';
import 'lender_dashboard.dart';
import 'lender_infoform.dart'; // ✅ new lender info form

void main() {
  runApp(const P2PLendingApp());
}

class P2PLendingApp extends StatefulWidget {
  const P2PLendingApp({super.key});

  @override
  State<P2PLendingApp> createState() => _P2PLendingAppState();
}

class _P2PLendingAppState extends State<P2PLendingApp> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  bool _biometricLogin = false;
  String _language = "English";

  void _toggleTheme(bool enabled) => setState(() => _darkMode = enabled);
  void _toggleNotifications(bool enabled) =>
      setState(() => _notificationsEnabled = enabled);
  void _toggleBiometric(bool enabled) =>
      setState(() => _biometricLogin = enabled);
  void _changeLanguage(String lang) => setState(() => _language = lang);
  void _changePassword() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Password change triggered")));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'P2P Lending App',
      theme: _darkMode ? ThemeData.dark() : darkBlueTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/borrower': (context) => BorrowerScreen(),

        // ✅ Lender role goes to lender info form (like borrower)
        '/lender': (context) => const LenderInfoFormScreen(),

        '/personalInfo': (context) => const PersonalInfoScreen(),
        '/settings': (context) => SettingsScreen(
          onThemeChanged: _toggleTheme,
          onNotificationsChanged: _toggleNotifications,
          onBiometricChanged: _toggleBiometric,
          onLanguageChanged: _changeLanguage,
          onPasswordChanged: _changePassword,
          darkMode: _darkMode,
          notificationsEnabled: _notificationsEnabled,
          biometricLogin: _biometricLogin,
          language: _language,
        ),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/borrowerHome':
            final borrower = settings.arguments as BorrowerData;
            return MaterialPageRoute(
              builder: (_) => BorrowerHome(borrower: borrower),
            );

          case '/lenderHome':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => LenderDashboardScreen(
                lenderName: args['name'],
                email: args['email'],
                phone: args['phone'],
                investmentCapacity: args['investmentCapacity'],
                riskAppetite: args['riskAppetite'],
              ),
            );

          case '/missingInfo':
            final userName = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => MissingInfoScreen(userName: userName),
            );

          case '/loanDetail':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            return MaterialPageRoute(
              builder: (_) => LoanDetailScreen(
                loanId: args['loanId'] ?? "Unknown",
                loanAmount:
                    int.tryParse(args['loanAmount']?.toString() ?? "0") ?? 0,
                interestRate:
                    double.tryParse(
                      args['interestRate']?.toString() ?? "0.0",
                    ) ??
                    0.0,
                loanGrade: args['loanGrade'] ?? "-",
                status: args['status'] ?? "Unknown",
                repaymentSchedule:
                    (args['repaymentSchedule'] as List<Map<String, String>>?) ??
                    [],
                repaymentHistory:
                    (args['repaymentHistory'] as List<Map<String, String>>?) ??
                    [],
              ),
            );

          case '/aiResult':
            final borrower = settings.arguments as BorrowerData;
            return MaterialPageRoute(
              builder: (_) => AIResultScreen(data: borrower),
            );

          case '/otp':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            return MaterialPageRoute(
              builder: (_) => OtpScreen(
                userName: args['userName'] ?? "",
                email: args['email'] ?? "",
                phone: args['phone'] ?? "",
              ),
            );

          default:
            return null;
        }
      },
    );
  }
}
