import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';

class ProfileImageWidget extends StatefulWidget {
  const ProfileImageWidget({super.key});

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  String? profilImageUrl;
  String? profilImageUrl2;
  bool profilMentor = false;

  bool isLargeTextMode = false;

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      isLargeTextMode = mode == 'largePolice';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    getImageProfil();
    getImageProfil2();
  }

  Future<void> getImageProfil() async {
    String? imageUrl = await DatabaseHelper().getImageProfil();
    profilMentor = false;
    setState(() {
      profilImageUrl = imageUrl;
    });
  }

  Future<void> getImageProfil2() async {
    String? imageUrl = await DatabaseHelper().getImageProfilMentor();
    profilMentor = true;
    setState(() {
      profilImageUrl2 = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    return Container(
      height: isLargeTextMode ? 66.sp : 52.sp,
      width: isLargeTextMode ? 66.sp : 52.sp,
      margin: EdgeInsets.symmetric(
          vertical: isLargeTextMode ? 3.h : 6.h,
          horizontal: isLargeTextMode ? 11.sp : 22.w),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(48.0),
          bottomRight: Radius.circular(48.0),
          topLeft: Radius.circular(48.0),
        ),
        image: profilImageUrl != null && profilImageUrl!.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(profilImageUrl!),
                fit: BoxFit.cover,
              )
            : const DecorationImage(
                image: AssetImage('assets/images/default_profile.png'),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
