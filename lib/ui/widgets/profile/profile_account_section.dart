import 'package:flutter/material.dart';
import './account_option_tile.dart';
import './logout_button.dart'; 

class ProfileAccountSection extends StatelessWidget {
  const ProfileAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        AccountOptionTile(
          title: 'Support',
          icon: Icons.help_outline,
          color: Colors.blue,
          onTap: () {
            Navigator.pushNamed(context, '/support');
          },
        ),
        const SizedBox(height: 12),
        AccountOptionTile(
          title: 'About',
          icon: Icons.info_outline,
          color: Colors.teal,
          onTap: () {
            Navigator.pushNamed(context, '/about');
          },
        ),
        const SizedBox(height: 20),
        const LogoutButton(),
      ],
    );
  }
}
