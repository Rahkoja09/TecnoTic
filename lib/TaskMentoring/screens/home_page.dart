import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ticeo/TaskMentoring/screens/calendar_page.dart';
import 'package:ticeo/TaskMentoring/theme/colors/light_colors.dart';
import 'package:ticeo/TaskMentoring/widgets/active_project_card.dart';
import 'package:ticeo/TaskMentoring/widgets/task_column.dart';
import 'package:ticeo/TaskMentoring/widgets/top_container.dart';

class HomeTask extends StatelessWidget {
  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
        color: LightColors.kDarkBlue,
        fontSize: 20.sp, // Utilisation de ScreenUtil pour le texte
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  static CircleAvatar calendarIcon() {
    return CircleAvatar(
      radius: 25.r, // Utilisation de ScreenUtil pour le rayon
      backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.calendar_today,
        size: 20.sp, // Utilisation de ScreenUtil pour la taille de l'icône
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = 1.sw; // Utilisation de ScreenUtil pour la largeur de l'écran
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopContainer(
              height: 190.h, // Utilisation de ScreenUtil pour la hauteur
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(Icons.menu,
                          color: LightColors.kDarkBlue, size: 30.0),
                      Icon(Icons.search,
                          color: LightColors.kDarkBlue, size: 25.0),
                    ],
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CircularPercentIndicator(
                          radius:
                              50.r, // Utilisation de ScreenUtil pour le rayon
                          lineWidth: 5.w,
                          animation: true,
                          percent: 0.75,
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor:
                              const Color.fromARGB(255, 100, 205, 228),
                          backgroundColor: Color.fromARGB(255, 42, 131, 153),
                          center: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 223, 153, 91),
                            radius:
                                35.r, // Utilisation de ScreenUtil pour le rayon
                            backgroundImage: AssetImage(
                              'assets/images/avatar.png',
                            ),
                          ),
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Fanevaniaina Koja',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 22.0,
                                color: LightColors.kDarkBlue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Mentor',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black45,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              subheading('Mes Tâches'),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CalendarPage()),
                                  );
                                },
                                child: calendarIcon(),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          TaskColumn(
                            icon: Icons.alarm,
                            iconBackgroundColor: LightColors.kRed,
                            title: 'Listes Tâches',
                            subtitle: '5 Tâches',
                          ),
                          SizedBox(height: 15.h),
                          TaskColumn(
                            icon: Icons.blur_circular,
                            iconBackgroundColor: LightColors.kDarkYellow,
                            title: 'En progression',
                            subtitle: '1 en progres',
                          ),
                          SizedBox(height: 15.h),
                          TaskColumn(
                            icon: Icons.check_circle_outline,
                            iconBackgroundColor: LightColors.kBlue,
                            title: 'Tâches finis',
                            subtitle: '18 tâches finis',
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          subheading('Mes Tâches Actives'),
                          SizedBox(height: 5.h),
                          Row(
                            children: <Widget>[
                              ActiveProjectsCard(
                                cardColor: LightColors.kGreen,
                                loadingPercent: 0.25,
                                title: 'Microsoft Power Point',
                                subtitle: '9 hours progress',
                              ),
                              SizedBox(width: 20.w),
                              ActiveProjectsCard(
                                cardColor: LightColors.kRed,
                                loadingPercent: 0.6,
                                title: 'Microsoft Word',
                                subtitle: '20 hours progress',
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              ActiveProjectsCard(
                                cardColor: LightColors.kDarkYellow,
                                loadingPercent: 0.45,
                                title: 'Info braille',
                                subtitle: '5 hours progress',
                              ),
                              SizedBox(width: 20.w),
                              ActiveProjectsCard(
                                cardColor: LightColors.kBlue,
                                loadingPercent: 0.9,
                                title: 'Internet',
                                subtitle: '23 hours progress',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
