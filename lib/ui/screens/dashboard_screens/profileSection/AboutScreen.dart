//-----------------------------AboutScreen shows company, mission, app info, and legal links-----------------------------//
import 'package:flutter/material.dart';
import '../../../widgets/custom_app_bar.dart';

//-----------------------------Main AboutScreen widget-----------------------------//
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
            //-----------------------------Company Info Section-----------------------------//
            _CompanyInfo(),
            SizedBox(height: 20),
            //-----------------------------Mission & Story Section-----------------------------//
            _MissionStory(),
            SizedBox(height: 20),
            //-----------------------------App Info Section-----------------------------//
            _AppInfo(),
            SizedBox(height: 20),
            //-----------------------------Legal Section-----------------------------//
            _LegalSection(),
            SizedBox(height: 20),
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

//-----------------------------Company Info Widget-----------------------------//
class _CompanyInfo extends StatelessWidget {
  const _CompanyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            child: ClipOval(
              child: Image.asset(
                'assets/Z.jpg',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Zanvar Group',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          //-----------------------------Tag Chip-----------------------------//
          const _TagChip(),
        ],
      ),
    );
  }
}

//-----------------------------Tag Chip Widget-----------------------------//
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

//-----------------------------Mission & Story Widget-----------------------------//
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 6),
          Text(
            'At Zanvar Group, we strive to revolutionize industrial operations through innovative technology solutions that enhance productivity, safety, and sustainability.',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              fontFamily: 'Poppins',
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Our Story',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Founded in 2020, Zanvar Group began with a vision to transform traditional industrial processes through digital innovation. What started as a small team of passionate engineers has grown into a leading provider of industrial management solutions across multiple sectors.',
            style: TextStyle(
              fontSize: 13,
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

//-----------------------------App Info Widget-----------------------------//
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 10),
          InfoRow(title: 'Version', value: '1.0.0'),
          SizedBox(height: 6),
          InfoRow(title: 'Beta Testing', value: 'January 2025'),
          SizedBox(height: 6),
          InfoRow(title: 'Platform', value: 'Android'),
          SizedBox(height: 6),
          InfoRow(title: 'Developer', value: 'DYPCET & Zanvar Tech Team'),
        ],
      ),
    );
  }
}

//-----------------------------Legal Section Widget-----------------------------//
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 10),
          //-----------------------------Legal Links-----------------------------//
          LegalLink(
            title: 'Terms of Service',
            onTap: () {
              // TODO: Navigate to Terms of Service
            },
          ),
          const SizedBox(height: 6),
          LegalLink(
            title: 'Privacy Policy',
            onTap: () {
              // TODO: Navigate to Privacy Policy
            },
          ),
          const SizedBox(height: 6),
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

//-----------------------------Reusable Info Row Widget-----------------------------//
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
            fontSize: 12,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

//-----------------------------Reusable Legal Link Widget-----------------------------//
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