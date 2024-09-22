import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';

class CustomFormButton extends StatefulWidget {
  final String innerText;
  final void Function()? onPressed;

  const CustomFormButton({
    Key? key,
    required this.innerText,
    required this.onPressed,
  }) : super(key: key);

  @override
  _CustomFormButtonState createState() => _CustomFormButtonState();
}

class _CustomFormButtonState extends State<CustomFormButton> {
  bool _isLargeText = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      _isLargeText = mode == 'largePolice';
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.8,
      height: _isLargeText ? 60.h : 50.h,
      decoration: BoxDecoration(
        color: const Color(0xff233743),
        borderRadius: BorderRadius.circular(_isLargeText ? 30.r : 26.r),
      ),
      child: TextButton(
        onPressed: widget.onPressed,
        child: Text(
          widget.innerText,
          style: TextStyle(
            color: Colors.white,
            fontSize: _isLargeText ? 30.sp : 20.sp,
            fontFamily: 'Jersey',
          ),
        ),
      ),
    );
  }
}
