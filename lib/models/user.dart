import 'package:flutter/material.dart';

class LocalUser {
  final String uid;
  final String userName;
  final String email;
  final String role;

  LocalUser({required this.uid, required this.userName, required this.email, required this.role});

  factory LocalUser.fromDocument(Map<String, dynamic> doc) {
    return LocalUser(
      uid: doc['id'] ?? '',
      userName: doc['userName'] ?? '',
      email: doc['email'] ?? '',
      role: doc['role'] ?? '',
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});
  final LocalUser user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(user.userName),
        subtitle: Text(user.email),
        trailing: Text(user.role),
      ),
    );
  }
}