import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';
import '../services/chat_service.dart';

class ChatDetailScreen extends StatefulWidget {
  final String otherUserId;
  final String otherUserEmail;
  final String otherUserName;

  const ChatDetailScreen({
    super.key,
    required this.otherUserId,
    required this.otherUserEmail,
    required this.otherUserName,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  late final Stream<List<MessageModel>>? _messages;
  String? _streamError;
  bool _isSending = false;
  int _lastMessageCount = -1;

  @override
  void initState() {
    super.initState();
    try {
      _messages = _chatService.getMessages(widget.otherUserId);
    } catch (error) {
      _messages = null;
      _streamError = error.toString();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _inputFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;
    if (FirebaseAuth.instance.currentUser?.uid == widget.otherUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You cannot send a message to yourself.')),
      );
      return;
    }

    setState(() => _isSending = true);
    try {
      await _chatService.sendMessage(
        receiverId: widget.otherUserId,
        message: text,
      );
      _messageController.clear();
      _inputFocusNode.requestFocus();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Message failed to send: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  String _formatTime(Timestamp timestamp) {
    final time = timestamp.toDate().toLocal();
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${time.hour >= 12 ? 'PM' : 'AM'}';
  }

  void _scrollToNewest(int count) {
    if (count == _lastMessageCount) return;
    _lastMessageCount = count;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.otherUserName),
            if (widget.otherUserEmail.isNotEmpty)
              Text(
                widget.otherUserEmail,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _streamError != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(_streamError!, textAlign: TextAlign.center),
                    ),
                  )
                : StreamBuilder<List<MessageModel>>(
                    stream: _messages,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'Could not load messages. Check your Firestore access.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final messages = snapshot.data!;
                      _scrollToNewest(messages.length);
                      if (messages.isEmpty) {
                        return const Center(
                          child: Text('Start the conversation.'),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMine = message.senderId == currentUid;
                          final bubbleColor = isMine
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceContainerHighest;
                          final textColor = isMine
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface;

                          return TweenAnimationBuilder<double>(
                            key: ValueKey(
                              '${message.timestamp.millisecondsSinceEpoch}-$index',
                            ),
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 240),
                            curve: Curves.easeOut,
                            builder: (context, progress, child) => Opacity(
                              opacity: progress,
                              child: Transform.translate(
                                offset: Offset(0, 10 * (1 - progress)),
                                child: child,
                              ),
                            ),
                            child: Align(
                              alignment: isMine
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.sizeOf(context).width * 0.78,
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.fromLTRB(
                                    14,
                                    10,
                                    12,
                                    7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: bubbleColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(16),
                                      topRight: const Radius.circular(16),
                                      bottomLeft: Radius.circular(
                                        isMine ? 16 : 4,
                                      ),
                                      bottomRight: Radius.circular(
                                        isMine ? 4 : 16,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          message.message,
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _formatTime(message.timestamp),
                                            style: TextStyle(
                                              color: textColor.withValues(
                                                alpha: 0.72,
                                              ),
                                              fontSize: 10,
                                            ),
                                          ),
                                          if (isMine) ...[
                                            const SizedBox(width: 4),
                                            Icon(
                                              Icons.done,
                                              size: 13,
                                              color: textColor.withValues(
                                                alpha: 0.78,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _inputFocusNode,
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Write a message',
                        filled: true,
                        fillColor: theme.cardColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton.filled(
                      tooltip: _isSending ? 'Sending' : 'Send message',
                      onPressed: _isSending ? null : _sendMessage,
                      icon: _isSending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isSending)
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text('Sending...', style: TextStyle(fontSize: 11)),
            ),
        ],
      ),
    );
  }
}
