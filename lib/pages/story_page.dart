import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_service.dart';
import '../themes/theme.dart';
import '../themes/theme_provider.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  // Instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  void initState() {
    super.initState();
    // Load the theme when the StoryPage is initialized
    Provider.of<ThemeProvider>(context, listen: false).loadTheme();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool _isSwitched = themeProvider.themeData == darkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue.shade600),
        title: Text(
          'Stories',
          style: TextStyle(
            color: Theme.of(context).primaryTextTheme.headlineLarge?.color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryTextTheme.headlineSmall?.color,
              ),
              child: Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('lib/assets/img1.JPG'),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Handle home tap
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle settings tap
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_page),
              title: Text('Contact'),
              onTap: () {
                // Handle contact tap
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(themeProvider.themeData == darkMode
                  ? Icons.dark_mode
                  : Icons.light_mode),
              title: Text(themeProvider.themeData == darkMode
                  ? 'Dark Mode'
                  : 'Light Mode'),
              trailing: Switch(
                value: _isSwitched,
                activeColor: themeProvider.themeData == darkMode ? Colors.white : Colors.black,
                onChanged: (bool value) {
                  setState(() {
                    _isSwitched = value;
                  });
                  themeProvider.toggleTheme();
                  themeProvider.saveTheme();
                },
              ),
              onTap: () {
                // Handle contact tap
                Navigator.pop(context);
              },
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log out'),
                onTap: signOut, // Call the sign-out function
              ),
            ),
          ],
        ),
      ),
    );
  }
}
