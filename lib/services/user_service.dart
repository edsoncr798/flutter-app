import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAllUsers() async{
    QuerySnapshot querySnapshot = await _firestore.collection('users').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList().cast<Map<String, dynamic>>();
  }
}