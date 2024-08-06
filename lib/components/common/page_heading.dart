import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/state/provider_state.dart';

class PageHeading extends StatelessWidget {
  final String title;

  const PageHeading({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final textSizeProvider = Provider.of<ModeProvider>(context);
    double fontSize = textSizeProvider.isLargeTextMode ? 34.sp : 25.sp;
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 25.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          fontFamily: 'NotoSerif',
        ),
      ),
    );
  }
}
