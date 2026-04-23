import 'package:flutter/material.dart';
import 'lender_detail.dart';
import 'lender_profile.dart';
import 'tracking_history.dart'; // ✅ use your new screen

class LenderDashboardScreen extends StatefulWidget {
  final String lenderName;
  final String email;
  final String phone;
  final String investmentCapacity;
  final String riskAppetite;

  const LenderDashboardScreen({
    super.key,
    required this.lenderName,
    required this.email,
    required this.phone,
    required this.investmentCapacity,
    required this.riskAppetite,
  });

  @override
  State<LenderDashboardScreen> createState() => _LenderDashboardScreenState();
}

class _LenderDashboardScreenState extends State<LenderDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  int _selectedIndex = 0;

  final borrowers = [
    {
      "name": "Ali Khan",
      "city": "Karachi",
      "amount": "PKR 500,000",
      "rate": "14.5%",
      "risk": "Low Risk",
      "term": "36 months",
      "type": "Salaried",
    },
    {
      "name": "Ahmed Raza",
      "city": "Lahore",
      "amount": "PKR 300,000",
      "rate": "16.8%",
      "risk": "Medium Risk",
      "term": "24 months",
      "type": "Self-employed",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredBorrowers = borrowers.where((b) {
      final query = _searchQuery.toLowerCase();
      return b["name"]!.toLowerCase().contains(query) ||
          b["city"]!.toLowerCase().contains(query) ||
          b["type"]!.toLowerCase().contains(query);
    }).toList();

    Widget bodyContent;
    PreferredSizeWidget? appBar;

    switch (_selectedIndex) {
      case 0:
        // Loans tab → show AppBar
        appBar = AppBar(
          title: const Text("Lender Dashboard"),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LenderProfileScreen(
                      name: widget.lenderName,
                      email: widget.email,
                      phone: widget.phone,
                      investmentCapacity: widget.investmentCapacity,
                      riskAppetite: widget.riskAppetite,
                    ),
                  ),
                );
              },
            ),
          ],
        );
        bodyContent = Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search borrowers...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Loan Applications",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.filter_list),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredBorrowers.length,
                itemBuilder: (context, index) {
                  final b = filteredBorrowers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      title: Text(b["name"]!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(b["city"]!),
                          Text(
                            "${b["amount"]} • ${b["rate"]} • ${b["risk"]} • ${b["term"]}",
                          ),
                          Text(b["type"]!),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LenderDetailScreen(
                              borrowerName: b["name"]!,
                              city: b["city"]!,
                              type: b["type"]!,
                              loanAmount: b["amount"]!,
                              interestRate: b["rate"]!,
                              riskLevel: b["risk"]!,
                              term: b["term"]!,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
        break;

      case 1:
        // ✅ Tracking tab → open TrackingHistoryScreen
        appBar = null;
        bodyContent = const TrackingHistoryScreen();
        break;

      case 2:
        // Profile tab → no AppBar
        appBar = null;
        bodyContent = LenderProfileScreen(
          name: widget.lenderName,
          email: widget.email,
          phone: widget.phone,
          investmentCapacity: widget.investmentCapacity,
          riskAppetite: widget.riskAppetite,
        );
        break;

      default:
        appBar = null;
        bodyContent = const SizedBox();
    }

    return Scaffold(
      appBar: appBar,
      body: bodyContent,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Loans"),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: "Tracking",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
