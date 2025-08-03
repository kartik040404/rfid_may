// lib/ui/screens/dashboard_screens/dashboard_screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../RFIDPlugin.dart';
import '../../../services/local_storage_service.dart';
import '../../../services/pattern_service.dart';
import '../../../utils/date_format.dart';

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
    fontSize: 22,
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
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Color(0xFF8B0000),
  );
}

class DashboardScreen extends StatefulWidget {
  final String userName;

  const DashboardScreen({Key? key, this.userName = "User"}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // If you need to re-fetch on resume, call PatternService.fetchPatterns() here
  }

  @override
@override
Widget build(BuildContext context) {
  final allPatterns = PatternService.allPatterns;
  final totalCount = allPatterns.length;
  final registeredCount = allPatterns.where((p) => p.rfdId.isNotEmpty).length;
  final unregisteredCount = totalCount - registeredCount;

  return Scaffold(
    backgroundColor: DashboardTheme.lightGrey,
    // Add the RefreshIndicator here!
    body: RefreshIndicator(
      onRefresh: () async {
        await PatternService.fetchPatterns();
        // Make sure to update the UI after fetching
        setState(() {});
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // ensures scroll even if content is short
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            _buildStatisticsSection(
              totalCount,
              registeredCount,
              unregisteredCount,
            ),
            const SizedBox(height: 32),
            _buildRecentRegistrationsSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildHeaderSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [DashboardTheme.primaryRed, DashboardTheme.darkRed],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: DashboardTheme.primaryRed.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
                  "Welcome, ${widget.userName}",
                  style: DashboardTheme.headerStyle
                      .copyWith(fontSize: 16),
                ),
                const SizedBox(height: 4),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const Padding(
          padding: EdgeInsets.only(left: 70.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Text(
                "SHIROLI",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsSection(
      int totalCount, int registeredCount, int unregisteredCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Pattern Statistics",
              style: DashboardTheme.sectionTitleStyle),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TotalCard(
                  title: "Total Patterns",
                  value: totalCount.toString(),
                  icon: Icons.donut_large_outlined,
                  iconColor: DashboardTheme.primaryRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatsCard(
                  title: "Registered",
                  value: registeredCount.toString(),
                  icon: Icons.check_circle_outline,
                  iconColor: const Color(0xFF27AE60),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatsCard(
                  title: "Unregistered",
                  value: unregisteredCount.toString(),
                  icon: Icons.local_offer_outlined,
                  iconColor: DashboardTheme.darkRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRegistrationsSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: LocalStorageService.getRecentRegistrations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text("No recent registrations."),
          );
        }
        final registrations = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Recent Registrations"),
              const SizedBox(height: 12),
              Column(
                children: registrations.take(3).map((item) {
                  return LogCard(
                    title: "Pattern #${item['PatternCode']}",
                    subtitle: item['PatternName'] ?? "Unknown",
                    time: DateHelper.formatToDDMMYYYY(item['date']),
                    icon: Icons.add_circle_outline,
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: DashboardTheme.sectionTitleStyle),
      ],
    );
  }
}

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const StatsCard({
    Key? key,
    required this.title,
    required this.value,
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: DashboardTheme.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: DashboardTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TotalCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const TotalCard({
    Key? key,
    required this.title,
    required this.value,
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
            padding: const EdgeInsets.all(26),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: DashboardTheme.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        value,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: DashboardTheme.textPrimary,
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
        borderRadius: BorderRadius.circular(10),
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
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
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
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: DashboardTheme.textPrimary,
                            ),
                          ),
                          Text(
                            time,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: DashboardTheme.textSecondary,
                        ),
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
