import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profile"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          // Profile Picture
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/user.svg"), // Change as needed
          ),
          SizedBox(height: 10),

          // User Name
          Text(
            "Johan Smith", // Replace with dynamic user data
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),

          // Email or Other Info
          Text(
            "johansmith@example.com", // Example email
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 20),

          // Options List
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                _profileOption(Icons.lock, "Change Password", context, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                  );
                }),
                _profileOption(Icons.logout, "Logout", context, () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for list items
  Widget _profileOption(IconData icon, String title, BuildContext context, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}

// Change Password Page
class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController oldPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to Profile Page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Old Password"),
            ),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "New Password"),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Confirm Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement password change logic
              },
              child: Text("Update Password"),
            ),
          ],
        ),
      ),
    );
  }
}
