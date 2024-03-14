// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:todo_users/models/user.dart';
//
// import '../screens/login_screen.dart';
// import '../services/auth_service.dart';
//
// class AuthMiddleware extends StatelessWidget {
//
//   final Widget child;
//   const AuthMiddleware({Key? key, required this.child}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final authService = Provider.of<AuthService>(context);
//
//     return StreamBuilder<bool>(
//       stream: authService.user,
//       builder: (_, snapshot){
//         if (snapshot.connectionState == ConnectionState.active) {
//           if (snapshot.data == null) {
//             return const LoginScreen();
//           } else {
//             return child;
//           }
//         }
//         return const CircularProgressIndicator();
//       },
//     );
//   }
// }
//
