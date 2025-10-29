import 'package:get/get.dart';
import 'package:utsav_beladiya/models/post.dart';
import 'package:utsav_beladiya/repositories/post_repository.dart';

class PostController extends GetxController {
  final PostRepository _repo;

  PostController({PostRepository? repository}) : _repo = repository ?? PostRepository();

  final RxList<Post> posts = <Post>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxMap<int, bool> readMap = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  Future<void> loadInitial() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final remoteFirst = await _repo.loadPosts();
      posts.assignAll(remoteFirst);
      readMap.assignAll(await _repo.getReadMap());
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshNow() async {
    errorMessage.value = '';
    try {
      final latest = await _repo.refreshPosts();
      posts.assignAll(latest);
      readMap.assignAll(await _repo.getReadMap());
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    }
  }

  Future<void> markPostAsRead(Post post) async {
    try {
      final id = post.id;
      if (id == null) return;
      await _repo.markAsRead(id);
      readMap[id] = true;
      readMap.refresh();
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }
}


