// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticeo/components/login_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLargeTextMode = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      _isLargeTextMode = mode == 'largePolice';
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double titlesize = _isLargeTextMode ? 20.h : 16.h;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Paramètres',
          style: TextStyle(fontSize: _isLargeTextMode ? 30.h : 22.h),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil', style: TextStyle(fontSize: titlesize)),
              onTap: () {
                // Navigate to Profile Page
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title:
                  Text('Notification', style: TextStyle(fontSize: titlesize)),
              onTap: () {
                // Navigate to Notification Settings
              },
            ),
            ListTile(
              leading: Icon(Icons.palette),
              title: Text('Apparance et thème',
                  style: TextStyle(fontSize: titlesize)),
              onTap: () {
                // Navigate to Appearance and Theme Settings
              },
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Termes et conditions',
                  style: TextStyle(fontSize: titlesize)),
              onTap: () {
                // Navigate to Terms and Conditions
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Aide et assistance',
                  style: TextStyle(fontSize: titlesize)),
              onTap: () {
                // Navigate to Help and Support
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('À propos', style: TextStyle(fontSize: titlesize)),
              onTap: () {
                // Navigate to About Page
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title:
                  Text('Se déconnecter', style: TextStyle(fontSize: titlesize)),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
