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
    final local = await _dao.getAllPosts();
    if (syncInBackground) {
      _syncPostsSilently();
    }
    return local;
  }

  Future<void> _syncPostsSilently() async {
    try {
      final remote = await _api.fetchPosts();
      await _dao.upsertPosts(remote);
    } catch (_) {
      // Silent background sync failure
    }
  }

  Future<List<Post>> refreshPosts() async {
    final remote = await _api.fetchPosts();
    await _dao.upsertPosts(remote);
    return await _dao.getAllPosts();
  }

  Future<Post?> getLocalPost(int id) => _dao.getPostById(id);

  Future<Post> fetchPostDetail(int id) async {
    return await _api.fetchPostDetail(id);
  }

  Future<void> markAsRead(int id) => _dao.markAsRead(id);

  Future<Map<int, bool>> getReadMap() => _dao.getReadMap();
}


