import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sysman_prueba/models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'productos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE productos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        descripcion TEXT,
        precio REAL,
        imagen TEXT
      )
    ''');
  }

  Future<int> insertProduct(Producto producto) async {
    Database db = await database;
    return await db.insert('productos', producto.toMap());
  }

  Future<List<Producto>> getProductos() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('productos');
    
    return List.generate(maps.length, (i) {
      return Producto.fromMap(maps[i]);
    });
  }

  Future<Producto?> getProducto(int id) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'productos',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Producto.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateProducto(Producto producto) async {
    Database db = await database;
    return await db.update(
      'productos',
      producto.toMap(),
      where: 'id = ?',
      whereArgs: [producto.id],
    );
  }

  Future<int> deleteProducto(int id) async {
    Database db = await database;
    return await db.delete(
      'productos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}