import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/chat_service.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ChatService _chatService = ChatService();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _displayName(Map<String, dynamic> user) {
    final fullName = [user['firstName'], user['lastName']]
        .where((value) => value != null && value.toString().trim().isNotEmpty)
        .join(' ')
        .trim();
    return fullName.isNotEmpty
        ? fullName
        : (user['name'] ?? user['username'] ?? user['email'] ?? 'User')
              .toString();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: currentUser == null
          ? const Center(child: Text('Sign in with Firebase to view users.'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search by name or email',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Clear search',
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                              icon: const Icon(Icons.close),
                            ),
                      filled: true,
                      fillColor: theme.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _chatService.getUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'Could not load users. Check your connection and Firestore access.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final query = _searchQuery.trim().toLowerCase();
                      final users = snapshot.data!.where((user) {
                        final uid = (user['uid'] ?? user['firebaseUid'] ?? '')
                            .toString();
                        if (uid.isEmpty || uid == currentUser.uid) return false;
                        final name = _displayName(user).toLowerCase();
                        final email = (user['email'] ?? '')
                            .toString()
                            .toLowerCase();
                        return query.isEmpty ||
                            name.contains(query) ||
                            email.contains(query);
                      }).toList();

                      if (users.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              query.isEmpty
                                  ? 'No other DX users yet.'
                                  : 'No users match your search.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
                        itemCount: users.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final uid = (user['uid'] ?? user['firebaseUid'] ?? '')
                              .toString();
                          final email = (user['email'] ?? '').toString();
                          final name = _displayName(user);
                          final image =
                              (user['image'] ?? user['photoURL'] ?? '')
                                  .toString();

                          return Card(
                            margin: EdgeInsets.zero,
                            child: ListTile(
                              onTap: () {
                                if (uid == currentUser.uid) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'You cannot chat with yourself.',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatDetailScreen(
                                      otherUserId: uid,
                                      otherUserEmail: email,
                                      otherUserName: name,
                                    ),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                backgroundColor: theme.colorScheme.primary
                                    .withValues(alpha: 0.12),
                                child: image.isEmpty
                                    ? Icon(
                                        Icons.person_outline,
                                        color: theme.colorScheme.primary,
                                      )
                                    : ClipOval(
                                        child: Image.network(
                                          image,
                                          width: 44,
                                          height: 44,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) => Icon(
                                            Icons.person_outline,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ),
                              ),
                              title: Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                email.isEmpty ? 'No email provided' : email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: const Icon(Icons.chevron_right),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
