// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/common/custom_form_button.dart';
import 'package:ticeo/components/common/custom_input_field.dart';
import 'package:ticeo/components/common/page_header_sing.dart';
import 'package:ticeo/components/common/page_heading.dart';
import 'package:ticeo/components/database_gest/login_data.dart';
import 'package:ticeo/components/loadingPage/loading.dart';
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
  bool _textSize = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      _textSize = mode == 'largePolice';
    });
  }

  void createMentor() async {
    final dbHelper = DatabaseHelperLogin();
    await dbHelper.createMentorTable();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: _isLoading
            ? LoadingWidget(
                backgroundColor: Color.fromARGB(15, 52, 172, 205)
                    .withOpacity(0.5)) // Ajustez l'opacité ici
            : SingleChildScrollView(
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      const PageHeader(),
                      Container(
                        decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.w),
                            ),
                            border: const Border(
                                top: BorderSide(
                                    color: Color.fromARGB(255, 214, 134, 22)))),
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
                                      builder: (context) => const SignupPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Mot de passe oublié?',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.color,
                                    fontSize: _textSize ? 24.sp : 18.sp,
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
                                      fontSize: _textSize ? 30.sp : 14.sp,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.color,
                                      fontWeight: FontWeight.w500,
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
                                          fontSize: _textSize ? 30.sp : 22.sp,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.color,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Jersey'),
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
      setState(() {
        _isLoading = true;
      });
      String idFireBaseMentor = '';
      String name = '';
      String contact = '';
      String email = '';
      String mdp = '';
      String imageUrl = '';
      int isMentor = 0;

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (!mounted) return;
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Utilisateurs')
            .where('EmailUtil', isEqualTo: _emailController.text)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          idFireBaseMentor = querySnapshot.docs.first['idFireBaseMentor'] ?? '';
          print(
              'me voici le id fire base de mentor recuperer dans firebase : $idFireBaseMentor');

          // Récupération des infos mentor si c'est un mentor
          if (idFireBaseMentor.isNotEmpty) {
            isMentor = 1;
            await DatabaseHelper().insertUser(
              0,
              querySnapshot.docs.first['NomUtil'],
              querySnapshot.docs.first['EmailUtil'],
              querySnapshot.docs.first['TelUtil'],
              querySnapshot.docs.first['MdpUtil'],
              querySnapshot.docs.first['ProfileImageUrl'],
              querySnapshot.docs.first['idFireBase'],
              isMentor,
              idFireBaseMentor,
            );
            DocumentSnapshot querySnapshotMentor = await FirebaseFirestore
                .instance
                .collection('Mentors')
                .doc(
                    idFireBaseMentor) // Utilisation de .doc() au lieu de .where()
                .get();

            if (querySnapshotMentor.exists) {
              print(querySnapshot.docs.first
                  .data()); // Pour voir ce qui est récupéré

              createMentor();
              await DatabaseHelper().insertMentor(
                0,
                querySnapshotMentor['name'],
                querySnapshotMentor['contact'],
                querySnapshotMentor['email'],
                querySnapshotMentor['hours'],
                querySnapshotMentor['description'],
                querySnapshotMentor['accomplishments'],
                querySnapshotMentor['price'],
                querySnapshotMentor['specialty'],
                querySnapshotMentor['rates'],
                querySnapshotMentor['idFireBase'],
                querySnapshotMentor['image_url'],
              );
            } else {
              print('Aucun mentor trouvé avec cet idFireBaseMentor.');
            }
          } else {
            isMentor = 0;
            await DatabaseHelper().insertUser(
              0,
              querySnapshot.docs.first['NomUtil'],
              querySnapshot.docs.first['EmailUtil'],
              querySnapshot.docs.first['TelUtil'],
              querySnapshot.docs.first['MdpUtil'],
              querySnapshot.docs.first['ProfileImageUrl'],
              querySnapshot.docs.first['idFireBase'],
              isMentor,
              idFireBaseMentor,
            );
          }
        } else {
          print('Snapshot user or and mentor empty, mila verifiena');
        }

        // Redirection après connexion
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GoogleBottomBar()),
        );
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.message}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
