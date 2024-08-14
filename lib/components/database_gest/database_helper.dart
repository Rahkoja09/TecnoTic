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

    // Crée le chemin complet vers le fichier de la base de données dans le sous-dossier db/data
    String path =
        join(documentsDirectory.path, 'assets', 'database', 'local_db.db');

    await Directory(dirname(path)).create(recursive: true);

    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE preferences(id INTEGER PRIMARY KEY AUTOINCREMENT, mode TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertPreference(String mode) async {
    final db = await database;
    await db.insert(
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
}
