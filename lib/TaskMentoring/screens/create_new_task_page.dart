import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Importer ScreenUtil
import 'package:ticeo/TaskMentoring/screens/home_page.dart';
import 'package:ticeo/TaskMentoring/theme/colors/light_colors.dart';
import 'package:ticeo/TaskMentoring/widgets/back_button.dart';
import 'package:ticeo/TaskMentoring/widgets/my_text_field.dart';
import 'package:ticeo/TaskMentoring/widgets/top_container.dart';

class CreateNewTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialiser ScreenUtil
    ScreenUtil.init(
      context,
      designSize:
          Size(360, 690), // Ajuste cette taille selon la taille de ton design
      minTextAdapt: true,
    );

    double width = ScreenUtil().screenWidth;
    var downwardIcon = Icon(
      Icons.keyboard_arrow_down,
      color: Colors.black54,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TopContainer(
              padding: EdgeInsets.fromLTRB(
                  20.w, 20.h, 20.w, 40.h), // Utiliser ScreenUtil
              width: width,
              child: Column(
                children: <Widget>[
                  MyBackButton(),
                  SizedBox(height: 30.h), // Utiliser ScreenUtil
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Create new task',
                        style: TextStyle(
                          fontSize: 30.sp, // Utiliser ScreenUtil
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h), // Utiliser ScreenUtil
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MyTextField(label: 'Title'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: MyTextField(
                              label: 'Date',
                              icon: downwardIcon,
                            ),
                          ),
                          // HomeTask.calendarIcon(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.w), // Utiliser ScreenUtil
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: MyTextField(
                            label: 'Start Time',
                            icon: downwardIcon,
                          ),
                        ),
                        SizedBox(width: 40.w), // Utiliser ScreenUtil
                        Expanded(
                          child: MyTextField(
                            label: 'End Time',
                            icon: downwardIcon,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h), // Utiliser ScreenUtil
                    MyTextField(
                      label: 'Description',
                      minLines: 3,
                      maxLines: 3,
                    ),
                    SizedBox(height: 20.h), // Utiliser ScreenUtil
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Category',
                            style: TextStyle(
                              fontSize: 18.sp, // Utiliser ScreenUtil
                              color: Colors.black54,
                            ),
                          ),
                          Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 10.w, // Utiliser ScreenUtil
                            children: <Widget>[
                              Chip(
                                label: Text("SPORT APP"),
                                backgroundColor: LightColors.kRed,
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                              Chip(label: Text("MEDICAL APP")),
                              Chip(label: Text("RENT APP")),
                              Chip(label: Text("NOTES")),
                              Chip(label: Text("GAMING PLATFORM APP")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 80.h, // Utiliser ScreenUtil
              width: width,
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(
                  20.w, 10.h, 20.w, 20.h), // Utiliser ScreenUtil
              decoration: BoxDecoration(
                color: LightColors.kBlue,
                borderRadius:
                    BorderRadius.circular(30.r), // Utiliser ScreenUtil
              ),
              child: Text(
                'Create Task',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp, // Utiliser ScreenUtil
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
