
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_service.dart';
import '../services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget{
  final void Function()? onTap;
  const RegisterPage({super.key, this.onTap});


  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  void signUp() async{
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("password do not match")
          ));
    }

    //get the auth services
    final authService= Provider.of<AuthService>(context,listen: false);
    try{
       await authService.signUpWithEmailAndPassword(emailController.text, passwordController.text);


    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()))
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                //logo
                CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('lib/assets/mylogo.jpg'),
                ),
                SizedBox(
                  height: 50,
                ),
                //welcome back messge
                Text('Ready to Get Started? Sign Up and Dive In!',style: TextStyle(
                  fontSize: 16,color: Colors.blue
                ),),
                SizedBox(
                  height: 25,
                ),

                //email textfield
                MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obsecureText: false),
                SizedBox(
                  height: 10,
                ),
                //password field
                MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obsecureText: true),
                SizedBox(
                  height: 10,
                ),

                //Confiem password
                MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Password",
                    obsecureText: true),
                SizedBox(
                  height: 25,
                ),

                //sign in button
                MyButton(
                    onTap: signUp,
                    text: "SignUp"),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?',style: TextStyle(color: Theme.of(context).primaryTextTheme.headlineLarge?.color),),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: widget.onTap,
                        child: Text("Login now",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),)),
                  ],
                )

                //not a member ? register now
              ],
            ),
          ),
        ),
      ),

    );
  }
}