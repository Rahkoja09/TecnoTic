import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelperLogin {
  static final DatabaseHelperLogin _instance = DatabaseHelperLogin._internal();
  factory DatabaseHelperLogin() => _instance;
  DatabaseHelperLogin._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // Chemin vers le fichier de la base de données
    String path = join(documentsDirectory.path, 'local_db.db');

    // Crée le répertoire si nécessaire
    await Directory(dirname(path)).create(recursive: true);

    // Crée et ouvre la base de données
    return await openDatabase(
      path,
      version: 1,
    );
  }

  // Méthode pour créer la table Mentor
  Future<void> createMentorTable() async {
    final db = await database;

    // Vérifie si la table existe avant de la créer
    var result = await db.rawQuery('''
      SELECT name 
      FROM sqlite_master 
      WHERE type='table' AND name='Mentor'
    ''');

    if (result.isEmpty) {
      // Création de la table 'Mentor'
      await db.execute('''
        CREATE TABLE Mentor(
          id INTEGER PRIMARY KEY, 
          NomComplet TEXT, 
          Contact TEXT, 
          Email TEXT, 
          HeureMentoring TEXT, 
          Apropos TEXT,
          Accomplissements TEXT,
          Prix TEXT,
          Competence TEXT,
          rates TEXT,
          IdFireBase TEXT,
          imageUrl TEXT
        )
      ''');
      print('Table Mentor créée.');
    } else {
      print('Table Mentor existe déjà.');
    }
  }
}
