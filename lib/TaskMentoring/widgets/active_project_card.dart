import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ActiveProjectsCard extends StatelessWidget {
  final Color cardColor;
  final double loadingPercent;
  final String title;
  final String subtitle;

  ActiveProjectsCard({
    required this.cardColor,
    required this.loadingPercent,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h), // Responsive margin
        padding: EdgeInsets.all(25.w), // Responsive padding
        height: 220.h, // Responsive height
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20.r), // Responsive border radius
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.w), // Responsive padding
              child: CircularPercentIndicator(
                animation: true,
                radius: 60.r, // Responsive radius
                percent: loadingPercent,
                lineWidth: 9.w, // Responsive line width
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.white10,
                progressColor: Colors.white,
                center: Text(
                  '${(loadingPercent * 100).round()}%',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 16.sp), // Responsive font size
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp, // Responsive font size
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp, // Responsive font size
                    color: Colors.white54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
