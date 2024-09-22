import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/components/state/provider_state.dart';
import 'package:ticeo/home/home.dart';
import 'package:ticeo/introduction_animation/introduction_animation_screen.dart';
import 'package:audioplayers/audioplayers.dart';

class ModeSelectionPage extends StatefulWidget {
  const ModeSelectionPage({super.key});

  @override
  _ModeSelectionPageState createState() => _ModeSelectionPageState();
}

class _ModeSelectionPageState extends State<ModeSelectionPage> {
  final List<bool> _selections = List.generate(3, (_) => false);
  static const platform = MethodChannel('accessibility_service');
  bool _isLargeTextMode = false;

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      _isLargeTextMode = mode == 'largePolice';
    });
  }

  @override
  void initState() {
    super.initState();
    _checkIfModePageSeen();
  }

  Future<void> _checkIfModePageSeen() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    String? mode = await dbHelper.getPreference();
    if (mode != null) {
      _navigateToHomeScreen();
    }
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

  void _navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            IntroductionAnimationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  Future<void> _checkTalkBackStatus() async {
    bool isTalkBackEnabled;
    try {
      final bool result = await platform.invokeMethod('isTalkBackEnabled');
      isTalkBackEnabled = result;
      if (!isTalkBackEnabled) {
        _checkIfModePageSeen();
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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                spreadRadius: 5.0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Choix du mode d\'utilisation',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              _buildOptionButton(
                context,
                'Mode Lecture d\'écran',
                0,
              ),
              _buildOptionButton(
                context,
                'Mode grand police',
                1,
              ),
              _buildOptionButton(
                context,
                'Mode normale',
                2,
              ),
              const SizedBox(height: 10.0),
              const Text(
                '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 58, 58, 59),
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_selections[0]) {
                    _checkTalkBackStatus();
                    saveOrUpdatePreference('largePolice');
                  } else if (_selections[1]) {
                    _navigateToHomeScreen();
                    saveOrUpdatePreference('largePolice');
                  } else if (_selections[2]) {
                    _navigateToHomeScreen();
                    saveOrUpdatePreference('normale');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Suivant',
                    style: TextStyle(
                      fontSize: 26.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    String title,
    int index, {
    VoidCallback? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            if (index == 1 && _selections[2]) {
              _selections[2] = false;
            } else if (index == 2 && _selections[1]) {
              _selections[1] = false;
            }
            _selections[index] = !_selections[index];
          });
          onPressed?.call();
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: _selections[index]
              ? const Color.fromARGB(255, 243, 189, 246)
              : Colors.white,
          shadowColor: Colors.grey[300],
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
