// ignore_for_file: library_private_types_in_public_api, camel_case_types, unnecessary_brace_in_string_interps, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/TaskMentoring/screens/home_page.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/design_course/design_course_app_theme.dart';
import 'package:ticeo/design_course/models/category.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:ticeo/mentoring/mentoring_home.dart';

class Principal_content extends StatefulWidget {
  final String titre;
  final Category category;
  const Principal_content(
      {super.key, required this.titre, required this.category});

  @override
  _PrincipalContentState createState() => _PrincipalContentState();
}

class _PrincipalContentState extends State<Principal_content>
    with TickerProviderStateMixin {
  final double infoHeight = 364.h;
  AnimationController? animationController;
  Animation<double>? animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;

  late Future<Map<String, dynamic>> contentData;
  late ScrollController _scrollController;

  bool isLargeTextMode = false;

  // Déplacer currentGrandTitleIndex et grandTitles ici
  int currentGrandTitleIndex = 0;
  List<String> grandTitles = [];
  Map<String, List<Map<String, dynamic>>> groupedContents = {};

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
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    contentData = getData(widget.titre);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> getData(String id) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('CoursTiceo')
          .where('Nom_Module', isEqualTo: widget.category.title)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print(
            'Aucun document trouvé dans CoursTiceo pour le module: ${widget.category.title}.');
        return {};
      }

      final moduleDoc = querySnapshot.docs.first;
      final seancesCollection = moduleDoc.reference.collection('Seances');
      final seancesDoc = seancesCollection.doc(id);
      final contenusCollection = seancesDoc.collection('Contenus');
      final contentsSnapshot = await contenusCollection.get();

      if (contentsSnapshot.size == 0) {
        print('Aucun document trouvé dans Contenus.');
        return {};
      }

      final contents = <String, dynamic>{};
      for (var doc in contentsSnapshot.docs) {
        final data = doc.data();
        final title = doc.id;

        data.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            value.forEach((subKey, subValue) {
              contents['$title - $key - $subKey'] = subValue;
            });
          } else {
            contents['$title - $key'] = value;
          }
        });
      }
      return contents;
    } catch (e) {
      print('Erreur lors de la récupération des données: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    bool isLastContent = false;
    final double tempHeight =
        ScreenUtil().screenHeight - (ScreenUtil().screenWidth / 1.2) + 24.h;

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: widget.titre,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 28.sp,
          fontFamily: 'Jersey',
          letterSpacing: 0.27,
          color: const Color.fromARGB(255, 55, 55, 55),
        ),
      ),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: ScreenUtil().screenWidth - 60.w);

    final double textHeight = textPainter.size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                width: ScreenUtil().screenWidth,
                height: 140.h + textHeight, // Ajuster la hauteur
                child: Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.2,
                      child: Image.asset(
                        'assets/design_course/bcg2.png',
                        fit: BoxFit.cover,
                        width: ScreenUtil().screenWidth,
                        height: 250.h,
                      ),
                    ),
                    Positioned(
                      top: isLargeTextMode ? 20.h : 20.h,
                      left: 30.w,
                      child: SizedBox(
                        width: ScreenUtil().screenWidth - 60.w,
                        child: Text(
                          widget.titre,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: isLargeTextMode ? 34.sp : 28.sp,
                            fontFamily: 'Jersey',
                            letterSpacing: 0.27,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20.h,
                      left: 20.w,
                      child: Row(
                        children: <Widget>[
                          getTimeBoxUI('2', 'Heures'),
                          SizedBox(width: 6.w),
                          getTimeBoxUI('3', 'Cours'),
                          SizedBox(
                            width: 10.w,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MentoringHomePage()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 109, 171, 234),
                              padding: EdgeInsets.symmetric(
                                vertical: 14.h,
                                horizontal: 32.w,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Mentoring',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isLargeTextMode ? 24.sp : 18.sp,
                                  fontFamily: 'Jersey',
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 140.h + textHeight - 24.h,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: DesignCourseAppTheme.grey.withOpacity(0.2),
                    offset: const Offset(1.1, 1.1),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: FutureBuilder<Map<String, dynamic>>(
                  future: contentData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erreur: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Aucun contenu disponible.'));
                    } else {
                      final contents = snapshot.data!;
                      final displayedGrandTitles = <String>{};

                      // Grouper les contenus par grand titre
                      contents.entries.forEach((entry) {
                        final keyParts = entry.key.split(' - ');
                        final grandTitle =
                            keyParts.isNotEmpty ? keyParts.first : '';

                        if (!groupedContents.containsKey(grandTitle)) {
                          groupedContents[grandTitle] = [];
                          grandTitles.add(
                              grandTitle); // Ajouter les grands titres à la liste
                        }

                        groupedContents[grandTitle]!.add({
                          'key': entry.key,
                          'content': entry.value,
                        });
                      });

                      // Vérifier que l'index actuel ne dépasse pas le nombre de grands titres
                      if (currentGrandTitleIndex >= grandTitles.length) {
                        currentGrandTitleIndex = grandTitles.length - 1;
                      }

                      // Obtenir le contenu du grand titre actuel
                      final currentGrandTitle =
                          grandTitles[currentGrandTitleIndex];
                      final currentContentList =
                          groupedContents[currentGrandTitle]!;

                      print('------- $currentContentList');

                      final contentWidgets = <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 40.h, bottom: 10.h),
                          child: FadeIn(
                            duration: Duration(milliseconds: 500),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.book,
                                  color: Color.fromARGB(255, 199, 125, 61),
                                  size: isLargeTextMode ? 26.sp : 18.sp,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    currentGrandTitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Jersey',
                                          fontSize:
                                              isLargeTextMode ? 36.sp : 26.sp,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.color,
                                          letterSpacing: 1.2,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ];

                      // Afficher les contenus liés au grand titre actuel
                      currentContentList.forEach((contentData) {
                        final content = contentData['content'];

                        final key = contentData['key'] as String;
                        final keyParts = key.split(' - ');
                        final subTitle =
                            keyParts.length > 2 ? keyParts.last : '';
                        final isImage =
                            keyParts.any((part) => part.contains('image'));

                        if (!isImage && subTitle.isNotEmpty) {
                          contentWidgets.add(
                            Padding(
                              padding: EdgeInsets.only(top: 18.h),
                              child: FadeIn(
                                duration: Duration(milliseconds: 300),
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.arrowRightLong,
                                      color: Colors.green,
                                      size: isLargeTextMode ? 24.sp : 18.sp,
                                    ),
                                    SizedBox(width: 6.w),
                                    Expanded(
                                      child: Text(
                                        subTitle,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: isLargeTextMode
                                                  ? 24.sp
                                                  : 18.sp,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.color,
                                              letterSpacing: 0.8,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        if (content is List) {
                          contentWidgets.addAll(
                            content.map<Widget>((item) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top: 4.h, bottom: 4.h, left: 16.w),
                                child: Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.checkCircle,
                                      size: isLargeTextMode ? 20.sp : 12.sp,
                                      color: Color.fromARGB(255, 25, 95, 192),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        '$item \n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize:
                                              isLargeTextMode ? 24.sp : 16.sp,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }

                        if (content is String && !isImage) {
                          contentWidgets.add(
                            Padding(
                              padding: EdgeInsets.only(left: 16.w, top: 2.h),
                              child: Text(
                                content,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: isLargeTextMode ? 24.sp : 16.sp,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.color,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          );
                        }

                        if (isImage) {
                          contentWidgets.add(
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: isLargeTextMode ? 10.w : 16.w,
                                  horizontal: isLargeTextMode ? 10.w : 16.w),
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Image.network(content as String),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      });

                      return SingleChildScrollView(
                        controller:
                            _scrollController, // Ajouté le ScrollController
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...contentWidgets,
                            SizedBox(height: 20.h),
                            Row(
                              children: [
                                Spacer(),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12.h, horizontal: 24.w),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    backgroundColor:
                                        Color.fromARGB(255, 19, 75, 120),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      // Réinitialisation des contenus pour éviter la duplication
                                      groupedContents.clear();

                                      // Incrémenter l'index et utiliser le modulo pour revenir au début
                                      currentGrandTitleIndex =
                                          (currentGrandTitleIndex + 1) %
                                              grandTitles.length;

                                      // Réinitialiser le défilement
                                      _scrollController.animateTo(
                                        0.0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    });

                                    // Si on revient au début de la boucle (currentGrandTitleIndex == 0)
                                    if (currentGrandTitleIndex == 0) {
                                      await showDialog(
                                        context: context,
                                        builder: (_) => CongratsPopup(),
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Suivant',
                                    style: TextStyle(
                                      fontSize: isLargeTextMode ? 26.sp : 16.sp,
                                      color: Colors.white,
                                      fontFamily: 'Jersey',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            )
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
            child: SizedBox(
              width: AppBar().preferredSize.height.w,
              height: AppBar().preferredSize.height.h,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(AppBar().preferredSize.height),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getTimeBoxUI(String text1, String txt2) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.all(
              Radius.circular(12.0)), // Réduit le rayon de bord
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: DesignCourseAppTheme.grey
                    .withOpacity(0.1), // Réduit l'opacité de l'ombre
                offset: const Offset(1.1, 1.1),
                blurRadius: 6.0), // Réduit le flou de l'ombre
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
              left: 12.w,
              right: 12.w,
              top: 4.h,
              bottom: 4.h), // Réduit le padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isLargeTextMode ? 22.sp : 20.sp,
                    color: const Color.fromARGB(255, 215, 149, 42)),
              ),
              Text(txt2,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Jersey',
                        fontSize: isLargeTextMode ? 24.sp : 18.sp,
                        color: Theme.of(context).textTheme.bodyText1?.color,
                      )),
            ],
          ),
        ),
      ),
    );
  }
}

class CongratsPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle),
        Text("Félicitations!"),
        Text("N'hésitez pas à réviser certains cours..."),
        ElevatedButton(
            onPressed: () => Navigator.pop(context), child: Text("Ok"))
      ],
    );
  }
}
