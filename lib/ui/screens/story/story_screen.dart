import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utsav_beladiya/ui/screens/story/story_controller.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final GlobalKey _stackKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StoryController());
    final screenSize = MediaQuery.of(context).size;
    
    // Initialize position to center on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializePosition(screenSize);
    });

    return Scaffold(
      body: GestureDetector(
        onTapDown: (details) {
          // Allow tapping anywhere to move emoji (Instagram story-like)
          final RenderBox? box = _stackKey.currentContext?.findRenderObject() as RenderBox?;
          if (box != null) {
            final localPosition = box.globalToLocal(details.globalPosition);
            controller.updatePosition(localPosition);
          }
        },
        child: Stack(
          key: _stackKey,
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'asstes/images/bg_img.jpg',
                fit: BoxFit.cover,
              ),
            ),
            
            // Movable emoji image
            Obx(() {
              final position = controller.emojiPosition.value;
              
              // Only show if position is initialized
              if (position == null) {
                return const SizedBox.shrink();
              }
              
              return Positioned(
                left: position.dx - 50, // Center the emoji on the tap position (assuming 100x100 size)
                top: position.dy - 50,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    // Update position as user drags
                    final RenderBox? box = _stackKey.currentContext?.findRenderObject() as RenderBox?;
                    if (box != null) {
                      final localPosition = box.globalToLocal(details.globalPosition);
                      controller.updatePosition(localPosition);
                    }

                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'asstes/images/emoji.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

