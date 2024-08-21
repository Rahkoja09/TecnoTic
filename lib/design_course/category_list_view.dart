// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticeo/design_course/design_course_app_theme.dart';
import 'models/category.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key, this.callBack});

  final Function()? callBack;
  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: SizedBox(
        height: 108.h,
        width: double.infinity,
        child: ListView.builder(
          padding:
              EdgeInsets.only(top: 0.h, bottom: 0.h, right: 10.w, left: 10.w),
          itemCount: Category.categoryList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            final Animation<double> animation =
                Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animationController!,
                curve: Interval((1 / Category.categoryList.length) * index, 1.0,
                    curve: Curves.fastOutSlowIn),
              ),
            );

            if (index == Category.categoryList.length - 1) {
              animationController?.forward();
            }

            return CategoryView(
              category: Category.categoryList[index],
              animation: animation,
              animationController: animationController,
              callback: widget.callBack,
            );
          },
        ),
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView(
      {super.key,
      this.category,
      this.animationController,
      this.animation,
      this.callback});

  final VoidCallback? callback;
  final Category? category;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100.w * (1.0 - animation!.value), 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: callback,
              child: SizedBox(
                width: 280.w,
                child: Stack(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 42.w,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(29, 148, 233, 105),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0.sp)),
                            ),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 46.w + 22.w,
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: 16.h),
                                        child: Text(
                                          category!.title,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.sp,
                                            letterSpacing: 0.27,
                                            color:
                                                DesignCourseAppTheme.darkerText,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: SizedBox(),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: 16.w, bottom: 8.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '${category!.lessonCount} cours',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontSize: 10.sp,
                                                letterSpacing: 0.27,
                                                color:
                                                    DesignCourseAppTheme.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 12.h, right: 12.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '${category!.money} heures',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.sp,
                                                letterSpacing: 0.27,
                                                color: DesignCourseAppTheme
                                                    .nearlyBlue,
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: DesignCourseAppTheme
                                                    .nearlyBlue,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0.sp)),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(2.0.sp),
                                                child: Icon(
                                                  Icons.add,
                                                  color: DesignCourseAppTheme
                                                      .nearlyWhite,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 24.h, bottom: 24.h, left: 18.w),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0.sp)),
                            child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Image.asset(category!.imagePath)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
