import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/common/custom_form_button.dart';
import 'package:ticeo/components/common/custom_input_field.dart';
import 'package:ticeo/components/common/page_header.dart';
import 'package:ticeo/components/common/page_heading.dart';
import 'package:ticeo/components/forget_password_page.dart';
import 'package:ticeo/components/nav_bar/bottom_navbar.dart';
import 'package:ticeo/components/signup_page.dart';
import 'package:ticeo/components/state/provider_state.dart';

class LoginPage extends StatefulWidget {
  final bool isLargeTextMode; // Ajoute cette ligne

  const LoginPage({super.key, required this.isLargeTextMode});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final textSizeProvider = Provider.of<ModeProvider>(context);
    double innerSize = textSizeProvider.isLargeTextMode ? 20.sp : 18.sp;

    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: Column(
          children: [
            const PageHeader(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        const PageHeading(
                          title: 'Se connecter',
                        ),
                        CustomInputField(
                            labelText: 'Email',
                            hintText: 'Entrer votre email',
                            validator: (textValue) {
                              if (textValue == null || textValue.isEmpty) {
                                return 'Il faut entrer votre email!';
                              }
                              if (!EmailValidator.validate(textValue)) {
                                return 'Entrer une email valide';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomInputField(
                          labelText: 'Mot de passe',
                          hintText: 'Entrer votre mot de passe',
                          obscureText: true,
                          suffixIcon: true,
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'Il faut entrer un mot de passe!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          width: size.width * 0.80,
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgetPasswordPage(
                                          isLargeTextMode:
                                              widget.isLargeTextMode)))
                            },
                            child: Text(
                              'Mot de passe oublié?',
                              style: TextStyle(
                                color: const Color(0xff939393),
                                fontSize: innerSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomFormButton(
                          innerText: 'Se connecter',
                          onPressed: _handleLoginUser,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        SizedBox(
                          width: size.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Pas de compte ? ',
                                style: TextStyle(
                                    fontSize: innerSize,
                                    color: const Color(0xff939393),
                                    fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignupPage(
                                              isLargeTextMode:
                                                  widget.isLargeTextMode)))
                                },
                                child: Text(
                                  'Créer un compte',
                                  style: TextStyle(
                                      fontSize: innerSize,
                                      color: const Color(0xff748288),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLoginUser() {
    // login user
    if (_loginFormKey.currentState!.validate()) {
      // Afficher une snackbar pour la soumission des données
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Validation des données..')),
      );

      // Naviguer vers la page HomePage
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                GoogleBottomBar(isLargeTextMode: widget.isLargeTextMode)),
      );
    }
  }
}
