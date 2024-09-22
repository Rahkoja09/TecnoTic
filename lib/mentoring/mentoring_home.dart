// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/mentoring/helper/color.dart';
import 'package:ticeo/mentoring/helper/m_fonts.dart';
import 'package:ticeo/mentoring/model/form_mentor.dart';
import 'package:ticeo/mentoring/model/mentor_model.dart';
import 'package:ticeo/mentoring/profile_page.dart';
import 'package:ticeo/mentoring/widget/ratings.dart';
import 'package:ticeo/settings/settingsHome.dart';

class MentoringHomePage extends StatefulWidget {
  const MentoringHomePage({super.key});

  @override
  _MentoringHomePageState createState() => _MentoringHomePageState();
}

class _MentoringHomePageState extends State<MentoringHomePage> {
  TextEditingController _searchController = TextEditingController();
  List<MentorModel> mentorList = [];
  List<MentorModel2> mentorList2 = [];
  List<MentorModel> filteredMentorList = [];
  bool Mentoring = true;
  var isMentorValue;

  bool isLargeTextMode = false;

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      isLargeTextMode = mode == 'largePolice';
    });
  }

// 3 étoiles ne vaux que 1 étoile
  double ratingsTrans(double ratings) {
    return ratings / 3;
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _isMentor();
    _fetchMentors();
    _searchController.addListener(_filterMentors);
  }

  _isMentor() async {
    isMentorValue = (await DatabaseHelper().getisMentor());
    print('voici la valeur de ismentorvalue : $isMentorValue');
    setState(() {
      if (isMentorValue == 1) {
        Mentoring = false;
      } else {
        Mentoring = true;
      }
    });
  }

  void _filterMentors() {
    String searchTerm = _searchController.text.toLowerCase();
    setState(() {
      if (searchTerm.isEmpty) {
        filteredMentorList = mentorList;
      } else {
        filteredMentorList = mentorList.where((mentor) {
          final mentorName = mentor.name.toLowerCase();
          final mentorSpecialty = mentor.type.toLowerCase();
          return mentorName.contains(searchTerm) ||
              mentorSpecialty.contains(searchTerm);
        }).toList();
      }
    });
  }

  Future<void> _fetchMentors() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Mentors')
          .where('isValide', isEqualTo: 1)
          .orderBy('rates', descending: true)
          .get();

      setState(() {
        mentorList = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          return MentorModel(
            name: data['name'] ?? '',
            image: data['image_url'] ?? '',
            type: data['specialty'] ?? '',
            price: double.parse(data['price'] ?? '0'),
            ratings: (data['rates'] is num)
                ? ratingsTrans((data['rates'] as num).toDouble())
                : 0.0,
            details: MentorModel2(
              accomplissement: data['accomplishments'] ?? '',
              contact: data['contact'] ?? '',
              heure: (data['hours'] is num) ? data['hours'].toDouble() : 0.0,
              propos: data['description'] ?? '',
            ),
          );
        }).toList();
        filteredMentorList = mentorList;
      });
    } catch (e) {
      print('Error fetching mentors: $e');
    }
  }

  Widget _appBar() {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.menu,
              color: Theme.of(context).textTheme.bodyText2?.color,
              size: isLargeTextMode ? 38.sp : 28.sp),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => SettingsPage())));
          },
          tooltip: 'Menu et paramettrage',
        ),
        const Spacer(),
        // Afficher le bouton seulement si 'Mentoring' est vrai
        if (Mentoring)
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormMentor(
                    onClose: () {},
                  ),
                ),
              );
            },
            child: Text(
              'S\'inscrire ',
              style: TextStyle(
                fontFamily: 'Jersey',
                fontSize: isLargeTextMode ? 32.sp : 24.sp,
                color: Theme.of(context).textTheme.bodyText1?.color,
              ),
            ),
          ),
        const Spacer(),
        // Icon(
        //   Icons.notifications_none,
        //   size: isLargeTextMode ? 38.sp : 28.sp,
        //   color: Theme.of(context).textTheme.bodyText1?.color,
        // ),
      ],
    );
  }

  Widget _searchBar(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return Container(
      height: isLargeTextMode ? 48.h : 40.h,
      margin: EdgeInsets.symmetric(vertical: 20.0.h),
      decoration: BoxDecoration(
        color: const Color(0xffd2d1e1).withOpacity(.3),
        borderRadius: BorderRadius.circular(20.0.r),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(width: 16.0.w),
          const Icon(
            Icons.search,
          ),
          SizedBox(width: 12.0.w),
          SizedBox(
            width: MediaQuery.of(context).size.width - 150.0.w,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  hintText: "Recherche mentor (exemple: Bureautique ou Rakoto)",
                  hintStyle: GoogleFonts.inter(
                    fontSize: isLargeTextMode ? 14.sp : 11.sp,
                    color: Theme.of(context).textTheme.bodyText1?.color,
                  ),
                  border: InputBorder.none),
            ),
          ),
          const Spacer(),
          Container(
              width: 50.0.w,
              height: 50.0.h,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 26, 72, 112),
                borderRadius: BorderRadius.circular(20.0.r),
              ),
              child: RotatedBox(
                  quarterTurns: 1,
                  child: Icon(Icons.search_rounded,
                      size: isLargeTextMode ? 32.sp : 22.sp,
                      color: Colors.white)))
        ],
      ),
    );
  }

  Widget _category(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Listes",
                style: GoogleFonts.inter(
                  fontSize: isLargeTextMode ? 24.sp : 14.sp,
                  color: Theme.of(context).textTheme.bodyText1?.color,
                )),
            SizedBox(
                width: 49.0.w,
                child: Divider(
                  color: MColor.green,
                  thickness: 4.0.h,
                ))
          ],
        ),
        SizedBox(width: 12.0.w),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: <Widget>[
        //     Text("Par popularité",
        //         style:
        //             GoogleFonts.inter(fontSize: 14.0.sp, color: Colors.black38))
        //   ],
        // ),
      ],
    );
  }

  Widget _cards(BuildContext context, MentorModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0.h),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(model: model)));
        },
        child: Row(
          children: <Widget>[
            Container(
              height: isLargeTextMode ? 80.h : 60.h,
              width: isLargeTextMode ? 80.w : 60.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0.r),
                image: DecorationImage(
                  image: NetworkImage(model.image),
                  onError: (error, stackTrace) {
                    print('Error loading image: $error');
                  },
                  fit: BoxFit.cover,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 15.0.r,
                    color: Colors.grey.shade400,
                    offset: Offset(4.0.w, 2.0.h),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 12.0.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    model.name,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: isLargeTextMode ? 20.sp : 15.sp),
                    overflow: TextOverflow
                        .ellipsis, // Tronquer si le texte est trop long
                  ),
                  SizedBox(height: 5.0.h),
                  Text(
                    model.type,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w300,
                        fontSize: isLargeTextMode ? 16.sp : 10.sp,
                        color: Theme.of(context).textTheme.bodyText1?.color),
                    overflow: TextOverflow.ellipsis, // Tronquer si nécessaire
                  ),
                ],
              ),
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Ratings(
                    rating: model.ratings, isLargeTextMode: isLargeTextMode),
                SizedBox(height: 5.0.h),
                Text("\Ar ${model.price}",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: isLargeTextMode ? 20.sp : 14.sp,
                        color: Color.fromARGB(255, 10, 148, 160))),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10.0.h),
                    _appBar(),
                    SizedBox(height: 20.0.h),
                    Text(
                      "Trouver votre",
                      style: TextStyle(
                        fontSize: isLargeTextMode ? 34.sp : 28.sp,
                        fontFamily: 'Jersey',
                        color: Theme.of(context).textTheme.bodyText1?.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Meilleur mentor pour vous guider",
                      style: TextStyle(
                        fontSize: isLargeTextMode ? 34.sp : 28.sp,
                        fontFamily: 'Jersey',
                        color: Theme.of(context).textTheme.bodyText1?.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.0.h),
                    _searchBar(context),
                    SizedBox(height: 10.0.h),
                    _category(context),
                  ],
                )),
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.w),
                child: ListView.builder(
                  itemCount: filteredMentorList.length,
                  itemBuilder: (context, index) {
                    return _cards(context, filteredMentorList[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
