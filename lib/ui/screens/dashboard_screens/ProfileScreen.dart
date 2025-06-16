// import 'package:flutter/material.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//   @override
//   State<ProfileScreen> createState() =>
//       _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   String name = 'John Doe';
//   String email = 'johndoe@example.com';
//   bool isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         elevation: 0,
//         // backgroundColor: Colors.white,
//         title: const Text(
//           'Profile',
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         child: Column(
//           children: [
//             // Header Section with Avatar
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 30),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade100,
//               ),
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//                     backgroundColor: Colors.blue.shade100,
//                     child: Icon(
//                       Icons.person,
//                       size: 60,
//                       color: Colors.blue.shade600,
//                     ),
//                   ),
//                   const SizedBox(height: 15),
//                   Text(
//                     name,
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     email,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey.shade700,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Options Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Column(
//                 children: [
//                   _profileOptionCard(
//                     text: 'Edit Profile',
//                     icon: Icons.edit_outlined,
//                     onTap: () {
//                       // Navigator.of(context).push(
//                       //   MaterialPageRoute(
//                       //     builder: (context) => const EditProfileScreen(),
//                       //   ),
//                       // );
//                     },
//                   ),
//                   const SizedBox(height: 15),
//                   _profileOptionCard(
//                     text: 'Privacy Settings',
//                     icon: Icons.privacy_tip_outlined,
//                     onTap: () {
//                       // Navigator.of(context).push(
//                       //   MaterialPageRoute(
//                       //     builder: (context) =>
//                       //     const PrivacySettingsScreen(),
//                       //   ),
//                       // );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//
//             // Logout Button
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: _logoutButton(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _profileOptionCard({
//     required String text,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 8,
//               spreadRadius: 2,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: Colors.blue.shade600, size: 28),
//             const SizedBox(width: 20),
//             Text(
//               text,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black87,
//               ),
//             ),
//             const Spacer(),
//             Icon(Icons.arrow_forward_ios,
//                 color: Colors.grey.shade500, size: 18),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _logoutButton(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Placeholder logout action
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Logout clicked"),
//           ),
//         );
//         // You can navigate to login screen here if needed
//       },
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//         decoration: BoxDecoration(
//           color: Colors.red.shade50,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: Colors.red.shade100,
//             width: 1.5,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.red.shade100,
//               blurRadius: 8,
//               spreadRadius: 2,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Icon(Icons.exit_to_app, color: Colors.red.shade600, size: 28),
//             const SizedBox(width: 20),
//             Text(
//               'Log Out',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.red.shade600,
//               ),
//             ),
//             const Spacer(),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../../widgets/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'John Doe';
  String email = 'johndoe@example.com';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 60, color: Colors.red.shade600),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    // const SizedBox(height: 2),
                    Text(
                      email,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Option Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _optionCard(
                    icon: Icons.edit_outlined,
                    label: 'Edit Profile',
                    onTap: () {},
                  ),
                  const SizedBox(height: 15),
                  _optionCard(
                    icon: Icons.lock_outline,
                    label: 'Privacy Settings',
                    onTap: () {},
                  ),
                  const SizedBox(height: 15),
                  _optionCard(
                    icon: Icons.settings_outlined,
                    label: 'App Settings',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _logoutButton(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _optionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.red.shade600, size: 26),
            const SizedBox(width: 18),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logged out")),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.red.shade600),
            const SizedBox(width: 10),
            Text(
              'Log Out',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

