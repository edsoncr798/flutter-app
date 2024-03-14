import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final storage = const FlutterSecureStorage();
  final _userSubject = StreamController<User?>();



  AuthService(){
    // Emitir el estado de autenticación inicial
    _userSubject.add(_auth.currentUser);

    // Escuchar el estado de autenticación de Firebase
    _auth.authStateChanges().listen((User? user) {
      _userSubject.add(user);
    });
  }

  // Stream para escuchar el estado de autenticación
  Stream<User?>? get user => _auth.authStateChanges();


  Future<UserCredential> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'Usuario no encontrado') {
        throw Exception('Ningún usuario encontrado para ese correo electrónico.');
      } else if (e.code == 'contraseña incorrecta') {
        throw Exception('Contraseña incorrecta proporcionada para ese usuario.');
      }
      throw Exception(e.message);
    }
  }


  Future<UserCredential> signUpUser(String email, String password, String userName, String rol) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Crear una nueva instancia de Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Guardar los datos adicionales en la base de datos
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'user_name': userName,
        'email': email,
        'role': rol,
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'correo electrónico ya en uso') {
        throw Exception('El correo electrónico ya está en uso.');
      } else if (e.code == 'contraseña débil') {
        throw Exception('La contraseña proporcionada es demasiado débil.');
      }
      throw Exception(e.message);
    }
  }


}