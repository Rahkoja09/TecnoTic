import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';

class FeedbackPage extends StatefulWidget {
  FeedbackPage({super.key});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  // Variables d'état
  bool _isLargeTextMode = false;
  int _rating = 0;
  String userId = '';
  TextEditingController feedbackController = TextEditingController();

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      _isLargeTextMode = mode == 'largePolice';
    });
  }

  Future<void> getUser() async {
    var infoUser = await DatabaseHelper().getUser();
    if (infoUser!.isNotEmpty) {
      userId = infoUser.first['idFireBase'];
    } else {
      print('Erreur lors de la récuperation infoUser!!');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    getUser();
  }

  Future<void> _submitFeedback(
      String feedbackText, int rating, String userId) async {
    final feedbackId =
        FirebaseFirestore.instance.collection('Feedback').doc().id;

    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);

    Map<String, dynamic> feedbackData = {
      'idUtilisateur': userId,
      'retour': feedbackText,
      'etoiles': rating,
    };

    await FirebaseFirestore.instance
        .collection('Feedback')
        .doc(feedbackId)
        .set({
      formattedDate: feedbackData,
    });

    print('Feedback envoyé avec succès');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedback',
          style: TextStyle(
            fontSize: _isLargeTextMode ? 34.sp : 24.sp,
            fontFamily: 'Jersey',
            color: Theme.of(context).textTheme.bodyText2?.color,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Votre retour est important',
              style: TextStyle(
                fontSize: _isLargeTextMode ? 36.sp : 26.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyText2?.color,
                fontFamily: 'Jersey',
              ),
            ),
            SizedBox(height: 20.h),

            Text(
              'Donnez-nous votre opinion sur notre application Tecno-Tic (Elles resteront privées) :',
              style: TextStyle(
                fontSize: _isLargeTextMode ? 22.sp : 14.sp,
                color: Theme.of(context).textTheme.bodyText2?.color,
              ),
            ),
            SizedBox(height: 10.h),
            TextField(
              controller: feedbackController,
              maxLines: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Tapez votre retour ici...',
                hintStyle: TextStyle(
                  fontSize: _isLargeTextMode ? 18.sp : 14.sp,
                  color: Theme.of(context).textTheme.bodyText2?.color,
                ),
              ),
              style: TextStyle(
                fontSize: _isLargeTextMode ? 18.sp : 14.sp,
                color: Theme.of(context).textTheme.bodyText2?.color,
              ),
            ),
            SizedBox(height: 20.h),

            // Rating Section
            Text(
              'Évaluez cette application :',
              style: TextStyle(
                fontSize: _isLargeTextMode ? 22.sp : 14.sp,
                color: Theme.of(context).textTheme.bodyText2?.color,
              ),
            ),
            SizedBox(height: 10.h),
            RatingWidget(
              rating: _rating,
              onRatingChanged: (newRating) {
                setState(() {
                  _rating = newRating;
                });
              },
            ),
            SizedBox(height: 20.h),

            // Submit Button
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  String feedbackText = feedbackController.text;
                  if (feedbackText.isEmpty || _rating == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Champ vide et/ou évaluation non remplie!')),
                    );
                  } else {
                    _submitFeedback(feedbackText, _rating, userId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Merci pour votre retour !')),
                    );

                    feedbackController.clear();
                    setState(() {
                      _rating = 0;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 19, 75, 120),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  minimumSize: Size(double.infinity, 50.h),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Text(
                  'Envoyer',
                  style: TextStyle(
                    fontSize: _isLargeTextMode ? 34.sp : 24.sp,
                    color: Colors.white,
                    fontFamily: 'Jersey',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget personnalisé pour l'évaluation avec des étoiles
class RatingWidget extends StatelessWidget {
  final int rating;
  final Function(int) onRatingChanged;

  RatingWidget({required this.rating, required this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 30.w,
          ),
          onPressed: () {
            onRatingChanged(index + 1);
          },
        );
      }),
    );
  }
}
