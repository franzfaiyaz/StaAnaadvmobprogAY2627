import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

// Enhancement 2: Chat FloatingActionButton (moved from bottom navigation).
class ChatFab extends StatelessWidget {
  const ChatFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChatScreen()),
        );
      },
      backgroundColor: const Color(0xFF4A4E69),
      child: const Icon(Icons.chat),
    );
  }
}
