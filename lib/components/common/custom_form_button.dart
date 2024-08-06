import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/state/provider_state.dart';

class CustomFormButton extends StatelessWidget {
  final String innerText;
  final void Function()? onPressed;

  const CustomFormButton({
    Key? key,
    required this.innerText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //provider------
    final textSizeProvider = Provider.of<ModeProvider>(context);
    double fontSize = textSizeProvider.isLargeTextMode ? 32.sp : 20.sp;
    double buttonHeight = textSizeProvider.isLargeTextMode ? 62.h : 50.h;
    double borderRadius = textSizeProvider.isLargeTextMode ? 34.r : 26.r;

    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      height: buttonHeight,
      decoration: BoxDecoration(
        color: const Color(0xff233743),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          innerText,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
