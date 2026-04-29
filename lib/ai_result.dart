import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'borrower_data.dart';
import 'borrower_dashboard.dart';
import 'lender_dashboard.dart';
import 'borrower_home.dart';

class AIResultScreen extends StatefulWidget {
  final BorrowerData data;

  const AIResultScreen({super.key, required this.data});

  @override
  State<AIResultScreen> createState() => _AIResultScreenState();
}

class _AIResultScreenState extends State<AIResultScreen> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchResults();
  }

  Future<Map<String, dynamic>> _fetchResults() async {
    // IMPORTANT: replace with your laptop IP on hotspot/Wi‑Fi
    final url = Uri.parse('http://127.0.0.1:8000/predict');

    final payload = {
      "loanAmount": widget.data.loanAmount,
      "loanTerm": widget.data.loanTerm,
      "creditScore": widget.data.creditScore,
      "annualIncome": widget.data.annualIncome,
      "dti": _calcDtiPercent(
        monthlyObligations: widget.data.monthlyObligations,
        annualIncome: widget.data.annualIncome,
      ),
      "description": (widget.data.loanPurpose ?? "").toString(),
      "homeOwnership": (widget.data.homeOwnership ?? "RENT").toString(),
      "purpose": (widget.data.loanPurpose ?? "other").toString(),
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json", "accept": "application/json"},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      throw Exception("API did not return a JSON object");
    }

    throw Exception("Backend error ${response.statusCode}: ${response.body}");
  }

  static double _calcDtiPercent({
    required dynamic monthlyObligations,
    required dynamic annualIncome,
  }) {
    final mo = double.tryParse(monthlyObligations.toString()) ?? 0.0;
    final ai = double.tryParse(annualIncome.toString()) ?? 0.0;
    final monthlyIncome = ai / 12.0;
    if (monthlyIncome <= 0) return 0.0;
    return (mo / monthlyIncome) * 100.0;
  }

  Color _categoryColor(String category) {
    final c = category.toLowerCase();
    if (c.contains("low")) return Colors.green;
    if (c.contains("medium")) return Colors.orange;
    if (c.contains("high")) return Colors.red;
    return Colors.blueGrey;
  }

  String _decisionText(int defaultProbability) {
    if (defaultProbability < 20) return "Decision: Approve (Recommended)";
    if (defaultProbability < 50) return "Decision: Manual Review";
    return "Decision: High Risk / Reject";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Result")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Failed to connect to AI backend.\n\n${snapshot.error}\n\n"
                  "Make sure:\n"
                  "1) FastAPI is running\n"
                  "2) Phone + laptop are on same Wi‑Fi / hotspot\n"
                  "3) You used laptop IP (not 127.0.0.1)\n"
                  "4) Firewall allowed port 8000",
                ),
              ),
            );
          }

          final res = snapshot.data ?? {};

          final int riskScore = res["riskScore"] is int
              ? res["riskScore"]
              : int.tryParse(res["riskScore"]?.toString() ?? "") ?? 0;

          final String riskCategory =
              (res["riskCategory"] ?? "Unknown").toString();

          final int defaultProbability = res["defaultProbability"] is int
              ? res["defaultProbability"]
              : int.tryParse(res["defaultProbability"]?.toString() ?? "") ?? 0;

          final color = _categoryColor(riskCategory);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: ListTile(
                    title: const Text("Risk Category"),
                    subtitle: Text(
                      riskCategory,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: ListTile(
                    title: const Text("Risk Score"),
                    subtitle: Text(
                      "$riskScore / 100",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: ListTile(
                    title: const Text("Default Probability"),
                    subtitle: Text(
                      "$defaultProbability%",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: ListTile(
                    title: const Text("System Suggestion"),
                    subtitle: Text(
                      _decisionText(defaultProbability),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const Spacer(),

                ElevatedButton(
                  onPressed: () async {
                    try {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => BorrowerHome(borrower: widget.data)),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Navigation error: $e")),
                      );
                    }
                  },
                  child: const Text("Continue"),
                ),
                const SizedBox(height: 10),

                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LenderDashboardScreen(
                          lenderName: "Demo Lender",
                          email: "demo@example.com",
                          phone: "1234567890",
                          investmentCapacity: "PKR 1,000,000",
                          riskAppetite: "Medium",
                        ),
                      ),
                    );
                  },
                  child: const Text("Continue (Lender Dashboard)"),
                ),
                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Back"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}