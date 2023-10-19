import 'package:flutter/cupertino.dart';
import 'package:thuc_tap_flutter/views/screens/auth/login_screen.dart';
import 'package:thuc_tap_flutter/views/screens/auth/register_screen.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // initially show the login screen
  bool showLoginScreen = true;
  // toggle between login and register screen
  void toggleScreen() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginScreen) {
      return LoginScreen(onTap: toggleScreen);
    }else{
      return RegisterScreen(onTap: toggleScreen);
    }
  }
}
