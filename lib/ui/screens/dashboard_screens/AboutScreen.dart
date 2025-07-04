import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const CustomAppBar(title: 'About Us'),
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CompanyInfo(),
            SizedBox(height: 30),
            _MissionStory(),
            SizedBox(height: 24),
            _AppInfo(),
            SizedBox(height: 24),
            _LegalSection(),
            SizedBox(height: 30),
            Center(
              child: Text(
                '© 2025 Zanvar Group. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _CompanyInfo extends StatelessWidget {
  const _CompanyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20), // 0.08 * 255 ≈ 20
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.business,
              size: 60,
              color: Colors.teal[700],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Zanvar Group',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          const _TagChip(),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.teal.withAlpha(25), // 0.1 * 255 ≈ 25
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Est. 2020',
        style: TextStyle(
          color: Colors.teal[700],
          fontSize: 14,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}

class _MissionStory extends StatelessWidget {
  const _MissionStory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13), // 0.05 * 255 ≈ 13
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Mission',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 10),
          Text(
            'At Zanvar Group, we strive to revolutionize industrial operations through innovative technology solutions that enhance productivity, safety, and sustainability.',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              fontFamily: 'Poppins',
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Our Story',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Founded in 2020, Zanvar Group began with a vision to transform traditional industrial processes through digital innovation. What started as a small team of passionate engineers has grown into a leading provider of industrial management solutions across multiple sectors.',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              fontFamily: 'Poppins',
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppInfo extends StatelessWidget {
  const _AppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'App Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 16),
          InfoRow(title: 'Version', value: '1.0.0'),
          SizedBox(height: 8),
          InfoRow(title: 'Beta Testing', value: 'January 2025'),
          SizedBox(height: 8),
          InfoRow(title: 'Platform', value: 'Android'),
          SizedBox(height: 8),
          InfoRow(title: 'Developer', value: 'DYPCET & Zanvar Tech Team'),
        ],
      ),
    );
  }
}

class _LegalSection extends StatelessWidget {
  const _LegalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Legal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          LegalLink(
            title: 'Terms of Service',
            onTap: () {
              // TODO: Navigate to Terms of Service
            },
          ),
          const SizedBox(height: 12),
          LegalLink(
            title: 'Privacy Policy',
            onTap: () {
              // TODO: Navigate to Privacy Policy
            },
          ),
          const SizedBox(height: 12),
          LegalLink(
            title: 'Licenses',
            onTap: () {
              // TODO: Navigate to Licenses
            },
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$title: ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

class LegalLink extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const LegalLink({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.teal[700],
                fontFamily: 'Poppins',
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.teal[700]),
          ],
        ),
      ),
    );
  }
}