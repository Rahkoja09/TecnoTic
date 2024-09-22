import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';

class HelpAndSupportPage extends StatefulWidget {
  const HelpAndSupportPage({super.key});

  @override
  _HelpAndSupportPageState createState() => _HelpAndSupportPageState();
}

class _HelpAndSupportPageState extends State<HelpAndSupportPage> {
  bool _isLargeTextMode = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      _isLargeTextMode =
          mode == 'largePolice'; // Gérer la préférence réelle ici
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Aide et Assistance',
          style: TextStyle(
            fontSize: _isLargeTextMode ? 38.sp : 28.sp,
            color: Theme.of(context).textTheme.bodyText2?.color,
            fontFamily: 'Jersey',
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explications des fonctionnalités',
                style: TextStyle(
                  fontSize: _isLargeTextMode ? 34.sp : 24.sp,
                  color: Theme.of(context).textTheme.bodyText2?.color,
                  fontFamily: 'Jersey',
                ),
              ),
              SizedBox(height: 20.h),

              // Exemple des cartes de fonctionnalités
              FonctionnaliteCard(
                title: 'Fonctionnalité 1',
                description: 'Description détaillée de la fonctionnalité 1.',
                icon: Icons.settings,
                isLargeTextMode: _isLargeTextMode,
              ),
              FonctionnaliteCard(
                title: 'Fonctionnalité 1',
                description: 'Description détaillée de la fonctionnalité 1.',
                icon: Icons.settings,
                isLargeTextMode: _isLargeTextMode,
              ),
              FonctionnaliteCard(
                title: 'Fonctionnalité 1',
                description: 'Description détaillée de la fonctionnalité 1.',
                icon: Icons.settings,
                isLargeTextMode: _isLargeTextMode,
              ),
              FonctionnaliteCard(
                title: 'Fonctionnalité 1',
                description: 'Description détaillée de la fonctionnalité 1.',
                icon: Icons.settings,
                isLargeTextMode: _isLargeTextMode,
              ),
              FonctionnaliteCard(
                title: 'Fonctionnalité 1',
                description: 'Description détaillée de la fonctionnalité 1.',
                icon: Icons.settings,
                isLargeTextMode: _isLargeTextMode,
              ),
              FonctionnaliteCard(
                title: 'Fonctionnalité 1',
                description: 'Description détaillée de la fonctionnalité 1.',
                icon: Icons.settings,
                isLargeTextMode: _isLargeTextMode,
              ),
              FonctionnaliteCard(
                title: 'Fonctionnalité 1',
                description: 'Description détaillée de la fonctionnalité 1.',
                icon: Icons.settings,
                isLargeTextMode: _isLargeTextMode,
              ),

              SizedBox(height: 30.h),

              // Section Assistance
              Text(
                'Assistance',
                style: TextStyle(
                  fontSize: _isLargeTextMode ? 34.sp : 24.sp,
                  color: Theme.of(context).textTheme.bodyText2?.color,
                  fontFamily: 'Jersey',
                ),
              ),
              SizedBox(height: 20.h),

              AssistanceCard(
                phone: '+261 34 56 756 89',
                email: 'tecnotic@gmail.com',
                isLargeTextMode: _isLargeTextMode,
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget réutilisable pour une fonctionnalité
class FonctionnaliteCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isLargeTextMode;

  FonctionnaliteCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isLargeTextMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    return Card(
      color: theme.cardColor,
      elevation: 0.3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.r),
      ),
      child: ExpansionTile(
        leading: Icon(
          icon,
          color: Theme.of(context).textTheme.bodyText2?.color,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: isLargeTextMode ? 26.sp : 16.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyText2?.color,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              description,
              style: TextStyle(
                fontSize: isLargeTextMode ? 22.sp : 14.sp,
                color: Theme.of(context).textTheme.bodyText2?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget réutilisable pour l'assistance
class AssistanceCard extends StatelessWidget {
  final String phone;
  final String email;
  final bool isLargeTextMode;

  AssistanceCard({
    required this.phone,
    required this.email,
    required this.isLargeTextMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    return Card(
      color: theme.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.phone,
                    color: Theme.of(context).textTheme.bodyText2?.color,
                    size: 24.sp),
                SizedBox(width: 10.w),
                // Le texte du téléphone avec retour à la ligne automatique
                Expanded(
                  child: Text(
                    'Téléphone : $phone',
                    style: TextStyle(
                      fontSize: isLargeTextMode ? 24.sp : 16.sp,
                      color: Theme.of(context).textTheme.bodyText1?.color,
                    ),
                    softWrap: true, // Permet de retourner à la ligne
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(Icons.email,
                    color: Theme.of(context).textTheme.bodyText2?.color,
                    size: 24.sp),
                SizedBox(width: 10.w),
                // Le texte de l'email avec retour à la ligne automatique
                Expanded(
                  child: Text(
                    'Email : $email',
                    style: TextStyle(
                      fontSize: isLargeTextMode ? 24.sp : 16.sp,
                      color: Theme.of(context).textTheme.bodyText1?.color,
                    ),
                    softWrap: true, // Permet de retourner à la ligne
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Google Maps ou autre contenu
            Text(
              'Emplacement de la création de l\'application :',
              style: TextStyle(
                fontSize: isLargeTextMode ? 26.sp : 16.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyText1?.color,
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 2.w),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  'assets/images/map.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
