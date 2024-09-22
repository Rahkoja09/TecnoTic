import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticeo/TaskMentoring/dates_list.dart';
import 'package:ticeo/TaskMentoring/screens/create_new_task_page.dart';
import 'package:ticeo/TaskMentoring/theme/colors/light_colors.dart';
import 'package:ticeo/TaskMentoring/widgets/back_button.dart';
import 'package:ticeo/TaskMentoring/widgets/calendar_dates.dart';
import 'package:ticeo/TaskMentoring/widgets/task_container.dart';

class CalendarPage extends StatelessWidget {
  Widget _dashedText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h), // Responsive padding
      child: Text(
        '------------------------------------------',
        maxLines: 1,
        style: TextStyle(
          fontSize: 20.sp, // Responsive font size
          color: Colors.black12,
          letterSpacing: 5.w, // Responsive letter spacing
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20.w, // Responsive padding
            20.h,
            20.w,
            0,
          ),
          child: Column(
            children: <Widget>[
              MyBackButton(),
              SizedBox(height: 30.h), // Responsive height
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 30.sp, // Responsive font size
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    height: 40.h, // Responsive height
                    width: 120.w, // Responsive width
                    decoration: BoxDecoration(
                      color: LightColors.kGreen,
                      borderRadius: BorderRadius.circular(
                          30.r), // Responsive border radius
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateNewTaskPage(),
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          'Add task',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp, // Responsive font size
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h), // Responsive height
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Productive Day, Sourav',
                    style: TextStyle(
                      fontSize: 18.sp, // Responsive font size
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h), // Responsive height
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'April, 2020',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp, // Responsive font size
                  ),
                ),
              ),
              SizedBox(height: 20.h), // Responsive height
              Container(
                height: 58.h, // Responsive height
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: days.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CalendarDates(
                      day: days[index],
                      date: dates[index],
                      dayColor: index == 0 ? LightColors.kRed : Colors.black54,
                      dateColor:
                          index == 0 ? LightColors.kRed : LightColors.kDarkBlue,
                    );
                  },
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 20.h), // Responsive padding
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                            itemCount: time.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) =>
                                Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.h), // Responsive padding
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${time[index]} ${time[index] > 8 ? 'PM' : 'AM'}',
                                  style: TextStyle(
                                    fontSize: 16.sp, // Responsive font size
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.w, // Responsive width
                        ),
                        Expanded(
                          flex: 5,
                          child: ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              _dashedText(),
                              TaskContainer(
                                title: 'Project Research',
                                subtitle:
                                    'Discuss with the colleagues about the future plan',
                                boxColor: LightColors.kLightYellow2,
                              ),
                              _dashedText(),
                              TaskContainer(
                                title: 'Work on Medical App',
                                subtitle: 'Add medicine tab',
                                boxColor: LightColors.kLavender,
                              ),
                              TaskContainer(
                                title: 'Call',
                                subtitle: 'Call to David',
                                boxColor: LightColors.kPalePink,
                              ),
                              TaskContainer(
                                title: 'Design Meeting',
                                subtitle:
                                    'Discuss with designers for new task for the medical app',
                                boxColor: LightColors.kLightGreen,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
