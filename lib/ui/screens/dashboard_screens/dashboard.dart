
import 'package:flutter/material.dart';
import '../../../RFIDPlugin.dart';
import '../../widgets/BottomNaviagtionBar.dart';

// class MainScreen extends StatefulWidget {
//    MainScreen({Key? key}) : super(key: key);
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _initializeRFID();
//   }
//
//   Future<void> _initializeRFID() async {
//     await RFIDPlugin.initRFID();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       body: DashboardContent(), // Change to any other screen you want
//     );
//   }
// }

class DashboardContent extends StatelessWidget {
  final String userName;

  const DashboardContent({Key? key, this.userName = "User"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome, $userName!",
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _DashboardCard(title: "Total Patterns", value: "1250"),
               _DashboardCard(title: "Available Patterns", value: "1240"),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            "Recent Scans",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(),
          _RecentLogCard(title: "#12345", time: "2 hrs ago"),
          _RecentLogCard(title: "#67890", time: "4 hrs ago"),
          _RecentLogCard(title: "#12233", time: "8 hrs ago"),
          const SizedBox(height: 20),
          const Text(
            "Recent Registrations",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(),
          _RecentLogCard(title: "#12900", time: "Today"),
          _RecentLogCard(title: "#12899", time: "1 day ago"),
          const SizedBox(height: 20),
          const Text(
            "RFID Status: Connected",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}


class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;

   _DashboardCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 150,
        height: 100,
        padding:  EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style:  TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            //  SizedBox(height: 5),
            Text(
              value,
              style:  TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
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
   _RecentLogCard({required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          title,
          style:  TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
        trailing: Text(
          time,
          style:  TextStyle(fontFamily: 'Poppins', color: Colors.grey),
        ),
      ),
    );
  }
}



