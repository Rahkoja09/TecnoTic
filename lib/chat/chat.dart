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
import 'package:provider/provider.dart';
import 'package:ticeo/components/Theme/ThemeProvider.dart';
import 'package:ticeo/components/database_gest/database_helper.dart';
import 'package:ticeo/components/nav_bar/bottom_navbar.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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
  bool _textSize = false;

  // Pour suivre les messages en cours de chargement
  final Set<String> _loadingMessages = {};

  StreamSubscription? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _loadPreferences();
    loadidUser();
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final mode = await DatabaseHelper().getPreference();
    setState(() {
      _textSize = mode == 'largePolice';
    });
  }

  Future<void> loadidUser() async {
    var infoUser = await DatabaseHelper().getUser();
    if (infoUser!.isNotEmpty) {
      id_user = infoUser.first['idFireBase'];
      var name = infoUser.first['nom'].split(' ')[0];
      if (infoUser.first['isMentor'] == 1) {
        name = name + ' (Mentor)';
      }
      setState(() {
        _user = types.User(
          id: id_user,
          firstName: name,
          imageUrl: infoUser.first['profileImageUrl'],
        );
      });
    }
  }

  // Charger les messages depuis Firestore
  void _loadMessages() {
    _messageSubscription = FirebaseFirestore.instance
        .collection('Globalchat')
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

  void _addMessage(types.Message message) {
    if (!mounted) return;

    setState(() {
      _messages.insert(0, message);
    });

    // Enregistrer le message dans Firestore
    FirebaseFirestore.instance.collection('Globalchat').add(message.toJson());
  }

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
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'Photo',
                    style: TextStyle(fontSize: _textSize ? 16.sp : 11.sp),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Annuler',
                      style: TextStyle(fontSize: _textSize ? 16.sp : 11.sp)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  // Fonction de compression et redimensionnement de l'image
  Future<File?> compressAndResizeImage(File file,
      {int quality = 70, int minWidth = 800, int minHeight = 800}) async {
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/${Uuid().v4()}.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      minWidth: minWidth,
      minHeight: minHeight,
    );

    return result;
  }

  // Gérer la sélection d'images et l'upload vers Firebase Storage
  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      File imageFile = File(result.path);
      File? compressedImage = await compressAndResizeImage(imageFile);

      if (compressedImage != null) {
        setState(() {
          _loadingMessages.add(compressedImage.path);
        });

        try {
          final bytes = await compressedImage.readAsBytes();
          final image = await decodeImageFromList(bytes);

          // Upload de l'image compressée sur Firebase Storage
          final storageRef = FirebaseStorage.instance.ref().child(
              'MediasGlobalMessage/${compressedImage.path.split('/').last}');
          final uploadTask = storageRef.putFile(compressedImage);
          final snapshot = await uploadTask;
          final downloadUrl = await snapshot.ref.getDownloadURL();

          final message = types.ImageMessage(
            author: _user!,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            height: image.height.toDouble(),
            id: const Uuid().v4(),
            name: compressedImage.path.split('/').last,
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
              _loadingMessages.remove(compressedImage.path);
            });
          }
        }
      }
    }
  }

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

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user!,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  Widget _bubbleBuilder(
    Widget child, {
    required types.Message message,
    required bool nextMessageInGroup,
  }) {
    final isCurrentUser = message.author.id == _user?.id;
    final theme = Provider.of<ThemeProvider>(context).currentTheme;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (message is types.TextMessage && message.author.firstName != null)
            Text(
              isCurrentUser ? 'Vous' : message.author.firstName!,
              style: TextStyle(
                fontSize: _textSize
                    ? 16.sp
                    : 11.sp, // Ajuster la taille en fonction de _textSize
                color: Colors.grey,
              ),
            ),
          Bubble(
            margin: nextMessageInGroup
                ? const BubbleEdges.symmetric(horizontal: 6)
                : const BubbleEdges.only(top: 10),
            nip: isCurrentUser
                ? nextMessageInGroup
                    ? BubbleNip.rightCenter
                    : BubbleNip.rightBottom
                : nextMessageInGroup
                    ? BubbleNip.leftCenter
                    : BubbleNip.leftBottom,
            color: isCurrentUser ? Colors.blue : Colors.grey[200],
            padding: const BubbleEdges.all(20),
            child: message is types.TextMessage
                ? Text(
                    message.text, // Le texte du message
                    style: TextStyle(
                      fontSize: _textSize
                          ? 24.sp // Taille de texte pour message plus grande
                          : 14.sp, // Taille de texte pour message plus petite
                      color: isCurrentUser
                          ? Theme.of(context).textTheme.bodyText1?.color
                          : Theme.of(context).textTheme.bodyText2?.color,
                    ),
                  )
                : child, // Si c'est un autre type de message, utiliser child
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 15, 68, 105),
        title: Row(
          children: [
            Icon(
              Icons.chat,
              size: _textSize ? 30.sp : 20.sp,
              color: Colors.white,
            ),
            SizedBox(width: 10.h),
            Text(
              'Message global de Tecno-Tic',
              style: TextStyle(
                fontFamily: 'Jersey',
                fontSize: _textSize ? 30.sp : 20.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
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
            showUserNames: false,
            theme: DefaultChatTheme(
              backgroundColor: theme.scaffoldBackgroundColor,
              inputBackgroundColor: const Color.fromARGB(255, 52, 52, 52),
              messageBorderRadius: 10.0,
              primaryColor: const Color.fromARGB(255, 25, 80, 125),
              secondaryColor: Colors.grey[200]!,
            ),
          ),
          if (_loadingMessages.isNotEmpty)
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(137, 55, 55, 55),
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
