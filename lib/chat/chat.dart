import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:uuid/uuid.dart';

class ChatUI extends StatelessWidget {
  const ChatUI({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String id_user = '';
  final List<types.Message> _messages = [];
  types.User? _user;
  final _otherUser = const types.User(id: '12345'); // Utilisateur de test

  // Pour suivre les messages en cours de chargement
  final Set<String> _loadingMessages = {};

  StreamSubscription? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    loadidUser();
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadidUser() async {
    var infoUser = await DatabaseHelper().getUser();
    if (infoUser!.isNotEmpty) {
      id_user = infoUser.first['idFireBase'];
      setState(() {
        _user = types.User(
          id: id_user, firstName: infoUser.first['nom'],
          imageUrl: infoUser.first['profileImageUrl'],
        );
      });
    }
  }

  // Charger les messages depuis Firestore
  void _loadMessages() {
    _messageSubscription = FirebaseFirestore.instance
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final messages = snapshot.docs.map((doc) {
        return types.Message.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      if (mounted) {
        setState(() {
          _messages.clear();
          _messages.addAll(messages);
        });
      }
    });
  }

  // Ajouter un message localement et l'enregistrer dans Firestore
  void _addMessage(types.Message message) {
    if (!mounted) return; // Vérifie si le widget est monté

    setState(() {
      _messages.insert(0, message);
    });

    // Enregistrer le message dans Firestore
    FirebaseFirestore.instance.collection('messages').add(message.toJson());
  }

  // Gérer l'ouverture du menu des pièces jointes
  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Fichier'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Annuler'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Gérer la sélection de fichiers autres que les images
  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user!,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  // Gérer la sélection d'images et l'upload vers Firebase Storage
  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      setState(() {
        _loadingMessages.add(result.path);
      });

      try {
        final bytes = await result.readAsBytes();
        final image = await decodeImageFromList(bytes);

        // Upload de l'image sur Firebase Storage
        final storageRef =
            FirebaseStorage.instance.ref().child('uploads/${result.name}');
        final uploadTask = storageRef.putFile(File(result.path));
        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();

        final message = types.ImageMessage(
          author: _user!,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          height: image.height.toDouble(),
          id: const Uuid().v4(),
          name: result.name,
          size: bytes.length,
          uri: downloadUrl,
          width: image.width.toDouble(),
        );

        _addMessage(message);
      } catch (e) {
        print('Erreur lors de l\'envoi de l\'image : $e');
      } finally {
        if (mounted) {
          setState(() {
            _loadingMessages.remove(result.path);
          });
        }
      }
    }
  }

  // Gérer le tap sur un message pour ouvrir un fichier
  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage || message is types.ImageMessage) {
      String localPath;

      if (message is types.FileMessage) {
        localPath = message.uri;
      } else if (message is types.ImageMessage) {
        localPath = message.uri;
      } else {
        return;
      }

      String fileName = message is types.FileMessage
          ? message.name
          : localPath.split('/').last;

      if (localPath.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          if (index == -1) return;

          _loadingMessages.add(message.id);

          if (mounted) {
            setState(() {});
          }

          final client = http.Client();
          final request = await client.get(Uri.parse(localPath));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/$fileName';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } catch (e) {
          print('Erreur lors de l\'ouverture du fichier : $e');
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          if (index == -1) return;

          _loadingMessages.remove(message.id);

          if (mounted) {
            setState(() {});
          }
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  // Gérer la récupération des données de prévisualisation pour les messages texte
  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    if (index == -1) return;

    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    if (mounted) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    }
  }

  // Gérer l'envoi des messages texte
  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user!,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  // Construire les bulles de messages personnalisées
  Widget _bubbleBuilder(
    Widget child, {
    debugShowCheckedModeBanner = false,
    required types.Message message,
    required bool nextMessageInGroup,
  }) {
    final isCurrentUser = message.author.id == _user?.id;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Bubble(
        child: child,
        color: isCurrentUser
            ? const Color(0xff6f61e8) // Couleur des messages envoyés
            : const Color(0xfff5f5f7), // Couleur des messages reçus
        margin: nextMessageInGroup
            ? const BubbleEdges.symmetric(horizontal: 6)
            : const BubbleEdges.only(top: 8, bottom: 8, left: 6, right: 6),
        nip: nextMessageInGroup
            ? BubbleNip.no
            : isCurrentUser
                ? BubbleNip.rightBottom
                : BubbleNip.leftBottom,
        alignment: isCurrentUser
            ? Alignment.centerRight
            : Alignment.centerLeft, // Aligner les bulles à droite ou à gauche
        padding: const BubbleEdges.all(
            10), // Ajouter du padding pour rendre la bulle plus agréable visuellement
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(114, 210, 144, 51),
        title: Row(
          children: [
            Icon(Icons.chat),
            SizedBox(width: 10.h),
            const Text(
              'Message global de Tecno-Tic',
              style: TextStyle(fontFamily: 'Jersey'),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Chat(
            messages: _messages,
            onAttachmentPressed: _handleAttachmentPressed,
            onMessageTap: _handleMessageTap,
            onPreviewDataFetched: _handlePreviewDataFetched,
            onSendPressed: _handleSendPressed,
            user: _user!,
            bubbleBuilder: _bubbleBuilder,
            showUserAvatars: true,
            showUserNames: true,
          ),
          if (_loadingMessages.isNotEmpty)
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Importation ...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
