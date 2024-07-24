import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/services/auth/login_or_register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../pages/home_page.dart';

class AuthGate extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          //user is loged in
          if(snapshot.hasData){
            return MainPage();
          }

          //user in not looged in
          else{
            return LoginOrRegisterPage();
          }
        },
      ),
    );

  }

}