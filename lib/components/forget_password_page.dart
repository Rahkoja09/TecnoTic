import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'package:ticeo/components/common/custom_form_button.dart';
import 'package:ticeo/components/common/custom_input_field.dart';
import 'package:ticeo/components/common/page_header.dart';
import 'package:ticeo/components/common/page_heading.dart';
import 'package:ticeo/components/login_page.dart';

class ForgetPasswordPage extends StatefulWidget {
  final bool isLargeTextMode; // Ajoute cette ligne

  const ForgetPasswordPage({super.key, required this.isLargeTextMode});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _forgetPasswordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                    key: _forgetPasswordFormKey,
                    child: Column(
                      children: [
                        const PageHeading(
                          title: 'Mot de passe oublier',
                        ),
                        CustomInputField(
                            labelText: 'Email',
                            hintText: 'Entrer votre email',
                            isDense: true,
                            validator: (textValue) {
                              if (textValue == null || textValue.isEmpty) {
                                return 'Il faut un email de recuperation!';
                              }
                              if (!EmailValidator.validate(textValue)) {
                                return 'Entrer une email valide';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomFormButton(
                          innerText: 'Récuperer',
                          onPressed: _handleForgetPassword,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage(
                                          isLargeTextMode:
                                              widget.isLargeTextMode)))
                            },
                            child: const Text(
                              'Retour au page de connexion',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff939393),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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

  void _handleForgetPassword() {
    // forget password
    if (_forgetPasswordFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Validation des données...')),
      );
    }
  }
}
