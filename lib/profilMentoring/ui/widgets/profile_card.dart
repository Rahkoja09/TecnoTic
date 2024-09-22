import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/profilMentoring/utils/theme.dart';

class ProfileCardWidget extends StatefulWidget {
  final String title;
  final String desc;
  final IconData icon;
  final Color iconColor;
  final Function()? onTap;

  const ProfileCardWidget({
    Key? key,
    this.title = '',
    this.desc = '',
    this.icon = Icons.abc,
    this.iconColor = Colors.black,
    this.onTap,
  }) : super(key: key);

  @override
  _ProfileCardWidgetState createState() => _ProfileCardWidgetState();
}

class _ProfileCardWidgetState extends State<ProfileCardWidget> {
  bool isLargeTextMode = false;

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    if (mounted) {
      setState(() {
        isLargeTextMode = mode == 'largePolice';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        height: 200.h,
        child: Card(
          color: theme.cardColor,
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(
                  widget.icon,
                  color: widget.iconColor,
                  size: isLargeTextMode ? 60.sp : 20.sp,
                ),
                SizedBox(height: 20.0.h),
                Text(
                  widget.title,
                  style: AppTheme.cardTitleStyle(context, isLargeTextMode),
                ),
                Text(
                  widget.desc,
                  style: AppTheme.cardDescStyle(context, isLargeTextMode),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
