import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';
import 'package:ticeo/components/common/custom_form_button.dart';
import 'package:ticeo/components/common/custom_input_field.dart';
import 'package:ticeo/components/common/page_header_sing.dart';
import 'package:ticeo/components/common/page_heading.dart';
import 'package:ticeo/components/nav_bar/bottom_navbar.dart';
import 'package:ticeo/components/signup_page.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  double _textSize = 18.sp;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      _textSize = mode == 'large' ? 20.sp : 18.sp;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: SingleChildScrollView(
          child: Form(
            key: _loginFormKey,
            child: Column(
              children: [
                const PageHeader(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.w),
                    ),
                  ),
                  child: Column(
                    children: [
                      const PageHeading(
                        title: 'Se connecter',
                      ),
                      CustomInputField(
                        labelText: 'Email',
                        hintText: 'Entrer votre email',
                        controller: _emailController,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'Il faut entrer votre email!';
                          }
                          if (!EmailValidator.validate(textValue)) {
                            return 'Entrer une email valide';
                          }
                          return null;
                        },
                      ),
                      CustomInputField(
                        labelText: 'Mot de passe',
                        hintText: 'Entrer votre mot de passe',
                        obscureText: true,
                        suffixIcon: true,
                        controller: _passwordController,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'Il faut entrer un mot de passe!';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Mot de passe oublié?',
                            style: TextStyle(
                              color: const Color(0xff939393),
                              fontSize: _textSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CustomFormButton(
                        innerText: 'Se connecter',
                        onPressed: _handleLoginUser,
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Pas de compte ? ',
                              style: TextStyle(
                                fontSize: _textSize,
                                color: const Color(0xff939393),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Créer un compte',
                                style: TextStyle(
                                  fontSize: _textSize,
                                  color: const Color(0xff748288),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLoginUser() async {
    if (_loginFormKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GoogleBottomBar()),
        );
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.message}')),
        );
      }
    }
  }
}
