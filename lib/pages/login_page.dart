
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_text_field.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget{
  final void Function()? onTap;
  LoginPage({super.key,required this.onTap});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController=TextEditingController();

  final passwordController=TextEditingController();

  void signIn() async{
    final authService= Provider.of<AuthService>(context,listen: false);

    try{
      await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      // showDialog(
      //   context: context,
      //   builder: (context)=>const Center(
      //     child: CircularProgressIndicator(),
      //   ),);

    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      resizeToAvoidBottomInset: false,
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

                    //these two are basically the same
                    // Container(
                    //   width: 150,
                    //   height: 150,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(80),
                    //     image: DecorationImage(
                    //       image: AssetImage('lib/assets/mylogo.jpg'),
                    //     ),
                    //
                    //   ),
                    // ),
                    SizedBox(
                      height: 50,
                    ),
                    //welcome back messge
                    Text('Unlock the Magic – Sign In to See What’s New!',style: TextStyle(
                      fontSize: 16,color: Colors.blue,
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
                      height: 25,
                    ),
                    //sign in button
                    MyButton(
                      onTap: signIn,
                        text: "Login"),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Not a member?',style: TextStyle(color: Theme.of(context).primaryTextTheme.headlineLarge?.color,),),
                        SizedBox(width: 10,),
                        GestureDetector(
                          onTap: widget.onTap,
                            child: Text("Register now",
                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),)),
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