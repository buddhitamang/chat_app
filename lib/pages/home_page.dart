import 'package:chat_app/components/circle_compnent.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/auth/chat_service.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //instance of chat service
  final ChatService _chatService = ChatService();

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  final List people = [
    ['Admin', 'lib/assets/img1.JPG'],
    ['Hello', 'lib/assets/img2.jpg'],
    ['Buddhi', 'lib/assets/img3.jpg'],
    ['Test', 'lib/assets/img4.jpg'],
  ];

  @override
  void initState() {
    super.initState();
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
        //drawer color
        title: Text(
          'Chats',
          style: TextStyle(
              color: Theme.of(context).primaryTextTheme.headlineLarge?.color,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: signOut,
              child: Icon(
                Icons.logout_sharp,
                color: Colors.blue.shade600,
              ),
            ),
          )
        ],
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
            child: SizedBox(
              height: 35,
              child: TextField(
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).colorScheme.surface,
                    filled: true,
                    hintText: 'Search',
                    contentPadding: EdgeInsets.symmetric(vertical: 9),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )),
            ),
          ),
          Container(
            height: 110,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: people.length,
                itemBuilder: (context, index) {
                  return CircleCompnent(
                    text: people[index][0],
                    backgroundImage: people[index][1],
                  );
                }),
          ),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  //build a list of users except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
        stream: _chatService.getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  //build individual user list items
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    String emailPrefix = userData['email'].split('@')[0];

    //display all users except current user
    if (_auth.currentUser!.email != userData['email']) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
              Theme.of(context).primaryTextTheme.headlineMedium?.color,
              child: Text(
                userData['email'][0].toUpperCase(),
                style: TextStyle(
                    color: Theme.of(context)
                        .primaryTextTheme
                        .headlineLarge
                        ?.color),
              ),
            ),
            //       title: Text(userData['email']),  it shows the entire gmail
            title: Text(emailPrefix),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverUserEmail: userData['email'],
                    receiverUserID: userData['uid'],
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
