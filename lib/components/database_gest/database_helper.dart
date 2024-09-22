import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

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

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTableIfNotExists(db, 'utilisateurs', '''
        CREATE TABLE utilisateurs(
          id INTEGER PRIMARY KEY, 
          nom TEXT, 
          email TEXT, 
          telephone TEXT, 
          motdepasse TEXT, 
          profileImageUrl TEXT,
          idFireBase TEXT,
          idFireBaseMentor TEXT,
          isMentor INTEGER
        )
      ''');

        await _createTableIfNotExists(db, 'preferences', '''
        CREATE TABLE preferences(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          mode TEXT
        )
      ''');

        await _createTableIfNotExists(db, 'Mentor', '''
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
          rates INTEGER,
          IdFireBase TEXT,
          imageUrl TEXT
        )
      ''');

        await _createTableIfNotExists(db, 'Theme', '''
        CREATE TABLE Theme(
          id INTEGER PRIMARY KEY, 
          NomTheme TEXT, 
          CouleurFond TEXT, 
          CouleurCarte TEXT, 
          CouleurPolice TEXT, 
          CouleurIcon TEXT,
          CouleurButton TEXT,
          CouleurButtonPrime TEXT,
          CouleurPoliceBtn TEXT
        )
      ''');
      },
    );
  }

  Future<void> _createTableIfNotExists(
      Database db, String tableName, String createTableQuery) async {
    var result = await db.rawQuery('''
    SELECT name 
    FROM sqlite_master 
    WHERE type='table' AND name='$tableName'
  ''');

    if (result.isEmpty) {
      await db.execute(createTableQuery);
    }
  }

  Future<void> insertPreference(String mode) async {
    final db = await database;
    await db.insert(
      'preferences',
      {'mode': mode},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updatePreference(String mode) async {
    final db = await database;
    await db.update(
      'preferences',
      {'mode': mode},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getPreference() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('preferences');
    if (maps.isNotEmpty) {
      return maps.first['mode'] as String?;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getMentor() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Mentor');
    return maps;
  }

  Future<List<Map<String, dynamic>>?> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('utilisateurs');
    return maps;
  }

  Future<int?> getisMentor() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('utilisateurs');
    if (maps.isNotEmpty) {
      int? isMentor = maps.first['isMentor'] as int?;
      if (isMentor != null) {
        return isMentor;
      } else {
        print("isMentorL est null ou vide");
      }
    } else {
      print("No Mentor found");
    }
    return null;
  }

  Future<String?> getImageProfil() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('utilisateurs');
    if (maps.isNotEmpty) {
      String? imageUrl = maps.first['profileImageUrl'] as String?;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        return imageUrl;
      } else {
        print("Image URL is null or empty");
      }
    } else {
      print("No user found");
    }
    return null;
  }

  Future<String?> getImageProfilMentor() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Mentor');
    if (maps.isNotEmpty) {
      String? imageUrl = maps.first['imageUrl'] as String?;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        return imageUrl;
      } else {
        print("Image URL is null or empty");
      }
    } else {
      print("No user found");
    }
    return null;
  }

  Future<void> insertUser(
      int id,
      String nom,
      String email,
      String telephone,
      String motdepasse,
      String? profileImageUrl,
      String idFireBase,
      int isMentor,
      String idFireBaseMentor) async {
    final db = await database;
    await db.insert(
      'utilisateurs',
      {
        'id': id,
        'nom': nom,
        'email': email,
        'telephone': telephone,
        'motdepasse': motdepasse,
        'profileImageUrl': profileImageUrl,
        'idFireBase': idFireBase,
        'isMentor': isMentor,
        'idFireBaseMentor': idFireBaseMentor,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateUser(
      int id,
      String nom,
      String email,
      String telephone,
      String motdepasse,
      String? profileImageUrl,
      String idFireBase,
      int isMentor,
      String idFireBaseMentor) async {
    final db = await database;
    await db.update(
      'utilisateurs',
      {
        'nom': nom,
        'email': email,
        'telephone': telephone,
        'motdepasse': motdepasse,
        'profileImageUrl': profileImageUrl,
        'idFireBase': idFireBase,
        'isMentor': isMentor,
        'idFireBaseMentor': idFireBaseMentor,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateIsMentor(int id, int isMentor) async {
    final db = await database;
    await db.update(
      'utilisateurs',
      {
        'isMentor': isMentor,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateIdFireBaseMentor(int id, String idFireBaseMentor) async {
    final db = await database;
    await db.update(
      'utilisateurs',
      {
        'idFireBaseMentor': idFireBaseMentor,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateMentor(
      int id,
      String nom,
      String contact,
      String email,
      String heurementoring,
      String apropos,
      String accomplissement,
      String prix,
      String competence,
      int rates,
      String idFireBase,
      String imageUrl) async {
    final db = await database;
    await db.update(
      'Mentor',
      {
        'id': id,
        'NomComplet': nom,
        'Contact': contact,
        'Email': email,
        'HeureMentoring': heurementoring,
        'Apropos': apropos,
        'Accomplissements': accomplissement,
        'Prix': prix,
        'Competence': competence,
        'rates': rates,
        'IdFireBase': idFireBase,
        'imageUrl': idFireBase,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertMentor(
      int id,
      String nom,
      String contact,
      String email,
      String heurementoring,
      String apropos,
      String accomplissement,
      String prix,
      String competence,
      int rates,
      String idFireBase,
      String imageUrl) async {
    final db = await database;
    await db.insert(
      'Mentor',
      {
        'id': id,
        'NomComplet': nom,
        'Contact': contact,
        'Email': email,
        'HeureMentoring': heurementoring,
        'Apropos': apropos,
        'Accomplissements': accomplissement,
        'Prix': prix,
        'Competence': competence,
        'rates': rates,
        'IdFireBase': idFireBase,
        'imageUrl': imageUrl,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteTableDataIfExists(String tableName) async {
    final db = await DatabaseHelper().database;

    var tableExists = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName';");

    if (tableExists.isNotEmpty) {
      await db.delete(tableName);
      print('Table $tableName vidée avec succès.');
    } else {
      print('La table $tableName n\'existe pas.');
    }
  }

  Future<void> updateMentorName(int id, int NomComplet) async {
    final db = await database;
    await db.update(
      'Mentor',
      {
        'NomComplet': NomComplet,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateMentorAbout(int id, String Apropos) async {
    final db = await database;
    await db.update(
      'Mentor',
      {
        'Apropos': Apropos,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateMentorAccomplishment(
      int id, String Accomplissements) async {
    final db = await database;
    await db.update(
      'Mentor',
      {
        'Accomplissements': Accomplissements,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateMentorCompetence(int id, String Competence) async {
    final db = await database;
    await db.update(
      'Mentor',
      {
        'Competence': Competence,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateMentorPrice(int id, String Prix) async {
    final db = await database;
    await db.update(
      'Mentor',
      {
        'Prix': Prix,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateMentorImageUrl(int id, String imageUrl) async {
    final db = await database;
    await db.update(
      'Mentor',
      {
        'imageUrl': imageUrl,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateMentorContact(int id, String Contact) async {
    final db = await database;
    await db.update(
      'Mentor',
      {
        'Contact': Contact,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateMentorMentoringHours(int id, String HeureMentoring) async {
    final db = await database;
    await db.update(
      'Mentor',
      {
        'HeureMentoring': HeureMentoring,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
