// ignore_for_file: avoid_print
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticeo/components/common/custom_form_button.dart';
import 'package:ticeo/components/common/custom_input_field.dart';
import 'package:ticeo/components/common/page_header_sing.dart';
import 'package:ticeo/components/common/page_heading.dart';
import 'package:ticeo/components/login_page.dart';
import 'package:ticeo/components/state/provider_state.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required bool isLargeTextMode});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  File? _profileImage;

  final _signupFormKey = GlobalKey<FormState>();

  Future _pickProfileImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => _profileImage = imageTemporary);
    } on PlatformException catch (e) {
      debugPrint('Erreur lors de la recuperation d\'image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textSizeProvider = Provider.of<ModeProvider>(context);
    double innerSize = textSizeProvider.isLargeTextMode ? 20.sp : 18.sp;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: SingleChildScrollView(
          child: Form(
            key: _signupFormKey,
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
                        title: 'Création de compte',
                      ),
                      SizedBox(
                        width: 130.w, // Avatar width
                        height: 130.h, // Avatar height
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 5.w,
                                right: 5.w,
                                child: GestureDetector(
                                  onTap: _pickProfileImage, //_pickProfileImage,
                                  child: Container(
                                    height: 50.h,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade400,
                                      border: Border.all(
                                          color: Colors.white, width: 3.w),
                                      borderRadius: BorderRadius.circular(25.w),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.camera_alt_sharp,
                                        color: Colors.white,
                                        size: 25.sp,
                                      ),
                                      tooltip: 'importer un photo de profil',
                                      onPressed: _pickProfileImage,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      CustomInputField(
                          labelText: 'Nom',
                          hintText: 'Entrer votre nom',
                          isDense: true,
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'IL faut entrer un nom!';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 16.h,
                      ),
                      CustomInputField(
                          labelText: 'Email',
                          hintText: 'Entrer votre email',
                          isDense: true,
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'Il faut entrer une email!';
                            }
                            if (!EmailValidator.validate(textValue)) {
                              return 'Entrer une email valide';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 16.h,
                      ),
                      CustomInputField(
                          labelText: 'Contact',
                          hintText: 'Entrer votre contact',
                          isDense: true,
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'Un contact est recommandé!';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 16.h,
                      ),
                      CustomInputField(
                        labelText: 'Mot de passe',
                        hintText: 'Créer un mot de passe',
                        isDense: true,
                        obscureText: true,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'Entrer un mot de passe valide!';
                          }
                          return null;
                        },
                        suffixIcon: true,
                      ),
                      SizedBox(
                        height: 22.h,
                      ),
                      CustomFormButton(
                        innerText: 'Créer le compte',
                        onPressed: _handleSignupUser,
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Déjà un compte? ',
                              style: TextStyle(
                                  fontSize: innerSize,
                                  color: const Color(0xff939393),
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(
                                      isLargeTextMode:
                                          textSizeProvider.isLargeTextMode,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Se connecter',
                                style: TextStyle(
                                    fontSize: innerSize,
                                    color: const Color(0xff748288),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
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

  void _handleSignupUser() {
    if (_signupFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Validation des données..')),
      );
    }
  }
}
