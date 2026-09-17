import 'package:flutter/material.dart';

import '../widgets/custom_text.dart';

// Enhancement 2: Chat screen — opened via FloatingActionButton (moved from bottom nav).
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [
    'Hello! How can we help you today?',
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add('You: $text');
      _messages.add('Support: Thanks for your message!');
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: const Color(0xFF4A4E69),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final isUser = _messages[index].startsWith('You:');
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.orange.shade100
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomText(
                      _messages[index],
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                  color: Colors.orange.shade700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
