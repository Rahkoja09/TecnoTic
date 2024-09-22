// ignore_for_file: avoid_print, file_names

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateMentorDescription(
    String mentorId, String newDescription) async {
  try {
    await FirebaseFirestore.instance
        .collection('Mentors')
        .doc(mentorId)
        .update({
      'description': newDescription,
    });
    print("Mise à jour réussie !");
  } catch (e) {
    print("Erreur lors de la mise à jour : $e");
  }
}

Future<void> updateMentorAccomplissements(
    String mentorId, String newAccomplishments) async {
  try {
    await FirebaseFirestore.instance
        .collection('Mentors')
        .doc(mentorId)
        .update({
      'accomplishments': newAccomplishments,
    });
    print("Mise à jour réussie !");
  } catch (e) {
    print("Erreur lors de la mise à jour : $e");
  }
}

Future<void> updateMentorSpecialty(String mentorId, String newSpecialty) async {
  try {
    await FirebaseFirestore.instance
        .collection('Mentors')
        .doc(mentorId)
        .update({
      'specialty': newSpecialty,
    });
    print("Mise à jour réussie !");
  } catch (e) {
    print("Erreur lors de la mise à jour : $e");
  }
}

Future<void> updateMentorPrice(String mentorId, String newPrice) async {
  try {
    await FirebaseFirestore.instance
        .collection('Mentors')
        .doc(mentorId)
        .update({
      'price': newPrice,
    });
    print("Mise à jour réussie !");
  } catch (e) {
    print("Erreur lors de la mise à jour : $e");
  }
}

Future<void> updateMentorImageUrl(String mentorId, String newImageUrl) async {
  try {
    await FirebaseFirestore.instance
        .collection('Mentors')
        .doc(mentorId)
        .update({
      'image_url': newImageUrl,
    });
    print("Mise à jour réussie !");
  } catch (e) {
    print("Erreur lors de la mise à jour : $e");
  }
}

Future<void> updateMentorContact(String mentorId, String newContact) async {
  try {
    await FirebaseFirestore.instance
        .collection('Mentors')
        .doc(mentorId)
        .update({
      'contact': newContact,
    });
    print("Mise à jour réussie !");
  } catch (e) {
    print("Erreur lors de la mise à jour : $e");
  }
}

Future<void> updateMentorHours(String mentorId, String newHours) async {
  try {
    await FirebaseFirestore.instance
        .collection('Mentors')
        .doc(mentorId)
        .update({
      'hours': newHours,
    });
    print("Mise à jour réussie !");
  } catch (e) {
    print("Erreur lors de la mise à jour : $e");
  }
}

Future<void> updateMentorName(String mentorId, String newName) async {
  try {
    await FirebaseFirestore.instance
        .collection('Mentors')
        .doc(mentorId)
        .update({
      'name': newName,
    });
    print("Mise à jour réussie !");
  } catch (e) {
    print("Erreur lors de la mise à jour : $e");
  }
}
