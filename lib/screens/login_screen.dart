import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:todo_users/screens/user_list_screen.dart';
import 'package:todo_users/screens/welcome.dart';
import 'package:todo_users/services/auth_service.dart';
import '../components/components.dart';
import '../constants.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService();
  late String email;
  late String password;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.id);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const TopScreenImage(screenImageName: 'welcome.png'),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const ScreenTitle(title: 'Login'),
                        CustomTextField(
                          textField: TextField(
                              onChanged: (value) {
                                email = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                  hintText: 'Email')),
                        ),
                        CustomTextField(
                          textField: TextField(
                            obscureText: true,
                            onChanged: (value) {
                              password = value;
                            },
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                            decoration: kTextInputDecoration.copyWith(
                                hintText: 'Password'),
                          ),
                        ),
                        CustomBottomScreen(
                          textButton: 'Login',
                          heroTag: 'login',
                          question: 'Forgot password?',
                          buttonPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              _saving = true;
                            });
                            try {
                              await authService.loginUser(email, password);
                              if(authService.user != null){
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (_) => UserListScreen()));
                              }

                            } catch (e) {
                              signUpAlert(
                                context: context,
                                onPressed: () {
                                  setState(() {
                                    _saving = false;
                                  });
                                  Navigator.popAndPushNamed(
                                      context, LoginScreen.id);
                                },
                                title:
                                    'CONTRASEÑA O CORREO ELECTRÓNICO EQUIVOCADO',
                                desc:
                                    'Confirma tu correo electrónico y contraseña y vuelve a intentarlo.',
                                btnText: 'OK',
                              ).show();
                            }
                          },
                          questionPressed: () {
                            signUpAlert(
                              context: context,
                              onPressed: () {
                                Navigator.popAndPushNamed(
                                    context, WelcomeScreen.id);
                              },
                              title: 'FORGOT PASSWORD',
                              desc: 'Please contact the admin',
                              btnText: 'Contact',
                            ).show();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
