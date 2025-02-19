import 'package:flutter/material.dart';

import '../register.dart';
import '../results_screen.dart';
import '../settings_page/SettingsPage.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PatternTrackRFID",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/profile.jpg"), // Profile image
          ),
          const SizedBox(width: 15),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF1E1E1E)),
              child: Text(
                "Menu",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text(
                "Dashboard",
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()), // Navigate to SettingsPage
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.document_scanner_sharp),
              title: const Text(
                "Scan Pattern",
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()), // Navigate to SettingsPage
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.app_registration_outlined),
              title: const Text(
                "Register Pattern",
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPatternPage()), // Navigate to SettingsPage
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(
                "Settings",
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()), // Navigate to SettingsPage
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  Text(
                    "Dashboard",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Quick overview of your inventory",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.8,
              children: const [
                _DashboardCard(title: "Total Patterns", value: "1,250"),
                _DashboardCard(title: "Inward Logs", value: "320"),
                _DashboardCard(title: "Outward Logs", value: "275"),
                _DashboardCard(title: "Alerts", value: "5"),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Recent Logs",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  _RecentLogCard(
                    title: "Pattern #12345 - Inward",
                    time: "2 hours ago",
                  ),
                  _RecentLogCard(
                    title: "Pattern #67890 - Outward",
                    time: "4 hours ago",
                  ),
                  _RecentLogCard(
                    title: "Pattern #11223 - Inward",
                    time: "6 hours ago",
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

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  const _DashboardCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentLogCard extends StatelessWidget {
  final String title;
  final String time;
  const _RecentLogCard({required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
          ),
        ),
        trailing: Text(
          time,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
