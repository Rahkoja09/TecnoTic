import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ticeo/mentoring/helper/color.dart';
import 'package:ticeo/mentoring/helper/m_fonts.dart';

class Ratings extends StatelessWidget {
  const Ratings({Key? key, required this.rating, required this.isLargeTextMode})
      : super(key: key);
  final double rating;
  final bool isLargeTextMode;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
          rating.toInt(),
          (index) => Icon(Icons.star_outline_rounded,
              size: isLargeTextMode ? 20.sp : 12.sp,
              color: MColor.yellow)).toList(),
    );
  }
}
