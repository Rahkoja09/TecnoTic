import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ticeo/mentoring/helper/color.dart';
import 'package:ticeo/mentoring/helper/m_fonts.dart';
import 'package:ticeo/mentoring/model/mentor_model.dart';
import 'package:ticeo/mentoring/profile_page.dart';
import 'package:ticeo/mentoring/widget/ratings.dart';

class MentoringHomePage extends StatefulWidget {
  const MentoringHomePage({super.key});

  @override
  _MentoringHomePageState createState() => _MentoringHomePageState();
}

class _MentoringHomePageState extends State<MentoringHomePage> {
  final List<MentorModel> list = [
    MentorModel(
        name: "Stefan stefencfik",
        image: "assets/images/face_1.jpg",
        type: "Bureautique",
        price: 35,
        ratings: 4),
    MentorModel(
        name: "Jenny Nackos",
        image: "assets/images/face_2.jpg",
        type: "Info braille",
        price: 65,
        ratings: 5),
    MentorModel(
        name: "Joseph Gonzalez",
        image: "assets/images/face_3.jpg",
        type: "Communication",
        price: 30,
        ratings: 3),
    MentorModel(
        name: "Jenny Leiefser",
        image: "assets/images/face_4.jpg",
        type: "Bureatique",
        price: 80,
        ratings: 5),
  ];

  Widget _appBar() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.menu,
          size: 28.0.sp,
          color: const Color.fromARGB(255, 129, 129, 129),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {},
          child: Text(
            'S\'inscrire ',
            style: TextStyle(
                fontFamily: 'Jersey',
                fontSize: 24.0.sp,
                color: const Color.fromARGB(255, 28, 105, 168)),
          ),
        ),
        const Spacer(),
        Icon(
          Icons.notifications_none,
          size: 28.0.sp,
          color: const Color.fromARGB(255, 172, 135, 96),
        ),
      ],
    );
  }

  Widget _searchBar(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return Container(
      height: 40.0.h,
      margin: EdgeInsets.symmetric(vertical: 20.0.h),
      decoration: BoxDecoration(
        color: const Color(0xffd2d1e1).withOpacity(.3),
        borderRadius: BorderRadius.circular(20.0.r),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(width: 16.0.w),
          const Icon(Icons.search),
          SizedBox(width: 12.0.w),
          SizedBox(
            width: MediaQuery.of(context).size.width - 150.0.w,
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Recherche mentor(exemple: Bureatique, Rakoto)",
                  hintStyle: GoogleFonts.inter(fontSize: 11.0.sp),
                  border: InputBorder.none),
            ),
          ),
          const Spacer(),
          Container(
              width: 50.0.w,
              height: 50.0.h,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 26, 72, 112),
                borderRadius: BorderRadius.circular(20.0.r),
              ),
              child: RotatedBox(
                  quarterTurns: 1,
                  child: Icon(Icons.search_rounded,
                      size: 22.0.sp, color: Colors.white)))
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
                    fontSize: 14.0.sp, color: Colors.black87)),
            SizedBox(
                width: 49.0.w,
                child: Divider(
                  color: MColor.green,
                  thickness: 4.0.h,
                ))
          ],
        ),
        SizedBox(width: 12.0.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Par popularité",
                style:
                    GoogleFonts.inter(fontSize: 14.0.sp, color: Colors.black38))
          ],
        ),
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
              height: 60.0.h,
              width: 60.0.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0.r),
                  image: DecorationImage(
                    image: AssetImage(model.image),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      blurRadius: 15.0.r,
                      color: Colors.grey.shade400,
                      offset: Offset(4.0.w, 2.0.h),
                    )
                  ]),
            ),
            SizedBox(
              width: 12.0.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(model.name,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600, fontSize: 15.0.sp)),
                SizedBox(height: 5.0.h),
                Text(model.type,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w300,
                        fontSize: 10.0.sp,
                        color: Colors.black54)),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Ratings(rating: model.ratings),
                SizedBox(height: 5.0.h),
                Text("\Ar ${model.price}",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0.sp,
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
                        fontSize: 28.0.sp,
                        fontFamily: 'Jersey',
                        color: Color.fromARGB(221, 66, 66, 66),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Meilleur mentor pour vous guider",
                      style: TextStyle(
                        fontSize: 28.0.sp,
                        fontFamily: 'Jersey',
                        color: Color.fromARGB(221, 59, 113, 183),
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
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return _cards(context, list[index]);
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
