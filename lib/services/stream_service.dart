import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class StreamService {
  static final StreamService _instance = StreamService._internal();

  factory StreamService() => _instance;

  StreamService._internal();

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _notificationsSubscription;

  // Méthode pour obtenir le flux des notifications
  Stream<DocumentSnapshot<Map<String, dynamic>>> getNotificationsStream(
      String mentorId) {
    return FirebaseFirestore.instance
        .collection('Mentors')
        .doc(mentorId)
        .snapshots();
  }

  // Méthode pour abonner au flux
  void subscribeToNotifications(String mentorId) {
    _notificationsSubscription =
        getNotificationsStream(mentorId).listen((snapshot) {
      // Vous pouvez gérer les mises à jour ici
    });
  }

  // Méthode pour annuler l'abonnement
  void cancelSubscription() {
    _notificationsSubscription?.cancel();
  }
}
