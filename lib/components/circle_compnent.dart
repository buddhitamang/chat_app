import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircleCompnent extends StatelessWidget {
  final String text;
  final String backgroundImage;
  const CircleCompnent({super.key, required this.text, required this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(backgroundImage),
          ),
          Text(text,style: TextStyle(color: Theme.of(context).primaryTextTheme.headlineLarge?.color),),
        ],
      ),
    );
  }
}
