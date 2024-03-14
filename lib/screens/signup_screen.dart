
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../components/components.dart';
import '../constants.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static String id = 'signup_screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService authService = AuthService();

  String _email = '';
  String _password = '';
  String _username = '';
  String _role = '';
  String _confirmPassword = '';
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.id);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TopScreenImage(screenImageName: 'signup.png'),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const ScreenTitle(title: 'Sign Up'),
                          CustomTextField(
                            textField: TextField(
                              onChanged: (value) {
                                _email = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'correo electrónico',
                              ),
                            ),
                          ),
                          CustomTextField(
                            textField: TextField(
                              obscureText: true,
                              onChanged: (value) {
                                _password = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'contraseña',
                              ),
                            ),
                          ),
                          CustomTextField(
                            textField: TextField(
                              obscureText: true,
                              onChanged: (value) {
                                _confirmPassword = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'confirmar contraseña',
                              ),
                            ),
                          ),
                          CustomTextField(
                            textField: TextField(
                              onChanged: (value) {
                                _username = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'nombre de usuario',
                              ),
                            ),
                          ),
                          CustomTextField(
                            textField: TextField(
                              onChanged: (value) {
                                _role = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'rol',
                              ),
                            ),
                          ),
                          CustomBottomScreen(
                            textButton: 'Sign Up',
                            heroTag: 'signup_btn',
                            question: 'Have an account?',
                            buttonPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                _saving = true;
                              });
                              if (_confirmPassword == _password &&
                                  _email.isNotEmpty &&
                                  _password.isNotEmpty &&
                                  _username.isNotEmpty &&
                                  _role.isNotEmpty) {
                                try {
                                  await authService.signUpUser(
                                      _email, _password, _username, _role);
                                  if (context.mounted) {
                                    signUpAlert(
                                      context: context,
                                      title: 'GOOD JOB',
                                      desc: 'Go login now',
                                      btnText: 'Login Now',
                                      onPressed: () {
                                        setState(() {
                                          _saving = false;
                                          Navigator.popAndPushNamed(
                                              context, SignUpScreen.id);
                                        });
                                        Navigator.pushNamed(
                                            context, LoginScreen.id);
                                      },
                                    ).show();
                                  }
                                } catch (e) {
                                  signUpAlert(
                                      context: context,
                                      onPressed: () {
                                        SystemNavigator.pop();
                                      },
                                      title: 'OCURRE ALGO',
                                      desc: 'Cierra la aplicación y vuelve a intentarlo.',
                                      btnText: 'OK');
                                }
                              } else {
                                showAlert(
                                    context: context,
                                    title: 'ALGO SALIÓ MAL',
                                    desc:
                                        'Asegúrate de que todos los campos estén llenos o que las contraseñas coincidan',
                                    onPressed: () {
                                      setState(() {
                                        _saving = false;
                                      });
                                      Navigator.popAndPushNamed(
                                          context, SignUpScreen.id);
                                    }).show();
                              }
                            },
                            questionPressed: () async {
                              Navigator.pushNamed(context, LoginScreen.id);
                            },
                          ),
                        ],
                      ),
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
