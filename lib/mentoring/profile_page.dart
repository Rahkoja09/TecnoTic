// ignore_for_file: avoid_print, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/mentoring/helper/color.dart';
import 'package:ticeo/mentoring/model/mentor_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, this.model}) : super(key: key);
  final MentorModel? model;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isStarred = false;

  String idUserDmd = "";
  String nameUserDemande = '';
  String contactUserDemande = '';
  String contactMentor = '';
  String reason = 'Demande de mentoring';
  String UrlPhotoUser = '';
  bool isLargeTextMode = false;
  int isMentor = 0;
  bool isRequestAvailable = true;

  @override
  void initState() {
    super.initState();
    _checkMentoringRequestAvailability();
    _checkIfRated(widget.model!.details.contact);
    _initializeData();
  }

  Future<void> _checkMentoringRequestAvailability() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      var userInfo = await DatabaseHelper().getUser();

      if (currentUser != null && userInfo!.isNotEmpty) {
        String idUser = userInfo.first['idFireBase'];
        DocumentReference userDocRef =
            FirebaseFirestore.instance.collection('Utilisateurs').doc(idUser);

        DocumentSnapshot userSnapshot = await userDocRef.get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;

          DateTime lastRequestDate =
              userData['lastRequestDate']?.toDate() ?? DateTime(2000);
          int requestsToday = userData['requestsToday'] ?? 0;

          DateTime today = DateTime.now();
          DateTime todayMidnight = DateTime(today.year, today.month, today.day);
          DateTime nextDay = todayMidnight.add(const Duration(days: 1));

          // Check if last request was before today
          if (lastRequestDate.isBefore(todayMidnight)) {
            // Reset request count and update last request date
            await userDocRef.update({
              'requestsToday': 0,
              'lastRequestDate': todayMidnight,
            });
            setState(() {
              isRequestAvailable = true;
            });
          } else if (requestsToday < 5) {
            // Requests are still available
            setState(() {
              isRequestAvailable = true;
            });
          } else {
            // No requests available until the next day
            setState(() {
              isRequestAvailable = false;
            });
          }
        } else {
          // If no user document exists, create it with initial values
          await userDocRef.set({
            'requestsToday': 0,
            'lastRequestDate': DateTime(2000), // Default old date
          });
          setState(() {
            isRequestAvailable = true;
          });
        }
      }
    } catch (e) {
      print("Error checking mentoring request availability: $e");
    }
  }

  Future<void> _showConfirmationDialog(BuildContext context, String idUserDmd,
      String reason, String contact) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // L'utilisateur doit appuyer sur un bouton pour fermer
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Voulez-vous vraiment envoyer cette demande de mentorat ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
            ),
            TextButton(
              child: Text('Confirmer'),
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
                SendDemandeMentoring(
                    idUserDmd, reason, widget.model!.details.contact);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _initializeData() async {
    await _loadPreferences();
    await getUser();
    await getMentor();
    setState(() {
      // Force la mise à jour de l'état après que toutes les données aient été chargées
    });
  }

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      isLargeTextMode = mode == 'largePolice';
    });
  }

  List<Map<String, String>> _parseAccomplishments(String accomplishments) {
    List<Map<String, String>> parsedAccomplishments = [];
    final RegExp exp = RegExp(r'([^:]+):\s*([^.]*)\.', multiLine: true);
    final Iterable<RegExpMatch> matches = exp.allMatches(accomplishments);

    for (final match in matches) {
      final title = match.group(1)?.trim() ?? 'Titre non disponible';
      final description =
          match.group(2)?.trim() ?? 'Description non disponible';
      parsedAccomplishments.add({'title': title, 'description': description});
    }

    return parsedAccomplishments;
  }

  Future<void> _addRate(String contact) async {
    try {
      // Rechercher le document du mentor via le champ 'contact'
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Mentors')
          .where('contact', isEqualTo: contact)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Récupérer le premier document trouvé
        DocumentSnapshot mentorSnapshot = querySnapshot.docs.first;
        DocumentReference mentorRef = mentorSnapshot.reference;

        // Obtenir les données actuelles
        int currentRates =
            (mentorSnapshot.data() as Map<String, dynamic>)['rates'];

        if (currentRates == 12) {
          print('vous êtes déjà un super mentor');
        } else if (currentRates < 12) {
          await mentorRef.update({
            'rates': currentRates + 1,
          });
        }

        // Mettre à jour l'information pour l'utilisateur qu'il a déjà noté ce mentor
        await FirebaseFirestore.instance
            .collection('Utilisateurs')
            .doc(idUserDmd) // ID utilisateur
            .set({
          'ratedMentors':
              FieldValue.arrayUnion([contact]), // Ajouter le mentor à la liste
        }, SetOptions(merge: true));

        print('Rates updated successfully!');
      } else {
        print('Mentor not found with contact: $contact');
      }
    } catch (e) {
      print('Error updating rates: $e');
    }
  }

  bool _isStarVisible = true;

  Future<void> _checkIfRated(String contact) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String idUserDmd = currentUser.uid;

        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('Utilisateurs')
            .doc(idUserDmd)
            .get();

        if (userSnapshot.exists) {
          List<dynamic> ratedMentors =
              (userSnapshot.data() as Map<String, dynamic>)['ratedMentors'] ??
                  [];
          if (ratedMentors.contains(contact)) {
            setState(() {
              _isStarVisible = false;
            });
          }
        }
      } else {
        print('Utilisateur non connecté');
      }
    } catch (e) {
      print('Error checking if mentor is rated: $e');
    }
  }

  Future<void> getMentor() async {
    await getIsMentor();
    if (isMentor == 1) {
      var infoMentor = await DatabaseHelper().getMentor();
      if (infoMentor!.isNotEmpty) {
        contactMentor = infoMentor.first['Contact'];
      }
    } else {
      contactMentor = 'SureToNotCorrEspond!?.';
      print(contactMentor);
    }
  }

  Future<void> getUser() async {
    var infoUser = await DatabaseHelper().getUser();
    if (infoUser!.isNotEmpty) {
      idUserDmd = infoUser.first['idFireBase'];
      nameUserDemande = infoUser.first['nom'];
      contactUserDemande = infoUser.first['telephone'];
      UrlPhotoUser = infoUser.first['profileImageUrl'];
    } else {
      print(
          "Erreur lors de la recuperation des information utilisateur dans local_db.db");
    }
  }

  Future<void> getIsMentor() async {
    var infoUser = await DatabaseHelper().getUser();
    if (infoUser!.isNotEmpty) {
      isMentor = infoUser.first['isMentor'];
    } else {
      print(
          "Erreur lors de la recuperation des information utilisateur dans local_db.db");
    }
  }

  Future<void> SendDemandeMentoring(
      String idUserDmd, String reason, String contact) async {
    if (!isRequestAvailable) return;

    try {
      // Récupérer le nom de l'utilisateur à partir de son idFirebase
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Utilisateurs')
          .doc(idUserDmd)
          .get();
      if (!userSnapshot.exists) {
        print("Utilisateur introuvable");
        return;
      }

      // Récupérer les données de l'utilisateur
      String nameUserDemande = userSnapshot['NomUtil'];
      String contactUserDemande = userSnapshot['TelUtil'];
      String UrlPhotoUser = userSnapshot['ProfileImageUrl'];

      // Rechercher le mentor correspondant au contact donné dans la collection 'Mentors'
      QuerySnapshot mentorQuery = await FirebaseFirestore.instance
          .collection('Mentors')
          .where('contact', isEqualTo: contact)
          .get();

      if (mentorQuery.docs.isEmpty) {
        print("Aucun mentor trouvé avec ce contact");
        return;
      }

      // Récupérer le document du mentor
      DocumentReference mentorRef = mentorQuery.docs.first.reference;

      // Accéder au champ 'Notifications' du document du mentor
      DocumentSnapshot mentorSnapshot = await mentorRef.get();
      Map<String, dynamic> notifications =
          (mentorSnapshot.data() as Map<String, dynamic>)['Notifications'] ??
              {};

      // Trouver la dernière notification 'notifX' existante
      int lastNotifIndex = -1;
      notifications.forEach((key, value) {
        if (key.startsWith('notif')) {
          int index = int.tryParse(key.substring(5)) ?? -1;
          if (index > lastNotifIndex) {
            lastNotifIndex = index;
          }
        }
      });

      // Créer le nom de la nouvelle notification (notifX+1)
      String newNotifKey = 'notif${lastNotifIndex + 1}';

      // Récupérer la date et l'heure actuelles
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

      // Ajouter la nouvelle notification avec 'NameUserDemande' et 'Reason'
      notifications[newNotifKey] = {
        'DateDemande': formattedDate,
        'idUserDemande': idUserDmd,
        'Contact': contactUserDemande,
        'NameUserDemande': nameUserDemande,
        'UserPhoto': UrlPhotoUser,
        'Reason': reason,
      };

      // Mettre à jour le document avec la nouvelle notification
      await mentorRef.update({'Notifications': notifications});

      // Enregistrer l'heure de la demande dans SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'lastMentorRequestDate', DateTime.now().toIso8601String());

      // Mettre à jour l'état pour indiquer que la demande n'est plus disponible
      setState(() {
        isRequestAvailable = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Demande de mentorat envoyée avec succès !')),
      );

      print("Notification ajoutée avec succès !");
    } catch (e) {
      print("Erreur lors de l'envoi de la demande de mentoring : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _appBar(context),
                _cards(context),
                SizedBox(height: 20.h),
                _description(),
                SizedBox(height: 20.h),
                _achivment(),
                if (contactMentor != widget.model?.details.contact) _button(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar(context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Icon(
              Icons.arrow_back,
              size: isLargeTextMode ? 32.sp : 24.sp,
            ),
          ),
        ),
        Spacer(),
        if (_isStarVisible && contactMentor != widget.model?.details.contact)
          IconButton(
            icon: Icon(
              _isStarred ? Icons.star : Icons.star_border,
              color: _isStarred
                  ? Colors.blue
                  : Theme.of(context).textTheme.bodyText1?.color,
              size: isLargeTextMode ? 32.sp : 24.sp,
            ),
            onPressed: () {
              _addRate(widget.model!.details.contact);
              setState(() {
                _isStarred = !_isStarred;
                _isStarVisible = false;
              });
            },
          ),
      ],
    );
  }

  Widget _cards(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(model: widget.model)));
        },
        child: Row(
          children: <Widget>[
            Container(
              height: isLargeTextMode ? 120.h : 85.h,
              width: isLargeTextMode ? 120.w : 85.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                image: DecorationImage(
                  image: NetworkImage(widget.model!.image),
                  onError: (error, stackTrace) {
                    print('Error loading image: $error');
                  },
                  fit: BoxFit.cover,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 10.r,
                    color: Colors.grey.shade400,
                    offset: Offset(4.w, 4.h),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                decoration: BoxDecoration(
                  border: Border.all(color: MColor.grey.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.phone,
                            color: MColor.yellow,
                            size: isLargeTextMode ? 28.sp : 15.sp),
                        SizedBox(height: 5.h),
                        // Text("${widget.model?.details.heure ?? 'test'} heures",
                        //     style: GoogleFonts.inter(
                        //       fontWeight: FontWeight.w300,
                        //       fontSize: 12.sp,
                        //     )),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text("Contact ",
                            style: GoogleFonts.inter(
                                fontSize: isLargeTextMode ? 18.sp : 10.sp)),
                        SizedBox(height: 8.h),
                        Text(widget.model?.details.contact ?? '',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w300,
                              fontSize: isLargeTextMode ? 18.sp : 12.sp,
                              color:
                                  Theme.of(context).textTheme.bodyText1?.color,
                            )),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (isLargeTextMode)
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  // Ajout de Column ici pour afficher de haut en bas
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.model?.name ?? "Nom non disponible",
                      style: TextStyle(
                          fontSize: isLargeTextMode ? 28.sp : 20.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                          fontFamily: "Jersey"),
                      softWrap: true,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "\Ar ${widget.model?.price ?? '00.0'}",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: isLargeTextMode ? 20.sp : 14.sp,
                        color: Theme.of(context).textTheme.bodyText1?.color,
                      ),
                    ),
                    Text(
                      widget.model?.type ?? "Type non disponible",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w300,
                        fontSize: isLargeTextMode ? 18.sp : 10.sp,
                        color: Theme.of(context).textTheme.bodyText1?.color,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        if (!isLargeTextMode)
          Row(
            children: <Widget>[
              Expanded(
                // Ajout de Expanded ici
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.model?.name ?? "Nom non disponible",
                      style: TextStyle(
                          fontSize: isLargeTextMode ? 28.sp : 20.sp,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                          fontFamily: "Jersey"),
                      softWrap: true,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.model?.type ?? "Type non disponible",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w300,
                        fontSize: isLargeTextMode ? 18.sp : 10.sp,
                        color: Theme.of(context).textTheme.bodyText1?.color,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Text(
                "\Ar ${widget.model?.price ?? '00.0'}",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: isLargeTextMode ? 20.sp : 14.sp,
                  color: Theme.of(context).textTheme.bodyText1?.color,
                ),
              ),
            ],
          ),
        SizedBox(height: 20.h),
        Text(
          'A propos de ${widget.model?.name.split(" ")[0] ?? 'Mentor'}',
          style: TextStyle(
            fontSize: isLargeTextMode ? 31.sp : 25.sp,
            fontWeight: FontWeight.w500,
            height: 1.3,
            fontFamily: "Jersey",
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          widget.model?.details.propos ?? '',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w300,
            fontSize: isLargeTextMode ? 18.sp : 12.sp,
            height: 1.4,
            color: Theme.of(context).textTheme.bodyText1?.color,
          ),
        ),
      ],
    );
  }

  Widget _achivment() {
    final accomplishments = widget.model?.details.accomplissement ?? '';
    final parsedAccomplishments = _parseAccomplishments(accomplishments);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Accomplissements',
          style: TextStyle(
              fontSize: isLargeTextMode ? 31.sp : 25.sp,
              fontWeight: FontWeight.w500,
              height: 1.3,
              fontFamily: "Jersey"),
        ),
        SizedBox(height: 16.h),
        for (int i = 0; i < parsedAccomplishments.length && i < 2; i++)
          _achivmentCard(
            parsedAccomplishments[i]['title']!,
            parsedAccomplishments[i]['description']!,
          ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _achivmentCard(String title, String description) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: MColor.grey.withOpacity(.1),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
            width: 40.w,
            alignment: Alignment.center,
            child: Icon(Icons.star_outline_rounded,
                color: MColor.yellow, size: isLargeTextMode ? 28.sp : 20.sp)),
        title: Text(title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: isLargeTextMode ? 23.sp : 15.sp,
              color: Theme.of(context).textTheme.bodyText1?.color,
            )),
        subtitle: Text(description,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontSize: isLargeTextMode ? 20.sp : 12.sp,
              color: Theme.of(context).textTheme.bodyText1?.color,
            )),
      ),
    );
  }

  Widget _button() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 19, 75, 120),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      onPressed: () {
        _showConfirmationDialog(
            context, idUserDmd, reason, widget.model!.details.contact);
      },
      child: Container(
        height: 40.h,
        alignment: Alignment.center,
        child: Text(
          'Demander Mentoring',
          style: TextStyle(
              fontFamily: 'Jersey',
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: isLargeTextMode ? 30.sp : 22.sp),
        ),
      ),
    );
  }
}
