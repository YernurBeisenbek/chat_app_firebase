import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app_firebase/screens/sign_in_screen.dart';
import 'package:chat_app_firebase/services/auth_service.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChatListScreen({super.key});

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      await AuthService().signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => SignInScreen()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $error')),
      );
    }
  }

  Widget _buildUserTile(BuildContext context, QueryDocumentSnapshot user) {
    final String peerId = user.id;
    final String? peerName = user['displayName'];
    final String? email = user['email'];
    final String? photoURL = user['photoURL'];

    if (peerName == null || email == null) {
      return const SizedBox.shrink(); 
    }

    return ListTile(
      title: Text(peerName),
      subtitle: Text(email),
      leading: CircleAvatar(
        backgroundImage: photoURL != null
            ? NetworkImage(photoURL)
            : null, 
        child: photoURL == null ? const Icon(Icons.person) : null, // Default icon
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatScreen(peerId: peerId, peerName: peerName),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat List'),
        actions: [
          IconButton(
            onPressed: () => _handleSignOut(context),
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          final users = snapshot.data!.docs
              .where((doc) => doc['displayName'] != null && doc['email'] != null)
              .toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) =>
                _buildUserTile(context, users[index]),
          );
        },
      ),
    );
  }
}
