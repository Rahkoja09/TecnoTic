import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'À propos',
          style: TextStyle(
            fontSize: _isLargeTextMode ? 38.sp : 22.sp,
            fontFamily: 'Jersey',
            color: Theme.of(context).textTheme.bodyText2?.color,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Description de l'application
            _buildSectionTitle('À propos de l\'application'),
            SizedBox(height: 10.h),
            _buildCard(
              child: Column(
                children: [
                  _buildLogoSection('assets/icons/logo.png',
                      'Cette application a été conçue pour faciliter l\'intégration des personnes en situation de handicap dans le domaine des TIC.'),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            // Section CNFPPSH
            _buildSectionTitle('Centre CNFPPSH'),
            SizedBox(height: 10.h),
            _buildCard(
              child: Column(
                children: [
                  _buildImageSection('assets/design_course/cnfppsh.jpg',
                      'Le CNFPPSH est un centre dédié à la formation professionnelle des personnes en situation de handicap. Il offre une formation en TIC pour promouvoir l\'inclusion et l\'autonomie.'),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            // Section Développeur
            _buildSectionTitle('Développeur'),
            SizedBox(height: 10.h),
            _buildCard(
              child: Padding(
                padding: EdgeInsets.all(15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildContactInfo('Nom :', 'Koja Nekena'),
                    SizedBox(height: 10.h),
                    _buildContactInfo(
                        'Email :', 'ramanamahefakoja.mg@gmail.com'),
                    SizedBox(height: 10.h),
                    _buildContactInfo('Contact :', '+261343032382'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour construire la section titre
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: _isLargeTextMode ? 30.sp : 18.sp,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.bodyText2?.color,
      ),
    );
  }

  // Méthode pour créer une carte moderne
  Widget _buildCard({required Widget child}) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    return Card(
      color: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.r),
      ),
      elevation: 0.3,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: child,
      ),
    );
  }

  // Section logo avec description
  Widget _buildLogoSection(String logoPath, String description) {
    return Column(
      children: [
        ClipRRect(
          child: Image.asset(
            logoPath,
            height: 50.h,
            width: 400.w,
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: _isLargeTextMode ? 24.sp : 14.sp,
            color: Theme.of(context).textTheme.bodyText2?.color,
          ),
        ),
      ],
    );
  }

  // Section image avec description
  Widget _buildImageSection(String imagePath, String description) {
    return Column(
      children: [
        ClipRRect(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 15.h),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: _isLargeTextMode ? 24.sp : 14.sp,
            color: Theme.of(context).textTheme.bodyText2?.color,
          ),
        ),
      ],
    );
  }

  // Informations de contact
  Widget _buildContactInfo(String title, String info) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: _isLargeTextMode ? 28.sp : 14.sp,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyText2?.color,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            info,
            style: TextStyle(
              fontSize: _isLargeTextMode ? 28.sp : 14.sp,
              color: Theme.of(context).textTheme.bodyText2?.color,
            ),
          ),
        ),
      ],
    );
  }
}
