import 'package:utsav_beladiya/data/local/post_dao.dart';
import 'package:utsav_beladiya/data/remote/post_api.dart';
import 'package:utsav_beladiya/models/post.dart';

class PostRepository {
  final PostDao _dao;
  final PostApi _api;

  PostRepository({PostDao? dao, PostApi? api})
      : _dao = dao ?? PostDao(),
        _api = api ?? PostApi();

  // Cache-first load: returns local immediately, syncs in background
  Future<List<Post>> loadPosts({bool syncInBackground = true}) async {
    // Remote-first: fetch from API, persist, then read from DB
    try {
      final remote = await _api.fetchPosts();
      await _dao.upsertPosts(remote);
      return await _dao.getAllPosts();
    } catch (_) {
      // Fallback to local cache on failure
      return await _dao.getAllPosts();
    }
  }

  

  Future<List<Post>> refreshPosts() async {
    final remote = await _api.fetchPosts();
    await _dao.upsertPosts(remote);
    return await _dao.getAllPosts();
  }

  Future<Post?> getLocalPost(int id) => _dao.getPostById(id);

  Future<Post> fetchPostDetail(int id) async {
    final remote = await _api.fetchPostDetail(id);
    await _dao.upsertPost(remote);
    // Prefer the normalized version from DB if available (keeps isRead, etc.)
    return (await _dao.getPostById(id)) ?? remote;
  }

  Future<void> markAsRead(int id) => _dao.markAsRead(id);

  Future<Map<int, bool>> getReadMap() => _dao.getReadMap();
}


