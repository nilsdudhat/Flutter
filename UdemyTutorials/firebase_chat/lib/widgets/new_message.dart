import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {

  final _messageController = TextEditingController();

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage
        .trim()
        .isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    final userId = FirebaseAuth.instance.currentUser!.uid;

    final userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get();

    FirebaseFirestore.instance.collection("chat").add({
      "message": enteredMessage,
      "createdAt": Timestamp.now(),
      "userId": userId,
      "userName": userData.data()!["UserName"],
      "userProfile": userData.data()!["Image"],
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 4, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: "Send a Message"),
            ),
          ),
          IconButton(
            color: Theme
                .of(context)
                .colorScheme
                .primary,
            onPressed: _submitMessage,
            icon: const Icon(Icons.send),
          )
        ],
      ),
    );
  }
}
