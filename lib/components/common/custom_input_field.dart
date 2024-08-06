import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/state/provider_state.dart';

class CustomInputField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final String? Function(String?) validator;
  final bool suffixIcon;
  final bool? isDense;
  final bool obscureText;

  const CustomInputField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.validator,
    this.suffixIcon = false,
    this.isDense,
    this.obscureText = false,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    // provider
    final textSizeProvider = Provider.of<ModeProvider>(context);
    double fontSize = textSizeProvider.isLargeTextMode ? 24.sp : 18.sp;
    double maxHeight = textSizeProvider.isLargeTextMode ? 44.sp : 33.sp;
    double hintsize = textSizeProvider.isLargeTextMode ? 24.sp : 15.sp;
    double paddingHorizontal = textSizeProvider.isLargeTextMode ? 22.w : 15.w;
    double paddingVertical = textSizeProvider.isLargeTextMode ? 12.h : 3.h;

    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.9,
      padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal, vertical: paddingVertical),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.labelText,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
            obscureText: (widget.obscureText && _obscureText),
            decoration: InputDecoration(
              isDense: widget.isDense ?? false,
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: hintsize,
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
                      maxHeight: maxHeight,
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
