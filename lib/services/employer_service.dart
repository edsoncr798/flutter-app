import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/employer.dart';

class EmployerService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Stream<List<Employer>> getAllEmployers(){
  return _firestore.collection('employers').snapshots().map((snapshot){
    return snapshot.docs.map((doc) {
      return Employer.fromDocument(doc.data(), doc.id);
    }).toList();
  });
}


  Future<void> createEmployer(String name, String lastname, String email, String phone, String post) async {
    try {
      DocumentReference employerReference = await _firestore.collection('employers').add({
        'name': name,
        'lastname': lastname,
        'email': email,
        'phone': phone,
        'post': post,
        'photo': '',
        'created_at': FieldValue.serverTimestamp(),
        'updated_at': FieldValue.serverTimestamp(),
      });

      await employerReference.update({'uid': employerReference.id});
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }


  Future<void> updateEmployer(String uid, String name, String lastname, String email, String phone, String post) async {
    try {
      await _firestore.collection('employers').doc(uid).update({
        'name': name,
        'lastname': lastname,
        'email': email,
        'phone': phone,
        'post': post,
        'updated_at': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }


  Future<void> deleteEmployer(String uid) async {
    try {
      await _firestore.collection('employers').doc(uid).delete();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

}