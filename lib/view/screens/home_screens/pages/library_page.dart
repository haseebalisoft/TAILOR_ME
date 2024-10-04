import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tailer_app/view/auth/login_screen.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Color(0xFF2a87ef),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                        'assets/library_icon.png'), // Replace with an appropriate image
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Store COlllection',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '1000 + Item',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Color(0xFF2a87ef)),
                    onPressed: () {
                      // Handle edit library details action
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            SizedBox(height: 20),
           
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            // Options List
            Expanded(
              child: ListView(
                children: [
                  buildListTile(Icons.notifications, 'Notifications', () {}),
                  buildListTile(
                      Icons.account_circle, 'Account Settings', () {}),
                  buildListTile(Icons.security, 'Privacy & Security', () {}),
                  buildListTile(Icons.language, 'Language', () {}),
                  buildListTile(Icons.help, 'Help & Support', () {}),
                ],
              ),
            ),
            // Logout Button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle logout action
                  Get.offAll(() => LoginScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2a87ef),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Logout', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build each action button
  Widget buildActionButton(String text, IconData icon) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          // Handle button action
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Color(0xFF2a87ef),
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Color(0xFF2a87ef)),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: Color(0xFF2a87ef)),
            SizedBox(height: 8),
            Text(text, style: TextStyle(color: Color(0xFF2a87ef))),
          ],
        ),
      ),
    );
  }

  // Widget to build each list tile in the options list
  Widget buildListTile(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF2a87ef)),
      title: Text(text),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
