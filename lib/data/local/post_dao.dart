import 'package:sqflite/sqflite.dart';
import 'package:utsav_beladiya/data/local/app_database.dart';
import 'package:utsav_beladiya/models/post.dart';

class PostDao {
  Future<Database> get _db async => await AppDatabase().database;

  Future<void> upsertPosts(List<Post> posts) async {
    final db = await _db;
    final existingReads = await _getReadMap(db);
    final batch = db.batch();
    for (final post in posts) {
      final map = post.toJson();
      final id = map['id'] as int?;
      final isRead = (id != null && existingReads[id] == true) ? 1 : 0;
      map['isRead'] = isRead;
      batch.insert(
        'posts',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Post>> getAllPosts() async {
    final db = await _db;
    final maps = await db.query('posts', orderBy: 'id ASC');
    return maps.map((m) => Post.fromJson(m)).toList();
  }

  Future<Post?> getPostById(int id) async {
    final db = await _db;
    final maps = await db.query('posts', where: 'id = ?', whereArgs: [id], limit: 1);
    if (maps.isEmpty) return null;
    return Post.fromJson(maps.first);
  }

  Future<void> markAsRead(int id) async {
    final db = await _db;
    await db.update('posts', {'isRead': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<int, bool>> getReadMap() async {
    final db = await _db;
    return _getReadMap(db);
  }

  Future<Map<int, bool>> _getReadMap(Database db) async {
    final rows = await db.query('posts', columns: ['id', 'isRead']);
    final Map<int, bool> map = {};
    for (final row in rows) {
      final id = row['id'] as int?;
      final isRead = row['isRead'] as int?;
      if (id != null) map[id] = isRead == 1;
    }
    return map;
  }
}


