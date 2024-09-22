import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/design_course/design_course_app_theme.dart';
import 'models/category.dart';

class PopularCourseListView extends StatefulWidget {
  const PopularCourseListView({super.key, required this.callBack});

  final Function(Category category) callBack;

  @override
  _PopularCourseListViewState createState() => _PopularCourseListViewState();
}

class _PopularCourseListViewState extends State<PopularCourseListView>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Future<void> _fetchData;
  bool isLargeTextMode = false;

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      isLargeTextMode = mode == 'largePolice';
    });
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fetchData = _loadData();
    _loadPreferences();
  }

  Future<void> _loadData() async {
    final category = Category();
    await category.fetchPopularCourses();
    setState(() {}); // Met à jour l'état pour reconstruire le widget
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FutureBuilder<void>(
        future: _fetchData,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 28.0,
                crossAxisSpacing: 28.0,
                childAspectRatio: 0.8,
              ),
              itemCount: Category.popularCourseList.length,
              itemBuilder: (BuildContext context, int index) {
                final int count = Category.popularCourseList.length;
                final category = Category.popularCourseList[index];
                final Animation<double> animation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animationController,
                    curve: Interval((1 / count) * index, 1.0,
                        curve: Curves.fastOutSlowIn),
                  ),
                );
                animationController.forward();

                return GestureDetector(
                  onTap: () {
                    widget.callBack(category);
                  },
                  child: CategoryView(
                    callback: () {
                      widget.callBack(category);
                    },
                    category: category,
                    animation: animation,
                    animationController: animationController,
                    isLargeTextMode: isLargeTextMode,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView({
    super.key,
    this.category,
    this.animationController,
    this.animation,
    this.callback,
    required this.isLargeTextMode,
  });

  final VoidCallback? callback;
  final Category? category;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final bool isLargeTextMode;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    double cardWidth = isLargeTextMode ? 340.w : 280.w;
    double titlesize = isLargeTextMode ? 18.sp : 14.sp;
    double subtitlesize = isLargeTextMode ? 16.sp : 12.sp;
    double ratio = isLargeTextMode ? 2.28 : 1.28;
    double blurRadius = isLargeTextMode ? 1.0.r : 6.0.r;

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: callback,
              child: SizedBox(
                height: cardWidth,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(44, 240, 204, 121),
                        borderRadius: BorderRadius.circular(16.0.r),
                      ),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 16.h, left: 16.w, right: 16.w),
                                  child: Text(
                                    category!.title,
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: titlesize,
                                          letterSpacing: 0.27.w,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.color,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 8.w,
                                      left: 16.w,
                                      right: 16.w,
                                      bottom: 8.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '${category!.lessonCount} Séances',
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                              fontWeight: FontWeight.w200,
                                              fontSize: subtitlesize,
                                              letterSpacing: 0.27.w,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.color,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 48.h),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 20.w, right: 18.w, left: 18.w),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: DesignCourseAppTheme.grey.withOpacity(0.2),
                              offset: const Offset(0.0, 0.0),
                              blurRadius: blurRadius,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: AspectRatio(
                            aspectRatio: ratio,
                            child: Image.asset(category!.imagePath),
                          ),
                        ),
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
