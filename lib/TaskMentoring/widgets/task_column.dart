import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskColumn extends StatelessWidget {
  final IconData? icon;
  final Color? iconBackgroundColor;
  final String? title;
  final String? subtitle;

  TaskColumn({
    this.icon,
    this.iconBackgroundColor,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 20.r, // Responsive radius
          backgroundColor: iconBackgroundColor,
          child: Icon(
            icon,
            size: 15.sp, // Responsive icon size
            color: Colors.white,
          ),
        ),
        SizedBox(width: 10.w), // Responsive width
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title!,
              style: TextStyle(
                fontSize: 16.sp, // Responsive font size
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 14.sp, // Responsive font size
                fontWeight: FontWeight.w500,
                color: Colors.black45,
              ),
            ),
          ],
        )
      ],
    );
  }
}
