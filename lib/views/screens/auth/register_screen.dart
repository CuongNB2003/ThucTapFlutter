import 'package:thuc_tap_flutter/services/auth/auth_service.dart';
import 'package:thuc_tap_flutter/validate/auth_validate.dart';
import 'package:thuc_tap_flutter/views/widgets/my_button.dart';
import 'package:thuc_tap_flutter/views/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final void Function()? onTap;
  const RegisterScreen({super.key, required this.onTap});

  @override
  State<StatefulWidget> createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  bool _showPass = true;
  bool _showConfirnPass = true;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _authValidate = AuthValidate();
  final _formKey = GlobalKey<FormState>();

  void onclickShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  void onclickShowConfirmPass() {
    setState(() {
      _showConfirnPass = !_showConfirnPass;
    });
  }

  void handleCreateAccount() async {
    if(_formKey.currentState!.validate()){
      final authService = Provider.of<AuthService>(context, listen: false);
      try {
        await authService.signUpWithEmailAndPassword(
            _emailCtrl.text, _passCtrl.text);
        print("Tạo tài khoản thành công");
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    }else {
      print('Validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Let's",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Create An Account For You!",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    MyTextField(
                      isRightIcon: false,
                      controller: _nameCtrl,
                      hintText: "Name",
                      obscureText: false,
                      icon: const Icon(Icons.perm_identity_outlined),
                      onValidate: (value) => _authValidate.validateName(value),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextField(
                      controller: _emailCtrl,
                      hintText: "Email",
                      obscureText: false,
                      icon: const Icon(Icons.email_outlined),
                      isRightIcon: false,
                      onValidate: (value) => _authValidate.validateEmail(value),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextField(
                      onTap: onclickShowPass,
                      controller: _passCtrl,
                      hintText: "PassWord",
                      obscureText: _showPass,
                      icon: const Icon(Icons.lock_outline),
                      isRightIcon: true,
                      onValidate: (value) => _authValidate.validatePassword(value),
                    ),const SizedBox(
                      height: 20,
                    ),
                    MyTextField(
                      onTap: onclickShowConfirmPass,
                      controller: _confirmPassCtrl,
                      hintText: "Confirm PassWord",
                      obscureText: _showConfirnPass,
                      icon: const Icon(Icons.lock_outline),
                      isRightIcon: true,
                      onValidate: (value) => _authValidate.validateConfirmPassword(value, _passCtrl.text),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    MyButton(
                      onTap: handleCreateAccount,
                      text: "SIGN UP",
                      sizeHeigh: double.infinity,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          const Text(
                            'Already a member? ',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              'Login Now',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
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
      ),
    );
  }
}
