import 'package:flutter/material.dart';

import 'package:ticeo/mentoring/helper/color.dart';
import 'package:ticeo/mentoring/helper/m_fonts.dart';

class Ratings extends StatelessWidget {
  const Ratings({Key? key, required this.rating}) : super(key: key);
  final double rating;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
          rating.toInt(),
          (index) => Icon(Icons.star_outline_rounded,
              size: 12, color: MColor.yellow)).toList(),
    );
  }
}
