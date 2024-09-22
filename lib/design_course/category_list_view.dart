import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
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

  bool isLargeTextMode = false;

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      isLargeTextMode = mode == 'largePolice';
    });
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    super.initState();
    _loadPreferences();
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
    // Adjust the card height and width based on the isLargeTextMode
    double cardHeight = isLargeTextMode ? 140.h : 108.h;
    double cardWidth = isLargeTextMode ? 300.w : 280.w;

    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: SizedBox(
        height: cardHeight, // Adjusted height
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
              isLargeTextMode: isLargeTextMode,
              cardWidth: cardWidth,
            );
          },
        ),
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView({
    super.key,
    this.category,
    this.animationController,
    this.animation,
    this.callback,
    this.isLargeTextMode = false,
    this.cardWidth = 280.0, // Default width
  });

  final VoidCallback? callback;
  final Category? category;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final bool isLargeTextMode;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    double titleFontSize = isLargeTextMode ? 20.sp : 14.sp;
    double subTextFontSize = isLargeTextMode ? 16.sp : 10.sp;
    double infoFontSize = isLargeTextMode ? 18.sp : 14.sp;
    double coursSpaceleft = isLargeTextMode ? 16.sp : 4.sp;
    double heureSpaceleft = isLargeTextMode ? 16.sp : 4.sp;
    double titleSpaceleft = isLargeTextMode ? 16.sp : 4.sp;

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
                width: cardWidth,
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
                                        padding: EdgeInsets.only(
                                            top: 16.h,
                                            left: titleSpaceleft,
                                            right: titleSpaceleft),
                                        child: Text(
                                          category!.title,
                                          textAlign: TextAlign.left,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: titleFontSize,
                                                letterSpacing: 0.27,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.color,
                                              ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: SizedBox(),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: 16.w,
                                            bottom: 8.h,
                                            left: coursSpaceleft),
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
                                                fontSize: subTextFontSize,
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
                                            bottom: 12.h,
                                            right: 12.w,
                                            left: heureSpaceleft),
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
                                                fontSize: infoFontSize,
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
