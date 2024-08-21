import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:ticeo/components/common/custom_form_button.dart';
import 'package:ticeo/components/common/custom_input_field.dart';
import 'package:ticeo/components/common/page_header_sing.dart';
import 'package:ticeo/components/common/page_heading.dart';
import 'package:ticeo/components/login_page.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'dart:io';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  File? _profileImage;
  double _textSize = 18.sp;

  final _signupFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      _textSize = mode == 'large' ? 20.sp : 18.sp;
    });
  }

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
  void initState() {
    super.initState();
    _loadPreferences();
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
                                  onTap: _pickProfileImage,
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
                                      tooltip: 'Importer une photo de profil',
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
                          controller: _nameController,
                          labelText: 'Nom',
                          hintText: 'Entrer votre nom',
                          isDense: true,
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'Il faut entrer un nom!';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 16.h,
                      ),
                      CustomInputField(
                          controller: _emailController,
                          labelText: 'Email',
                          hintText: 'Entrer votre email',
                          isDense: true,
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'Il faut entrer un email!';
                            }
                            if (!EmailValidator.validate(textValue)) {
                              return 'Entrer un email valide';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 16.h,
                      ),
                      CustomInputField(
                          controller: _contactController,
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
                        controller: _passwordController,
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
                                  fontSize: _textSize,
                                  color: const Color(0xff939393),
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Se connecter',
                                style: TextStyle(
                                    fontSize: _textSize,
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

  void _handleSignupUser() async {
    if (_signupFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Validation des données..')),
      );
      try {
        // Création de l'utilisateur avec FirebaseAuth
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Récupération de l'utilisateur
        User? user = userCredential.user;

        if (user != null) {
          // Ajout des informations supplémentaires à Firestore
          await FirebaseFirestore.instance
              .collection('Utilisateurs')
              .doc(user.uid)
              .set({
            'NomUtil': _nameController.text,
            'EmailUtil': _emailController.text,
            'TelUtil': _contactController.text,
            'MdpUtil': _passwordController.text,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Compte créé avec succès!')),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Le mot de passe est trop faible.')),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Un compte existe déjà avec cet email.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur1: ${e.message}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur2: ${e.toString()}')),
        );
      }
    }
  }
}
