import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/goalkeeper_stats.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('goalkeeper.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE matches(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        paradas INTEGER,
        disparosArco INTEGER,
        pasesExitosos INTEGER,
        totalPases INTEGER,
        salidasExitosas INTEGER,
        salidas INTEGER,
        paradasPorcentaje REAL,
        pasesPorcentaje REAL,
        salidasPorcentaje REAL
      )
    ''');
  }

  Future<int> saveMatch(GoalkeeperStats stats) async {
    final db = await database;
    final data = {
      'date': DateTime.now().toIso8601String(),
      'paradas': stats.paradas,
      'disparosArco': stats.disparosArco,
      'pasesExitosos': stats.pasesExitosos,
      'totalPases': stats.totalPases,
      'salidasExitosas': stats.salidasExitosas,
      'salidas': stats.salidas,
      'paradasPorcentaje': stats.paradasPorcentaje,
      'pasesPorcentaje': stats.pasesPorcentaje,
      'salidasPorcentaje': stats.porcentajeSalidasExitosas,
    };
    return await db.insert('matches', data);
  }
}
