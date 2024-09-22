import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/profilMentoring/utils/theme.dart';

class ProfileHeaderWidget extends StatefulWidget {
  final String title;
  final String desc;

  const ProfileHeaderWidget({super.key, this.title = '', this.desc = ''});

  @override
  State<ProfileHeaderWidget> createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
  late String nameUser = '';
  late String nameUser2 = '';
  bool isMentorUser = false;
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
    getisMentor();
    getMentorName();
    getUserName();
  }

  Future<void> getMentorName() async {
    try {
      List<Map<String, dynamic>>? getUser = await DatabaseHelper().getMentor();
      if (getUser!.isNotEmpty) {
        setState(() {
          nameUser = getUser.first['NomComplet'] ?? 'Utilisateur';
        });
      } else {
        print('Aucun utilisateur trouvé.');
      }
    } catch (e) {
      print('Erreur lors de la récupération du nom de l\'utilisateur : $e');
    }
  }

  Future<void> getUserName() async {
    try {
      List<Map<String, dynamic>>? getUser = await DatabaseHelper().getUser();
      if (getUser!.isNotEmpty) {
        setState(() {
          nameUser2 = getUser.first['nom'] ?? 'Utilisateur';
        });
      } else {
        print('Aucun utilisateur trouvé.');
      }
    } catch (e) {
      print('Erreur lors de la récupération du nom de l\'utilisateur : $e');
    }
  }

  Future<void> getisMentor() async {
    var isMentor = await DatabaseHelper().getisMentor();
    try {
      if (isMentor == 1) {
        isMentorUser = true;
      } else {
        isMentorUser = false;
      }
    } catch (e) {
      print('erreur de recuperation de isMentor : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    ScreenUtil.init(context, designSize: const Size(360, 690));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 10.0,
        ),
        if (isMentorUser)
          Text(
            widget.title.isNotEmpty ? widget.title : 'Profile (Mentor)',
            style: AppTheme.profileHeaderStyle(context, isLargeTextMode),
          ),
        if (!isMentorUser)
          Text(
            widget.title.isNotEmpty ? widget.title : 'Profile',
            style: AppTheme.profileHeaderStyle(context, isLargeTextMode),
          ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                widget.desc.isNotEmpty ? nameUser : nameUser2,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyText1?.color,
                      fontSize: isLargeTextMode ? 24.sp : 16.sp,
                    ),
                softWrap: true,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 10.0.w,
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Nom de l\'utilisateur'),
                      content:
                          Text(widget.desc.isNotEmpty ? nameUser : nameUser2),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Fermer'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(
                Icons.edit,
                color: Theme.of(context).textTheme.bodyText1?.color,
                size: 15.0.sp,
              ),
            ),
          ],
        )
      ],
    );
  }
}
