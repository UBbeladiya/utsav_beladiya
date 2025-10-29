import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsav_beladiya/ui/screens/post_list/post_controller.dart';
import 'package:utsav_beladiya/models/post.dart';
import 'package:utsav_beladiya/ui/screens/post_details/post_detail_screen.dart';
import 'package:utsav_beladiya/ui/theme/app_colors.dart';
import 'package:utsav_beladiya/ui/widgets/app_text.dart';
import 'package:utsav_beladiya/ui/strings/app_strings.dart';

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PostController controller = Get.put(PostController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const AppText(AppStrings.posts),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.posts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty && controller.posts.isEmpty) {
          return _ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.loadInitial,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            try {
              await controller.refreshNow();
              Get.snackbar(AppStrings.updated, AppStrings.postsSynchronized);
            } catch (e) {
              Get.snackbar(
                AppStrings.syncFailed,
                controller.errorMessage.value,
              );
            }
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.posts.length,
            itemBuilder: (context, index) {
              final post = controller.posts[index];
              return _PostTile(
                post: post,
                onTap: () async {
                  await controller.markPostAsRead(post);
                  if (post.id != null) {
                    await Get.to(() => PostDetailScreen(postId: post.id!));
                    await controller.refreshNow();
                  }
                },
              );
            },
          ),
        );
      }),
    );
  }
}

class _PostTile extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;

  const _PostTile({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final PostController controller = Get.find<PostController>();
    return Obx(() {
      final bool isRead = controller.readMap[post.id ?? -1] == true;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isRead ? AppColors.white : AppColors.lightYellow,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          post.title ?? '',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 6),
                        AppText(
                          post.body ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary,),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              message,
              textAlign: TextAlign.center,
              color: AppColors.error,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const AppText(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}
