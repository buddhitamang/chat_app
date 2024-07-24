import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../components/chat_bubble.dart';
import '../services/auth/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;

  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);
      _messageController.clear();
    }
  }

  void _showPopupMenu(BuildContext context, Offset position, String messageId, String message) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, 0),
      items: [
        PopupMenuItem(
          value: 'copy',
          child: Text('Copy'),
          onTap: () {
            Clipboard.setData(ClipboardData(text: message));
          },
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text('Delete'),
          onTap: () async {
            await _chatService.unsendMessage(widget.receiverUserID, messageId);
          },
        ),
        PopupMenuItem(
          value: 'edit',
          child: Text('Edit'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepPurpleAccent),
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(widget.receiverUserEmail),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: Row(
              children: [
                Icon(
                  Icons.videocam_outlined,
                  color: Colors.deepPurple,
                  size: 35,
                ),
                SizedBox(width: 15),
                Icon(
                  Icons.call,
                  color: Colors.deepPurple,
                  size: 25,
                ),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('lib/assets/img1.JPG'),
                    radius: 50,
                  ),
                  Text(
                    widget.receiverUserEmail,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Theme.of(context)
                          .primaryTextTheme
                          .headlineLarge
                          ?.color,
                    ),
                  ),
                  Text(
                    'You can now chat',
                    style: TextStyle(
                      color: Theme.of(context)
                          .primaryTextTheme
                          .headlineMedium
                          ?.color,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildMessageList(),
                ],
              ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('StreamBuilder Error: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          print('No messages found');
        }
        return Column(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    DateTime dateTime = data['timestamp'].toDate();
    String formattedTime = DateFormat('hh:mm a').format(dateTime);


    //color of chat
    Color bubbleColor = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Colors.purple // this is the Sender color
        : Colors.grey.shade700; // this isReceiver color

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment:
          (data['senderId'] == _firebaseAuth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onLongPressStart: (details) {
                _showPopupMenu(context, details.globalPosition, document.id, data['message']);
              },
              child: ChatBubble(message: data['message'], color: bubbleColor),
            ),
            Text(formattedTime,
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }


  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
      child: Row(
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.deepPurpleAccent),
              child: Icon(
                Icons.add,
                color: Colors.white,
              )),
          SizedBox(width: 12),
          Icon(Icons.camera_alt, color: Colors.deepPurpleAccent),
          SizedBox(width: 12),
          Icon(Icons.image, color: Colors.deepPurpleAccent),
          SizedBox(width: 12),
          Icon(Icons.mic, color: Colors.deepPurpleAccent),
          SizedBox(width: 12),
          Expanded(
              child: SizedBox(
                  height: 32,
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                        hintText: 'Aa',
                        suffixIcon: Icon(
                          Icons.emoji_emotions,
                          color: Colors.deepPurpleAccent,
                        ),
                        contentPadding: EdgeInsets.only(top: 8, left: 6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey))),
                  ))),
          IconButton(
              onPressed: sendMessage,
              icon: Icon(
                Icons.arrow_circle_right_rounded,
                color: Colors.purple,
                size: 40,
              ))
        ],
      ),
    );
  }
}
