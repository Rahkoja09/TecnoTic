// ignore_for_file: unused_field, library_private_types_in_public_api, avoid_print

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/components/loadingPage/loading.dart';

class FormMentor extends StatefulWidget {
  final VoidCallback onClose;
  const FormMentor({Key? key, required this.onClose}) : super(key: key);

  @override
  State<FormMentor> createState() => _FormMentorState();
}

class _FormMentorState extends State<FormMentor> {
  int currentStep = 0;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool isFormValid = false;
  String idFireBaseUser = '';
  bool isLargeTextMode = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _accomplissementController =
      TextEditingController();
  final TextEditingController _prixController = TextEditingController();

  String selectedType = '';
  String idFirebase = '';
  bool _isLoading = false;

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      isLargeTextMode = mode == 'largePolice';
    });
  }

  Future<void> getidFireBaseUser() async {
    var infoUser = await DatabaseHelper().getUser();
    if (infoUser!.isNotEmpty) {
      idFireBaseUser = infoUser.first['idFireBase'];
    } else {
      print('Erreur lors de la récuperation idFireBaseUser dans local_db.db');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    getidFireBaseUser();
  }

  Future<void> _uploadData() async {
    setState(() {
      _isLoading = true;
    });
    if (_imageFile == null) {
      print('No image selected.');
      return;
    }

    try {
      final String fileName = DateTime.now().microsecondsSinceEpoch.toString();
      final String? fileExtension = _imageFile!.path.split('.').last;

      if (fileExtension == null || fileExtension.isEmpty) {
        print('No valid file extension found.');
        return;
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('mentor_images/$fileName.$fileExtension');
      final uploadTask = storageRef.putFile(_imageFile!);

      final snapshot = await uploadTask.whenComplete(() => {});
      const rates = 0;
      final imageUrl = await snapshot.ref.getDownloadURL();
      final mentorData = {
        'name': _nameController.text,
        'contact': _contactController.text,
        'email': _emailController.text,
        'hours': _hoursController.text,
        'description': _descriptionController.text,
        'accomplishments': _accomplissementController.text,
        'specialty': selectedType,
        'price': _prixController.text,
        'image_url': imageUrl,
        'idFireBase': "",
        'rates': rates,
        'isValide': 0,
        'Notifications': {},
      };

      await FirebaseFirestore.instance.collection('Mentors').add(mentorData);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Mentors')
          .where('contact', isEqualTo: _contactController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String documentId = querySnapshot.docs.first.id;
        idFirebase = documentId;

        await FirebaseFirestore.instance
            .collection('Mentors')
            .doc(idFirebase)
            .update({
          'idFireBase': idFirebase,
        });
      } else {
        print(
            "Aucun mentor trouvé avec ce contact pendant le login idFirebase erreur alors!");
        return;
      }
      await DatabaseHelper().insertMentor(
        0,
        _nameController.text,
        _contactController.text,
        _emailController.text,
        _hoursController.text,
        _descriptionController.text,
        _accomplissementController.text,
        _prixController.text,
        selectedType,
        rates,
        idFirebase,
        imageUrl,
      );

      await DatabaseHelper().updateIdFireBaseMentor(0, idFirebase);

      await DatabaseHelper().updateIsMentor(
        0,
        1,
      );

      try {
        await FirebaseFirestore.instance
            .collection('Utilisateurs')
            .doc(idFireBaseUser)
            .update({
          'idFireBaseMentor': idFirebase,
        });
      } catch (f) {
        print('Error:  $f');
      }

      widget.onClose();
    } on FirebaseAuthException catch (e) {
      print('Erreur lors de l\'ajout des données Mentors: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void nextStep() {
    if (isFormValid) {
      setState(() {
        if (currentStep < 3) currentStep++;
        isFormValid = false;
      });
    }
  }

  void previousStep() {
    setState(() {
      if (currentStep > 0) currentStep--;
    });
  }

  void validateForm() {
    setState(() {
      isFormValid = true;
    });
  }

  Widget getStepContent() {
    switch (currentStep) {
      case 0:
        return StepLocalisation(
          onFormChanged: validateForm,
          nameController: _nameController,
          contactController: _contactController,
          emailController: _emailController,
          hoursController: _hoursController,
          isLargeTextMode: isLargeTextMode,
        );
      case 1:
        return StepEnvironnement(
          onFormChanged: validateForm,
          descriptionController: _descriptionController,
          accomplissementController: _accomplissementController,
          isLargeTextMode: isLargeTextMode,
        );
      case 2:
        return StepSupplementaire(
          onFormChanged: validateForm,
          prixController: _prixController,
          selectedType: selectedType,
          isLargeTextMode: isLargeTextMode,
          onTypeChanged: (type) {
            setState(() {
              selectedType = type;
            });
          },
        );

      case 3:
        return StepFinale(
          onFormChanged: validateForm,
          isLargeTextMode: isLargeTextMode,
          onImageSelected: (File image) {
            setState(() {
              _imageFile = image;
            });
          },
        );

      default:
        return StepLocalisation(
          onFormChanged: validateForm,
          nameController: _nameController,
          contactController: _contactController,
          emailController: _emailController,
          hoursController: _hoursController,
          isLargeTextMode: isLargeTextMode,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return _isLoading
        ? LoadingWidget(
            backgroundColor: Color.fromARGB(15, 52, 172, 205)
                .withOpacity(0.5)) // Ajustez l'opacité ici
        : Dialog(
            backgroundColor: theme.scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Container(
              padding: EdgeInsets.all(16.w),
              width: 1000.w,
              height: 600.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: widget.onClose,
                      ),
                      Text(
                        'Étape ${currentStep + 1} sur 4',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 94, 94, 94),
                          fontSize: isLargeTextMode ? 23.sp : 15.sp,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: Text(
                      'S\'inscrire en tant que mentor',
                      style: TextStyle(
                        fontSize: isLargeTextMode ? 26.sp : 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyText2?.color,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: getStepContent(),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (currentStep > 0)
                        TextButton(
                          onPressed: previousStep,
                          child: Text(
                            'Précédent',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2?.color,
                              fontWeight: FontWeight.bold,
                              fontSize: isLargeTextMode ? 26.sp : 18.sp,
                            ),
                          ),
                        ),
                      if (currentStep < 3)
                        TextButton(
                          onPressed: isFormValid ? nextStep : null,
                          child: Text(
                            'Suivant',
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2?.color,
                              fontWeight: FontWeight.bold,
                              fontSize: isLargeTextMode ? 26.sp : 18.sp,
                            ),
                          ),
                        )
                      else
                        ElevatedButton(
                          onPressed: () async {
                            validateForm;
                            print(isFormValid);
                            if (isFormValid) {
                              await _uploadData();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 17, 150, 184),
                          ),
                          child: Text(
                            'Valider',
                            style: TextStyle(
                              fontSize: isLargeTextMode ? 26.sp : 18.sp,
                              color:
                                  Theme.of(context).textTheme.bodyText2?.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}

class StepLocalisation extends StatefulWidget {
  final VoidCallback onFormChanged;
  final TextEditingController nameController;
  final TextEditingController contactController;
  final TextEditingController emailController;
  final TextEditingController hoursController;
  final isLargeTextMode;

  const StepLocalisation({
    super.key,
    required this.onFormChanged,
    required this.nameController,
    required this.contactController,
    required this.emailController,
    required this.hoursController,
    required this.isLargeTextMode,
  });

  @override
  _StepLocalisationState createState() => _StepLocalisationState();
}

class _StepLocalisationState extends State<StepLocalisation> {
  void _checkForm() {
    bool isValid = widget.nameController.text.isNotEmpty &&
        widget.contactController.text.isNotEmpty &&
        widget.emailController.text.isNotEmpty &&
        widget.hoursController.text.isNotEmpty;
    if (isValid) {
      widget.onFormChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Color.fromARGB(77, 68, 220, 234),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vos Propos?',
                  style: TextStyle(
                    fontSize: widget.isLargeTextMode ? 26.sp : 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyText2?.color,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'La premiere étape c\'est de donner vos informations public pour votre compte Mentor. Comme : votre nom, contact, etc',
                  style: TextStyle(
                    fontSize: widget.isLargeTextMode ? 24.sp : 14.sp,
                    color: Theme.of(context).textTheme.bodyText2?.color,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              children: [
                TextField(
                  controller: widget.nameController,
                  onChanged: (_) => _checkForm(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      size: 24.sp,
                      color: Theme.of(context).textTheme.bodyText2?.color,
                    ),
                    hintText: 'Entrer votre nom complet',
                    hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2?.color,
                      fontSize: widget.isLargeTextMode ? 24.sp : 14.sp,
                    ),
                    fillColor: const Color.fromARGB(142, 222, 223, 223),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: widget.contactController,
                  onChanged: (_) => _checkForm(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.phone,
                      size: 24.sp,
                      color: Theme.of(context).textTheme.bodyText2?.color,
                    ),
                    hintText: 'Entrer un contact',
                    hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2?.color,
                      fontSize: widget.isLargeTextMode ? 24.sp : 14.sp,
                    ),
                    fillColor: const Color.fromARGB(142, 222, 223, 223),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: widget.emailController,
                  onChanged: (_) => _checkForm(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.mail,
                      size: 24.sp,
                      color: Theme.of(context).textTheme.bodyText2?.color,
                    ),
                    hintText: 'Entrer un adresse Email',
                    hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2?.color,
                      fontSize: widget.isLargeTextMode ? 24.sp : 14.sp,
                    ),
                    fillColor: const Color.fromARGB(142, 222, 223, 223),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: widget.hoursController,
                  onChanged: (_) => _checkForm(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.timer,
                      size: 24.sp,
                      color: Theme.of(context).textTheme.bodyText2?.color,
                    ),
                    hintText: 'Heure de mentoring(exemple : 12)',
                    hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2?.color,
                      fontSize: widget.isLargeTextMode ? 24.sp : 14.sp,
                    ),
                    fillColor: const Color.fromARGB(142, 222, 223, 223),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  's\'il vous plaît, entréer des informations vrai et réel car une vérification sera fait par l\'adrministrateur pour voir la véracité de vos informations, merci',
                  style: TextStyle(
                    fontSize: widget.isLargeTextMode ? 24.sp : 14.sp,
                    color: Theme.of(context).textTheme.bodyText2?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StepEnvironnement extends StatefulWidget {
  final VoidCallback onFormChanged;
  final TextEditingController descriptionController;
  final TextEditingController accomplissementController;
  final isLargeTextMode;

  const StepEnvironnement({
    super.key,
    required this.onFormChanged,
    required this.descriptionController,
    required this.accomplissementController,
    required this.isLargeTextMode,
  });

  @override
  _StepEnvironnementState createState() => _StepEnvironnementState();
}

class _StepEnvironnementState extends State<StepEnvironnement> {
  void _checkForm() {
    bool isValid = widget.descriptionController.text.isNotEmpty &&
        widget.accomplissementController.text.isNotEmpty;

    if (isValid) {
      widget.onFormChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: const Color.fromARGB(77, 68, 220, 234),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Decrivez vous, qui vous êtes.',
                  style: TextStyle(
                    fontSize: widget.isLargeTextMode ? 28.sp : 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyText2?.color,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'La deuxième étape, C\'est de vous décrire pour que les Utilisateurs puissent bien vous connaitre.',
                  style: TextStyle(
                    fontSize: widget.isLargeTextMode ? 24.sp : 14.sp,
                    color: Theme.of(context).textTheme.bodyText2?.color,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              children: [
                TextField(
                  controller: widget.descriptionController,
                  onChanged: (_) => _checkForm(),
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.description,
                      size: 24.sp,
                      color: Theme.of(context).textTheme.bodyText2?.color,
                    ),
                    hintText:
                        'Entrez votre description\n plusieur ligne possible',
                    hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2?.color,
                      fontSize: widget.isLargeTextMode ? 24.sp : 14.sp,
                    ),
                    fillColor: const Color.fromARGB(142, 222, 223, 223),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: widget.accomplissementController,
                  onChanged: (_) => _checkForm(),
                  minLines: widget.isLargeTextMode ? 10 : 7,
                  maxLines: widget.isLargeTextMode ? 10 : 7,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.verified,
                      size: 24.sp,
                      color: Theme.of(context).textTheme.bodyText2?.color,
                    ),
                    hintText:
                        'Entrez vos accomplissements(02 maximum).\n Exemple :\n\n TITRE1 : Description1 . (à la ligne)\n TITRE2 : Description2 .',
                    hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2?.color,
                      fontSize: widget.isLargeTextMode ? 22.sp : 14.sp,
                    ),
                    fillColor: const Color.fromARGB(142, 222, 223, 223),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StepSupplementaire extends StatefulWidget {
  final VoidCallback onFormChanged;
  final TextEditingController prixController;
  final String selectedType;
  final ValueChanged<String> onTypeChanged;
  final isLargeTextMode;

  const StepSupplementaire({
    super.key,
    required this.onFormChanged,
    required this.prixController,
    required this.selectedType,
    required this.onTypeChanged,
    required this.isLargeTextMode,
  });

  @override
  _StepSupplementaireState createState() => _StepSupplementaireState();
}

class _StepSupplementaireState extends State<StepSupplementaire> {
  void _checkForm() {
    bool isValid =
        widget.prixController.text.isNotEmpty && widget.selectedType.isNotEmpty;

    if (isValid) {
      widget.onFormChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: const Color.fromARGB(77, 68, 220, 234),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Des informations supplémentaires',
                  style: TextStyle(
                    fontSize: widget.isLargeTextMode ? 28.sp : 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyText2?.color,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'L\avant derniere étape est de fournir votre prix de mentoring et le compétence dans les TIC que vous pouvez offrir aux autres(Les compétences sont disponibles aux choix).',
                  style: TextStyle(
                    fontSize: widget.isLargeTextMode ? 24.sp : 14.sp,
                    color: Theme.of(context).textTheme.bodyText2?.color,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              children: [
                TextField(
                  controller: widget.prixController,
                  onChanged: (_) => _checkForm(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.attach_money, size: 24.sp),
                    hintText: 'Entrez votre prix de mentoring',
                    hintStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2?.color,
                      fontSize: widget.isLargeTextMode ? 24.sp : 14.sp,
                    ),
                    fillColor: const Color.fromARGB(142, 222, 223, 223),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Compétence',
                  style: TextStyle(
                    fontSize: widget.isLargeTextMode ? 18.sp : 12.sp,
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: widget.selectedType.isNotEmpty
                      ? widget.selectedType
                      : null,
                  onChanged: (value) {
                    if (value != null) {
                      widget.onTypeChanged(value); // Appel du callback
                    }
                  },
                  items: <String>[
                    'Général',
                    'Bureautique',
                    'Info braille',
                    'Communication',
                    'MS word',
                    'MS Excel',
                    'Power Point',
                    'Mobile'
                  ]
                      .map((type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                              type,
                              style: TextStyle(
                                fontSize:
                                    widget.isLargeTextMode ? 24.sp : 14.sp,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.color,
                              ),
                            ),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.category, size: 24.sp),
                    fillColor: const Color.fromARGB(142, 222, 223, 223),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StepFinale extends StatefulWidget {
  final Function(File) onImageSelected;
  final VoidCallback onFormChanged;
  final isLargeTextMode;

  const StepFinale({
    Key? key,
    required this.onFormChanged,
    required this.onImageSelected,
    required this.isLargeTextMode,
  }) : super(key: key);

  @override
  _StepFinaleState createState() => _StepFinaleState();
}

class _StepFinaleState extends State<StepFinale> {
  File? _image;
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        widget.onImageSelected(_image!);
      });
      if (_image != null) {
        widget.onFormChanged();
      }
    }
    widget.onFormChanged();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: const Color.fromARGB(77, 68, 220, 234),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Un peux de photo?',
                  style: TextStyle(
                    fontSize: widget.isLargeTextMode ? 28.sp : 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyText2?.color,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'C\'est la fin, la dernière étape est d\'ajouter une belle photo de profil pour votre compte mentoring',
                  style: TextStyle(
                    fontSize: widget.isLargeTextMode ? 24.sp : 14.sp,
                    color: Theme.of(context).textTheme.bodyText2?.color,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              children: [
                Container(
                  height: 150.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: _image == null
                      ? Center(
                          child: Text('Aucune image sélectionnée',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize:
                                    widget.isLargeTextMode ? 14.sp : 11.sp,
                              )))
                      : Image.file(_image!),
                ),
                SizedBox(height: 5.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: theme.cardColor,
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.w, vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    //onFormChanged: validateForm;

                    onPressed: _pickImage,
                    child: Text(
                      ' + Importer une image',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText2?.color,
                        fontSize: widget.isLargeTextMode ? 16.sp : 14.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  'Tous ces informations sont public, et concerne votre propos compte de mentoring. Une vérification sera faite par l\'administrateur avant d\'affiché votre profil mentoring aux public, si quelque chose ne vas pas, on vous contacteras pour vous en informer. Uniforme et validé par nos termes et conditions, que vous pouvez re-consulter dans la séction menu et paramettrage',
                  style: TextStyle(
                    fontSize: widget.isLargeTextMode ? 24.sp : 12.sp,
                    color: Theme.of(context).textTheme.bodyText2?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
