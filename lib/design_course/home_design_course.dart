// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/design_course/category_list_view.dart';
import 'package:ticeo/design_course/course_info_screen.dart';
import 'package:ticeo/design_course/models/category.dart';
import 'package:ticeo/design_course/popular_course_list_view.dart';
import 'design_course_app_theme.dart';

class DesignCourseHomeScreen extends StatefulWidget {
  const DesignCourseHomeScreen({super.key});
  @override
  _DesignCourseHomeScreenState createState() => _DesignCourseHomeScreenState();
}

class _DesignCourseHomeScreenState extends State<DesignCourseHomeScreen> {
  CategoryType categoryType = CategoryType.ui;
  bool _isLargeTextMode = false;
  String imageUrl = '';

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    var infoUser = await DatabaseHelper().getUser();
    if (infoUser!.isNotEmpty) {
      imageUrl = infoUser.first['profileImageUrl'];
    }
    setState(() {
      _isLargeTextMode = mode == 'largePolice';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      getSearchBarUI(),
                      getCategoryUI(),
                      Flexible(
                        child: getPopularCourseUI(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCategoryUI() {
    double fonttitlesize = _isLargeTextMode ? 34.sp : 26.sp;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 8.0.h, left: 18.0.w, right: 16.0.w),
          child: Text(
            'Modules/séances',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: fonttitlesize,
                  fontFamily: 'Jersey',
                  letterSpacing: 0.27,
                  color: Theme.of(context).textTheme.bodyText1?.color,
                ),
          ),
        ),
        SizedBox(
          height: 16.0.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w),
          child: Row(
            children: <Widget>[
              getButtonUI(CategoryType.ui, categoryType == CategoryType.ui),
              SizedBox(
                width: 16.0.w,
              ),
              getButtonUI(
                  CategoryType.coding, categoryType == CategoryType.coding),
              SizedBox(
                width: 16.0.w,
              ),
              getButtonUI(
                  CategoryType.basic, categoryType == CategoryType.basic),
            ],
          ),
        ),
        SizedBox(
          height: 16.0.h,
        ),
        const CategoryListView(),
      ],
    );
  }

  Widget getPopularCourseUI() {
    double fonttitlesize = _isLargeTextMode ? 34.sp : 26.sp;
    return Padding(
      padding: EdgeInsets.only(top: 8.0.h, left: 18.0.w, right: 16.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Modules Permetic A',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: fonttitlesize,
                  fontFamily: 'Jersey',
                  letterSpacing: 0.27,
                  color: Theme.of(context).textTheme.bodyText1?.color,
                ),
          ),
          Flexible(
            child: PopularCourseListView(
              callBack: (Category category) {
                moveTo(category);
              },
            ),
          )
        ],
      ),
    );
  }

  void moveTo(Category category) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CourseInfoScreen(category: category)));
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    double fontSectionsize = _isLargeTextMode ? 20.sp : 12.sp;
    String txt = '';
    if (CategoryType.ui == categoryTypeData) {
      txt = 'MS Word';
    } else if (CategoryType.coding == categoryTypeData) {
      txt = 'MS Excel';
    } else if (CategoryType.basic == categoryTypeData) {
      txt = 'Power Point';
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? Color.fromARGB(255, 19, 75, 120)
                : DesignCourseAppTheme.nearlyWhite,
            borderRadius: BorderRadius.all(Radius.circular(24.0.sp)),
            border: Border.all(color: Color.fromARGB(255, 19, 75, 120))),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: BorderRadius.all(Radius.circular(24.0.sp)),
            onTap: () {
              setState(() {
                categoryType = categoryTypeData;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(
                  top: 12.h, bottom: 12.h, left: 18.w, right: 18.w),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: fontSectionsize,
                    letterSpacing: 0.27,
                    color: isSelected
                        ? Theme.of(context).textTheme.bodyText1?.color
                        : Color.fromARGB(255, 19, 75, 120),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSearchBarUI() {
    double fontresearchsize = _isLargeTextMode ? 22.sp : 16.sp;
    return Padding(
      padding: EdgeInsets.only(top: 8.0.h, left: 18.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 64.0.h,
            child: Padding(
              padding: EdgeInsets.only(top: 8.0.h, bottom: 8.0.h),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffd2d1e1).withOpacity(.3),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(13.0.r),
                    bottomLeft: Radius.circular(13.0.r),
                    topLeft: Radius.circular(13.0.r),
                    topRight: Radius.circular(13.0.r),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w),
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0.sp,
                            color: Color.fromARGB(255, 126, 123, 123),
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Rechercher vos cours',
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontresearchsize,
                              color: const Color.fromARGB(255, 22, 190, 28),
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0.sp,
                              letterSpacing: 0.2,
                              color: Color.fromARGB(255, 162, 162, 162),
                            ),
                          ),
                          onEditingComplete: () {},
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60.0.w,
                      height: 60.0.h,
                      child: Icon(
                        Icons.search,
                        color: Color.fromARGB(255, 136, 136, 136),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    double fonttitlesize = _isLargeTextMode ? 34.sp : 26.sp;
    double fontChoisissezsize = _isLargeTextMode ? 26.sp : 18.sp;
    double imageRadusSize = _isLargeTextMode ? 34.sp : 24.sp;
    return Padding(
      padding: EdgeInsets.only(top: 8.0.h, left: 18.0.w, right: 18.0.w),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Choisissez votre :',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: fontChoisissezsize,
                    fontFamily: 'Jersey',
                    letterSpacing: 0.2,
                    color: Theme.of(context).textTheme.bodyText1?.color,
                  ),
                ),
                Text(
                  'Cours et mentorat de Tecno-Tic',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: fonttitlesize,
                    fontFamily: 'Jersey',
                    letterSpacing: 0.27,
                    color: Theme.of(context).textTheme.bodyText1?.color,
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: imageRadusSize,
            backgroundImage: NetworkImage(imageUrl),
          )
        ],
      ),
    );
  }
}

enum CategoryType {
  ui,
  coding,
  basic,
}
