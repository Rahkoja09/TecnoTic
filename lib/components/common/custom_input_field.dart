import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';

class CustomInputField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final String? Function(String?) validator;
  final bool suffixIcon;
  final bool? isDense;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomInputField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.validator,
    this.suffixIcon = false,
    this.isDense,
    this.obscureText = false,
    this.controller,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;
  double _fontSize = 18.sp;
  double _hintSize = 15.sp;
  double _maxHeight = 33.sp;
  double _paddingHorizontal = 15.w;
  double _paddingVertical = 3.h;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      _fontSize = mode == 'large' ? 24.sp : 18.sp;
      _hintSize = mode == 'large' ? 24.sp : 15.sp;
      _maxHeight = mode == 'large' ? 44.sp : 33.sp;
      _paddingHorizontal = mode == 'large' ? 22.w : 15.w;
      _paddingVertical = mode == 'large' ? 12.h : 3.h;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.9,
      padding: EdgeInsets.symmetric(
        horizontal: _paddingHorizontal,
        vertical: _paddingVertical,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.labelText,
              style:
                  TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText && _obscureText,
            decoration: InputDecoration(
              isDense: widget.isDense ?? false,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: _hintSize,
                color: const Color.fromARGB(255, 73, 73, 73),
              ),
              suffixIcon: widget.suffixIcon
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.remove_red_eye
                            : Icons.visibility_off_outlined,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              suffixIconConstraints: widget.isDense != null
                  ? BoxConstraints(
                      maxHeight: _maxHeight,
                    )
                  : null,
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}
