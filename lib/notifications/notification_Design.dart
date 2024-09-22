import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/services/stream_service.dart'; // Importez le service

class NotificationPage extends StatefulWidget {
  final String mentorId;

  const NotificationPage({required this.mentorId, super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _idLargePolice = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    // Abonner aux notifications via le service
    StreamService().subscribeToNotifications(widget.mentorId);
  }

  @override
  void dispose() {
    // Annuler l'abonnement lorsque le widget est détruit
    StreamService().cancelSubscription();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      _idLargePolice = mode == 'largePolice';
    });
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd – HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: const Text('Notifications Mentoring'),
        titleTextStyle: TextStyle(
          color: Theme.of(context).textTheme.bodyText1?.color,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: StreamService().getNotificationsStream(widget.mentorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Aucune notification trouvée'));
          }

          Map<String, dynamic> data = snapshot.data!.data() ?? {};
          Map<String, dynamic> notifications = data['Notifications'] ?? {};

          List<Map<String, dynamic>> notificationList = [];
          notifications.forEach((key, value) {
            if (key.startsWith('notif') && value is Map<String, dynamic>) {
              notificationList.add(value);
            }
          });

          notificationList.sort((a, b) {
            DateTime dateA = _parseDate(a['DateDemande']);
            DateTime dateB = _parseDate(b['DateDemande']);
            return dateB.compareTo(dateA);
          });

          return ListView.builder(
            itemCount: notificationList.length,
            itemBuilder: (context, index) {
              var notification = notificationList[index];
              DateTime date = _parseDate(notification['DateDemande']);
              String name = notification['NameUserDemande'] ?? 'Nom inconnu';
              String contact = notification['Contact'] ?? 'Contact inconnu';
              String reason = notification['Reason'] ?? 'Raison inconnue';

              return Card(
                color: theme.cardColor,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                elevation: 1,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(notification['UserPhoto'] ??
                        'https://via.placeholder.com/150'),
                    radius: _idLargePolice ? 35 : 24,
                  ),
                  title: Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _idLargePolice ? 20 : 12,
                      color: Theme.of(context).textTheme.bodyText1?.color,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact,
                        style: TextStyle(
                          fontSize: _idLargePolice ? 20 : 12,
                          color: Theme.of(context).textTheme.bodyText1?.color,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        reason,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: _idLargePolice ? 20 : 12,
                          color: Theme.of(context).textTheme.bodyText1?.color,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        formatDateTime(date),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1?.color,
                          fontSize: _idLargePolice ? 20 : 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  DateTime _parseDate(String dateData) {
    try {
      return DateFormat('yyyy-MM-dd – HH:mm').parse(dateData);
    } catch (e) {
      print("Erreur lors du parsing de la date : $e");
      return DateTime.now();
    }
  }
}
