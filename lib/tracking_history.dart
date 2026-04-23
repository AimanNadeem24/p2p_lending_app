import 'package:flutter/material.dart';

class TrackingHistoryScreen extends StatefulWidget {
  const TrackingHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TrackingHistoryScreen> createState() => _TrackingHistoryScreenState();
}

class _TrackingHistoryScreenState extends State<TrackingHistoryScreen> {
  int _selectedTab = 0;
  int _selectedRisk = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        title: const Text("Tracking & History"),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeaderTabs(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryGrid(),
                  const SizedBox(height: 16),
                  _buildGraphCard(),
                  const SizedBox(height: 16),
                  _buildRiskFilters(),
                  const SizedBox(height: 12),
                  if (_selectedTab == 0) _buildActiveLoans(),
                  if (_selectedTab == 1) _buildCompletedLoans(),
                  if (_selectedTab == 2) _buildTransactionTimeline(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tabs
  Widget _buildHeaderTabs() {
    final tabs = ["Active", "Completed", "History"];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(color: Color(0xFF1E3A8A)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (i) {
          final isSelected = _selectedTab == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = i),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 22),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.white24,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                tabs[i],
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Summary Grid
  Widget _buildSummaryGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1.8,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _SummaryCard("PKR 8.5L", "Total Lent"),
        _SummaryCard("PKR 72,400", "Returns Earned"),
        _SummaryCard("7 Active", "Ongoing Loans"),
        _SummaryCard("13.2%", "Avg. Return"),
      ],
    );
  }

  // Graph Card
  Widget _buildGraphCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "PKR 72,400",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: const [
                Text("Total returns - last 6 months"),
                Spacer(),
                Text("+18.4%", style: TextStyle(color: Colors.green)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text("Graph Placeholder")),
            ),
          ],
        ),
      ),
    );
  }

  // Risk Filters
  Widget _buildRiskFilters() {
    final labels = ["All Loans", "Low Risk", "Medium Risk", "High Risk"];
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedRisk == index;
          return ChoiceChip(
            label: Text(labels[index]),
            selected: isSelected,
            onSelected: (_) => setState(() => _selectedRisk = index),
            selectedColor: const Color(0xFF1E3A8A),
            backgroundColor: Colors.grey[300],
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          );
        },
      ),
    );
  }

  // Active Loans
  Widget _buildActiveLoans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Active Loans",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        LoanCard(
          name: "Ali Khan",
          badge: "Low Risk",
          amount: "PKR 5,00,000",
          rate: "14.5% p.a. · 36 months · Grade B2",
          progressValue: 0.24,
          progressText: "PKR 1,20,000 repaid • 24%",
          nextPayment: "Next: 15 May 2026",
        ),
        LoanCard(
          name: "Ahmed Raza",
          badge: "Med Risk",
          amount: "PKR 3,00,000",
          rate: "16.8% p.a. · 24 months · Grade C3",
          progressValue: 0.58,
          progressText: "PKR 1,74,000 repaid • 58%",
          nextPayment: "Next: 20 May 2026",
        ),
      ],
    );
  }

  // Completed Loans
  Widget _buildCompletedLoans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Completed Loans",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        LoanCard(
          name: "Sara Malik",
          badge: "Completed",
          amount: "PKR 2,00,000",
          rate: "11.5% p.a. · 12 months · Grade A4",
          progressValue: 1.0,
          progressText: "Fully repaid • Earned PKR 12,650",
          nextPayment: "Completed Jan 2026",
        ),
      ],
    );
  }

  // Transaction Timeline
  Widget _buildTransactionTimeline() {
    final items = [
      "15 Apr 2026 • Payment received • Ali Khan • PKR 17,200",
      "20 Apr 2026 • Payment received • Ahmed Raza • PKR 14,900",
      "10 Mar 2026 • Loan funded • Ali Khan • PKR 5,00,000",
      "15 Jan 2026 • Loan completed • Sara Malik",
      "5 Dec 2025 • Loan funded • Sara Malik • PKR 2,00,000",
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Transaction Timeline",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...items.map(
          (t) => ListTile(
            leading: const Icon(
              Icons.circle,
              size: 12,
              color: Color(0xFF1E3A8A),
            ),
            title: Text(t),
            dense: true,
          ),
        ),
      ],
    );
  }
}

// Summary Card
class _SummaryCard extends StatelessWidget {
  final String value;
  final String label;
  const _SummaryCard(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

// Loan Card widget
class LoanCard extends StatelessWidget {
  final String name;
  final String badge;
  final String amount;
  final String rate;
  final double progressValue;
  final String progressText;
  final String nextPayment;

  const LoanCard({
    Key? key,
    required this.name,
    required this.badge,
    required this.amount,
    required this.rate,
    required this.progressValue,
    required this.progressText,
    required this.nextPayment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with avatar + badge
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.green[100],
                  child: Text(
                    name[0],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(badge),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              amount,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(rate, style: const TextStyle(color: Colors.black87)),

            const SizedBox(height: 10),

            LinearProgressIndicator(
              value: progressValue,
              minHeight: 7,
              color: const Color(0xFF1E3A8A),
              backgroundColor: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),

            const SizedBox(height: 6),
            Text(progressText, style: const TextStyle(color: Colors.black87)),

            const SizedBox(height: 6),
            Text(nextPayment, style: const TextStyle(color: Colors.blueGrey)),
          ],
        ),
      ),
    );
  }
}
