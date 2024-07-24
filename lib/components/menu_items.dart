import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MenuItems extends StatelessWidget {
  final String message;

  const MenuItems({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.emoji_emotions),
              title: Text('😊'),
            ),
            ListTile(
              leading: Icon(Icons.copy),
              title: Text('Copy'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: message));
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Unsend'),
              onTap: () {
                // Handle unsend action
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
