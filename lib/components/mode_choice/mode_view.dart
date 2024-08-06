import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playWelcomeVoice();
  }

  Future<void> _playWelcomeVoice() async {
    await _audioPlayer.play(AssetSource('sounds/assistance_bienvenue.aac'));
  }

  Future<void> _stopWelcomeVoice() async {
    await _audioPlayer.stop();
  }

  Future<void> _checkTalkBackStatus() async {
    bool isTalkBackEnabled;
    try {
      final bool result = await platform.invokeMethod('isTalkBackEnabled');
      isTalkBackEnabled = result;
      if (!isTalkBackEnabled) {
        _navigateToNextPage(); // Naviguer vers la page suivante
        Future.delayed(const Duration(seconds: 1), () {
          _requestTalkBackActivation(); // Ouvrir les paramètres après un délai
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('TalkBack est déjà activé')),
        );
        _navigateToNextPage();
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

  void _navigateToNextPage() {
    final modeProvider = Provider.of<ModeProvider>(context, listen: false);
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
    ).then((_) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final modeProvider = Provider.of<ModeProvider>(context);

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
              Text(
                'Choix du mode d\'utilisation',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: modeProvider.isLargeTextMode ? 36.0 : 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              IconButton(
                icon: const Icon(Icons.volume_off),
                onPressed: _stopWelcomeVoice,
                tooltip: 'Muet, faire taire l\'assistante',
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
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_selections[0]) {
                    _checkTalkBackStatus();
                  } else {
                    setState(() {
                      modeProvider.setLargeTextMode(_selections[1]);
                    });
                    _navigateToNextPage();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Suivant',
                    style: TextStyle(
                      fontSize: modeProvider.isLargeTextMode ? 26.0 : 22.0,
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
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
