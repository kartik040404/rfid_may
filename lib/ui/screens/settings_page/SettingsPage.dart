import 'package:flutter/material.dart';

import 'Notification.dart';
import 'ProfilePage.dart';
import 'RFIDsettingsPage.dart';

void main() {
  runApp(MaterialApp(
    home: SettingsPage(),
  ));
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile Management"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notification Preferences"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPreferencesPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.qr_code_scanner),
            title: Text("RFID Scanner Settings"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RFIDScannerSettingsPage()));
            },
          ),
        ],
      ),
    );
  }
}
