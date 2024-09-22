import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/profilMentoring/Services.dart';
import 'package:ticeo/profilMentoring/ui/widgets/profile_card.dart';
import 'package:ticeo/profilMentoring/ui/widgets/profile_header.dart';
import 'package:ticeo/profilMentoring/ui/widgets/profile_image_widget.dart';
import 'package:ticeo/profilMentoring/utils/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String propos = '';
  String accomplissement = '';
  String competence = '';
  String prix = '';
  String profil = '';
  String contact = '';
  String email = '';
  String IdFireBase = '';

  String profil2 = '';
  String contact2 = '';
  String email2 = '';

  int isMentor = 0;
  bool isLargeTextMode = false;
  var imageUrlDownload = '';
  File? _imageFile;

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      isLargeTextMode = mode == 'largePolice';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    getMentor();
    getUser();
    getIsMentor();
  }

  Future<void> getMentor() async {
    var infoMentor = await DatabaseHelper().getMentor();
    if (infoMentor!.isNotEmpty) {
      setState(() {
        propos = infoMentor.first['Apropos'];
        accomplissement = infoMentor.first['Accomplissements'];
        competence = infoMentor.first['Competence'];
        prix = infoMentor.first['Prix'];
        profil = infoMentor.first['imageUrl'];
        contact = infoMentor.first['Contact'];
        email = infoMentor.first['Email'];
        IdFireBase = infoMentor.first['IdFireBase'];
      });
    } else {
      print('Erreur de récuperation Mentor dans local_db.db');
    }
  }

  Future<void> uploadImage(String IdFireBase) async {
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
      imageUrlDownload = await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('Mentors')
          .doc(IdFireBase)
          .update({
        'image_url': imageUrlDownload,
      });
      DatabaseHelper().updateMentorImageUrl(0, imageUrlDownload);
      print("l'url que l'on a eu est :::::: $imageUrlDownload");
    } catch (e) {
      print('Erreur upload image dans profil mentor(modifier profil): $e');
    }
  }

  Future<void> deleteImageFromStorage(String imageUrl) async {
    try {
      String filePath =
          Uri.decodeFull(imageUrl.split('?').first.split('/o/').last);
      Reference ref = FirebaseStorage.instance.ref().child(filePath);

      await ref.delete();
      await uploadImage(IdFireBase);

      print('Image supprimée avec succès de Firebase Storage.');
    } catch (e) {
      print('Erreur lors de la suppression de l\'image: $e');
    }
  }

  Future<void> getUser() async {
    var infoMentor = await DatabaseHelper().getUser();
    if (infoMentor!.isNotEmpty) {
      setState(() {
        profil2 = infoMentor.first['profileImageUrl'];
        contact2 = infoMentor.first['telephone'];
        email2 = infoMentor.first['email'];
      });
    } else {
      print('Erreur de récuperation Mentor dans local_db.db');
    }
  }

  Future<void> getIsMentor() async {
    int mentorStatus = (await DatabaseHelper().getisMentor())!;
    setState(() {
      isMentor = mentorStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    ScreenUtil.init(context,
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {},
          icon:
              Icon(Icons.keyboard_backspace, color: Colors.white, size: 24.sp),
        ),
        actions: const <Widget>[
          ProfileImageWidget(),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
        color: theme.scaffoldBackgroundColor,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileHeaderWidget(),
            SizedBox(height: 35.h),
            Expanded(
              child: GridView.count(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: isLargeTextMode ? 1 : 2,
                mainAxisSpacing: isLargeTextMode ? 30.h : 10.h,
                crossAxisSpacing: isLargeTextMode ? 30.w : 10.w,
                children: <Widget>[
                  // Afficher ces cartes uniquement pour les mentors
                  if (isMentor == 1) ...[
                    ProfileCardWidget(
                      title: 'A propos',
                      desc: '1 propos',
                      icon: Icons.list,
                      iconColor: AppTheme.iconColors[0],
                      onTap: () {
                        showCustomDialog(context, 'A propos', propos);
                      },
                    ),
                    ProfileCardWidget(
                      title: 'Accomplissement',
                      desc: '2 accomplissement',
                      icon: Icons.bookmark,
                      iconColor: AppTheme.iconColors[1],
                      onTap: () {
                        showCustomDialog(
                            context, 'Accomplissement', accomplissement);
                      },
                    ),
                    ProfileCardWidget(
                      title: 'Compétence',
                      desc: competence.isNotEmpty ? competence : 'Pas d\'info',
                      icon: Icons.calendar_today,
                      iconColor: AppTheme.iconColors[2],
                      onTap: () {
                        showCustomDialog(context, 'Compétence', competence);
                      },
                    ),
                    ProfileCardWidget(
                      title: 'Prix (Ariary)',
                      desc: prix.isNotEmpty ? prix : 'Pas d\'info',
                      icon: Icons.local_atm,
                      iconColor: AppTheme.iconColors[3],
                      onTap: () {
                        showCustomDialog(context, 'Prix', prix);
                      },
                    ),
                  ],

                  ProfileCardWidget(
                    title: 'Profil',
                    desc:
                        profil.isNotEmpty ? 'Photo disponible' : 'Pas de photo',
                    icon: Icons.camera,
                    iconColor: AppTheme.iconColors[4],
                    onTap: () {
                      // Vérifier si l'URL du profil est valide et afficher l'image
                      if (profil.isNotEmpty || profil2.isNotEmpty) {
                        showCustomDialog(context, 'Profil',
                            profil.isNotEmpty ? profil : profil2,
                            isImage: true);
                      } else {
                        showCustomDialog(
                            context, 'Profil', 'Aucune photo disponible');
                      }
                    },
                  ),

                  ProfileCardWidget(
                    title: 'Contact',
                    desc: contact.isNotEmpty ? contact : contact2,
                    icon: Icons.phone,
                    iconColor: AppTheme.iconColors[1],
                    onTap: () {
                      showCustomDialog(context, 'Contact',
                          contact.isNotEmpty ? contact : contact2);
                    },
                  ),
                  ProfileCardWidget(
                    title: 'Email',
                    desc: email.isNotEmpty ? email : email2,
                    icon: Icons.mail,
                    iconColor: AppTheme.iconColors[3],
                    onTap: () {
                      showCustomDialog(
                          context, 'Email', email.isNotEmpty ? email : email2);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCustomDialog(BuildContext context, String title, String content,
      {bool isImage = false}) {
    TextEditingController textController = TextEditingController(text: content);
    bool isEditing = false;
    bool isLoading = true;
    String imageUrl = content;
    File? selectedImage;
    String? dropdownValue;

    List<String> dropdownOptions = [
      'Général',
      'Bureautique',
      'Info braille',
      'Communication',
      'MS word',
      'MS Excel',
      'Power Point',
      'Mobile'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Provider.of<ThemeProvider>(context).currentTheme;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: theme.scaffoldBackgroundColor,
              title: Text(
                title,
                style: TextStyle(
                  fontSize: isLargeTextMode ? 32.sp : 22.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Jersey',
                  color: Theme.of(context).textTheme.bodyText1?.color,
                ),
              ),
              content: isImage
                  ? Stack(
                      children: [
                        selectedImage != null
                            ? Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Text(
                                    'Impossible de charger l\'image',
                                    style: TextStyle(
                                      fontSize: isLargeTextMode ? 24.sp : 16.sp,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.color,
                                    ),
                                  );
                                },
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    Future.microtask(() {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    });
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  }
                                },
                              ),
                        if (isLoading)
                          const Center(
                            child:
                                CircularProgressIndicator(), // Affichage pendant le chargement
                          ),
                      ],
                    )
                  : SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height *
                              0.6, // Limite la hauteur à 60% de la taille de l'écran
                        ),
                        child: isEditing
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (title == 'Compétence')
                                    DropdownButton<String>(
                                      dropdownColor:
                                          theme.scaffoldBackgroundColor,
                                      value: dropdownValue,
                                      hint: Text('Sélectionner une option',
                                          style: TextStyle(
                                            fontSize:
                                                isLargeTextMode ? 20.sp : 14.sp,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.color,
                                          )),
                                      isExpanded: true,
                                      items:
                                          dropdownOptions.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              style: TextStyle(
                                                fontSize: isLargeTextMode
                                                    ? 20.sp
                                                    : 14.sp,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.color,
                                              )),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          dropdownValue = newValue;
                                        });
                                      },
                                    )
                                  else
                                    TextField(
                                      controller: textController,
                                      decoration: const InputDecoration(
                                        labelText: 'Modifier',
                                        border: OutlineInputBorder(),
                                      ),
                                      style: TextStyle(
                                        fontSize:
                                            isLargeTextMode ? 24.sp : 16.sp,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.color,
                                      ),
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                    ),
                                ],
                              )
                            : Text(
                                content,
                                style: TextStyle(
                                  fontSize: isLargeTextMode ? 24.sp : 16.sp,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.color,
                                ),
                              ),
                      ),
                    ),
              actions: <Widget>[
                if (isImage)
                  TextButton(
                    onPressed: () async {
                      File? newImage = await _pickImage();

                      if (newImage != null) {
                        setState(() {
                          isLoading = false;
                          selectedImage = newImage;
                        });
                      }
                    },
                    child: Text('+ Changer profil',
                        style: TextStyle(
                          fontSize: isLargeTextMode ? 20.sp : 14.sp,
                          color: Theme.of(context).textTheme.bodyText1?.color,
                        )),
                  ),
                if (!isEditing)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                    child: Text('Modifier',
                        style: TextStyle(
                          fontSize: isLargeTextMode ? 20.sp : 14.sp,
                          color: Theme.of(context).textTheme.bodyText1?.color,
                        )),
                  ),
                if (isEditing)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isEditing = false;
                        if (title == 'Compétence') {
                          content = dropdownValue ?? '';
                        } else if (title == 'Profil') {
                          deleteImageFromStorage(imageUrl);
                        } else {
                          content = textController.text;
                          handleUpdate(title, content);
                        }
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Enregistrer',
                        style: TextStyle(
                          fontSize: isLargeTextMode ? 20.sp : 14.sp,
                          color: Theme.of(context).textTheme.bodyText1?.color,
                        )),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Fermer',
                      style: TextStyle(
                        fontSize: isLargeTextMode ? 20.sp : 14.sp,
                        color: Theme.of(context).textTheme.bodyText1?.color,
                      )),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<File?> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      return File(pickedFile.path);
    }
    return null;
  }

  void handleUpdate(String title, String newValue) {
    switch (title) {
      case 'A propos':
        DatabaseHelper().updateMentorAbout(0, newValue);
        updateMentorDescription(IdFireBase, newValue);
        break;
      case 'Accomplissement':
        DatabaseHelper().updateMentorAccomplishment(0, newValue);
        updateMentorAccomplissements(IdFireBase, newValue);
        break;
      case 'Compétence':
        DatabaseHelper().updateMentorCompetence(0, newValue);
        updateMentorSpecialty(IdFireBase, newValue);
        break;
      case 'Prix':
        DatabaseHelper().updateMentorPrice(0, newValue);
        updateMentorPrice(IdFireBase, newValue);
        break;

      case 'Contact':
        DatabaseHelper().updateMentorContact(0, newValue);
        updateMentorContact(IdFireBase, newValue);
        break;
      case 'Appuyer ici pour':
        print('Se déconnecter appuiez par l\'utilisateur');
        break;
      default:
        print('Aucune mise à jour spécifique trouvée pour ce titre.');
    }
  }
}
