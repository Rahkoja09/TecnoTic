import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/common/custom_form_button.dart';
import 'package:ticeo/components/common/custom_input_field.dart';
import 'package:ticeo/components/common/page_header_sing.dart';
import 'package:ticeo/components/common/page_heading.dart';
import 'package:ticeo/components/loadingPage/loading.dart';
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
  bool _textSize = false;
  bool _isLoading = false;

  final _signupFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();

  Future<String?> _uploadProfileImage(File image) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('PhotoProfile_SimpleUser/$fileName');

      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      debugPrint('Erreur lors du téléchargement de l\'image: $e');
      return null;
    }
  }

  // Fonction de compression et redimensionnement de l'image
  Future<File?> compressAndResizeImage(File file,
      {int quality = 70, int minWidth = 800, int minHeight = 800}) async {
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/${Uuid().v4()}.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      minWidth: minWidth,
      minHeight: minHeight,
    );

    return result;
  }

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      _textSize = mode == 'largePolice';
    });
  }

  Future _pickProfileImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      var imageTemporary = File(image.path);
      imageTemporary = await compressAndResizeImage(imageTemporary) as File;
      setState(() => _profileImage = imageTemporary);
    } on PlatformException catch (e) {
      debugPrint('Erreur lors de la récupération d\'image: $e');
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
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: _isLoading
            ? LoadingWidget()
            : SingleChildScrollView(
                child: Form(
                  key: _signupFormKey,
                  child: Column(
                    children: [
                      const PageHeader(),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                              _textSize ? 24.w : 20.sp,
                            ),
                          ),
                          border: Border(
                            top: BorderSide(
                                color: Color.fromARGB(255, 214, 134, 22)),
                          ),
                        ),
                        child: Column(
                          children: [
                            const PageHeading(title: 'Création de compte'),
                            SizedBox(
                              width: 130.w,
                              height: 130.h,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : null,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: _textSize ? 8.w : 5.w,
                                      right: _textSize ? 8.w : 5.w,
                                      child: GestureDetector(
                                        onTap: _pickProfileImage,
                                        child: Container(
                                          height: _textSize ? 54.h : 50.h,
                                          width: _textSize ? 54.w : 50.w,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade400,
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 3.w),
                                            borderRadius:
                                                BorderRadius.circular(25.w),
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.camera_alt_sharp,
                                              color: Colors.white,
                                              size: _textSize ? 28.sp : 25.sp,
                                            ),
                                            tooltip:
                                                'Importer une photo de profil',
                                            onPressed: _pickProfileImage,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
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
                              },
                            ),
                            SizedBox(height: 16.h),
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
                              },
                            ),
                            SizedBox(height: 16.h),
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
                              },
                            ),
                            SizedBox(height: 16.h),
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
                            SizedBox(height: _textSize ? 26.h : 20.h),
                            CustomFormButton(
                              innerText: 'Créer le compte',
                              onPressed: _handleSignupUser,
                            ),
                            SizedBox(height: _textSize ? 26.h : 18.h),
                            SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Déjà un compte? ',
                                    style: TextStyle(
                                      fontSize: _textSize ? 28.sp : 14.sp,
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
                                          builder: (context) =>
                                              const LoginPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Se connecter',
                                      style: TextStyle(
                                        fontSize: _textSize ? 28.sp : 22.sp,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.color,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Jersey',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: _textSize ? 36.h : 30.h),
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
      setState(() {
        _isLoading = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Validation des données...')),
      );

      try {
        // Création de l'utilisateur avec FirebaseAuth
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        User? user = userCredential.user;

        if (user != null) {
          String idFireBase = user.uid;
          String? imageUrl;

          if (_profileImage != null) {
            imageUrl = await _uploadProfileImage(_profileImage!);
            if (imageUrl == null || imageUrl.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Erreur lors du téléchargement de l\'image de profil.')),
              );
              return;
            }
          }

          // Ajout de l'utilisateur dans Firestore
          await FirebaseFirestore.instance
              .collection('Utilisateurs')
              .doc(idFireBase)
              .set({
            'NomUtil': _nameController.text,
            'EmailUtil': _emailController.text,
            'TelUtil': _contactController.text,
            'MdpUtil': _passwordController.text,
            'ProfileImageUrl': imageUrl,
            'idFireBase': idFireBase,
            'idFireBaseMentor': '',
          });

          // Insertion dans SQLite
          await DatabaseHelper().insertUser(
              0,
              _nameController.text,
              _emailController.text,
              _contactController.text,
              _passwordController.text,
              imageUrl ?? '',
              idFireBase,
              0,
              "");

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inscription réussie!')),
          );

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      } on FirebaseAuthException catch (e) {
        debugPrint('Erreur d\'authentification: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.message ?? 'Erreur lors de l\'inscription.')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
