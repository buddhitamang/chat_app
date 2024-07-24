
import 'package:chat_app/pages/register_page.dart';
import 'package:flutter/cupertino.dart';

import '../../pages/login_page.dart';

class LoginOrRegisterPage extends StatefulWidget{
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  //initaially show the login page
  bool showLoginPage=true;

  //toogle between login and register page
  void tooglePages(){
    setState(() {
      showLoginPage=!showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(onTap:tooglePages);
    }else{
      return RegisterPage(onTap: tooglePages);
    }
  }
}