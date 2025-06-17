
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


// Enhanced theme data matching the actual design
class DashboardTheme {
  static const Color primaryRed = Color(0xFFDC143C);
  static const Color darkRed = Color(0xFF8B0000);
  static const Color lightGrey = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF95A5A6);
  static const Color iconBackground = Color(0xFFFFEBEE);

  static const TextStyle appBarTitleStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle headerStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle subHeaderStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    color: Colors.white70,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle sectionTitleStyle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xFF8B0000),
  );
}

class DashboardContent extends StatelessWidget {
  final String userName;

  const DashboardContent({Key? key, this.userName = "User"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardTheme.lightGrey,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 24),
            _buildStatisticsSection(),
            const SizedBox(height: 32),
            _buildRecentScansSection(),
            const SizedBox(height: 24),
            _buildRecentRegistrationsSection(),
            const SizedBox(height: 100), // Bottom padding for navigation
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [DashboardTheme.primaryRed, DashboardTheme.darkRed],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: DashboardTheme.primaryRed.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome, $userName",
                  style: DashboardTheme.headerStyle,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Pattern Management System",
                  style: DashboardTheme.subHeaderStyle,
                ),
              ],
            ),
          ),
          _buildConnectionStatus(),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi, color: Colors.green, size: 18),
          SizedBox(width: 8),
          Text(
            "RFID Connected",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pattern Statistics",
            style: DashboardTheme.sectionTitleStyle,
          ),
          const SizedBox(height: 16),
          // Fixed GridView with proper aspect ratio and layout
          LayoutBuilder(
            builder: (context, constraints) {
              return GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // Increased aspect ratio to prevent overflow
                childAspectRatio: 1.25, // Changed from 1.1 to 1.25
                children: const [
                  StatsCard(
                    title: "Total Patterns",
                    value: "1,250",
                    trend: "+12% this month",
                    icon: Icons.donut_large_outlined,
                    iconColor: DashboardTheme.primaryRed,
                  ),
                  StatsCard(
                    title: "Available",
                    value: "1,240",
                    trend: "Ready to use",
                    icon: Icons.check_circle_outline,
                    iconColor: Color(0xFF27AE60),
                  ),
                  StatsCard(
                    title: "Pending",
                    value: "5",
                    trend: "Needs approval",
                    icon: Icons.schedule_outlined,
                    iconColor: Color(0xFFFF6B35),
                  ),
                  StatsCard(
                    title: "Tagged Items",
                    value: "832",
                    trend: "RFID enabled",
                    icon: Icons.local_offer_outlined,
                    iconColor: DashboardTheme.darkRed,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentScansSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildSectionHeader("Recent Scans", onViewAll: () {}),
          const SizedBox(height: 12),
          const Column(
            children: [
              LogCard(
                title: "Pattern #12345",
                subtitle: "Manufacturing Line A",
                time: "2 hrs ago",
                icon: Icons.inventory_2_outlined,
              ),
              LogCard(
                title: "Pattern #67890",
                subtitle: "Quality Control",
                time: "4 hrs ago",
                icon: Icons.inventory_2_outlined,
              ),
              LogCard(
                title: "Pattern #12233",
                subtitle: "Assembly Line",
                time: "8 hrs ago",
                icon: Icons.inventory_2_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRegistrationsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildSectionHeader("Recent Registrations", onViewAll: () {}),
          const SizedBox(height: 12),
          const Column(
            children: [
              LogCard(
                title: "Pattern #12900",
                subtitle: "Registered by Admin",
                time: "Today",
                icon: Icons.add_circle_outline,
              ),
              LogCard(
                title: "Pattern #12899",
                subtitle: "Registered by Operator",
                time: "1 day ago",
                icon: Icons.add_circle_outline,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: DashboardTheme.sectionTitleStyle),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              "View All",
              style: TextStyle(
                fontFamily: 'Poppins',
                color: DashboardTheme.primaryRed,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String trend;
  final IconData icon;
  final Color iconColor;

  const StatsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.trend,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DashboardTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16), // Reduced from 20 to 16
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Added this
              children: [
                Container(
                  padding: const EdgeInsets.all(10), // Reduced from 12 to 10
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22), // Reduced from 24 to 22
                ),
                const SizedBox(height: 12), // Reduced from 16 to 12
                Flexible( // Added Flexible widget
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13, // Reduced from 14 to 13
                          fontWeight: FontWeight.w500,
                          color: DashboardTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6), // Reduced from 8 to 6
                      Text(
                        value,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24, // Reduced from 28 to 24
                          fontWeight: FontWeight.bold,
                          color: DashboardTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3), // Reduced from 4 to 3
                      Text(
                        trend,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11, // Reduced from 12 to 11
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LogCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;

  const LogCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: DashboardTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: DashboardTheme.iconBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: DashboardTheme.primaryRed,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: DashboardTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: DashboardTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



