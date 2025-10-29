import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsav_beladiya/ui/screens/post_details/post_detail_controller.dart';
import 'package:utsav_beladiya/ui/widgets/app_text.dart';
import 'package:utsav_beladiya/ui/theme/app_colors.dart';
import 'package:utsav_beladiya/ui/strings/app_strings.dart';

class PostDetailScreen extends StatelessWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final tag = 'post_detail_$postId';
    final controller = Get.put(PostDetailController(postId), tag: tag);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: AppText(AppStrings.postTitleWithId(postId),),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.value.isNotEmpty) {
          return _Error(message: controller.error.value, onRetry: controller.load);
        }
        final p = controller.post.value;
        if (p == null) {
          return const Center(child: AppText(AppStrings.postNotFound));
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: AppColors.shadow, blurRadius: 8, spreadRadius: 1, offset: Offset(0, 3),),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  p.title ?? '',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                Divider(color: AppColors.shadow,),
                AppText(p.body ?? ''),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _Error extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _Error({required this.message, required this.onRetry});

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
