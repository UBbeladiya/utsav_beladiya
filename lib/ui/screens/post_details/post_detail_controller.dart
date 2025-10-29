import 'package:get/get.dart';
import 'package:utsav_beladiya/models/post.dart';
import 'package:utsav_beladiya/repositories/post_repository.dart';

class PostDetailController extends GetxController {
  final int postId;

  final PostRepository _repo = PostRepository();

  final Rx<Post?> post = Rx<Post?>(null);
  final RxBool loading = true.obs;
  final RxString error = ''.obs;

  PostDetailController(this.postId);

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    error.value = '';
    try {
      final result = await _repo.fetchPostDetail(postId);
      post.value = result;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', error.value);
    } finally {
      loading.value = false;
    }
  }
}


