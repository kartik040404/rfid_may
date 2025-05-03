// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:rfid_project/ui/screens/settings_page/ProfilePage.dart';
// import '../register.dart';
// import '../results_screen.dart';
// import '../settings_page/SettingsPage.dart';
//
// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "PatternTrackRFID",
//           style: TextStyle(
//             fontFamily: 'Poppins',
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         // actions: [
//         //   CircleAvatar(
//         //     backgroundColor: Colors.transparent,
//         //     child: SvgPicture.asset(
//         //       "assets/user.svg",
//         //       width: 40,
//         //       height: 40,
//         //     ),
//         //   ),
//         //   const SizedBox(width: 15),
//         // ],
//
//         actions: [
//           GestureDetector(
//             onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ProfilePage(), // Navigate to ProfileScreen
//               ),
//             );
//           },
//             child: CircleAvatar(
//               backgroundColor: Colors.transparent,
//               child: SvgPicture.asset(
//                 "assets/user.svg",
//                 width: 40,
//                 height: 40,
//               ),
//             ),
//           ),
//           const SizedBox(width: 15),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(color: Colors.black),
//               child: Text(
//                 "Menu",
//                 style: TextStyle(
//                   fontFamily: 'Poppins',
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.dashboard),
//               title: const Text(
//                 "Dashboard",
//                 style: TextStyle(fontFamily: 'Poppins'),
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => DashboardScreen()), // Navigate to SettingsPage
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.document_scanner_sharp),
//               title: const Text(
//                 "Scan Pattern",
//                 style: TextStyle(fontFamily: 'Poppins'),
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomePage()), // Navigate to SettingsPage
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.app_registration_outlined),
//               title: const Text(
//                 "Register Pattern",
//                 style: TextStyle(fontFamily: 'Poppins'),
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => RegisterPatternPage()), // Navigate to SettingsPage
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text(
//                 "Settings",
//                 style: TextStyle(fontFamily: 'Poppins'),
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SettingsPage()), // Navigate to SettingsPage
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Center(
//               child: Column(
//                 children: [
//                   Text(
//                     "Dashboard",
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     "Quick overview of your inventory",
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 16,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             GridView.count(
//               crossAxisCount: 2,
//               shrinkWrap: true,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//               childAspectRatio: 1.8,
//               children: const [
//                 _DashboardCard(title: "Total Patterns", value: "1,250"),
//                 _DashboardCard(title: "Inward Logs", value: "320"),
//                 _DashboardCard(title: "Outward Logs", value: "275"),
//                 _DashboardCard(title: "Alerts", value: "5"),
//               ],
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "Recent Logs",
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: ListView(
//                 children: const [
//                   _RecentLogCard(
//                     title: "Pattern #12345 - Inward",
//                     time: "2 hours ago",
//                   ),
//                   _RecentLogCard(
//                     title: "Pattern #67890 - Outward",
//                     time: "4 hours ago",
//                   ),
//                   _RecentLogCard(
//                     title: "Pattern #11223 - Inward",
//                     time: "6 hours ago",
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _DashboardCard extends StatelessWidget {
//   final String title;
//   final String value;
//   const _DashboardCard({required this.title, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 16,
//                 color: Colors.black54,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 5),
//             Text(
//               value,
//               style: const TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _RecentLogCard extends StatelessWidget {
//   final String title;
//   final String time;
//   const _RecentLogCard({required this.title, required this.time});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: ListTile(
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontFamily: 'Poppins',
//             fontSize: 16,
//           ),
//         ),
//         trailing: Text(
//           time,
//           style: const TextStyle(
//             fontFamily: 'Poppins',
//             color: Colors.grey,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rfid_project/ui/screens/settings_page/ProfilePage.dart';
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: SvgPicture.asset(
                "assets/user.svg",
                width: 40,
                height: 40,
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
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
              title: const Text("Dashboard", style: TextStyle(fontFamily: 'Poppins')),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.document_scanner_sharp),
              title: const Text("Scan Pattern", style: TextStyle(fontFamily: 'Poppins')),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),
            ),
            ListTile(
              leading: const Icon(Icons.app_registration_outlined),
              title: const Text("Register Pattern", style: TextStyle(fontFamily: 'Poppins')),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPatternPage())),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings", style: TextStyle(fontFamily: 'Poppins')),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())),
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
              children: [
                _DashboardCard(title: "Total Patterns", value: "1,250", isNavigable: true),
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
                  _RecentLogCard(title: "Pattern #12345 - Inward", time: "2 hours ago"),
                  _RecentLogCard(title: "Pattern #67890 - Outward", time: "4 hours ago"),
                  _RecentLogCard(title: "Pattern #11223 - Inward", time: "6 hours ago"),
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
  final bool isNavigable;

  const _DashboardCard({
    required this.title,
    required this.value,
    this.isNavigable = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isNavigable) {
          List<Map<String, String>> patterns = [
            {"id": "#12345", "name": "Pattern A"},
            {"id": "#67890", "name": "Pattern B"},
            {"id": "#11223", "name": "Pattern C"},
            {"id": "#44556", "name": "Pattern D"},
            {"id": "#78901", "name": "Pattern E"},
          ];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatternsScreen(
                patterns: [
                  {"id": "001", "name": "Pattern A", "date": "2024-03-28", "location": "Warehouse 1", "status": "Active", "shelfLife": 80},
                  {"id": "002", "name": "Pattern B", "date": "2024-03-27", "location": "Warehouse 2", "status": "Inactive", "shelfLife": 45},
                  {"id": "003", "name": "Pattern C", "date": "2024-03-26", "location": "Warehouse 3", "status": "Active", "shelfLife": null}, // No shelf life (Defaults to 0)
                ],
              ),
            ),
          );


        }
      },
      child: Card(
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
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
        ),
        trailing: Text(
          time,
          style: const TextStyle(fontFamily: 'Poppins', color: Colors.grey),
        ),
      ),
    );
  }
}




class PatternsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> patterns;

  const PatternsScreen({Key? key, required this.patterns}) : super(key: key);

  @override
  _PatternsScreenState createState() => _PatternsScreenState();
}

class _PatternsScreenState extends State<PatternsScreen> {
  String? expandedPatternId; // Track expanded card

  void toggleCard(String id) {
    setState(() {
      expandedPatternId = (expandedPatternId == id) ? null : id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Patterns List",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: widget.patterns.length,
          itemBuilder: (context, index) {
            final pattern = widget.patterns[index];
            final isExpanded = expandedPatternId == pattern["id"];

            // ✅ Fix: Ensure `shelfLife` is always a `double`
            final double shelfLife = (pattern["shelfLife"] ?? 0).toDouble();

            // Color Indicator
            Color shelfLifeColor;
            if (shelfLife > 50) {
              shelfLifeColor = Colors.green;
            } else if (shelfLife > 20) {
              shelfLifeColor = Colors.orange;
            } else {
              shelfLifeColor = Colors.red;
            }

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      pattern["name"]!,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ID: ${pattern["id"]}",
                          style: const TextStyle(fontFamily: 'Poppins', color: Colors.grey),
                        ),
                        Row(
                          children: [
                            Text(
                              "Shelf Life: $shelfLife%", // Safe to use now
                              style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: shelfLifeColor),
                            ),
                            const SizedBox(width: 5),
                            Icon(Icons.circle, color: shelfLifeColor, size: 12), // Indicator Dot
                          ],
                        ),
                      ],
                    ),
                    trailing: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    onTap: () => toggleCard(pattern["id"]!), // Expand card
                  ),

                  // Expanded Details
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "📅 Date Added: ${pattern["date"]}",
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "📍 Location: ${pattern["location"]}",
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text(
                                "🔍 Status: ",
                                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                              ),
                              Text(
                                pattern["status"],
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: pattern["status"] == "Active" ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text(
                                "🛠 Shelf Life: ",
                                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                              ),
                              Text(
                                "$shelfLife%",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: shelfLifeColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

