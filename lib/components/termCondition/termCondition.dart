// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';

class Termscreen extends StatefulWidget {
  const Termscreen({super.key});

  @override
  State<Termscreen> createState() => _TermscreenState();
}

class _TermscreenState extends State<Termscreen> {
  String pourquoiTermCondition = '';
  String nosTermes = '';
  String nosConditions = '';
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
    _fetchTermsAndConditions();
  }

  Future<void> _fetchTermsAndConditions() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Terms&Conditions').get();

      if (snapshot.docs.isNotEmpty) {
        // Récupération du premier document
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          pourquoiTermCondition =
              data['PourquoiTermeEtCondition'] ?? 'Aucun pourquoi disponible.';
          nosTermes = data['NosTermes'] ?? 'Aucun terme disponible.';
          nosConditions =
              data['NosConditions'] ?? 'Aucun condition disponible.';
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des Terms & Conditions : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          title: Text(
            'Termes et Conditions',
            style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w500),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        icon: Icons.info_outline,
                        title: 'Pourquoi Termes et Conditions ?',
                      ),
                      _buildSectionContent(pourquoiTermCondition),
                      _buildSectionDivider(),
                      _buildSectionHeader(
                        icon: Icons.rule,
                        title: 'Nos Termes',
                      ),
                      _buildSectionContent(nosTermes),
                      _buildSectionDivider(),
                      _buildSectionHeader(
                        icon: Icons.gavel,
                        title: 'Nos Conditions',
                      ),
                      _buildSectionContent(nosConditions),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.color, // Utilisation de la couleur du thème
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        content,
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              fontSize: 18,
              color: Theme.of(context).textTheme.bodyText2?.color,
              height: 1.5,
            ),
      ),
    );
  }

  Widget _buildSectionDivider() {
    return const Divider(
      color: Colors.grey,
      thickness: 1,
      height: 40,
    );
  }
}
