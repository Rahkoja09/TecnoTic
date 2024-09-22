import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/components/nav_bar/bottom_navbar.dart';
import 'package:ticeo/home/home.dart';
import 'package:ticeo/introduction_animation/introduction_animation_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ThemeCustomizationPage extends StatefulWidget {
  @override
  _ThemeCustomizationPageState createState() => _ThemeCustomizationPageState();
}

class _ThemeCustomizationPageState extends State<ThemeCustomizationPage> {
  static const platform = MethodChannel('accessibility_service');
  String selectedTheme = 'Light';
  Color backgroundColor = Colors.white;
  Color cardColor = const Color.fromARGB(255, 206, 206, 206);
  Color textColor = Colors.black;
  Color iconColor = Colors.black;

  bool isLargeTextMode = false;
  bool isScreenReaderEnabled = false;
  bool isAssistantMuted = false;
  bool _isLargeTextMode = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      _isLargeTextMode = mode == 'largePolice';
    });
  }

  Future<void> saveOrUpdatePreference(String mode) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    String? existingPreference = await dbHelper.getPreference();

    if (existingPreference != null && existingPreference.isNotEmpty) {
      await dbHelper.updatePreference(mode);
      print('Préférence mise à jour : $mode');
    } else {
      await dbHelper.insertPreference(mode);
      print('Nouvelle préférence insérée : $mode');
    }
  }

  Future<void> _checkTalkBackStatus() async {
    bool isTalkBackEnabled;
    try {
      final bool result = await platform.invokeMethod('isTalkBackEnabled');
      isTalkBackEnabled = result;
      if (!isTalkBackEnabled) {
        Future.delayed(const Duration(seconds: 1), () {
          _requestTalkBackActivation();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('TalkBack est déjà activé')),
        );
      }
    } on PlatformException catch (e) {
      print("Erreur lors de la vérification de TalkBack: ${e.message}");
    }
  }

  Future<void> _requestTalkBackActivation() async {
    try {
      await platform.invokeMethod('requestTalkBackActivation');
    } on PlatformException catch (e) {
      print("Erreur lors de la demande d'activation de TalkBack: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text('Personnalisation du thème',
            style: TextStyle(
                fontSize: _isLargeTextMode ? 30.sp : 22.sp,
                color: Theme.of(context).textTheme.bodyText2?.color,
                fontFamily: 'Jersey')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildThemeDropdown(themeProvider),
            const Divider(),
            _buildColorCustomizationSection(themeProvider),
            const Divider(),
            _buildUsageSettingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeDropdown(ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '-- Sélectionnez un thème par défaut :',
          style: TextStyle(
              fontSize: _isLargeTextMode ? 24.sp : 16.sp,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0.h),
        DropdownButton<String>(
          value: selectedTheme,
          items: ['Light', 'Dark', 'Custom']
              .map((theme) => DropdownMenuItem(
                    value: theme,
                    child: Text(
                      theme,
                      style: TextStyle(
                        fontSize: _isLargeTextMode ? 24.sp : 14.sp,
                        color: Theme.of(context).textTheme.bodyText2?.color,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: (newTheme) {
            setState(() {
              selectedTheme = newTheme!;
              if (selectedTheme == 'Light') {
                themeProvider.setTheme(ThemeData.light());
              } else if (selectedTheme == 'Dark') {
                themeProvider.setTheme(ThemeData.dark());
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildColorCustomizationSection(ThemeProvider themeProvider) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '-- Personnalisez les couleurs :',
          style: TextStyle(
              fontSize: _isLargeTextMode ? 22.sp : 16.sp,
              fontWeight: FontWeight.bold),
        ),
        _buildColorPicker('Couleur de fond', backgroundColor, (color) {
          setState(() {
            backgroundColor = color;
          });
        }),
        _buildColorPicker('Couleur des cartes', cardColor, (color) {
          setState(() {
            cardColor = color;
          });
        }),
        _buildColorPicker('Couleur du texte', textColor, (color) {
          setState(() {
            textColor = color;
          });
        }),
        _buildColorPicker('Couleur des icônes', iconColor, (color) {
          setState(() {
            iconColor = color;
          });
        }),
        SizedBox(height: 20.0.h),
        ElevatedButton(
          onPressed: () {
            // Appliquer les couleurs personnalisées via le ThemeProvider
            themeProvider.setCustomColors(
              backgroundColor: backgroundColor,
              cardColor: cardColor,
              textColor: textColor,
              iconColor: iconColor,
            );
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 17, 59, 94),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r))),
          child: Text(
            ' + Appliquer les couleurs personnalisées',
            style: TextStyle(
              fontSize: _isLargeTextMode ? 24.sp : 14.sp,
              color: Theme.of(context).textTheme.bodyText2?.color,
            ),
          ),
        ),
      ],
    );
  }

  // Section 3: Paramètres d'accessibilité
  Widget _buildUsageSettingsSection() {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '-- Paramètres d\'utilisation :',
          style: TextStyle(
              fontSize: _isLargeTextMode ? 28.sp : 16.sp,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        SwitchListTile(
          title: Text(
            'Mode grand texte',
            style: TextStyle(
              fontSize: _isLargeTextMode ? 24.sp : 12.sp,
              color: Theme.of(context).textTheme.bodyText2?.color,
            ),
          ),
          value: themeProvider.isLargeTextMode,
          onChanged: (bool value) async {
            themeProvider.setLargeTextMode(value);
            saveOrUpdatePreference('largePolice');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GoogleBottomBar()));
          },
        ),
        SwitchListTile(
          title: Text(
            'Lecture d\'écran',
            style: TextStyle(
              fontSize: _isLargeTextMode ? 24.sp : 12.sp,
              color: Theme.of(context).textTheme.bodyText2?.color,
            ),
          ),
          value: themeProvider.isScreenReaderEnabled,
          onChanged: (bool value) async {
            themeProvider.setScreenReaderEnabled(value);
            saveOrUpdatePreference('talkback');
            _checkTalkBackStatus();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GoogleBottomBar()));
          },
        ),
        SwitchListTile(
          title: Text(
            'Mode normal',
            style: TextStyle(
              fontSize: _isLargeTextMode ? 24.sp : 12.sp,
              color: Theme.of(context).textTheme.bodyText2?.color,
            ),
          ),
          value: !themeProvider.isLargeTextMode &&
              !themeProvider.isScreenReaderEnabled,
          onChanged: (bool value) {
            if (value) {
              themeProvider.resetModes();
            }
            saveOrUpdatePreference('normal');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const GoogleBottomBar()));
          },
        ),
      ],
    );
  }

  Widget _buildColorPicker(
      String label, Color currentColor, Function(Color) onColorChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: _isLargeTextMode ? 24.sp : 12.sp),
        ),
        GestureDetector(
          onTap: () async {
            Color? newColor = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'Choisissez une couleur',
                  style: TextStyle(fontSize: _isLargeTextMode ? 26.sp : 12.sp),
                ),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: currentColor,
                    onColorChanged: (color) {
                      setState(() {
                        currentColor = color;
                      });
                    },
                    showLabel: true,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'Annuler',
                      style:
                          TextStyle(fontSize: _isLargeTextMode ? 24.sp : 12.sp),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      'Choisir',
                      style:
                          TextStyle(fontSize: _isLargeTextMode ? 24.sp : 12.sp),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(currentColor);
                    },
                  ),
                ],
              ),
            );
            if (newColor != null) {
              onColorChanged(newColor);
            }
          },
          child: CircleAvatar(
            backgroundColor: currentColor,
            radius: _isLargeTextMode ? 24.r : 16.r,
          ),
        ),
      ],
    );
  }
}
